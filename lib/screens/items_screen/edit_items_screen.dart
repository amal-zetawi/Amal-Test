import 'dart:io';
import 'package:Talabat/screens/items_screen/controller/edit_items_contrller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EditItemsScreen extends GetWidget<EditItemsController> {
  const EditItemsScreen({super.key});
  @override
  Widget build(BuildContext context) {
    final Map<String, dynamic> itemInfo = Get.arguments;

    controller.initializeControllers(itemInfo);
    return Scaffold(
      appBar: AppBar(
        title: const Text('edit Item'),
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
                  () => CircleAvatar(
                    radius: 50,
                    backgroundColor: Colors.grey[300],
                    child: controller.profileImage.value != null
                        ? ClipOval(
                            child: Image.file(
                              File(controller.profileImage.value!.path),
                              fit: BoxFit
                                  .cover, // Adjust the fit to control the size of the image
                              width: 100, // Adjust the width as needed
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
                decoration: const InputDecoration(labelText: 'Item Name'),
                controller: controller.itemNameController,
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Price'),
                keyboardType: TextInputType.number,
                controller: controller.priceController,
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
