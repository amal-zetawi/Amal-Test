import 'package:Talabat/screens/currency_screen/controller/currency_card_controller.dart';
import 'package:get/get.dart';

class CurrencyCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => CurrencyCardController());
  }
}
