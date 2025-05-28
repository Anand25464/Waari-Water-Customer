import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:waari_water/controller/registration_controller/registration_controller.dart';
import 'package:waari_water/utils/common_header_text_field.dart';
import 'package:waari_water/utils/constants.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/view/registration/view/set_pin_view.dart';


class RegistrationUserDetailsPage extends StatefulWidget {
  String userMobile;
   RegistrationUserDetailsPage({required this.userMobile, super.key});

  @override
  State<RegistrationUserDetailsPage> createState() => _RegistrationUserDetailsPageState();
}

class _RegistrationUserDetailsPageState extends State<RegistrationUserDetailsPage> {
  RegistrationController registrationController = Get.find();
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  final _globalKey = GlobalKey<FormState>();
  bool isFilled = false;


  @override
  void initState() {
    super.initState();
    nameController.addListener(updateIsFilled);
    emailController.addListener(updateIsFilled);
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    super.dispose();
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text("Personal details",style: TextStyle(fontSize: 21,fontWeight: FontWeight.w800,color: Constants.textColor),),
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
      body: userDetails(),
      floatingActionButton: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
        child: InkWell(
          onTap: () {
            if(_globalKey.currentState!.validate()){
              registrationController.submitUserDetails(nameController.text, emailController.text, widget.userMobile);
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
                "Continue",
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
      resizeToAvoidBottomInset: true,
    );
  }
  Widget userDetails(){
    return Padding(
      padding: const EdgeInsets.fromLTRB(18,25,18,15),
      child: Form(
        key: _globalKey,
        child: Column(
          children: [
            CommonTextField(
                headerText: "Name",
                hintText: "Enter full name",
                validator:  (value){
                  if(value!.isEmpty){
                    return "Please Enter Full Name";
                  }
                  else if(value.isNum){
                    return "Please Enter Valid Name";
                  }
                    return null;
                },
                controller: nameController,
            ),
            const SizedBox(height: 15,),
            CommonTextField(
                headerText: "Email",
                hintText: "Enter email address",
                validator:  (value){
                  if(value!.isEmpty || !value.contains("@")){
                    return "Please enter  valid email address";
                  }
                    return null;
                },
                controller: emailController,

            ),
          ],
        ),
      ),
    );
  }
  void updateIsFilled() {
    setState(() {
      isFilled = nameController.text.isNotEmpty && emailController.text.isNotEmpty;
    });
  }


}
