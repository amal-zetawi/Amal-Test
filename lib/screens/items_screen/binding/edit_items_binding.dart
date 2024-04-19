import 'package:Talabat/screens/items_screen/controller/edit_items_contrller.dart';
import 'package:get/get.dart';

class EditItemsBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditItemsController());
  }
}