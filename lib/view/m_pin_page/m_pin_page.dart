
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/home_page/home_page.dart';

// M-PIN Cubit
abstract class MPinState {}

class MPinInitial extends MPinState {}

class MPinLoading extends MPinState {}

class MPinSuccess extends MPinState {
  final String message;
  MPinSuccess(this.message);
}

class MPinError extends MPinState {
  final String message;
  MPinError(this.message);
}

class MPinCubit extends Cubit<MPinState> {
  MPinCubit() : super(MPinInitial());

  void verifyPin(String pin) {
    emit(MPinLoading());
    
    // Simulate PIN verification
    Future.delayed(const Duration(seconds: 1), () {
      if (pin.length == 4) {
        emit(MPinSuccess("PIN verified successfully"));
        CustomNavigation.pushNamed(const HomePage());
      } else {
        emit(MPinError("Invalid PIN"));
      }
    });
  }
}

class MPinPage extends StatefulWidget {
  const MPinPage({super.key});

  @override
  State<MPinPage> createState() => _MPinPageState();
}

class _MPinPageState extends State<MPinPage> {
  final TextEditingController _pinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MPinCubit(),
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            "Enter M-PIN",
            style: TextStyle(fontSize: 18.sp),
          ),
          backgroundColor: Constants.primaryColor,
        ),
        body: BlocListener<MPinCubit, MPinState>(
          listener: (context, state) {
            if (state is MPinSuccess) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.green,
                ),
              );
            } else if (state is MPinError) {
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(state.message),
                  backgroundColor: Colors.red,
                ),
              );
            }
          },
          child: BlocBuilder<MPinCubit, MPinState>(
            builder: (context, state) {
              return Padding(
                padding: EdgeInsets.all(20.w),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Enter your 4-digit M-PIN",
                      style: TextStyle(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    SizedBox(height: 40.h),
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
                      onCompleted: (pin) {
                        context.read<MPinCubit>().verifyPin(pin);
                      },
                    ),
                    SizedBox(height: 40.h),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: state is MPinLoading
                            ? null
                            : () {
                                context.read<MPinCubit>().verifyPin(_pinController.text);
                              },
                        child: state is MPinLoading
                            ? const CircularProgressIndicator()
                            : const Text('Verify PIN'),
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
    super.dispose();
  }
}
