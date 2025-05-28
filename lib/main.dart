
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'utils/constants.dart';
import 'view/splash_screen_page/splash_screen_page.dart';
import 'core/di/injection_container.dart' as di;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        textTheme: const TextTheme(
          bodyLarge: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          bodyMedium: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          bodySmall: TextStyle(fontFamily: 'SofiaSans', color: Constants.textDisableColor),
          displayLarge: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          displayMedium: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          displaySmall: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          labelLarge: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          labelMedium: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          labelSmall: TextStyle(fontFamily: 'SofiaSans', color: Constants.textDisableColor),
          headlineMedium: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          headlineLarge: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          headlineSmall: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          titleLarge: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          titleMedium: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
          titleSmall: TextStyle(fontFamily: 'SofiaSans', color: Constants.textColor),
        ),
      ),
      builder: FToastBuilder(),
      home: const SplashScreen(),
    );
  }
}
