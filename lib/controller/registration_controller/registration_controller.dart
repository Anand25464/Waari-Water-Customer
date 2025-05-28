import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/utils/loader.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/utils/toast.dart';
import 'package:waari_water/view/home_page/home_page.dart';
import 'package:waari_water/view/registration/view/name_registration_page.dart';
import 'package:waari_water/view/registration/view/set_pin_view.dart';

class RegistrationController extends GetxController{
  MqttController mqttController = Get.find();

  var resetPin = false.obs;
  bool get getResetPin => resetPin.value;
  set setResetPin(bool val){
    resetPin.value = val;
    resetPin.refresh();
  }


  var isVerified = false.obs;
  bool get getIsVerified => isVerified.value;
  set setIsVerified(bool val){
    isVerified.value = val;
    isVerified.refresh();
  }



  getOTP(String mobileNumber)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString('RandomNum');
    try{
      Map<String,dynamic> data = {
        "phone": mobileNumber
      };
      mqttController.setCurrentTopic = "WaariWater/FE/User/SendRegOTP/Result/$clientId";
      mqttController.publish("WaariWater/FE/User/SendRegOTP/$clientId", data);
      mqttController.subscribe("WaariWater/FE/User/SendRegOTP/Result/$clientId",(String data) {
        if(mqttController.getCurrentTopic == "WaariWater/FE/User/SendRegOTP/Result/$clientId"){
          print("-------registration--------");
          print(data);
          final response = jsonDecode(data);
          bool success = response['success'];
          String message = response['message'];
          if(success){
            setIsVerified = true;
          }
          showToast(msg: message);
        }
        else{
          print("------------topic not match-------------3");
        }
      });
    }catch(e){
      print("----------logIn failed----------$e");
      Get.snackbar("Error", "Unable to send to mqtt");
    }
  }


  verifyOTP(String mobileNumber, String otp)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString('RandomNum');
    try{
      Map<String,dynamic> data = {
        "phone": mobileNumber,
        "otp": otp
      };
      mqttController.setCurrentTopic = "WaariWater/FE/User/VerifyRegOtp/Result/$clientId";
      mqttController.publish("WaariWater/FE/User/VerifyRegOtp/$clientId", data);
      mqttController.subscribe("WaariWater/FE/User/VerifyRegOtp/Result/$clientId", (String data) {
          if(mqttController.getCurrentTopic == "WaariWater/FE/User/VerifyRegOtp/Result/$clientId"){
            print("--------verifiy registration--------");
            print(data);
            final response = jsonDecode(data);
            bool success = response['success'];
            if(success) {
              CustomNavigation.push(RegistrationUserDetailsPage(userMobile: mobileNumber,));
            }else{
              String message = response['message'];
              showToast(msg: message);
            }
          }
          else{
            print("------------topic not match-------------4");
          }
      });

    }catch(e){
      print("----------logIn failed----------$e");
      Get.snackbar("Error", "Unable to send to mqtt");
    }
  }


  submitUserDetails(String userName, String email, String phone)async{
    try{
      Map<String,dynamic> data = {
        "userName": userName,
        "email": email,
        "phone": phone
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? clientId = prefs.getString('RandomNum');
      mqttController.setCurrentTopic = "WaariWater/FE/User/SaveCustomerDetails/Result/$clientId";
      mqttController.publish("WaariWater/FE/User/SaveCustomerDetails/$clientId", data);
      mqttController.subscribe("WaariWater/FE/User/SaveCustomerDetails/Result/$clientId", (String data) {
        if(mqttController.getCurrentTopic == "WaariWater/FE/User/SaveCustomerDetails/Result/$clientId"){
          print("-------------submitUserDetails---------------");
          print(data);
          final response = jsonDecode(data);
          bool success = response['success'];
          if(success){
            CustomNavigation.push( SetPinPage(userMobile: phone,));
          } else{
            String message = response['message'];
            showToast(msg: message);
          }

        }

      });
    }catch(e){
      print("--------------submitUserDetails failed $e------------");
      Get.snackbar("Error", "Unable to save user details");
    }
  }


  setUserPin(String pin, String phone,BuildContext context)async{
    try{
      Map<String,dynamic> data = {
        "phone": phone,
        "pin" : pin
      };
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String? clientId = prefs.getString('RandomNum');
      mqttController.setCurrentTopic = "WaariWater/FE/User/SetCustomerPin/Result/$clientId";
      mqttController.publish("WaariWater/FE/User/SetCustomerPin/$clientId", data);
      mqttController.subscribe("WaariWater/FE/User/SetCustomerPin/Result/$clientId", (String data) {
        if(mqttController.getCurrentTopic == "WaariWater/FE/User/SetCustomerPin/Result/$clientId"){
          print(data);
          final response = jsonDecode(data);
          bool success = response['success'];
          if(success){
            CustomNavigation.pushAndRemoveUntil(const HomePage());
            prefs.setBool("isUser", true);
            prefs.setString("userPhone", phone);
          } else{
            String message = response['message'];
            showToast(msg: message);
          }
        }
      });
    }catch(e){
      print("--------------setUserPin failed $e------------");
      Get.snackbar("Error", "Unable to set user pin");
    }
  }
}