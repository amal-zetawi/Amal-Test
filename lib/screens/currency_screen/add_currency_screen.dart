import 'package:Talabat/routes/app_routes.dart';
import 'package:currency_picker/currency_picker.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/add_currency_controller.dart';

class AddCurrencyScreen extends GetWidget<AddCurrencyController> {
  const AddCurrencyScreen({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Currency'),
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
              TextField(
                decoration: const InputDecoration(labelText: 'Currency Name'),
                controller:
                controller.currencyNameController, // Add controller for item name
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Currency Symbol'),
                controller:controller.currencySymbolController, // Add controller for price
              ),
              const SizedBox(height: 20),
              TextField(
                decoration: const InputDecoration(labelText: 'Currency Rate'),
                keyboardType: TextInputType.number,
                controller: controller.currencyRateController, // Add controller for price
              ),
              const SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  showCurrencyPicker(
                    context: context,
                    showFlag: true,
                    showSearchField: true,
                    showCurrencyName: true,
                    showCurrencyCode: true,
                    favorite: ['eur'],
                    onSelect: (Currency currency) {
                      controller.currencySymbolController.text = currency.symbol;
                      controller. currencyNameController.text = currency.name;
                    },
                  );
                },
                child: const Text('Select Currency name and symbol'),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  // Add logic to save item
                 controller.saveCurrency();
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
