import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/sign_up_controller.dart';
import 'models/model_user.dart';

class SignUpScreen extends GetWidget<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
   // final hashPassword = sha256.convert(utf8.encode(Get.arguments['user'].password)).toString();
    if (Get.arguments != null) {
     controller. nameController.text = Get.arguments['user'].user.name;
     controller. usernameController.text = Get.arguments['user'].user.username;
     controller. passwordController.text = Get.arguments['user'].user.password;
     print("zetawi${Get.arguments['user'].user.profile_image}");
     controller.profileImage.value = Get.arguments['user'].user.profile_image;
    }
    if (Get.arguments == null) {
      controller. nameController.text = '';
      controller. usernameController.text = '';
      controller. passwordController.text = '';
      controller.profileImage.value  ;
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(''),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            GestureDetector(
              onTap: controller.pickImage,
              child: Container(
                alignment: Alignment.center,
                padding: const EdgeInsets.all(8.0),
                child: Obx(
                  () =>CircleAvatar(
                    radius: 50,
                    backgroundImage:
                    controller.profileImage.value != null
                        ? FileImage(
                      File(
                        controller.profileImage.value!,
                      ),
                    )
                        : null,
                  ),
                  //CircleAvatar
                  //     (
                  //   radius: 50,
                  //   backgroundColor: Colors.grey[300],
                  //   child:
                  //   controller.profileImage.value != null
                  //       ?
                  //   FileImage(File(controller.profileImage.value!.path)
                  //    : null
                  //
                  //   )
                  //       : const Icon(
                  //     Icons.camera_alt,
                  //     color: Colors.white,
                  //   ),
                  // ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: controller.nameController,
                  decoration: const InputDecoration(
                    labelText: 'Name',
                    prefixIcon: Icon(Icons.person, color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20), // Add space on all sides
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: controller.usernameController,
                  decoration: const InputDecoration(
                    labelText: 'UserName',
                    prefixIcon: Icon(Icons.person, color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: SizedBox(
                height: 50,
                child: TextField(
                  controller: controller.passwordController,
                  obscureText: true,
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    prefixIcon: Icon(Icons.lock, color: Colors.deepOrange),
                    border: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.deepOrange),
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 20, top: 20, right: 20),
              child: ElevatedButton(
                onPressed: () async {
                  if (Get.arguments == null) {
                    controller.signUp();
                  } else {
                    User user = User(
                        name:   controller.nameController.text,
                        username:   controller. usernameController.text,
                        password: controller. passwordController.text,
                        profile_image:   controller.profileImage.value
                    );
                    await controller.updateUser(
                        'users', user, Get.arguments['user'].id);
                  }
                },
                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(350, 50),
                ),
                child: const Text(
                  'Save',
                  style: TextStyle(fontSize: 18, color: Colors.deepOrange),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
