class Order {
  int currencyId;
  int userId;
  String orderDate;
  double orderAmount;
  double equalOrderAmount;
  String status;
  String type;

  Order(
      {required this.currencyId,
      required this.userId,
      required this.orderDate,
      required this.orderAmount,
      required this.equalOrderAmount,
      required this.status,
      required this.type});

  Map<String, dynamic> toMap() {
    return {
      "currencyId": currencyId,
      "userId": userId,
      "orderDate": orderDate,
      "orderAmount": orderAmount,
      "equalOrderAmount": equalOrderAmount,
      "status": status,
      "type": type
    };
  }
}
