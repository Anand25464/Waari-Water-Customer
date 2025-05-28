import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waari_water/controller/registration_controller/registration_controller.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/loader.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/home_page/home_page.dart';

class SetPinPage extends StatefulWidget {
  String userMobile;
   SetPinPage({ required this.userMobile,super.key});

  @override
  State<SetPinPage> createState() => _SetPinPageState();
}

class _SetPinPageState extends State<SetPinPage> {
  RegistrationController registrationController = Get.put(RegistrationController());
  TextEditingController pinController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  bool isFilled = false;
  late FocusNode _focusNode;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    // Initialize the focus node
    _focusNode = FocusNode();

    // Set focus to the text field when the page is loaded
   // FocusScope.of(context).requestFocus(_focusNode);
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
      backgroundColor: Colors.white,
      appBar: AppBar(
        toolbarHeight: 80,
        title: const Text("Set New Pin",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w800,color: Constants.textColor),),
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
      body: sixDigitPin(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: Obx((){
          return InkWell(
            onTap: () {
              if(_globalKey.currentState!.validate()){
                registrationController.getResetPin ? registrationController.setUserPin(pinController.text,widget.userMobile,context) : (){};
                registrationController.setResetPin = true;
                pinController.clear();
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
                  registrationController.getResetPin ? "SetPin" :"Submit",
                  style: TextStyle(
                      fontWeight: FontWeight.w800,
                      fontSize: 18,
                      color: isFilled ? Colors.white : Constants.textDisableColor
                  ),
                ),
              ),
            ),
          );
        })
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      resizeToAvoidBottomInset: true,
    );
  }
  Widget sixDigitPin(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(18,25,18,15),
      child: Form(
        key: _globalKey,
        child: Obx((){
          return Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                registrationController.getResetPin ? "Re-Enter Pin" : "Enter New Pin",
                style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 18, color: Constants.textColor),
              ),
              const SizedBox(height: 10),
              TextFormField(
                textAlign: TextAlign.center,
                keyboardType: TextInputType.number,
                controller: pinController,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                  LengthLimitingTextInputFormatter(6),
                ],
                style: const TextStyle(fontSize: 21, fontWeight: FontWeight.w600, color: Constants.textColor),
                //textInputAction: TextInputAction.next,
                decoration: InputDecoration(
                  hintText: registrationController.getResetPin ? "Re-enter 6 Digit Pin" : "Enter 6 Digit Pin",
                  hintStyle: const TextStyle(fontWeight: FontWeight.w600, fontSize: 17, color: Constants.textDisableColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                  focusedBorder: OutlineInputBorder(
                    borderSide: const BorderSide(color: Constants.outLineColor),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12.0),
                    borderSide: const BorderSide(
                      color: Constants.outLineColor,
                      width: 2.0,
                    ),
                  ),

                ),
                validator: (value){
                  if(value!.length != 6){
                    return "Please enter 6 digit pin";
                  }
                  return null;
                },
                cursorColor: Constants.textColor,
                onChanged: (value){
                  if(value.length == 6){
                    setState(() {
                      isFilled = true;
                    });
                  }
                  else if(value.length <= 6){
                    setState(() {
                      isFilled = false;
                    });
                  }
                },
                focusNode: _focusNode,
                autofocus: true,
              ),
              const SizedBox(height: 10),
              Text(
                registrationController.getResetPin ? "Re-enter and confirm your security pin."
                    :"Secure your account with the pin password.",
                style: TextStyle(fontSize: 16,fontWeight: FontWeight.w600,color: Constants.textDisableColor),)
            ],
          );
        })
      ),
    );
  }
}
