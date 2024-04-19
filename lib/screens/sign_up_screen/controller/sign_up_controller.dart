import 'dart:convert';
import 'dart:io';
import 'package:Talabat/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:Talabat/sql/db_helper.dart';
import 'package:crypto/crypto.dart';

class SignUpController extends GetxController {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
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

  Future<void> signUp() async {
    if (nameController.text.isEmpty ||
        usernameController.text.isEmpty ||
        passwordController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          colorText: Colors.red);
      return;
    }

    final username = usernameController.text;
    final isUnique = await DatabaseHelper.isUsernameUnique(username);
    if (!isUnique) {
      Get.snackbar(
          'Error', 'Username already exists. Please choose a different one.',
          colorText: Colors.red);
      return;
    }

    final password = passwordController.text;

    bool isPasswordValid(String password) {
      final passwordRegex = RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d).{8,}$');
      return passwordRegex.hasMatch(password);
    }

    if (!isPasswordValid(password)) {
      Get.snackbar('Error',
          'Password must contain at least one uppercase letter, one lowercase letter, one digit, and have a minimum length of 8 characters.',
          colorText: Colors.red);
      return;
    }

    if (profileImage.value == null) {
      Get.snackbar('Error', 'Please select a profile image.',
          colorText: Colors.red);
      return;
    }

    final Directory appDir = await getApplicationDocumentsDirectory();
    final String uniqueFileName = '${DateTime.now().millisecondsSinceEpoch}_image.png';
    final String profileImagePath = join(appDir.path, uniqueFileName);
    await profileImage.value!.copy(profileImagePath);

    String hashPassword(String password) {
      final hashPassword = sha256.convert(utf8.encode(password)).toString();
      return hashPassword;
    }

    final hashedPassword = hashPassword(password);

    await DatabaseHelper.saveUser(
      nameController.text,
      usernameController.text,
      hashedPassword,
      profileImagePath,
    );
    Get.snackbar('Completed', 'successfully registered',
        colorText: Colors.green);
    Get.offNamed(
      AppRoutes.loginScreen,
    );
  }
}
