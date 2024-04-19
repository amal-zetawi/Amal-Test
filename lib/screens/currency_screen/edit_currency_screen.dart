import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/edit_currency_controller.dart';

class EditCurrencyScreen extends GetWidget<EditCurrencyController> {
  const EditCurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Retrieve the passed arguments
    final Map<String, dynamic> itemInfo = Get.arguments;

    // Call the method to initialize controllers
    controller.initializeControllers(itemInfo);


    return Scaffold(
      appBar: AppBar(
        title: const Text('edit Currency'),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                decoration: const InputDecoration(labelText: 'Currency Name'),
                controller: controller.currencyNameController,
              ),
             const  SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Currency Symbol'),
                controller: controller.currencySymbolController,
              ),
             const  SizedBox(height: 20),
              TextField(
                decoration:const  InputDecoration(labelText: 'Currency Raty'),
                keyboardType: TextInputType.number,
                controller: controller.currencyRateController,
              ),
            const  SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add logic to save item
                  controller.updateCurrency();
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
