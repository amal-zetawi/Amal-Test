import 'package:Talabat/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:Talabat/screens/currency_screen/controller/currency_card_controller.dart';
import 'package:Talabat/sql/db_helper.dart';
import 'controller/add_order_controller.dart';
import 'package:date_picker_plus/date_picker_plus.dart';

class AddOrderScreen extends GetWidget<AddOrderController> {
  final TextEditingController amountcontroller = TextEditingController();
  final TextEditingController equalamountcontroller = TextEditingController();
  final CurrencyCardController currencyController =
      Get.put(CurrencyCardController());
  final TextEditingController _searchController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  AddOrderScreen({super.key});

  @override
  Widget build(BuildContext context) {
    controller.selectedCurrency.value = 'defaultCurrencyId';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Order'),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Get.offNamed(AppRoutes.homeScreen);
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
                      hint: const Text('Select Currency'),
                      items: currencyList.map((value) {
                        return DropdownMenuItem(
                          onTap: () {
                            controller.upadateCurrencyId(value['currencyId']);
                            // controller.upadateCurrencyName(value['currencyName']);
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
                      hint: const Text('Select User'),
                      items: currencyList.map((value) {
                        return DropdownMenuItem(
                          onTap: () {
                            controller.upadateUserId(value['id']);
                            controller.upadateUserName(value['name']);
                            // controller.updateRate(value['currencyRate']);
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
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
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
                      hint: const Text('Select Type'),
                      value: controller.selectType.value,
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
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else {
                    final itemList = snapshot.data!;
                    return DropdownButtonFormField(
                      padding: const EdgeInsets.all(10),
                      isDense: true,
                      isExpanded: true,
                      hint: const Text('Select Status'),
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
              FutureBuilder<List<Map<String, dynamic>>>(
                future: DatabaseHelper.getAllItems(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const CircularProgressIndicator();
                  } else if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  } else if (snapshot.data == null) {
                    return const Text('No data available');
                  } else {
                    final itemsList = snapshot.data!;
                    return Autocomplete<Map<String, dynamic>>(
                      optionsBuilder: (TextEditingValue textEditingValue) {
                        final query = textEditingValue.text.toLowerCase();
                        return itemsList.where((item) {
                          final itemName =
                              item['itemName'].toString().toLowerCase();
                          return itemName.contains(query);
                        }).toList();
                      },
                      displayStringForOption: (Map<String, dynamic> item) =>
                          item['itemName'].toString(),
                      onSelected: (Map<String, dynamic> item) {
                        _searchController.text = item['itemName'].toString();
                        controller.selectedItems.add(_searchController.text);
                        _priceController.text = item['price'].toString();
                        controller.selectedItemsPrice
                            .add(_priceController.text);
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
                          AutocompleteOnSelected<Map<String, dynamic>>
                              onSelected,
                          Iterable<Map<String, dynamic>> options) {
                        return Material(
                          child: SizedBox(
                            height: 200.0, // Adjust height as needed
                            child: ListView(
                              children: options.map((item) {
                                return ListTile(
                                  title: Text(item['itemName'].toString()),
                                  onTap: () {
                                    onSelected(item);
                                  },
                                );
                              }).toList(),
                            ),
                          ),
                        );
                      },
                    );
                  }
                },
              ),
              const SizedBox(height: 10),
              Obx(
                () => Card(
                  child: ListTile(
                    title: Text(
                        "Selected items: ${controller.selectedItems}${controller.selectedItemsPrice}"),
                  ),
                ),
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
                onPressed: () {
                  // Add logic to save item
                  controller.saveOrder();
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
