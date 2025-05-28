import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:waari_water/controller/login_page_controller/login_page_controller.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/utils/common_mobile_number_form_field.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/registration/view/registration_page_view.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  LoginPageController loginPageController = Get.put(LoginPageController());
  TextEditingController mobileController = TextEditingController();
  TextEditingController otpController = TextEditingController();
  final _globalKey =GlobalKey<FormState>();
  MqttController mqttController = Get.find();
  int start = 60;
  bool wait = false;
  bool isOTP = false;
  bool isFilled = false;
  String buttonName = "Send";
  List<TextEditingController> controllers = List.generate(6, (index) => TextEditingController());
  List<FocusNode> focusNodes = List.generate(6, (index) => FocusNode());
  FToast? fToast;
  Timer? timer;

  @override
  void initState() {
    super.initState();
    fToast = FToast();
    // if you want to use context from globally instead of content we need to pass navigatorKey.currentContext!
    fToast!.init(context);
   /* // Add listeners to controllers to detect text changes
    for (int i = 0; i < controllers.length; i++) {
      controllers[i].addListener(() {
        if (controllers[i].text.isNotEmpty && controllers[i].text.length == 1) {
          print("--------0111111-----");
          // If a digit is entered, move focus to the next TextFormField
          if (i < controllers.length - 1) {
            print("--------022222-----");
            FocusScope.of(context).requestFocus(focusNodes[i + 1]);
          }
        } else if (controllers[i].text.isEmpty&& controllers[i].text.isEmpty) {
          print("--------0333333-----");
          // If the text field is cleared, move focus back to the previous TextFormField
          if (i > 0) {
            print("--------04444444-----");
            FocusScope.of(context).requestFocus(focusNodes[i - 1]);
          }
        }
      });
    }*/
  }
  
  
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
    otpController.dispose();
    super.dispose();
    timer?.cancel();
  }


    Widget toast = Container(
      padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(25.0),
        color: Constants.successColor,
      ),
      child: const Text("OTP send to your mobile number",style: TextStyle(color: Colors.white),),
    );



  @override
  Widget build(BuildContext context) {
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
    return Scaffold(
     // backgroundColor: Constants.backgroundColor,
      //body: Center(child: Image.asset("assets/logo/waari-logo 2.png")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(18,35,18,15),
          child: Form(
            key: _globalKey,
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    GestureDetector(
                      onTap: (){
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
                      child: const Text("Register Account",
                      style: TextStyle(fontWeight: FontWeight.w700,fontSize: 17,color: Constants.hyperLinkColor,decoration: TextDecoration.underline,),
                      ),
                    )
                  ],
                ),
                const SizedBox(height: 22,),
                Container(
                  height: 92,
                  width: 104,
                  decoration: const BoxDecoration(
                    image: DecorationImage(image: AssetImage("assets/logo/waari-logo 2.png"))
                  ),
                ),
                const SizedBox(height: 25,),
                 InkWell(
                   onTap: (){
                     fToast!.showToast(
                       child: toast,
                       gravity: ToastGravity.BOTTOM,
                       toastDuration: const Duration(seconds: 2),
                     );
                   },
                   child: const Text("Login",
                    style: TextStyle(fontSize: 35,fontWeight: FontWeight.w900),
                ),
                 ),
                const SizedBox(height: 5,),
                const Text("Verify your registered mobile number to access your account.",
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Constants.textDisableColor),
                  textAlign: TextAlign.center,),
                const SizedBox(height: 25,),
                MobileNumberInput(
                  controller: mobileController,
                    validator:  (value){
                      if(value!.isEmpty){
                        return "Please Enter Mobile Number";
                      }
                      return null;
                    },
                    suffix: Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: GestureDetector(
                          onTap: wait ? null : (){
                            if(_globalKey.currentState!.validate()){
                              loginPageController.setSendOTP = true;
                              setState(() {
                                start = 60;
                                startTimer();
                                wait = true;
                                buttonName = "Resend";
                                isOTP = true;
                              });
                              /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                                content: Text("Sending Message"),
                                padding: EdgeInsets.all(10),
                              ));*/
                              loginPageController.getOTP(mobileController.text);
                            }
                          },
                          child:  Text(
                            buttonName,
                            style: TextStyle(fontWeight: FontWeight.w600,fontSize: 17,color: wait ? Constants.textDisableColor : Constants.primaryColor),)),
                    ),
                  onChanged: (value){
                    if (value.length == 10) {
                      FocusScope.of(context).unfocus();
                    }
                  },
                ),
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
                            validator: (s) {
                              return s!.length == 6 ? null : 'Fill 6 digit pin';
                            },
                            defaultPinTheme: defaultPinTheme,
                            focusedPinTheme: focusedPinTheme,
                            submittedPinTheme: submittedPinTheme,
                            pinputAutovalidateMode: PinputAutovalidateMode.onSubmit,
                            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10),],
                            showCursor: true,
                            onCompleted: (pin) {
                              if (kDebugMode) {
                                print(pin);
                                print("-------------pin-------------");
                                print(otpController.text);
                              }
                              isFilled = true;
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
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: InkWell(
          onTap: () {
            if(_globalKey.currentState!.validate()){
              loginPageController.userLogin(mobileController.text, otpController.text,context);
              /*ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                content: Text("Login Success"),
                padding: EdgeInsets.all(5),
              ));*/
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
                "Login",
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
}
//
// onChanged: (value) {
// if (value.length == 1) {
// // Move focus to the second TextFormField
// FocusScope.of(context).requestFocus(focusNodes[index + 1]);
// },
// }

/*Expanded(
                              child: TextFormField(
                                controller: controller6,
                                focusNode: focusNode6,
                                textAlign: TextAlign.center,
                                style: Theme.of(context).textTheme.headlineMedium,
                                keyboardType: TextInputType.number,
                                inputFormatters: [FilteringTextInputFormatter.digitsOnly,
                                  LengthLimitingTextInputFormatter(1)],
                                decoration: InputDecoration(
                                  contentPadding: const EdgeInsets.only(top: 15),
                                  hintText: "_",
                                  hintStyle: const TextStyle(color: Constants.textDisableColor),
                                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10),
                                  ),
                                  focusedBorder: OutlineInputBorder(borderSide: const BorderSide(color: Constants.outLineColor),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                    borderSide: const BorderSide(
                                      color: Constants.outLineColor,
                                      width: 2.0,
                                    ),
                                  ),
                                ),
                              ),
                            ),*/
