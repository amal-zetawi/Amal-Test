import 'package:Talabat/constants/images_constant.dart';
import 'package:Talabat/routes/app_routes.dart';
import 'package:get/get.dart';
import 'controller/login_controller.dart';
import 'package:flutter/material.dart';

class LoginScreen extends GetWidget<LoginController> {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(
              ImageConstant.imglogin,
              height: 210,
              width: 210,
            ),
            SizedBox(
              height: 50,
              width: 350,
              child: TextField(
                controller: controller.usernameController,
                decoration: const InputDecoration(
                  labelText: 'Username',
                  prefixIcon: Icon(Icons.person, color: Colors.deepOrange),
                  border: OutlineInputBorder(
                    // Change border
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            SizedBox(
              height: 50,
              width: 350,
              child: TextField(
                controller: controller.passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Password',
                  prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                  border: OutlineInputBorder(
                    // Change border
                    borderSide: BorderSide(color: Colors.deepOrange),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                controller.login();
              },
              style: ElevatedButton.styleFrom(
                minimumSize: const Size(350, 50),
              ),
              child: const Text(
                'Login',
                style: TextStyle(fontSize: 18, color: Colors.deepOrange),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Obx(() => Checkbox(
                      value: controller.rememberMe.value,
                      onChanged: (value) {
                        controller.rememberMe.value = value!;
                      },
                    )),
                const Text(
                  'Remember Me',
                  style: TextStyle(fontSize: 10),
                ),
              ],
            ),
            Align(
              alignment: Alignment.centerLeft,
              child: GestureDetector(
                onTap: () {
                  Get.offNamed(
                    AppRoutes.signUpScreen,
                  );
                },
                child: const Text(
                  "No Account? Sign up",
                  style: TextStyle(
                    color: Colors.blue,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
