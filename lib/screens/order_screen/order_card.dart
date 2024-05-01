import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/currency_screen/models/model_currency.dart';
import 'package:Talabat/screens/order_screen/controller/order_card_controller.dart';
import 'package:Talabat/screens/sign_up_screen/models/model_user.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/add_order_controller.dart';
import 'models/model_argument_order.dart';
import 'models/model_order.dart';
import 'models/model_order_items.dart';

class OrderCard extends GetWidget<OrderCardController> {
  const OrderCard({super.key});
  @override
  Widget build(BuildContext context) {
    return GetBuilder<OrderCardController>(
      init: OrderCardController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Expanded(
              child: GetBuilder<OrderCardController>(
                builder: (_) => TextField(
                  onChanged: controller.setFilter,
                  decoration: InputDecoration(
                    labelText: 'search by status | amount',
                    labelStyle: const TextStyle(fontSize: 12), //
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                GetX<OrderCardController>(
                    builder: (OrderCardController controller) {
                  return GestureDetector(
                    child: controller.isDescSorted.value
                        ? const Icon(
                            Icons.arrow_upward,
                            color: Color.fromARGB(255, 64, 99, 67),
                            size: 30.0,
                          )
                        : const Icon(
                            Icons.arrow_downward,
                            color: Color.fromARGB(255, 64, 99, 67),
                            size: 30.0,
                          ),
                    onTap: () async {
                      controller.invertSorting();
                      await controller.sorting();
                    },
                  );
                }),
              ],
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            Get.offNamed(AppRoutes.addOrderScreen);
          },
          child: const Icon(Icons.add),
        ),
        body: SingleChildScrollView(
          child: FutureBuilder<List<Map<String, dynamic>>?>(
            future: controller.getOrder(),
            builder: (context, snapshot) {
              if (snapshot.hasError) {
                return Center(
                  child: Text('Error: ${snapshot.error}'),
                );
              } else {
                var filteredOrders = controller.filterOrder(snapshot.data);

                return FutureBuilder<List<Map<String, dynamic>>>(
                  future: filteredOrders,
                  builder: (context, filteredSnapshot) {
                    if (filteredSnapshot.connectionState ==
                        ConnectionState.waiting) {
                      return const Center(
                        child:
                            CircularProgressIndicator(), // or any other loading indicator
                      );
                    } else if (filteredSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${filteredSnapshot.error}'),
                      );
                    } else if (filteredSnapshot.data == null) {
                      return const Center(
                        child: Text(
                            'Data is null'), // or any other message or widget
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredSnapshot.data!.length,
                        itemBuilder: (context, i) {
                          return GetBuilder<OrderCardController>(
                            // init: OrderCardController(),
                            builder: (controller) => Card(
                              child: ListTile(
                                leading: Text(
                                  "${controller.orders[i]['status']}",
                                  style: const TextStyle(fontSize: 18),
                                ),
                                title: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                        "Type: ${controller.orders[i]['type']}"),
                                    Text(
                                        "Equal Amount: ${controller.orders[i]['equalOrderAmount']}"),
                                    Text(
                                        "Currency Name: ${controller.orders[i]['currencyName']}"),
                                    Text(
                                        "User Name: ${controller.orders[i]['username']}"),
                                    Text(
                                        "${controller.orders[i]['orderDate']}"),
                                    Text(
                                        "Amount: ${controller.orders[i]['orderAmount']}"),
                                  ],
                                ),
                                trailing: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      onPressed: () {
                                        controller.deleteOrder(filteredSnapshot
                                            .data![i]['orderId']);
                                      },
                                      icon: const Icon(Icons.delete,
                                          color: Colors.red),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        Get.offNamed(
                                          AppRoutes.addOrderScreen,
                                          arguments: OrderArgument(
                                            id: controller.orders[i]['orderId'],
                                            user: User(
                                              name: controller.orders[i]
                                                  ['name'],
                                              username: '',
                                              password: '',
                                              profile_image: null,
                                            ),
                                            currency: CurrencyPage(
                                              currencyName: controller.orders[i]
                                                  ['currencyName'],
                                              currencySymbol: '',
                                              currencyRate: controller.orders[i]
                                                  ['currencyRate'],
                                            ),
                                            order: Order(
                                              currencyId: controller.orders[i]
                                                  ['currencyId'],
                                              userId: controller.orders[i]
                                                  ['userId'],
                                              orderDate: controller.orders[i]
                                                  ['orderDate'],
                                              orderAmount: controller.orders[i]
                                                  ['orderAmount'],
                                              equalOrderAmount:
                                                  controller.orders[i]
                                                      ['equalOrderAmount'],
                                              status: controller.orders[i]
                                                  ['status'],
                                              type: controller.orders[i]
                                                  ['type'],
                                            ),
                                          ),
                                        );
                                      },
                                      icon: const Icon(Icons.edit,
                                          color: Colors.blue),
                                    ),
                                    Switch(
                                      value: controller.orders[i]['status'] ==
                                              'paid'
                                          ? true
                                          : false,
                                      onChanged: (value) async {
                                        // Implement logic to update status
                                        if (value) {
                                          // If value is true, set status to 'Paid', else set to 'Not Paid'
                                          // int res = await controller.updateStates(value,filteredSnapshot.data![i]['orderId']);
                                          // if (res > 0) {
                                          //   await controller.updateLocalOrder(filteredSnapshot.data![i]['orderId']);
                                          // }
                                        } else {
                                          // controller.updateStatus(filteredSnapshot.data![i]['orderId'], 'Not Paid');
                                        }
                                      },
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    }
                  },
                );
              }
            },
          ),
        ),
      ),
    );
  }
}
