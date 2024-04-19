import 'package:Talabat/routes/app_routes.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:get_storage/get_storage.dart';

Future<void> main() async {
  await GetStorage.init();
  bool rememberMe = GetStorage().read('rememberMe') ?? false;
  runApp(MyApp(initialRoute: rememberMe ? AppRoutes.homeScreen : AppRoutes.initialRoute));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key, required this.initialRoute});
  final String initialRoute;

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    //return Sizer(builder: (context, orientation, deviceType) {
      return GetMaterialApp(
        debugShowCheckedModeBanner: false,
       // theme: theme,
        //translations: AppLocalization(),
       // locale: Get.deviceLocale, //for setting localization strings
        fallbackLocale: const Locale('en', 'US'),
        title: 'orders_app',
       // initialBinding: InitialBindings(),
        initialRoute: initialRoute,
        getPages: AppRoutes.pages,
      );
    //});
  }
}
