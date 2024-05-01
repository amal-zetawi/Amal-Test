import 'dart:convert';
import 'dart:ffi';

import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/order_screen/models/model_order.dart';
import 'package:Talabat/screens/order_screen/models/model_order_items.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:Talabat/sql/db_helper.dart';

class AddOrderController extends GetxController {
  TextEditingController dateController = TextEditingController();
  TextEditingController currencyController = TextEditingController();
  TextEditingController currencyNameController = TextEditingController();
  TextEditingController currencySymbolController = TextEditingController();
  TextEditingController currencyRateController = TextEditingController();
  TextEditingController amountController = TextEditingController();
  TextEditingController equalAmmountController = TextEditingController();
  final TextEditingController priceController = TextEditingController();
  TextEditingController countController = TextEditingController();
  TextEditingController priceEditingController = TextEditingController();
  final List<TextEditingController> countControllers = [];

  var selectedCurrency = ''.obs;
  RxDouble rate = 0.0.obs;
  RxInt currencyId = 0.obs;
  String currencyName = '';
  String userName = '';
  RxInt userId = 0.obs;
  RxString stateKeyword = "".obs;
  RxBool isChecked = false.obs;
  RxInt userItem = 0.obs;
  RxInt selectType = 0.obs;
  String type = '';
  String status = '';
  int idCurrency = 1;
  RxInt selectStates = 0.obs;
  RxList orders = [].obs;
  RxList<OrderItem> orderItems = <OrderItem>[].obs;
  // RxList orderItems = [].obs;
  RxDouble amount = 0.0.obs;
  RxDouble eAmount = 0.0.obs;
  RxDouble price = 0.0.obs;
  int idUser = 0;
  //items.map((i) => orderitems.add(OrderItem(i['name'])))

  updateEAmount(double value) {
    eAmount.value = value;
  }

  updateAmount(double value) {
    amount.value = value;
  }

  updateRate(double value) {
    rate.value = value;
  }

  void updateSelectedCurrency(String currency) {
    selectedCurrency.value = currency;
  }

  RxList<Map<String, dynamic>> selectedItems = <Map<String, dynamic>>[].obs;
  RxList<String> selectedItemsPrice = <String>[].obs;

  double sumSelectedItemsPrice() {
    double sum = selectedItemsPrice.fold(
        0, (previousValue, element) => previousValue + double.parse(element));
    return sum;
  }

  @override
  Future<void> onInit() async {
    if (Get.arguments != null) {
      await getOrderItems(Get.arguments.id);
    }

    dateController = TextEditingController();
    currencyController = TextEditingController();

    ever(eAmount, (double value) {
      double equalAmount =
          equalAmmount(double.parse(amountController.text), value);
      equalAmmountController.text = equalAmount.toString();
    });

    getOrders();
    super.onInit();
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
  }

  updateAmountController() {
    amountController.text = amount.value.toStringAsFixed(2);
  }

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

  double equalAmmount(double amount, double value) {
    return amount / value;
  }

  upadateCurrencyId(int value) {
    currencyId.value = value;
    idCurrency = value;
  }

  upadateCurrencyName(int value) {
    currencyId.value = value;
  }

  upadateUserId(int value) {
    userId.value = value;
    idUser = value;
  }

  upadateUserName(String value) {
    userName = value;
  }

  upadateItemsId(int value) {
    userItem.value = value;
  }

  void updateType(value) {
    selectType.value = value;
    if (selectType.value == 0) {
      type = 'Sell Order';
    } else if (selectType.value == 1) {
      type = 'Purchased Order';
    } else if (selectType.value == 2) {
      type = 'Return Sell Order';
    } else if (selectType.value == 3) {
      type = 'Return Purchased Order';
    }
  }

  updateStateKeyWord(value) {
    if (value == 1) {
      stateKeyword.value = "Paid";
    }
    return stateKeyword.value;
  }

  toggleCheck(value) {
    isChecked.value = value!;
  }

  void updateStates(value) {
    selectStates.value = value;
    if (value == 0) {
      status = 'paid';
    } else if (value == 1) {
      status = 'not';
    }
  }

  Future<void> editOrder() async {
    double doubleRate = rate.value;
    updateEAmount(doubleRate);
    double equalA =
        equalAmmount(double.parse(amountController.text), doubleRate);
double amount =(orderItems[0].price*orderItems[0].count);
    Order order = Order(
      currencyId:1,
      userId:1,
      orderDate: dateController.text,
      orderAmount: amount,
      equalOrderAmount: equalA,
      status: status,
      type: type,
    );

    OrderItem orderItem=OrderItem(
       itemId:orderItems[0].itemId,
       itemName:orderItems[0].itemName,
       price:orderItems[0].price,
       count:orderItems[0].count,

    );
    updateOrderItems('ordersItems', orderItem, Get.arguments.id);
    updateOrder('orders', order, Get.arguments.id);
  }

