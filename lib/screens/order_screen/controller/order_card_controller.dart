import 'package:Talabat/sql/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class OrderCardController extends GetxController {
  TextEditingController searchTextController = TextEditingController();
  RxString filterText = ''.obs;
  RxInt selectStates = 0.obs;
  String status = '';
  RxList orders = [].obs;
  RxBool isDescSorted = false.obs;
  RxInt response3 =1.obs;

  invertSorting() {
    isDescSorted.value = !isDescSorted.value;
  }

  sorting() async {
    if (isDescSorted.value) {
      orders.sort((a, b) => -a['orderAmount'].compareTo(b['orderAmount']));
    } else {
      orders.sort((a, b) => a['orderAmount'].compareTo(b['orderAmount']));
    }
  }

  updateStates(bool state, int id) async {
    int response = await DatabaseHelper.updateOrderState('''
    UPDATE 'orders' SET status=$state WHERE orderId=$id
''');
    return response;
  }

  getOrders() async {
    List response = await DatabaseHelper.readJoin('''
    SELECT users.name AS name, users.username AS username, 
    users.password AS password, users.profile_image AS profile_image,
    currency.currencyName AS currencyName, currency.currencySymbol, currency.currencyRate,
    orders.orderDate, orders.status AS status, orders.orderAmount AS orderAmount,
    orders.type AS type, orders.equalOrderAmount AS equalOrderAmount, orders.orderId AS orderId,
    orders.userId, orders.currencyId
    FROM orders JOIN users 
    ON users.id=orders.userId JOIN currency 
    ON currency.currencyId=orders.currencyId
''');
    orders.addAll(response);
    orders.map((element) => null);
  }

  // void updateStates(value) {
  //   selectStates.value = value;
  //   if(value==1){
  //     status='paid';
  //   }
  //   else if(value==0){
  //     status='not';
  //
  //   }
  // }

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

  filter(String value) {
    Iterable filterdUsers = orders.where((element) =>
        element['username'].toString().toLowerCase().startsWith(value) ||
        element['amount'].toString().toLowerCase().startsWith(value));
    orders.replaceRange(0, orders.length, filterdUsers.toList());
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
      return status.contains(filterText.value.toLowerCase()) ||
          orderAmount.contains(filterText.value.toLowerCase());
    }).toList();
  }

  @override
  void onInit() {
    super.onInit();
    ever(orders, (_) {
      // Whenever orders list changes, update the UI
      update();
    });
    getOrders();
  }
}
