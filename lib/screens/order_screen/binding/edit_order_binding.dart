import 'package:Talabat/screens/order_screen/controller/edit_order_controller.dart';
import 'package:get/get.dart';

class EditOrderBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditOrderController());
  }
}