  Future<void> saveOrder() async {
    double doubleRate = rate.value;
    updateEAmount(doubleRate);
    double equalA =
        equalAmmount(double.parse(amountController.text), doubleRate);

    Order order = Order(
      currencyId: idCurrency,
      userId: idUser,
      orderDate: dateController.text,
      orderAmount: double.parse(amountController.text),
      equalOrderAmount: equalA,
      status: status,
      type: type,
    );

    insert('orders', order);
  }


  Future<void> saveOrderItems(OrderItem o,int id) async {

    insertOrderItems('ordersItems', o,id);
  }


  void addItem(Map<String, dynamic> item) {
    selectedItems.add(item);
  }

  void removeItem(String item) {
    selectedItems.remove(item);
  }

  updateOrder(String table, Order order, int id) async {
    Map<String, dynamic> orderMap = order.toMap();
    int res = await DatabaseHelper.update(table, orderMap, "orderId=$id");
    if (res > 0) {
      Get.offNamed(AppRoutes.homeScreen, arguments: 2);
    }
  }
  updateOrderItems(String table, OrderItem order, int id) async {
    Map<String, dynamic> orderMap = order.toMap();
    int res = await DatabaseHelper.update(table, orderMap, "orderId=$id");
    if (res > 0) {
      Get.offNamed(AppRoutes.homeScreen, arguments: 2);
    }
  }

  insert(String table, Order order) async {
    Map<String, dynamic> orderMap = order.toMap();
    int response = await DatabaseHelper.insert(table, orderMap);
    List<Map> inserted = await getLast();
    Map insertedOrder = inserted[0];
    orders.add(insertedOrder);
    if (response > 0) {
      Get.offNamed(AppRoutes.homeScreen, arguments: 2);
    }
    return response;
  }

  insertOrderItems(String table, OrderItem orderItem ,int id ) async {
    Map<String, dynamic> orderMap={
      "count": orderItem.count,
      "price": orderItem.price,
      "itemName":  orderItem.itemName,
      "itemId": orderItem.itemId,
      "orderId": id,
    };
    int response = await DatabaseHelper.insert(table,orderMap);
    orderItems.add(orderItem);
    if (response > 0) {
    }
    return response;
  }

  getLast() async {
    List<Map> response = await DatabaseHelper.getLast('''
 SELECT users.name AS name, users.username AS username, 
    users.password AS password, users.profile_image AS profile_image,
    currency.currencyName AS currencyName, currency.currencySymbol, currency.currencyRate,
    orders.orderDate, orders.status AS status, orders.orderAmount AS orderAmount,
    orders.type AS type, orders.equalOrderAmount AS equalOrderAmount, orders.orderId AS orderId,
    orders.userId, orders.currencyId
    FROM orders JOIN users 
    ON users.id=orders.userId JOIN currency 
    ON currency.currencyId=orders.currencyId ORDER BY orders.orderId DESC LIMIT 1
''');
    return response;
  }

  updateOrderState(int state, int id) async {
    int response = await DatabaseHelper.updateOrderState('''
    UPDATE 'orders' SET status=$state WHERE orderId=$id
''');
    if (response > 0) {}
  }

  updatePrice(double price, int id) async {
    int response = await DatabaseHelper.updateOrderState('''
    UPDATE 'items' SET price=$price WHERE itemId=$id
''');
    if (response > 0) {}
  }

  totalPrice() {
    double sum = selectedItemsPrice.fold(
        0, (previousValue, element) => previousValue + double.parse(element));
    String countText = countController.text;
    double count = double.tryParse(countText) ?? 0.0;
    amount.value = (sum * count);
  }

  void calculateTotalAmount() {
    double totalAmount = 0.0;
    for (OrderItem item in orderItems) {
      double newPrice = double.parse(item.priceController.text);
      double count = double.tryParse(item.countController.text) ?? 0.0;
      totalAmount += (newPrice * count);
    }
    amount.value = totalAmount;
   amountController.text = totalAmount.toString();
  }

  Future<List<OrderItem>> queryItems(String value) async {
    List<Map<String, dynamic>> mapList = await DatabaseHelper.queryItems(value);
    List<OrderItem> filteredItems = mapList.map((map) => OrderItem.fromMap(map)).toList();
    return filteredItems;
  }


  Future<List<Map<String, dynamic>>> getOrderItems(int orderId) async {
    List<Map<String, dynamic>> mapList = await DatabaseHelper.queryOrderItems(orderId);
    // Convert each map to an OrderItem object
    List<OrderItem> items = mapList.map((map) => OrderItem.fromMap(map)).toList();
    orderItems.assignAll(items);
    return mapList;
  }

}


