import 'package:get/get.dart';
import 'edit_user_controller.dart';

class  EditUserBinding extends Bindings {
  @override
  void dependencies() {
    Get.lazyPut(() => EditUserController());
  }
}