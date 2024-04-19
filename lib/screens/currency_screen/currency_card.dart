import 'package:Talabat/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/currency_card_controller.dart';

class CurrencyCard extends GetWidget<CurrencyCardController> {
  const CurrencyCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<CurrencyCardController>(
      init: CurrencyCardController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          actions: <Widget>[
            Expanded(
              child: GetBuilder<CurrencyCardController>(
                builder: (_) => TextField(
                  onChanged: controller.setFilter,
                  decoration: InputDecoration(
                    labelText: 'search currency',
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
                Get.offNamed(AppRoutes.addCurrencyScreen); // Navigate to currency add screen
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>?>(
          future: controller.getCurrency(),
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
              // Filter items based on search text
              var filteredItems = controller.filterCurrency(snapshot.data);
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      leading:Text("${filteredItems[i]['currencySymbol']}",style: const TextStyle(fontSize: 18),),
                      title:  Text("${filteredItems[i]['currencyName']}"),
                      subtitle: Text("${filteredItems[i]['currencyRate']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () {
                              controller.deleteCurrency(filteredItems[i]['currencyId']);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.offNamed(
                                AppRoutes.editCurrencyScreen,
                                arguments: filteredItems[i],
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.blue),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              );
            }
          },
        ),
      ),
    );
  }
}
