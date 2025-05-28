import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:waari_water/controller/login_page_controller/login_page_controller.dart';
import 'package:waari_water/controller/registration_controller/registration_controller.dart';
import 'package:waari_water/utils/common_mobile_number_form_field.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';


class ForgetPasswordPage extends StatefulWidget {
  const ForgetPasswordPage({super.key});

  @override
  State<ForgetPasswordPage> createState() => _ForgetPasswordPageState();
}

class _ForgetPasswordPageState extends State<ForgetPasswordPage> {
  RegistrationController registrationController = Get.put(RegistrationController());
  LoginPageController loginPageController = Get.find();
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  Timer? timer;
  int start = 60;
  bool wait = false;
  String buttonName = "Send";
  bool isOTP = false;
  bool isFilled = false;




  void startTimer(){
    const oneSec = Duration(seconds:  1);
    timer = Timer.periodic(oneSec, (timer) {
      if(start == 0){
        setState(() {
          timer.cancel();
          wait = false;
        });
      }
      else{
        setState(() {
          start--;
        });
      }
    });
  }

  @override
  void dispose() {
    super.dispose();
    timer!.cancel();
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Forgot Pin",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w800,color: Constants.textColor),),
        backgroundColor: Colors.white,
        leading: GestureDetector(
          onTap: (){
            CustomNavigation.pop();
          },
          child: Padding(
            padding: const EdgeInsets.all(15.0),
            child: SvgPicture.asset("assets/images/back_arrow2.svg",height: 20,width: 20,),
          ),
        ),
        elevation: 0,
      ),
      body: registrationForm(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: InkWell(
          onTap: () {
            if(_globalKey.currentState!.validate()){
              print("--------otpController---------");
              print(otpController.text);
              isFilled ? registrationController.verifyOTP(mobileController.text, otpController.text) : (){};
            }
          },
          child: Container(
            height: 50,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                color: isFilled ? Constants.primaryColor: Constants.primaryDullColor
            ),
            child: Center(
              child: Text(
                "Verify",
                style: TextStyle(
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    color: isFilled ? Colors.white : Constants.textDisableColor
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: false,
    );
  }
  registrationForm(){
    final defaultPinTheme = PinTheme(
      width: 56,
      height: 56,
      textStyle: const TextStyle(fontSize: 20, color: Constants.textColor, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.outLineColor,width: 1.5),
        borderRadius: BorderRadius.circular(15),
        //color: Constants.primaryDullColor
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Constants.outLineColor,width: 1.5),
      borderRadius: BorderRadius.circular(15),
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        //color: Constants.primaryDullColor
      ),
    );
    return SingleChildScrollView(
      child: Padding(
        padding: const EdgeInsets.fromLTRB(18,25,18,15),
        child: Form(
          key: _globalKey,
          child: Column(
            children: [
              MobileNumberInput(
                onChanged: (value){
                  if (value.length == 10) {
                    FocusScope.of(context).unfocus();
                  }
                },
                controller: mobileController,
                validator:  (value){
                  if(value!.isEmpty){
                    return "Please Enter Mobile Number";
                  }
                  else if(value.length < 10){
                    return "Please Enter Valid Mobile Number";
                  }
                  return null;
                },
                suffix: Padding(
                  padding: const EdgeInsets.all(15.0),
                  child: GestureDetector(
                      onTap: wait ? null : (){
                        if(_globalKey.currentState!.validate()){
                          registrationController.getOTP(mobileController.text);
                          loginPageController.setSendOTP = true;
                          setState(() {
                            start = 60;
                            startTimer();
                            wait = true;
                            buttonName = "Resend";
                            isOTP = true;
                          });
                        }
                      },
                      child:  Text(
                        buttonName,
                        style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17,color: wait ? Constants.textDisableColor : Constants.primaryColor),)),
                ),),
              const SizedBox(height: 5,),
              if(isOTP)
                Column(
                  children: [
                    RichText(text: TextSpan(children: [
                      const TextSpan(text: "Send OTP again in ",style: TextStyle(color: Constants.textDisableColor,fontFamily: 'SofiaSans')),
                      TextSpan(
                          text: " 00:${start < 10 ? "0$start" : start}",
                          style: const TextStyle(color: Constants.textColor,fontFamily: 'SofiaSans')),
                      const TextSpan(text: " sec",style: TextStyle(color: Constants.textDisableColor,fontFamily: 'SofiaSans')),
                    ])),
                    const SizedBox(height: 5,),
                    Pinput(
                      /*validator: (s) {
                        return s!.length == 6 ? null : 'fill 6 digit pin';
                      },*/
                      defaultPinTheme: defaultPinTheme,
                      focusedPinTheme: focusedPinTheme,
                      submittedPinTheme: submittedPinTheme,
                      pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                      showCursor: true,
                      onCompleted: (pin) {
                        print(pin);
                        print("-------------pin-------------");
                        print(otpController.text);
                        isFilled = true;
                      },
                      controller: otpController,
                      length: 6,
                    )
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}
