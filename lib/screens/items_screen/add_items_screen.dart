import 'dart:io';
import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/items_screen/controller/add_items_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'models/model_item.dart';


class AddItemsScreen extends GetWidget<AddItemsController> {
  const AddItemsScreen({super.key});

  @override
  Widget build(BuildContext context) {

    if (Get.arguments != null) {
      controller. itemNameController.text = Get.arguments['items'].items.itemName;
      controller.profileImage.value = Get.arguments['items'].items.image;
      controller. itemPriceController.text =(Get.arguments['items'].items.price).toString();
    }
    if (Get.arguments == null) {
      controller. itemNameController.text = '';
      controller.profileImage.value  ;
      controller. itemPriceController.text = '';
    }

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
                child:
                Obx(
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
              onPressed: () async {
                if (Get.arguments == null) {
                  controller.saveItem();
                } else {
                  Items items = Items(
                      itemName:   controller.itemNameController.text,
                      image:   controller.profileImage.value,
                      price:  double.parse(controller. itemPriceController.text) ,
                  );
                  await controller.updateItems(
                      'items', items, Get.arguments['items'].id);
                }
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
