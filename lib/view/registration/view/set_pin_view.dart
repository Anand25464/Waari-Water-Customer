
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:pinput/pinput.dart';
import 'package:waari_water/controller/registration_controller/registration_controller.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/home_page/home_page.dart';

class SetPinView extends ConsumerStatefulWidget {
  const SetPinView({super.key});

  @override
  ConsumerState<SetPinView> createState() => _SetPinViewState();
}

class _SetPinViewState extends ConsumerState<SetPinView> {
  final TextEditingController _pinController = TextEditingController();
  final TextEditingController _confirmPinController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final registrationState = ref.watch(registrationControllerProvider);

    ref.listen<RegistrationState>(registrationControllerProvider, (previous, next) {
      if (next.message != null && next.message!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.message!),
            backgroundColor: Colors.green,
          ),
        );
        CustomNavigation.pushNamed(const HomePage());
      } else if (next.error != null && next.error!.isNotEmpty) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.error!),
            backgroundColor: Colors.red,
          ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Set M-PIN",
          style: TextStyle(fontSize: 18.sp),
        ),
        backgroundColor: Constants.primaryColor,
      ),
      body: Padding(
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
                onPressed: registrationState.isLoading
                    ? null
                    : () {
                        ref.read(registrationControllerProvider.notifier).setPin(
                          _pinController.text,
                          _confirmPinController.text,
                        );
                      },
                child: registrationState.isLoading
                    ? const CircularProgressIndicator()
                    : const Text('Set PIN'),
              ),
            ),
          ],
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
