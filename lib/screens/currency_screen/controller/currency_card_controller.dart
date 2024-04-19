import 'package:Talabat/sql/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CurrencyCardController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  RxString filterText = ''.obs;
  RxList currency = [].obs;

  void setFilter(String value) {
    filterText.value = value;
    update();
  }

  Future<List<Map<String, dynamic>>?> getCurrency() async {
    return await DatabaseHelper.getAllCurrency();
  }

  Future<void> deleteCurrency(int index) async {
    await DatabaseHelper.deleteCurrency(index);
    update();
  }

  List<Map<String, dynamic>> filterCurrency(List<Map<String, dynamic>>? currency) {
    if (currency == null) {
      return [];
    }

    if (filterText.isEmpty) {
      return currency;
    }

    return currency.where((currency) {
      final String itemName = currency['currencyName'].toString().toLowerCase();
      final String price = currency['currencyRate'].toString().toLowerCase();
      return itemName.contains(filterText.value.toLowerCase()) ||
          price.contains(filterText.value.toLowerCase());
    }).toList();
  }

}
