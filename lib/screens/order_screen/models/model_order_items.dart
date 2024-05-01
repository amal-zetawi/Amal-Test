import 'package:flutter/material.dart';

class OrderItem {
  final int itemId;
  final String itemName;
  final TextEditingController priceController;
  final TextEditingController countController;
  double price;
 var count;
  OrderItem({required this.itemId,
    required this.itemName,
    required this.price,
    required this.count,
  })  : priceController = TextEditingController(text: price.toString()),
        countController = TextEditingController(text: count.toString()){
  // Listen to changes in the priceController and update the price property accordingly
  priceController.addListener(() {
  price = double.tryParse(priceController.text) ?? 0.0;
  });

  // Listen to changes in the countController and update the count property accordingly
  countController.addListener(() {
  count = int.tryParse(countController.text) ?? 1;
  });
}

  factory OrderItem.fromMap(Map<String, dynamic> map) {
    return OrderItem(
      itemId: map['itemId'] as int,
      itemName: map['itemName'] as String,
      price: map['price'] as double,
      count: map['count'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      "itemId": itemId,
      "itemName": itemName,
      "price": price,
      "count": count,
    };
  }
}
