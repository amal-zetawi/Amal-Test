import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:Talabat/sql/db_helper.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';


class AddItemsController extends GetxController {
  final TextEditingController itemNameController = TextEditingController();
  final TextEditingController itemPriceController = TextEditingController();
  Rx<File?> profileImage = Rx<File?>(null);


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
    if (itemNameController.text.isEmpty ||
        itemPriceController.text.isEmpty) {
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

    await DatabaseHelper.saveItem(
      itemNameController.text,
      profileImagePath,
      double.parse( itemPriceController.text),
    );

    DatabaseHelper.getAllItems();
  }


}