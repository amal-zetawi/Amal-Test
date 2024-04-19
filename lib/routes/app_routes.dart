import 'package:Talabat/screens/currency_screen/add_currency_screen.dart';
import 'package:Talabat/screens/currency_screen/binding/add_currency_binding.dart';
import 'package:Talabat/screens/currency_screen/binding/edit_currency_binding.dart';
import 'package:Talabat/screens/currency_screen/edit_currency_screen.dart';
import 'package:Talabat/screens/home_screen/binding/home_binding.dart';
import 'package:Talabat/screens/home_screen/home_screen.dart';
import 'package:Talabat/screens/items_screen/binding/add_items_binding.dart';
import 'package:Talabat/screens/items_screen/add_items_screen.dart';
import 'package:Talabat/screens/items_screen/binding/edit_items_binding.dart';
import 'package:Talabat/screens/items_screen/edit_items_screen.dart';
import 'package:Talabat/screens/login_screen/binding/login_binding.dart';
import 'package:Talabat/screens/login_screen/login_screen.dart';
import 'package:Talabat/screens/order_screen/add_order_screen.dart';
import 'package:Talabat/screens/order_screen/binding/add_order_binding.dart';
import 'package:Talabat/screens/order_screen/binding/edit_order_binding.dart';
import 'package:Talabat/screens/order_screen/edit_order_screen.dart';
import 'package:Talabat/screens/sign_up_screen/binding/sign_up_binding.dart';
import 'package:Talabat/screens/sign_up_screen/sign_up_screen.dart';
import 'package:Talabat/screens/splash_screen/binding/splash_binding.dart';
import 'package:Talabat/screens/splash_screen/splash_screen.dart';
import 'package:Talabat/screens/users_screen/edit_user_binding.dart';
import 'package:Talabat/screens/users_screen/edit_user_screen.dart';
import 'package:get/get.dart';

class AppRoutes{
  static const String initialRoute = '/initialRoute';
  static const String splashScreen = '/splash_screen';
  static const String loginScreen = '/login_screen';
  static const String signUpScreen = '/sign_up_screen';
  static const String homeScreen = '/home_screen';
  static const String addItemsScreen = '/add_items_screen';
  static const String editItemsScreen = '/edit_items_screen';
  static const String addCurrencyScreen = '/add_currency_screen';
  static const String editCurrencyScreen = '/edit_currency_screen';
  static const String addOrderScreen = '/add_order_screen';
  static const String editUserScreen = '/edit_user_screen';
  static const String editOrderScreen = '/edit_order_screen';



  static List<GetPage> pages = [
    GetPage(
      name: initialRoute,
      page: () => const SplashScreen(),
      bindings: [
        SplashBinding(),
      ],
    ),
    GetPage(
      name: loginScreen,
      page: () => const LoginScreen(),
      bindings: [
        LoginBinding(),
      ],
    ),
    GetPage(
      name: signUpScreen,
      page: () => const SignUpScreen(),
      bindings: [
        SignUpBinding (),
      ],
    ),
    GetPage(
      name: homeScreen,
      page: () =>HomeScreen(),
      bindings: [
        HomeBinding (),
      ],
    ),
    GetPage(
      name: addItemsScreen,
      page: () =>const AddItemsScreen(),
      bindings: [
        AddItemsBinding (),
      ],
    ),
    GetPage(
      name: editItemsScreen,
      page: () =>const EditItemsScreen(),
      bindings: [
        EditItemsBinding (),
      ],
    ),
    GetPage(
      name: addCurrencyScreen,
      page: () =>const AddCurrencyScreen(),
      bindings: [
        AddCurrencyBinding (),
      ],
    ),
    GetPage(
      name: editCurrencyScreen,
      page: () =>const EditCurrencyScreen(),
      bindings: [
        EditCurrencyBinding (),
      ],
    ),
    GetPage(
      name: addOrderScreen,
      page: () =>  AddOrderScreen(),
      bindings: [
        AddOrderBinding (),
      ],
    ),
    GetPage(
      name: editUserScreen,
      page: () =>const EditUserScreen(),
      bindings: [
        EditUserBinding (),
      ],
    ),
    GetPage(
      name: editOrderScreen,
      page: () => EditOrderScreen(),
      bindings: [
        EditOrderBinding (),
      ],
    ),
];
}