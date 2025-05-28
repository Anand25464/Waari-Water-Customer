
import 'dart:async';
import 'dart:math';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/di/injection_container.dart';
import '../../../../utils/common_mobile_number_form_field.dart';
import '../../../../utils/constants.dart';
import '../../../../utils/navigation.dart';
import '../../../registration/presentation/pages/registration_page.dart';
import '../../../home/presentation/pages/home_page.dart';
import '../../../registration/presentation/pages/set_pin_page.dart';
import '../cubit/auth_cubit.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (_) => sl<AuthCubit>(),
      child: const LoginView(),
    );
  }
}

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final TextEditingController mobileController = TextEditingController();
  final TextEditingController otpController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  int start = 60;
  bool wait = false;
  bool isOTP = false;
  bool isFilled = false;
  String buttonName = "Send";
  FToast? fToast;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    fToast!.init(context);
    _generateRandomClientId();
  }

  Future<void> _generateRandomClientId() async {
    final prefs = await SharedPreferences.getInstance();
    if (!prefs.containsKey('RandomNum')) {
      final randomNum = Random().nextInt(1000000).toString();
      await prefs.setString('RandomNum', randomNum);
    }
  }

  void startTimer() {
    const oneSec = Duration(seconds: 1);
    timer = Timer.periodic(oneSec, (timer) {
      if (start == 0) {
        setState(() {
          timer.cancel();
          wait = false;
        });
      } else {
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  void dispose() {
    otpController.dispose();
    mobileController.dispose();
    timer?.cancel();
    super.dispose();
  }

  Widget get toast => Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          color: Constants.successColor,
        ),
        child: const Text(
          "OTP sent to your mobile number",
          style: TextStyle(color: Colors.white),
        ),
      );

  @override
  Widget build(BuildContext context) {
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(
        fontSize: 20,
        color: Constants.textColor,
        fontWeight: FontWeight.w600,
      ),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.outLineColor, width: 1.5),
        borderRadius: BorderRadius.circular(15),
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Constants.outLineColor, width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(),
    );

    return Scaffold(
      body: BlocListener<AuthCubit, AuthState>(
        listener: (context, state) {
          if (state is OtpSent) {
            fToast!.showToast(
              child: toast,
              gravity: ToastGravity.BOTTOM,
              toastDuration: const Duration(seconds: 2),
            );
          } else if (state is AuthSuccess) {
            if (state.user.isVerified) {
              CustomNavigation.pushNamed(const HomePage());
            } else {
              CustomNavigation.pushNamed(
                SetPinPage(userMobile: mobileController.text),
              );
            }
          } else if (state is AuthError) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text(state.message)),
            );
          }
        },
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(18, 35, 18, 15),
            child: Form(
              key: _globalKey,
              child: Column(
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      GestureDetector(
                        onTap: () {
                          CustomNavigation.push(const RegistrationPage());
                          setState(() {
                            wait = false;
                            isOTP = false;
                            isFilled = false;
                            buttonName = "Send";
                            otpController.text = "";
                            mobileController.text = "";
                          });
                        },
                        child: const Text(
                          "Register Account",
                          style: TextStyle(
                            fontWeight: FontWeight.w700,
                            fontSize: 17,
                            color: Constants.hyperLinkColor,
                            decoration: TextDecoration.underline,
                          ),
                        ),
                      )
                    ],
                  ),
                  const SizedBox(height: 22),
                  Container(
                    height: 92,
                    width: 104,
                    decoration: const BoxDecoration(
                      image: DecorationImage(
                        image: AssetImage("assets/logo/waari-logo 2.png"),
                      ),
                    ),
                  ),
                  const SizedBox(height: 25),
                  const Text(
                    "Login",
                    style: TextStyle(fontSize: 35, fontWeight: FontWeight.w900),
                  ),
                  const SizedBox(height: 5),
                  const Text(
                    "Verify your registered mobile number to access your account.",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Constants.textDisableColor,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 25),
                  MobileNumberInput(
                    controller: mobileController,
                    validator: (value) {
                      if (value!.isEmpty) {
                        return "Please Enter Mobile Number";
                      }
                      return null;
                    },
                    suffix: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                        onTap: wait
                            ? null
                            : () {
                                if (_globalKey.currentState!.validate()) {
                                  context.read<AuthCubit>().sendOtp(mobileController.text);
                                  setState(() {
                                    start = 60;
                                    startTimer();
                                    wait = true;
                                    buttonName = "Resend";
                                    isOTP = true;
                                  });
                                }
                              },
                        child: Text(
                          buttonName,
                          style: TextStyle(
                            fontWeight: FontWeight.w600,
                            fontSize: 17,
                            color: wait
                                ? Constants.textDisableColor
                                : Constants.primaryColor,
                          ),
                        ),
                      ),
                    ),
                    onChanged: (value) {
                      if (value.length == 10) {
                        FocusScope.of(context).unfocus();
                      }
                    },
                  ),
                  const SizedBox(height: 5),
                  if (isOTP)
                    Column(
                      children: [
                        RichText(
                          text: TextSpan(
                            children: [
                              const TextSpan(
                                text: "Send OTP again in ",
                                style: TextStyle(
                                  color: Constants.textDisableColor,
                                  fontFamily: 'SofiaSans',
                                ),
                              ),
                              TextSpan(
                                text: " 00:${start < 10 ? "0$start" : start}",
                                style: const TextStyle(
                                  color: Constants.textColor,
                                  fontFamily: 'SofiaSans',
                                ),
                              ),
                              const TextSpan(
                                text: " sec",
                                style: TextStyle(
                                  color: Constants.textDisableColor,
                                  fontFamily: 'SofiaSans',
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 5),
                        Pinput(
                          validator: (s) {
                            return s!.length == 6 ? null : 'Fill 6 digit pin';
                          },
                          defaultPinTheme: defaultPinTheme,
                          focusedPinTheme: focusedPinTheme,
                          submittedPinTheme: submittedPinTheme,
                          pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                          inputFormatters: [
                            FilteringTextInputFormatter.digitsOnly,
                            LengthLimitingTextInputFormatter(6),
                          ],
                          showCursor: true,
                          onCompleted: (pin) {
                            if (kDebugMode) {
                              print(pin);
                            }
                            setState(() {
                              isFilled = true;
                            });
                          },
                          controller: otpController,
                          length: 6,
                        ),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: BlocBuilder<AuthCubit, AuthState>(
          builder: (context, state) {
            final isLoading = state is AuthLoading;
            
            return InkWell(
              onTap: isLoading
                  ? null
                  : () {
                      if (_globalKey.currentState!.validate() && isFilled) {
                        context.read<AuthCubit>().loginWithOtp(
                              mobileController.text,
                              otpController.text,
                            );
                      }
                    },
              child: Container(
                height: 50,
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(12),
                  color: (isFilled && !isLoading)
                      ? Constants.primaryColor
                      : Constants.primaryDullColor,
                ),
                child: Center(
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : Text(
                          "Login",
                          style: TextStyle(
                            fontWeight: FontWeight.w800,
                            fontSize: 18,
                            color: (isFilled && !isLoading)
                                ? Colors.white
                                : Constants.textDisableColor,
                          ),
                        ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
}
