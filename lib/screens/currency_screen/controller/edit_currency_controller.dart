import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Talabat/sql/db_helper.dart';

class EditCurrencyController extends GetxController {
  Rx<File?> profileImage = Rx<File?>(null);

  TextEditingController currencyNameController = TextEditingController();
  TextEditingController currencySymbolController = TextEditingController();
  TextEditingController currencyRateController = TextEditingController();

  late final int id;
  @override
  void onInit() {
    super.onInit();
    currencyNameController = TextEditingController();
    currencySymbolController = TextEditingController();
    currencyRateController = TextEditingController();
  }

  void initializeControllers(Map<String, dynamic> currencyInfo) {
    id = currencyInfo['currencyId'] ?? '';
    currencyNameController.text = currencyInfo['currencyName'] ?? '';
    currencySymbolController.text = currencyInfo['currencySymbol'] ?? '';
    currencyRateController.text = currencyInfo['currencyRate'] != null
        ? '${currencyInfo['currencyRate']}'
        : '';
  }

  Future<void> updateCurrency() async {
    if (currencyNameController.text.isEmpty ||
        currencySymbolController.text.isEmpty ||
        currencyRateController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          colorText: Colors.red);
      return;
    }

    await DatabaseHelper.updateCurrency(
      id,
      currencyNameController.text,
      currencySymbolController.text,
      double.parse(currencyRateController.text),
    );
  }
}
