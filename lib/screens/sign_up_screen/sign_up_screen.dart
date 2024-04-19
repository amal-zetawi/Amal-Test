import 'package:Talabat/constants/images_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/sign_up_controller.dart';

class SignUpScreen extends GetWidget<SignUpController> {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
                  () => CircleAvatar(
                    radius: 50,
                    backgroundImage: controller.profileImage.value != null
                        ? FileImage(controller.profileImage.value!)
                            as ImageProvider<Object>
                        : AssetImage(ImageConstant.imguser),
                    child: const Icon(
                      Icons.camera_alt,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20),
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
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20),
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
              padding: const EdgeInsets.only(
                  left: 20, top: 20, right: 20),
              child: ElevatedButton(
                onPressed: controller.signUp,

                style: ElevatedButton.styleFrom(
                  minimumSize: const Size(350, 50),
                ),
                child: const Text(
                  'Sign Up',
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
