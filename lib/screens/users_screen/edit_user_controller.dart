import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Talabat/sql/db_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class EditUserController extends GetxController {
  Rx<File?> profileImage = Rx<File?>(null);
  late final TextEditingController nameController;
  late final TextEditingController userNameController;
  late final TextEditingController passwordController;
  late final int id;
  @override
  void onInit() {
    super.onInit();
    nameController = TextEditingController();
   userNameController = TextEditingController();
    passwordController = TextEditingController();
  }

  void initializeControllers(Map<String, dynamic> userInfo) {
    id = userInfo['id'] ?? '';
    nameController= userInfo['name'] ?? '';
    userNameController.text = userInfo['userName'] ?? '';
    passwordController.text = userInfo['password'] != null ? '${userInfo['password']}' : '';
  }


  Future<void> pickImage() async {
    final ImagePicker picker = ImagePicker();
    final XFile? pickedFile =
    await picker.pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      profileImage.value = File(pickedFile.path);
    } else {
      Get.snackbar('Error', 'No image selected.', colorText: Colors.red);
    }
  }

  Future<void> saveItem() async {
    if (userNameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          colorText: Colors.red);
      return;
    }

    if (profileImage.value == null) {
      Get.snackbar('Error', 'Please select a profile image.',
          colorText: Colors.red);
      return;
    }

    // Save the image to the app directory
    final Directory appDir = await getApplicationDocumentsDirectory();
    // Generate a unique filename with UUI
    final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_image.png';
    final String profileImagePath = join(appDir.path, uniqueFileName);
    await profileImage.value!.copy(profileImagePath);

    //   await DatabaseHelper.saveItem(
    //     itemNameController.text,
    //     profileImagePath,
    //     double.parse( itemPriceController.text),
    //   );
    //
    //   DatabaseHelper.getAllItems();
    // }

    DatabaseHelper.getAllItems();
  }
  Future<void> updateItem() async {
    if (profileImage.value == null) {
      Get.snackbar('Error', 'Please select a profile image.',
          colorText: Colors.red);
      return;
    }

    // Save the image to the app directory
    final Directory appDir = await getApplicationDocumentsDirectory();
    // Generate a unique filename with UUI
    final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_image.png';
    final String profileImagePath = join(appDir.path, uniqueFileName);
    await profileImage.value!.copy(profileImagePath);

    await DatabaseHelper.updateItem(
      id,
      userNameController.text,
      profileImagePath,
      double.parse(passwordController.text),
    );
  }
}