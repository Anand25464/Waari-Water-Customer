
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/controller/login_page_controller/login_page_controller.dart';
import 'package:waari_water/controller/onboarding_page_controller/onboarding_page_controller.dart';
import 'package:waari_water/controller/registration_controller/registration_controller.dart';
import 'package:waari_water/features/auth/presentation/cubit/auth_cubit.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/splash_screen_page/splash_screen_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<MqttController>(
          create: (context) => MqttController(),
        ),
        BlocProvider<AuthCubit>(
          create: (context) => AuthCubit(),
        ),
        BlocProvider<LoginPageCubit>(
          create: (context) => LoginPageCubit(),
        ),
        BlocProvider<OnboardingPageCubit>(
          create: (context) => OnboardingPageCubit(),
        ),
        BlocProvider<RegistrationCubit>(
          create: (context) => RegistrationCubit(),
        ),
      ],
      child: ScreenUtilInit(
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
      ),
    );
  }
}
