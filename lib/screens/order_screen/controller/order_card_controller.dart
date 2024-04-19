import 'package:Talabat/sql/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderCardController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  RxString filterText = ''.obs;

  void setFilter(String value) {
    filterText.value = value;
    update();
  }

  Future<List<Map<String, dynamic>>?> getOrder() async {
    return await DatabaseHelper.getAllOrder();
  }

  Future<void> deleteOrder(int index) async {
    await DatabaseHelper.deleteOrder(index);
    update();
  }

  Future<List<Map<String, dynamic>>> filterOrder(
      List<Map<String, dynamic>>? order) async {
    if (order == null) {
      return [];
    }

    if (filterText.isEmpty) {
      return order;
    }

    return order.where((order) {
      final String status = order['status'].toString().toLowerCase();
      final String orderAmount = order['orderAmount'].toString().toLowerCase();
     var x =DatabaseHelper.getUserById(order['userId']);
      print("hafeth$x");
      return status.contains(filterText.value.toLowerCase()) ||
          orderAmount.contains(filterText.value.toLowerCase());
    }).toList();
  }
}
