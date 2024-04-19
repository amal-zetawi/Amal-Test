import 'package:Talabat/screens/order_screen/controller/add_order_controller.dart';
import 'package:get/get.dart';

class AddOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddOrderController());
  }
}