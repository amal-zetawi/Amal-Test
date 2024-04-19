import 'dart:io';
import 'package:Talabat/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'edit_user_controller.dart';

class EditUserScreen extends GetWidget<EditUserController> {
  const EditUserScreen({super.key});
  @override
  Widget build(BuildContext context) {


   // controller.initializeControllers(itemInfo);
      return Scaffold(
        appBar: AppBar(
          title: const Text('edit Profile'),
          leading: IconButton(
            icon:const  Icon(Icons.arrow_back),
            onPressed: () {
              Get.offNamed( AppRoutes.homeScreen);
            },
          ),
        ),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                GestureDetector(
                  onTap: controller.pickImage,
                  child: Obx(
                        () =>
                        CircleAvatar(
                          radius: 50,
                          backgroundColor: Colors.grey[300],
                          child: controller.profileImage.value != null
                              ? ClipOval(
                            child: Image.file(
                              File(controller.profileImage.value!.path),
                              fit: BoxFit
                                  .cover,
                              // Adjust the fit to control the size of the image
                              width: 100,
                              // Adjust the width as needed
                              height: 100, // Adjust the height as needed
                            ),
                          )
                              : const Icon(
                            Icons.camera_alt,
                            color: Colors.white,
                          ),
                        ),
                  ),
                ),
                TextField(
                  decoration: const InputDecoration(labelText: 'Name'),
                  controller: controller.nameController,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'User Name'),
                  keyboardType: TextInputType.number,
                  controller: controller.userNameController,
                ),
                const SizedBox(height: 20),
                TextField(
                  decoration: const InputDecoration(labelText: 'Password'),
                  keyboardType: TextInputType.number,
                  controller: controller.passwordController,
                ),
                const SizedBox(height: 20),
                ElevatedButton(
                  onPressed: () {
                    // Add logic to save item
                    controller.updateItem();
                  },
                  child: const Text('Save Edit'),
                ),
              ],
            ),
          ),
        ),
      );

  }
}
