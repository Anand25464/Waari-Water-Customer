import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:waari_water/utils/constants.dart';

import 'view/splash_screen_page/splash_screen_page.dart';


void main(){
  return runApp(const MyApp());
}


class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      theme:  ThemeData(
        textTheme:  const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          bodyMedium: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          bodySmall: TextStyle(fontFamily: 'SofiaSans',color: Constants.textDisableColor),
          displayLarge: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          displayMedium: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          displaySmall: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          labelLarge: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          labelMedium: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          labelSmall: TextStyle(fontFamily: 'SofiaSans',color: Constants.textDisableColor),
          headlineMedium: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          headlineLarge: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          headlineSmall: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          titleLarge: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          titleMedium: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
          titleSmall: TextStyle(fontFamily: 'SofiaSans',color: Constants.textColor),
        )
      ),
      builder: FToastBuilder(),//sanjay new
      home: const SplashScreen(),
    );
  }
}
