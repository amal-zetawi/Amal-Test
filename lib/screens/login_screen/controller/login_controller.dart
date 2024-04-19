import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/sql/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class LoginController extends GetxController {
  final TextEditingController usernameController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  RxBool rememberMe = false.obs;

  @override
  void onInit() {
    super.onInit();
    loadRememberMeState();
  }

  void loadRememberMeState() {
    rememberMe.value = GetStorage().read('rememberMe') ?? false;
  }

  void saveRememberMeState(bool value) {
    GetStorage().write('rememberMe', value);
  }

  void login() async {
    final String enteredUsername = usernameController.text;
    final String enteredPassword = passwordController.text;

    // Check if username and password are provided
    if (enteredUsername.isEmpty || enteredPassword.isEmpty) {
      Get.snackbar('Error', 'Please enter username and password',
          colorText: Colors.red);
    }
    final bool isAuthenticated =
        await DatabaseHelper.authenticateUser(enteredUsername, enteredPassword);
    if (isAuthenticated) {
      Get.offNamed(AppRoutes.homeScreen);
    } else {
      Get.snackbar('Error', 'Invalid username or password',
          colorText: Colors.red);
    }

    // Save the checkbox state when logging in
    saveRememberMeState(rememberMe.value);
  }
}
