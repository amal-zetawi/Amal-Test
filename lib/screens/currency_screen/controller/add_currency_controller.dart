import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/currency_screen/models/model_currency.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Talabat/sql/db_helper.dart';

class AddCurrencyController extends GetxController {
  TextEditingController currencyNameController = TextEditingController();
  TextEditingController currencySymbolController = TextEditingController();
  TextEditingController currencyRateController = TextEditingController();
  static RxList currencies = [].obs;
  RxInt deletedIndex = 0.obs;

  insert(String table, CurrencyPage currency) async {
    Map<String, dynamic> currencyMap = currency.toMap();
    int response = await DatabaseHelper.insert(table, currencyMap);
    List inserted = await getLast();
    Map insertedCurrency = inserted[0];
    currencies.add(insertedCurrency);
    if (response > 0) {
      Get.offNamed(AppRoutes.homeScreen, arguments: 1);
    }
    return response;
  }

  getLast() async {
    List<Map> response = await DatabaseHelper.getLast('''
        SELECT * FROM currency ORDER BY currencyId DESC LIMIT 1
    ''');

    return response;
  }

  Future<void> saveCurrency() async {
    if (currencyNameController.text.isEmpty ||
        currencySymbolController.text.isEmpty ||
        currencyRateController.text.isEmpty) {
      Get.snackbar('Error', 'Please fill in all fields.',
          colorText: Colors.red);
      return;
    }
    CurrencyPage currency = CurrencyPage(
      currencyName: currencyNameController.text,
      currencySymbol: currencySymbolController.text,
      currencyRate: double.parse(currencyRateController.text),
    );
    insert('currency', currency);
  }

  updateCurrency(String table, CurrencyPage currency, int id) async {
    Map<String, dynamic> userMap = currency.toMap();
    int res = await DatabaseHelper.update(table, userMap, "currencyId=$id");
    if (res > 0) {
      Get.offNamed(AppRoutes.homeScreen, arguments: 1);
    }
  }
}
