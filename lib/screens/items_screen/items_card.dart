import 'dart:io';
import 'package:Talabat/routes/app_routes.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/items_card_controller.dart';
import 'models/model_item.dart';
import 'models/modle_argument_item.dart';

class ItemsCard extends GetWidget<ItemsCardController> {
  const ItemsCard({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ItemsCardController>(
      init: ItemsCardController(),
      builder: (controller) => Scaffold(
        appBar: AppBar(
          // title: Text('Your App Title'),
          actions: <Widget>[
            Expanded(
              child: GetBuilder<ItemsCardController>(
                builder: (_) => TextField(
                  onChanged: controller.setFilter,
                  decoration: InputDecoration(
                    labelText: 'search by name | price',
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
            Get.offNamed(
                AppRoutes.addItemsScreen); // Navigate to currency add screen
          },
          child: const Icon(Icons.add),
        ),
        body: FutureBuilder<List<Map<String, dynamic>>?>(
          future: controller.getItem(),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Center(
                child: Text('Error: ${snapshot.error}'),
              );
            } else {
              // Filter items based on search text
              var filteredItems = controller.filterItems(snapshot.data);
              return ListView.builder(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemCount: filteredItems.length,
                itemBuilder: (context, i) {
                  return Card(
                    child: ListTile(
                      leading: Image.file(
                        File(filteredItems[i]['image']),
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                      ),
                      title: Text("${filteredItems[i]['itemName']}"),
                      subtitle: Text("${filteredItems[i]['price']}"),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            onPressed: () async {
                              await controller.delete(
                                  'items', filteredItems[i]['itemId']);
                            },
                            icon: const Icon(Icons.delete, color: Colors.red),
                          ),
                          IconButton(
                            onPressed: () {
                              Get.offNamed(AppRoutes.addItemsScreen,
                                  arguments: {
                                    "items": ItemArgument(
                                      id: controller.items[i]['itemId'],
                                      items: Items(
                                        itemName: controller.items[i]
                                            ['itemName'],
                                        image: controller.items[i]['image'],
                                        price: controller.items[i]['price'],
                                      ),
                                    )
                                  }
                                  //filteredItems[i],
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
