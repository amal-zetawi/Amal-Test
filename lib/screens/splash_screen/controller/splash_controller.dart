import 'package:Talabat/routes/app_routes.dart';
import 'package:get/get.dart';

class SplashController extends GetxController {
  @override
  void onReady() {
    Future.delayed(const Duration(milliseconds: 700), () {
      Get.offNamed(
        AppRoutes.loginScreen,
      );
    });
  }
}
