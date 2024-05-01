import 'package:Talabat/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  bool rememberMe = GetStorage().read('rememberMe') ?? false;
  runApp(MyApp(
      initialRoute:
          rememberMe ? AppRoutes.homeScreen : AppRoutes.initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      fallbackLocale: const Locale('en', 'US'),
      title: 'orders_app',
      initialRoute: initialRoute,
      getPages: AppRoutes.pages,
    );
  }
}
