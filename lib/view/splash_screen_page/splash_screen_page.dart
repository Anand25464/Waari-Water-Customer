import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/utils/topics.dart';
import 'package:waari_water/view/login_page/login_page.dart';
import 'package:waari_water/view/m_pin_page/m_pin_page.dart';
import 'package:waari_water/view/onboarding_page/onboarding_page.dart';




class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  late MqttController mqttController;


  @override
  void initState() {
    super.initState();
    mqttController = MqttController();
    mqttController.generateRandomNumber();
    Future.delayed(const Duration(seconds: 2),(){
       mqttController.connectMqtt();
    });
    Timer(const Duration(seconds: 5),()async {
      final prefs = await SharedPreferences.getInstance();
      final showHome = prefs.getBool("showHome") ?? false;
      final isUser = prefs.getBool("isUser") ?? false;
      if(isUser){
        CustomNavigation.pushNamed(const MPinPage());
        //CustomNavigation.pushNamed(showHome ? const LoginPage() : const OnboardingPage());
      }else{
        print(showHome);
        CustomNavigation.pushNamed(showHome ? const LoginPage() : const OnboardingPage());
      }
    });
  }
  @override
  Widget build(BuildContext context) {

    //SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(statusBarColor: Constants.primaryColor));
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: Center(child: Image.asset("assets/logo/waari-logo 2.png"))
    );
  }
}
