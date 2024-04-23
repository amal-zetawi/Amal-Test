import 'package:Talabat/sql/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ItemsCardController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  RxString filterText = ''.obs;
  RxList items = [].obs;
  RxInt deletedIndex = 0.obs;

  void setFilter(String value) {
    filterText.value = value;
    update();
  }

  Future<List<Map<String, dynamic>>?> getItem() async {
    return await DatabaseHelper.getAllItems();
  }


  delete(String table, int id) async {
    int response = await DatabaseHelper.delete(table, "itemId=$id");
    if (response > 0) {
      items.removeWhere((o) => o!['itemId'] == id);
      update();
    }
  }

  getItems(String table) async {
    List<Map> response = await DatabaseHelper.read(table);
    items.addAll(response);
  }

  //new
  filter(String value) {
    Iterable filterdUsers = items.where((element) =>
    element['name'].toString().toLowerCase().startsWith(value) ||
        element['price'].toString().toLowerCase().startsWith(value));
    items.replaceRange(0, items.length, filterdUsers.toList());
  }

  //old
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
  @override
  void onInit() {
    super.onInit();
    getItems('items');
  }

}
