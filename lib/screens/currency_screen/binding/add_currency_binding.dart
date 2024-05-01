import 'package:Talabat/screens/currency_screen/controller/add_currency_controller.dart';
import 'package:get/get.dart';

class AddCurrencyBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddCurrencyController());
  }
}
