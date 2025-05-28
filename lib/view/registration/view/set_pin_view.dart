import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:waari_water/controller/registration_controller/registration_controller.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/home_page/home_page.dart';

class SetPinView extends StatefulWidget {
  const SetPinView({super.key});

  @override
  State<SetPinView> createState() => _SetPinViewState();
}

class _SetPinViewState extends State<SetPinView> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegistrationCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Set M-PIN",
            style: TextStyle(fontSize: 18.sp),
          ),
          backgroundColor: Constants.primaryColor,
        ),
        body: BlocListener<RegistrationCubit, RegistrationState>(
          listener: (context, state) {
            if (state is RegistrationSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
              CustomNavigation.pushNamed(const HomePage());
            } else if (state is RegistrationError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<RegistrationCubit, RegistrationState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Set your 4-digit M-PIN",
                      style: TextStyle(
                        fontSize: 20.sp,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "Enter PIN",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Pinput(
                      controller: _pinController,
                      length: 4,
                      obscureText: true,
                      defaultPinTheme: PinTheme(
                        width: 56.w,
                        height: 56.h,
                        textStyle: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Constants.primaryColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 30.h),
                    Text(
                      "Confirm PIN",
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 10.h),
                    Pinput(
                      controller: _confirmPinController,
                      length: 4,
                      obscureText: true,
                      defaultPinTheme: PinTheme(
                        width: 56.w,
                        height: 56.h,
                        textStyle: TextStyle(
                          fontSize: 20.sp,
                          fontWeight: FontWeight.w600,
                        ),
                        decoration: BoxDecoration(
                          border: Border.all(color: Constants.primaryColor),
                          borderRadius: BorderRadius.circular(8.r),
                        ),
                      ),
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is RegistrationLoading
                            ? null
                            : () {
                                context.read<RegistrationCubit>().setPin(
                                  _pinController.text,
                                  _confirmPinController.text,
                                );
                              },
                        child: state is RegistrationLoading
                            ? const CircularProgressIndicator()
                            : const Text('Set PIN'),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pinController.dispose();
    _confirmPinController.dispose();
    super.dispose();
  }
}