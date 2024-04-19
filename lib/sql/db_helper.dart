import 'dart:convert';
import 'package:Talabat/routes/app_routes.dart';
import 'package:crypto/crypto.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:get/get.dart';

class DatabaseHelper {
  static Future<Database> get database async {
    final documentsDirectory = await getApplicationDocumentsDirectory();
    final String path = join(documentsDirectory.path, 'users_database.db');
    return openDatabase(path, version: 1, onCreate: _createDatabase);
  }

  static Future<void> _createDatabase(Database db, int version) async {
    Batch batch = db.batch();
    batch.execute(
      'CREATE TABLE users(id INTEGER PRIMARY KEY, name TEXT, username TEXT, password TEXT, profile_image TEXT)',
    );
    batch.execute(
      'CREATE TABLE items(itemId INTEGER PRIMARY KEY, itemName TEXT, image TEXT, price REAL)',
    );
    batch.execute(
      'CREATE TABLE currency(currencyId INTEGER PRIMARY KEY, currencyName TEXT, currencySymbol TEXT, currencyRate REAL)',
    );
    batch.execute(
      'CREATE TABLE orders(orderId INTEGER PRIMARY KEY, orderDate TEXT, currencyId INTEGER, userId INTEGER, status TEXT, type TEXT,orderAmount REAL, equalOrderAmount REAL, FOREIGN KEY(userId) REFERENCES users(id), FOREIGN KEY(currencyId) REFERENCES currency(currencyId))',
    );
    await batch.commit();
  }

  static Future<void> saveUser(String name, String username, String password,
      String profileImagePath) async {
    final Database db = await database;
    await db.insert(
      'users',
      {
        'name': name,
        'username': username,
        'password': password,
        'profile_image': profileImagePath,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );

  }
  static Future<List<Map<String, dynamic>>> getAllUsers() async {
    final Database db = await database;
    final userList = await db.query('users');
    return userList;
  }


  // Method to test isUsernameUnique
  static Future<bool> isUsernameUnique(String username) async {
    final Database db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [username],
    );
    return result.isEmpty;
  }

  static Future<bool> authenticateUser(
      String enteredUsername, String enteredPassword) async {
    final Database db = await database;
    // Hash the entered password using SHA-256
    final enteredPasswordHash =
        sha256.convert(utf8.encode(enteredPassword)).toString();
    // Query the database to retrieve the hashed password for the entered username
    final List<Map<String, dynamic>> result = await db.query(
      'users',
      where: 'username = ?',
      whereArgs: [enteredUsername],
    );

    // If no user with the provided username exists, return false
    if (result.isEmpty) {
      return false;
    }

    // Extract the hashed password from the database result
    final storedPasswordHash = result.first['password'];

    // Compare the hashed password from the database with the hashed entered password
    return storedPasswordHash == enteredPasswordHash;
  }

  ///////////////////////////////////////////////////////////////
  static Future<void> saveItem(
      String itemName, String image, double price) async {
    final Database db = await database;
    int response = await db.insert(
      'items',
      {
        'itemName': itemName,
        'image': image,
        'price': price,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (response > 0) {
      Get.offNamed(
        AppRoutes.homeScreen,
      );
    }
  }

  static Future<void> updateItem(
      int itemId, String itemName, String image, double price) async {
    final Database db = await database;
    int response = await db.update(
      'items',
      {
        'itemName': itemName,
        'image': image,
        'price': price,
      },
      where: 'itemId = ?',
      whereArgs: [itemId],
    );
    if (response > 0) {
      Get.offNamed(
        AppRoutes.homeScreen,
      );
    }
    //getAllItems();
  }

  static Future<void> updateUser(
      int itemId, String name, String username, String password) async {
    final Database db = await database;
    int response = await db.update(
      'users',
      {
        'name': name,
        'username': username,
        'password': password,
      },
      where: 'itemId = ?',
      whereArgs: [itemId],
    );
    if (response > 0) {
      Get.offNamed(
        AppRoutes.homeScreen,
      );
    }
    //getAllItems();
  }
  static Future<void> deleteItem(int itemId) async {
    final Database db = await database;
    await db.delete(
      'items',
      where: 'itemId = ?',
      whereArgs: [itemId],
    );
  }

  static Future<List<Map<String, dynamic>>> getAllItems() async {
    final Database db = await database;
    final itemsList = await db.query('items');
    return itemsList;
  }

/////////////////////////////////////////////
  static Future<void> saveCurrency(
      String currencyName, String currencySymbol, double currencyRate) async {
    final Database db = await database;
    int response = await db.insert(
      'currency',
      {
        'currencyName': currencyName,
        'currencySymbol': currencySymbol,
        'currencyRate': currencyRate,
      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (response > 0) {
      Get.offNamed(
        AppRoutes.homeScreen,
      );
    }
  }

  static Future<void> deleteCurrency(int itemId) async {
    final Database db = await database;
    await db.delete(
      'currency',
      where: 'currencyId = ?',
      whereArgs: [itemId],
    );
  }

  static Future<void> updateCurrency(int currencyId, String currencyName,
      String currencySymbol, double currencyRate) async {
    final Database db = await database;
    int response = await db.update(
      'currency',
      {
        'currencyName': currencyName,
        'currencySymbol': currencySymbol,
        'currencyRate': currencyRate,
      },
      where: 'currencyId = ?',
      whereArgs: [currencyId],
    );
    if (response > 0) {
      Get.offNamed(
        AppRoutes.homeScreen,
      );
    }
    //getAllItems();
  }

  static Future<List<Map<String, dynamic>>>? getAllCurrency() async {
    final Database db = await database;
    final currencyList = await db.query('currency');
    return currencyList;
  }


  static Future<void> saveOrder(
      String orderDate, int currencyId ,int userId,String status,String type,double orderAmount, double equalOrderAmount) async {
    final Database db = await database;
    int response = await db.insert(
      'orders',
      {
        'orderDate': orderDate,
        'currencyId':currencyId,
        'userId':userId,
        'status':status,
        'type':type,
        'orderAmount': orderAmount,
        'equalOrderAmount': equalOrderAmount,

      },
      conflictAlgorithm: ConflictAlgorithm.replace,
    );
    if (response > 0) {
      Get.offNamed(
        AppRoutes.homeScreen,
      );
    }
    getAllOrder();

  }

  static Future<List<Map<String, dynamic>>> getAllOrder() async {
    final Database db = await database;
    final userList = await db.query('orders');
    return userList;
  }

  static Future<void> deleteOrder(int itemId) async {
    final Database db = await database;
    await db.delete(
      'orders',
      where: 'orderId = ?',
      whereArgs: [itemId],
    );
  }

  static Future<Map<String, dynamic>?> getUserById(int userId) async {
    final Database db = await database;

    final List<Map<String, dynamic>> userList = await db.query('users', where: 'id = ?', whereArgs: [userId]);

    if (userList.isNotEmpty) {
      return userList.first;
    } else {
      return null;
    }
  }

  static updateOrderState(String sql) async {
   final Database  db = await database;
    int response = await db.rawUpdate(sql);
    return response;
  }

}
