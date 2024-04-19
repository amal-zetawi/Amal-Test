import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Talabat/sql/db_helper.dart';

class AddCurrencyController extends GetxController {
  TextEditingController currencyNameController = TextEditingController();
  TextEditingController currencySymbolController = TextEditingController();
  TextEditingController currencyRateController = TextEditingController();

  Future<void> saveCurrency() async {
    if (currencyNameController.text.isEmpty ||
        currencySymbolController.text.isEmpty ||
        currencyRateController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          colorText: Colors.red);
      return;
    }
    await DatabaseHelper.saveCurrency(
      currencyNameController.text,
      currencySymbolController.text,
      double.parse(currencyRateController.text),
    );
    DatabaseHelper.getAllCurrency();
  }
}
