import 'package:Talabat/screens/items_screen/controller/add_items_controller.dart';
import 'package:get/get.dart';

class AddItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => AddItemsController());
  }
}