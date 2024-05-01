import 'package:Talabat/constants/images_constant.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'controller/splash_controller.dart';

class SplashScreen extends GetWidget<SplashController> {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: SizedBox(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Expanded(
                  child: Center(
                child: Image.asset(
                  ImageConstant.imgsplash,
                  height: 200,
                  width: 200,
                ),
              )),
              const Expanded(
                  child: Center(
                child: Text(
                  "Welcome To Talabat App",
                  style: TextStyle(
                      color: Colors.deepOrange,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              )),
            ],
          ),
        ),
      ),
    );
  }
}
