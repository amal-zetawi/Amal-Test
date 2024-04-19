import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/order_screen/controller/order_card_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
                    labelText: 'search order',
                    labelStyle: const TextStyle(fontSize: 12), //
                    prefixIcon: const Icon(Icons.search),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                ),
              ),
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
              if (snapshot.connectionState == ConnectionState.waiting) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (snapshot.hasError) {
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
                        child: CircularProgressIndicator(),
                      );
                    } else if (filteredSnapshot.hasError) {
                      return Center(
                        child: Text('Error: ${filteredSnapshot.error}'),
                      );
                    } else {
                      return ListView.builder(
                        physics: const NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: filteredSnapshot.data!.length,
                        itemBuilder: (context, i) {
                          return Card(
                            child: ListTile(
                              leading: Text(
                                  "${filteredSnapshot.data![i]['status']}",
                                  style: const TextStyle(fontSize: 18)),
                              title: Column(
                                children: [
                                  Text("${filteredSnapshot.data![i]['type']}"),
                                  Text(
                                      "amont:${filteredSnapshot.data![i]['orderAmount']}"),
                                  Text(
                                      "Eamount:${filteredSnapshot.data![i]['equalOrderAmount']}"),
                                ],
                              ),
                              subtitle: Text(
                                  "${filteredSnapshot.data![i]['orderDate']}"),
                              trailing: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  // Delete IconButton
                                  IconButton(
                                    onPressed: () {
                                      controller.deleteOrder(
                                          filteredSnapshot.data![i]['orderId']);
                                    },
                                    icon: const Icon(Icons.delete,
                                        color: Colors.red),
                                  ),
                                  // Edit IconButton
                                  IconButton(
                                    onPressed: () {
                                      Get.offNamed(
                                        AppRoutes.editOrderScreen,
                                        arguments: filteredSnapshot.data![i],
                                      );
                                    },
                                    icon: const Icon(Icons.edit,
                                        color: Colors.blue),
                                  ),
                                  //Obx(() =>
                                  Switch(
                                    value: filteredSnapshot.data![i]
                                            ['status'] ==
                                        'Paid',
                                    onChanged: (value) {
                                      // Implement logic to update status
                                      if (value) {
                                        // If value is true, set status to 'Paid', else set to 'Not Paid'
                                        // controller.updateStatus(filteredSnapshot.data![i]['orderId'], 'Paid');
                                      } else {
                                        //controller.updateStatus(filteredSnapshot.data![i]['orderId'], 'Not Paid');
                                      }
                                    },
                                  ),
                                  // ),
                                ],
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
