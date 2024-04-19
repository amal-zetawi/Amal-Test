import 'package:Talabat/routes/app_routes.dart';
import 'package:Talabat/screens/currency_screen/currency_card.dart';
import 'package:Talabat/screens/items_screen/items_card.dart';
import 'package:Talabat/screens/order_screen/order_card.dart';
import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'controller/home_controller.dart';

class HomeScreen extends GetWidget<HomeController> {
  HomeScreen({super.key});

  final List<String> tabs = ['Items', 'Currency', 'ORDER'];
  int currentTabIndex = 0;

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Home page'),
          bottom: TabBar(
            tabs: tabs.map((String tab) {
              return Tab(
                text: tab,
              );
            }).toList(),
            onTap: (index) {
              currentTabIndex = index;
            },
          ),
        ),
        drawer: Drawer(
          width: MediaQuery.of(context).size.width * 0.5,
          child: ListView(
            padding: EdgeInsets.zero,
            children: <Widget>[
              const DrawerHeader(
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        CircleAvatar(
                          radius: 40,
                          child: Icon(
                            Icons.person,
                            size: 40,
                          ),
                        )
                      ],
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("user")
                      ],
                    )
                  ],
                ),
              ),
              ListTile(
                title: const Text('Profile'),
                leading:const Icon(Icons.account_circle),
                onTap: () {
                  Get.offNamed(
                    AppRoutes.editUserScreen,
                  );
                },
              ),

              ListTile(
                title: const Text('Logout'),
                leading: const Icon(Icons.exit_to_app), // Add icon for logout
                onTap: () {
                  Get.offNamed(
                    AppRoutes.loginScreen,
                  );
                },
              ),
            ],
          ),
        ),
        body: const TabBarView(
          children: [
            // Items tab
            Center(
              child: ItemsCard(),
            ),
            // Currency tab
            Center(
              child: CurrencyCard(),
            ),

            // Order tab
            Center(
              child: OrderCard(),
            ),
          ],
        ),
      ),
    );
  }
}
