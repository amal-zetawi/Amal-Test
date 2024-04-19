import 'package:Talabat/screens/currency_screen/controller/edit_currency_controller.dart';
import 'package:get/get.dart';

class EditCurrencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditCurrencyController());
  }
}