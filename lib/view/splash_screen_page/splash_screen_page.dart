
import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
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
  @override
  void initState() {
    super.initState();
    
    // Initialize MQTT controller
    context.read<MqttController>().generateRandomNumber();
    
    Future.delayed(const Duration(seconds: 2), () {
      context.read<MqttController>().connectMqtt();
    });
    
    Timer(const Duration(seconds: 5), () async {
      final prefs = await SharedPreferences.getInstance();
      final showHome = prefs.getBool("showHome") ?? false;
      final isUser = prefs.getBool("isUser") ?? false;
      if (isUser) {
        CustomNavigation.pushNamed(const MPinPage());
      } else {
        print(showHome);
        CustomNavigation.pushNamed(showHome ? const LoginPage() : const OnboardingPage());
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Constants.primaryColor,
      body: BlocListener<MqttController, MqttState>(
        listener: (context, state) {
          if (state is MqttError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(state.message),
                backgroundColor: Colors.red,
              ),
            );
          }
        },
        child: Center(
          child: Image.asset("assets/logo/waari-logo 2.png"),
        ),
      ),
    );
  }
}
