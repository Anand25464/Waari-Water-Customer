import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:pinput/pinput.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waari_water/controller/login_page_controller/login_page_controller.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/registration/view/forget_password_view.dart';
import 'package:waari_water/view/registration/view/set_pin_view.dart';


class MPinPage extends StatefulWidget {
  const MPinPage({super.key});

  @override
  State<MPinPage> createState() => _MPinPageState();
}

class _MPinPageState extends State<MPinPage> {
  LoginPageController loginPageController = Get.put(LoginPageController());
  TextEditingController pinController = TextEditingController();
   late FocusNode _focusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize the focus node
    _focusNode = FocusNode();

    // Set focus to the text field when the page is loaded
    //FocusScope.of(context).requestFocus(_focusNode);
  }

  @override
  void dispose() {
    // Dispose of the focus node to avoid memory leaks
    _focusNode.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: sixDigitPin(),
    );
  }

  sixDigitPin()  {
    final defaultPinTheme = PinTheme(
      width: 30,
      height: 30,
      textStyle: const TextStyle(fontSize: 20, color: Constants.textColor, fontWeight: FontWeight.w600),
      decoration: BoxDecoration(
        border: Border.all(color: Constants.primaryDullColor,width: 1.5),
        borderRadius: BorderRadius.circular(30),
        color: Constants.primaryDullColor
      ),
    );

    final focusedPinTheme = defaultPinTheme.copyDecorationWith(
      border: Border.all(color: Constants.primaryColor,width: 1.5),
      borderRadius: BorderRadius.circular(30),
      color: Constants.primaryColor
    );

    final submittedPinTheme = defaultPinTheme.copyWith(
      decoration: defaultPinTheme.decoration!.copyWith(
        color: Constants.primaryColor
      ),
    );
    return Padding(
        padding: const EdgeInsets.fromLTRB(15,30,15,15),
      child: Column(
        children: [
          const SizedBox(height: 35,),
          Container(
            height: 92,
            width: 104,
            decoration: const BoxDecoration(
                image: DecorationImage(image: AssetImage("assets/logo/waari-logo 2.png"))
            ),
          ),
          const SizedBox(height: 25,),
          const Text("Enter Pin", style: TextStyle(fontSize: 35,fontWeight: FontWeight.w900),),
          const SizedBox(height: 5,),
          const Text("Enter 6 digits long security pin to access your account.", style: TextStyle(fontSize: 16,fontWeight: FontWeight.w700,color: Constants.textDisableColor), textAlign: TextAlign.center,),
          const SizedBox(height: 25,),
          Pinput(
            focusNode: _focusNode,
            controller: pinController,
            autofocus: true,
            obscureText: true,
            obscuringCharacter: " ",
            defaultPinTheme: defaultPinTheme,
            focusedPinTheme: focusedPinTheme,
            submittedPinTheme: submittedPinTheme,
            inputFormatters: [FilteringTextInputFormatter.digitsOnly, LengthLimitingTextInputFormatter(10),],
            // keyboardType: TextInputType.numberWithOptions(decimal: false,signed: false),
            length: 6,
            cursor: Container(color: Constants.textColor,height: 12,width: 1.5,),
            onCompleted: (val) async {
              print("------------submitted-------------");
              final prefs = await SharedPreferences.getInstance();
              final userPhone = prefs.getString('userPhone');
              loginPageController.userLoginUsingPin(userPhone!, pinController.text);
            },
          ),
          const SizedBox(height: 25,),
          InkWell(
              onTap: (){
                CustomNavigation.pushNamed(const ForgetPasswordPage());
              },
              child: const Text("Forgot Pin?",style: TextStyle(decoration: TextDecoration.underline,decorationThickness: 1.5,fontWeight: FontWeight.w700,fontSize: 17),textAlign: TextAlign.center,softWrap: true,))
        ],
      ),
    );
  }
}
