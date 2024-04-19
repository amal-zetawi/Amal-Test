import 'package:Talabat/constants/images_constant.dart';
import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/items_screen/controller/add_items_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddItemsScreen extends GetWidget<AddItemsController> {
  const AddItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Item'),
        leading: IconButton(
          icon:const  Icon(Icons.arrow_back),
          onPressed: () {
            Get.offNamed( AppRoutes.homeScreen);
          },
        ),
      ),
      body:SingleChildScrollView(
      child:Padding(
        padding: const EdgeInsets.all(20.0),
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
            TextField(
              decoration: const InputDecoration(labelText: 'Item Name'),
              controller: controller.itemNameController, // Add controller for item name
            ),
           const SizedBox(height: 20),
            TextField(
              decoration:const  InputDecoration(labelText: 'Price'),
              keyboardType: TextInputType.number,
              controller: controller.itemPriceController, // Add controller for price
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add logic to save item
                controller.saveItem();
              },
              child: const Text('Save'),
            ),
          ],
        ),
      ),
      ),
    );
  }
}
