import 'dart:io';
import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/items_screen/models/model_item.dart';
import 'package:Talabat/screens/sign_up_screen/models/model_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Talabat/sql/db_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';

class AddItemsController extends GetxController {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  Rx<String?> profileImage = Rx<String?>(null);
  RxList items = [].obs;
  RxInt deletedIndex = 0.obs;

  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = (pickedFile.path);
    } else {
      Get.snackbar('Error', 'No image selected.', colorText: Colors.red);
    }
  }

  insert(String table, Items item) async {
    Map<String, dynamic> userMap = item.toMap();
    int response = await DatabaseHelper.insert(table, userMap);
    if (response > 0) {
      List<Map> lastInserted = await getLast();
      Map lastItems = lastInserted[0];
      items.add(lastItems);
        Get.offNamed(
          AppRoutes.homeScreen,
        );
    }
    return response;
  }

  getLast() async {
    return await DatabaseHelper
        .getLast('''SELECT * FROM items ORDER BY itemId DESC LIMIT 1''');
  }

  getItems(String table) async {
    List<Map> response = await DatabaseHelper.read(table);
    items.addAll(response);
  }

  delete(int id) async {
    int index = items.indexWhere((u) => u['id'] == id);
    deletedIndex.value = index;
    int response = await DatabaseHelper.delete('users', 'id=$id');
    if (response > 0) {
      items.removeWhere((user) => user!['id'] == id);
    }
  }

  getOne(int id) async {
    return await DatabaseHelper.getOne('users', "id=$id");
  }

  updateLocalItems(int id) async {
    List oneItems = await getOne(id);
    Map item = oneItems[0];
    int index = items.indexWhere((c) => c['id'] == id);
    items.removeAt(index);
  }

  updateUser(String table, User user, int id) async {
    Map<String, dynamic> userMap = user.toMap();
    int res = await DatabaseHelper.update(table, userMap, "id=$id");
    if (res > 0) {
      await updateLocalItems(id);
    }
  }

  Future<void> saveItem() async {
    if (itemNameController.text.isEmpty || itemPriceController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          colorText: Colors.red);
      return;
    }

    if (profileImage.value == null) {
      Get.snackbar('Error', 'Please select a profile image.',
          colorText: Colors.red);
      return;
    }

    final String profileImagePath = profileImage.value!;
    final File sourceFile = File(profileImagePath);
    final Directory appDir = await getApplicationDocumentsDirectory();
    final String uniqueFileName =
        '${DateTime.now().millisecondsSinceEpoch}_image.png';
    final String profileImageU = join(appDir.path, uniqueFileName);
    await sourceFile.copy(profileImageU);

    Items items = Items(
      itemName: itemNameController.text,
      image: profileImagePath,
      price: double.parse(itemPriceController.text),
    );
    insert('items',items);
  }

  getCurrentUser(String userName) async {
    List<Map> response =
        await DatabaseHelper.getOne('users', "userName=$userName");
    Map user = response[0];
    return user;
  }

  updateItems(String table, Items items, int id) async {
    Map<String, dynamic> userMap = items.toMap();
    int res = await DatabaseHelper.update(table, userMap, "itemId=$id");
    if (res > 0) {
      Get.offNamed(
        AppRoutes.homeScreen,
      );
    }
  }

  @override
  void onInit() {
    super.onInit();
    getItems('users');
  }
}
