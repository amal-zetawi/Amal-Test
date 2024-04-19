import 'package:Talabat/sql/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsCardController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  RxString filterText = ''.obs;

  void setFilter(String value) {
    filterText.value = value;
    update();
  }

  Future<List<Map<String, dynamic>>?> getItem() async {
    return await DatabaseHelper.getAllItems();
  }

  Future<void> deleteItem(int index) async {
    await DatabaseHelper.deleteItem(index);
    update();
  }

  List<Map<String, dynamic>> filterItems(List<Map<String, dynamic>>? items) {
    if (items == null) {
      return [];
    }

    if (filterText.isEmpty) {
      return items;
    }

    return items.where((item) {
      final String itemName = item['itemName'].toString().toLowerCase();
      final String price = item['price'].toString().toLowerCase();
      return itemName.contains(filterText.value.toLowerCase()) ||
          price.contains(filterText.value.toLowerCase());
    }).toList();
  }

}
