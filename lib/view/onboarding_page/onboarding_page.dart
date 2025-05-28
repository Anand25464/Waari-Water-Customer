import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:waari_water/controller/onboarding_page_controller/onboarding_page_controller.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/login_page/login_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => OnboardingPageCubit(),
      child: Scaffold(
        backgroundColor: Constants.primaryColor,
        body: BlocListener<OnboardingPageCubit, OnboardingPageState>(
          listener: (context, state) {
            if (state is OnboardingPageCompleted) {
              _completeOnboarding();
            } else if (state is OnboardingPageChanged) {
              _pageController.animateToPage(
                state.currentIndex,
                duration: const Duration(milliseconds: 300),
                curve: Curves.easeInOut,
              );
            }
          },
          child: BlocBuilder<OnboardingPageCubit, OnboardingPageState>(
            builder: (context, state) {
              return Column(
                children: [
                  Expanded(
                    child: PageView(
                      controller: _pageController,
                      onPageChanged: (index) {
                        context.read<OnboardingPageCubit>().setPage(index);
                      },
                      children: [
                        _buildOnboardingPage(
                          "Welcome to Waari Water",
                          "Your trusted water delivery service",
                          "assets/images/water_wave.png",
                        ),
                        _buildOnboardingPage(
                          "Fast Delivery",
                          "Get fresh water delivered to your doorstep",
                          "assets/images/water_bubble_wave.png",
                        ),
                        _buildOnboardingPage(
                          "Easy Ordering",
                          "Order with just a few taps",
                          "assets/images/wave_splash.png",
                        ),
                      ],
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.all(20.w),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        TextButton(
                          onPressed: () {
                            context.read<OnboardingPageCubit>().completeOnboarding();
                          },
                          child: Text(
                            "Skip",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 16.sp,
                            ),
                          ),
                        ),
                        ElevatedButton(
                          onPressed: () {
                            final cubit = context.read<OnboardingPageCubit>();
                            if (cubit.currentIndex < 2) {
                              cubit.nextPage();
                            } else {
                              cubit.completeOnboarding();
                            }
                          },
                          child: Text(
                            context.read<OnboardingPageCubit>().currentIndex < 2 ? "Next" : "Get Started",
                            style: TextStyle(fontSize: 16.sp),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildOnboardingPage(String title, String description, String imagePath) {
    return Padding(
      padding: EdgeInsets.all(20.w),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Image.asset(
            imagePath,
            height: 200.h,
            width: 200.w,
          ),
          SizedBox(height: 40.h),
          Text(
            title,
            style: TextStyle(
              fontSize: 24.sp,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
            textAlign: TextAlign.center,
          ),
          SizedBox(height: 20.h),
          Text(
            description,
            style: TextStyle(
              fontSize: 16.sp,
              color: Colors.white70,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  void _completeOnboarding() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool("showHome", true);
    CustomNavigation.pushNamed(const LoginPage());
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}