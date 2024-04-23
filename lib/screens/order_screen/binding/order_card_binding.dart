import 'package:Talabat/screens/order_screen/controller/order_card_controller.dart';
import 'package:get/get.dart';

class OrderCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => OrderCardController());
  }
}