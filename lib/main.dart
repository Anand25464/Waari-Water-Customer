import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waari_water/core/di/injection_container.dart' as di;
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/splash_screen_page/splash_screen_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await di.init();
  runApp(const ProviderScope(child: MyApp()));
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'Waari Water',
          theme: ThemeData(
            primarySwatch: Colors.blue,
            primaryColor: Constants.primaryColor,
          ),
          home: const SplashScreen(),
          navigatorKey: CustomNavigation.navigatorKey,
          debugShowCheckedModeBanner: false,
        );
      },
    );
  }
}