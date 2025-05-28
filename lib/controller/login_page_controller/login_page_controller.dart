import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/utils/loader.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/utils/toast.dart';
import 'package:waari_water/view/home_page/home_page.dart';
import 'package:waari_water/view/m_pin_page/m_pin_page.dart';
import 'package:waari_water/view/registration/view/set_pin_view.dart';

class LoginPageController extends GetxController{
  MqttController mqttController = Get.find();
  //final key = new GlobalKey<ScaffoldState>();

  var sendOTP = false.obs;
  bool get getSendOTP => sendOTP.value;
  set setSendOTP(bool val){
    sendOTP.value = val;
    sendOTP.refresh();
  }
  
   Future<void>getOTP(String mobileNumber)async{
     SharedPreferences prefs = await SharedPreferences.getInstance();
     String? clientId = prefs.getString('RandomNum');
    try{
      Map<String,dynamic> data = {
        "phone": mobileNumber
      };
      mqttController.setCurrentTopic = "WaariWater/FE/User/SendLoginOtp/Result/$clientId";
      await mqttController.publish("WaariWater/FE/User/SendLoginOtp/$clientId", data);
      await mqttController.subscribe("WaariWater/FE/User/SendLoginOtp/Result/$clientId", (String data) {
        if(mqttController.getCurrentTopic == "WaariWater/FE/User/SendLoginOtp/Result/$clientId"){
          print("--------logIn--------");
          print(data);
          final  response =jsonDecode(data);
          var message = response['message'];
          var success = response['success'];
          var details = response['data'];
          if(success){
            showToast(msg: message);
          }
          else{

          }
          print("------------userLogin response-------------");
          print(message);
          print(success);
          print(details);
        }
        else{
          print('------------topic not match-------------1');
        }
      });
    }catch(e){
      print("----------logIn failed----------$e");
      Get.snackbar("Error", "Unable to send to mqtt");
    }
  }

  userLogin(String mobileNumber, String otp, BuildContext context)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString('RandomNum');
    try{
      Map<String,dynamic> data = {
        "phone": mobileNumber,
        "otp": otp
      };
      mqttController.setCurrentTopic = "WaariWater/FE/User/Login/Result/$clientId";
      await mqttController.publish("WaariWater/FE/User/Login/$clientId", data);
      await mqttController.subscribe("WaariWater/FE/User/Login/Result/$clientId", (String data) async {
        if(mqttController.getCurrentTopic == "WaariWater/FE/User/Login/Result/$clientId"){
          print("--------userLogin---------");
          print(data);
          final  response =jsonDecode(data);
          bool success = response['success'];
          if(success){
            var details = response['data'];
            bool? isVerified = response['data']['isVerified'];
            String? userMobile = response['data']['phone'];
            print(details);
            print(isVerified);
            if(isVerified == true){
              CustomNavigation.pushNamed(const HomePage());
            }else{
              CustomNavigation.pushNamed( SetPinPage(userMobile: mobileNumber));
            }
          }
          else{
            String message = response['message'];
            showToast(msg: message);
          }
         // closeLoader(context);
        }
        else{
          print('------------topic not match-------------2');
        }
        });
    }catch(e){
      print("----------userLogin Fail------------$e");
      Get.snackbar("Error", "Unable to userLogin");
    }
  }


  userLoginUsingPin(String mobileNumber, String otp)async{
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString('RandomNum');
    try{
      Map<String,dynamic> data = {
        "phone": mobileNumber,
        "pin": otp
      };
      mqttController.setCurrentTopic = "WaariWater/FE/User/LoginWithPin/Result/$clientId";
      await mqttController.publish("WaariWater/FE/User/LoginWithPin/$clientId", data);
      await mqttController.subscribe("WaariWater/FE/User/LoginWithPin/Result/$clientId", (String data) async {
        if(mqttController.getCurrentTopic == "WaariWater/FE/User/LoginWithPin/Result/$clientId"){
          print("--------userLoginwith pin---------");
          print(data);
          final  response =jsonDecode(data);
          bool success = response['success'];
          if(success){
            CustomNavigation.pushNamed(const HomePage());
          } else{
              String message = response['message'];
                showToast(msg: message);
            }
          }
        else{
          print('------------topic not match-------------2');
        }
      });
    }catch(e){
      print("----------userLogin Fail------------$e");
      Get.snackbar("Error", "Unable to userLogin");
    }
  }
}