import 'package:Talabat/screens/items_screen/controller/items_card_controller.dart';
import 'package:get/get.dart';

class ItemsCardBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => ItemsCardController());
  }
}
