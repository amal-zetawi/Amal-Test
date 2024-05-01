import 'dart:convert';

import 'package:Talabat/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Talabat/screens/currency_screen/controller/currency_card_controller.dart';
import 'package:Talabat/sql/db_helper.dart';
import 'controller/add_order_controller.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

import 'models/model_order_items.dart';

class AddOrderScreen extends GetWidget<AddOrderController> {
  final TextEditingController amountcontroller = TextEditingController();
  final TextEditingController equalamountcontroller = TextEditingController();
  final CurrencyCardController currencyController =
  Get.put(CurrencyCardController());
  final TextEditingController _searchController = TextEditingController();

  AddOrderScreen({super.key});
  @override
  Widget build(BuildContext context) {
    if (Get.arguments != null) {
      controller.updateRate(Get.arguments.currency.currencyRate);
      // controller.upadateCurrencyId
       // print("amal${(Get.arguments. currency.currencyName)}");
      //controller.upadateUserId
     // print("amal${ (Get.arguments.order.type)}");

   //  print("amalalizetawi${ controller.getOrderItems(Get.arguments.id)}");
      controller.dateController.text = Get.arguments.order.orderDate;
      controller.amountController.text =
          Get.arguments.order.orderAmount.toString();
      controller.equalAmmountController.text =
          Get.arguments.order.equalOrderAmount.toString();
      controller.type = Get.arguments.order.type;
      controller.isChecked.value =
      Get.arguments.order.status == 1 ? true : false;
      // controller.getOrderItems(Get.arguments.id);
    print("amalalizetaw}") ;
    }
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offNamed(AppRoutes.homeScreen, arguments: 2);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(30),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextField(
                controller: controller.dateController,
                decoration: const InputDecoration(
                  labelText: 'Order Date',
                  prefixIcon: Icon(Icons.calendar_today),
                ),
                readOnly: true,
                onTap: () async {
                  final selectedDate = await showDatePickerDialog(
                    context: context,
                    minDate: DateTime(2021, 1, 1),
                    maxDate: DateTime(2023, 12, 31),
                  );
                  if (selectedDate != null) {
                    final formattedDate = DateFormat.yMd().format(selectedDate);
                    controller.dateController.text = formattedDate;
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper.getAllCurrency(),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return const Text('No data available');
                  } else {
                    final currencyList = snapshot.data!;
                    return DropdownButtonFormField(
                      padding: const EdgeInsets.all(10),
                      isDense: true,
                      isExpanded: true,
                      hint: Get.arguments != null
                    ? Text(Get.arguments.currency.currencyName)
                      : const Text('Select Currency'),
                      items: currencyList.map((value) {
                        return DropdownMenuItem(
                          onTap: () {
                            controller.upadateCurrencyId(value['currencyId']);
                            controller.updateRate(value['currencyRate']);
                          },
                          value: value['currencyId'],
                          child: Text(value['currencyName'].toString()),
                        );
                      }).toList(),
                      onChanged: (Object? value) {},
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper.getAllUsers(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return const Text('No data available');
                  } else {
                    final currencyList = snapshot.data!;
                    return DropdownButtonFormField(
                      padding: const EdgeInsets.all(10),
                      isDense: true,
                      isExpanded: true,
                      hint: Get.arguments != null
                          ? Text(Get.arguments.user.name)
                          : const Text('Select User'),
                      items: currencyList.map((value) {
                        return DropdownMenuItem(
                          onTap: () {
                            controller.upadateUserId(value['id']);
                            controller.upadateUserName(value['name']);
                          },
                          value: value['id'],
                          child: Text(value['name'].toString()),
                        );
                      }).toList(),
                      onChanged: (Object? value) {},
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<String>>(
                future: Future.value([
                  "Sell Order",
                  "Purchased Order",
                  "Return Sell Order",
                  "Return Purchased Order"
                ]),
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    // Add null check here
                    return const Text(
                        'No data available'); // Return a widget indicating no data
                  } else {
                    final itemList = snapshot.data!;
                    return DropdownButtonFormField(
                      padding: const EdgeInsets.all(10),
                      isDense: true,
                      isExpanded: true,
                      hint:  Get.arguments != null
                          ? Text(Get.arguments.order.type)
                          : const Text('Select Type'),
                      //value: controller.selectType.value,
                      items: itemList.map((item) {
                        return DropdownMenuItem<int>(
                          value: itemList.indexOf(item),
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          controller.updateType(newValue);
                        }
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<String>>(
                future: Future.value(["Paid", "Not Paid"]),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final itemList = snapshot.data!;
                    return DropdownButtonFormField(
                      padding: const EdgeInsets.all(10),
                      isDense: true,
                      isExpanded: true,
                      hint:  Get.arguments != null
                          ? Text(Get.arguments.order.status)
                          : const Text('Select status'),
                      value: controller.selectStates.value,
                      items: itemList.map((item) {
                        return DropdownMenuItem<int>(
                          value: itemList.indexOf(item),
                          child: Text(item),
                        );
                      }).toList(),
                      onChanged: (int? newValue) {
                        if (newValue != null) {
                          controller.updateStates(newValue);
                        }
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              FutureBuilder<List<OrderItem>>(
                future: controller.queryItems(_searchController.text),
                builder: (context, snapshot) {
                  print("amalZ${controller.queryItems}");
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null || snapshot.data!.isEmpty) {
                    return const Text('No data available');
                  } else {
                    final itemsList = snapshot.data!;
                    return Autocomplete<OrderItem>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        if (textEditingValue.text.isEmpty) {
                          return <OrderItem>[];
                        } else {
                          final query = textEditingValue.text.toLowerCase();
                          return itemsList.where((item) {
                            final itemName = item.itemName.toLowerCase();
                            return itemName.contains(query);
                          }).toList();
                        }
                      },
                      displayStringForOption: (OrderItem item) => item.itemName,
                      onSelected: (OrderItem item) {
                        _searchController.text = item.itemName;

                        final bool isDuplicate = controller.orderItems.any(
                              (selectedItem) => selectedItem.itemId == item.itemId,
                        );

                        if (!isDuplicate) {
                          controller.orderItems.add(item);
                        }
                      },
                      fieldViewBuilder: (BuildContext context,
                          TextEditingController fieldTextEditingController,
                          FocusNode fieldFocusNode,
                          VoidCallback onFieldSubmitted) {
                        _searchController.addListener(() {
                          onFieldSubmitted();
                        });
                        return TextField(
                          controller: fieldTextEditingController,
                          focusNode: fieldFocusNode,
                          decoration: const InputDecoration(
                            labelText: 'Search Items',
                          ),
                        );
                      },
                      optionsViewBuilder: (BuildContext context,
                          AutocompleteOnSelected<OrderItem> onSelected,
                          Iterable<OrderItem> options) {
                        return Material(
                          child: SizedBox(
                            height: 200.0,
                            child: SingleChildScrollView(
                              child: Column(
                                children: options.map((item) {
                                  return ListTile(
                                    title: Text(item.itemName),
                                    onTap: () {
                                      onSelected(item);
                                    },
                                  );
                                }).toList(),
                              ),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              SingleChildScrollView(
                child:
                Obx(() {
                  return ListView.builder(
                    shrinkWrap: true,
                    physics: const NeverScrollableScrollPhysics(),
                    itemCount: controller.orderItems.length,
                    itemBuilder: (context, index) {
                      return Card(
                        child: Column(
                          children: [
                            ListTile(
                              title: Text(
                                "Item: ${controller.orderItems[index].itemName}\nPrice: \$${controller.orderItems[index].priceController.text}\n",
                              ),
                            ),
                            TextFormField(
                              controller: controller.orderItems[index].priceController,
                              decoration: const InputDecoration(
                                labelText: 'Enter new price',
                              ),
                              keyboardType: TextInputType.number,
                            ),
                            TextField(
                              controller:controller.orderItems[index].countController,
                              decoration: const InputDecoration(
                                labelText: 'count',
                              ),
                            ),
                          ],
                        ),
                      );
                    },

                  );
                }),
              ),

              const SizedBox(height: 20),
              TextField(
                controller: controller.amountController,
                decoration: const InputDecoration(
                  labelText: 'Amount',
                ),
              ),
              const SizedBox(height: 10),
              TextField(
                controller: controller.equalAmmountController,
                decoration: const InputDecoration(
                  labelText: 'Equal Amount',
                ),
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: () async {
                  if (Get.arguments == null) {
                    //To do
                   controller. calculateTotalAmount();
                   await controller.saveOrder();
                   var orderId  = await controller.getLast();
                    // print("zetawiaaa${orderId[0]["orderId"]}");
                    // OrderItem
                   for(OrderItem o in  controller.orderItems){
                     controller.saveOrderItems(o, orderId[0]["orderId"]);
                   }

                  } else {
                    controller.editOrder();
                  }
                },
                child: const Text('Save Order'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}