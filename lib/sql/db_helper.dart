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

  static _createDatabase(Database db, int version) async {
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
    return storedPasswordHash == enteredPassword;
  }

  ///////////////////////////////////////////////////////////////

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
      // Move to the home screen
      Get.offNamed(AppRoutes.homeScreen, arguments: 1);
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
      Get.offNamed(AppRoutes.homeScreen, arguments: 1);

    }
    //getAllItems();
  }

  static Future<List<Map<String, dynamic>>>? getAllCurrency() async {
    final Database db = await database;
    final currencyList = await db.query('currency');
    return currencyList;
  }

  // static Future<void> saveOrder(
  //     String orderDate,
  //     int currencyId,
  //     int userId,
  //     String status,
  //     String type,
  //     double orderAmount,
  //     double equalOrderAmount) async {
  //   final Database db = await database;
  //   int response = await db.insert(
  //     'orders',
  //     {
  //       'orderDate': orderDate,
  //       'currencyId': currencyId,
  //       'userId': userId,
  //       'status': status,
  //       'type': type,
  //       'orderAmount': orderAmount,
  //       'equalOrderAmount': equalOrderAmount,
  //     },
  //     conflictAlgorithm: ConflictAlgorithm.replace,
  //   );
  //   if (response > 0) {
  //     Get.offNamed(
  //       AppRoutes.homeScreen,arguments: 2
  //     );
  //   }
  //   getAllOrder();
  // }

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

/////////////////////////////////////////////////////////////////////////////
//   static Future<Map<String, dynamic>?> getUserById(int userId) async {
//     final Database db = await database;
//
//     final List<Map<String, dynamic>> userList =
//         await db.query('users', where: 'id = ?', whereArgs: [userId]);
//
//     if (userList.isNotEmpty) {
//       return userList.first;
//     } else {
//       return null;
//     }
//   }

  static updateOrderState(String sql) async {
    final Database db = await database;
    int response = await db.rawUpdate(sql);
    return response;
  }

  static read(String table) async {
    Database? myDatabase = await database;
    List<Map> response = await myDatabase.query(table);
    return response;
  }

  static insert(String table, Map<String, dynamic> object) async {
    Database? mydb = await database;
    int response = await mydb.insert(table, object);
    return response;
  }

  static getLast(String sql) async {
    Database? mydb = await database;
    List<Map> response = await mydb.rawQuery(sql);
    return response;
  }

  static update(String table, Map<String, dynamic> map, String where) async {
    Database? mydb = await database;
    int response = await mydb.update(table, map, where: where);
    return response;
  }

  static getOne(String table, String where) async {
    Database? mydb = await database;
    List<Map> response = await mydb.query(table, where: where);
    return response;
  }

  static delete(String table, String where) async {
    Database? mydb = await database;
    int response = await mydb.delete(table, where: where);
    return response;
  }

  static readJoin(String sql) async {
    Database? mydb = await database;
    List response = await mydb.rawQuery(sql);
    return response;
  }

 static Future<List<Map<String, dynamic>>> queryItems(String value) async {
    Database? db = await database;
    final List<Map<String, dynamic>> result = await db.query(
      'items',
      where: "itemName LIKE ?",
      whereArgs: ['%$value%'],
    );
    return result;
  }

}
