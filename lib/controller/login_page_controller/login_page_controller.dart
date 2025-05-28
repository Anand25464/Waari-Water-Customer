import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get/get.dart';
import 'package:equatable/equatable.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:waari_water/controller/mqtt_controller/mqtt_controller.dart';
import 'package:waari_water/utils/loader.dart';
import 'package:waari_water/utils/navigation.dart';
import 'package:waari_water/utils/toast.dart';
import 'package:waari_water/view/home_page/home_page.dart';
import 'package:waari_water/view/m_pin_page/m_pin_page.dart';
import 'package:waari_water/view/registration/view/set_pin_view.dart';
import 'package:waari_water/view/registration/view/registration_page_view.dart';

// States
abstract class LoginPageState extends Equatable {
  const LoginPageState();

  @override
  List<Object> get props => [];
}

class LoginPageInitial extends LoginPageState {}

class LoginPageLoading extends LoginPageState {}

class LoginPageSuccess extends LoginPageState {
  final String message;

  const LoginPageSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class LoginPageError extends LoginPageState {
  final String message;

  const LoginPageError(this.message);

  @override
  List<Object> get props => [message];
}

// Cubit
class LoginPageCubit extends Cubit<LoginPageState> {
  LoginPageCubit() : super(LoginPageInitial());

  MqttController mqttController = Get.find();

  Future<void> getOTP(String mobileNumber) async {
    emit(LoginPageLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString('RandomNum');
    try {
      Map<String, dynamic> data = {
        "phone": mobileNumber
      };
      mqttController.setCurrentTopic = "WaariWater/FE/User/SendLoginOtp/Result/$clientId";
      await mqttController.publish("WaariWater/FE/User/SendLoginOtp/$clientId", data);
      await mqttController.subscribe("WaariWater/FE/User/SendLoginOtp/Result/$clientId", (String data) {
        if (mqttController.getCurrentTopic == "WaariWater/FE/User/SendLoginOtp/Result/$clientId") {
          print("--------logIn--------");
          print(data);
          final response = jsonDecode(data);
          var message = response['message'];
          var success = response['success'];
          var details = response['data'];
          if (success) {
            showToast(msg: message);
            emit(LoginPageSuccess(message)); // Emit success with the message
          } else {
            emit(LoginPageError(message)); // Emit error if not successful
          }
          print("------------userLogin response-------------");
          print(message);
          print(success);
          print(details);
        } else {
          print('------------topic not match-------------1');
        }
      });
    } catch (e) {
      print("----------logIn failed----------$e");
      emit(LoginPageError("Unable to send to mqtt: ${e.toString()}"));
    }
  }

  Future<void> userLogin(String mobileNumber, String otp, BuildContext context) async {
    emit(LoginPageLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString('RandomNum');
    try {
      Map<String, dynamic> data = {
        "phone": mobileNumber,
        "otp": otp
      };
      mqttController.setCurrentTopic = "WaariWater/FE/User/Login/Result/$clientId";
      await mqttController.publish("WaariWater/FE/User/Login/$clientId", data);
      await mqttController.subscribe("WaariWater/FE/User/Login/Result/$clientId", (String data) async {
        if (mqttController.getCurrentTopic == "WaariWater/FE/User/Login/Result/$clientId") {
          print("--------userLogin---------");
          print(data);
          final response = jsonDecode(data);
          bool success = response['success'];
          if (success) {
            var details = response['data'];
            bool? isVerified = response['data']['isVerified'];
            String? userMobile = response['data']['phone'];
            print(details);
            print(isVerified);
            if (isVerified == true) {
              CustomNavigation.pushNamed(const HomePage());
            } else {
              CustomNavigation.pushNamed(SetPinPage(userMobile: mobileNumber));
            }
            emit(LoginPageSuccess("Login successful"));
          } else {
            String message = response['message'];
            showToast(msg: message);
            emit(LoginPageError(message));
          }
          // closeLoader(context);
        } else {
          print('------------topic not match-------------2');
        }
      });
    } catch (e) {
      print("----------userLogin Fail------------$e");
      emit(LoginPageError("Unable to userLogin: ${e.toString()}"));
    }
  }

  Future<void> userLoginUsingPin(String mobileNumber, String otp) async {
    emit(LoginPageLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? clientId = prefs.getString('RandomNum');
    try {
      Map<String, dynamic> data = {
        "phone": mobileNumber,
        "pin": otp
      };
      mqttController.setCurrentTopic = "WaariWater/FE/User/LoginWithPin/Result/$clientId";
      await mqttController.publish("WaariWater/FE/User/LoginWithPin/$clientId", data);
      await mqttController.subscribe("WaariWater/FE/User/LoginWithPin/Result/$clientId", (String data) async {
        if (mqttController.getCurrentTopic == "WaariWater/FE/User/LoginWithPin/Result/$clientId") {
          print("--------userLoginwith pin---------");
          print(data);
          final response = jsonDecode(data);
          bool success = response['success'];
          if (success) {
            CustomNavigation.pushNamed(const HomePage());
            emit(LoginPageSuccess("Login successful"));
          } else {
            String message = response['message'];
            showToast(msg: message);
            emit(LoginPageError(message));
          }
        } else {
          print('------------topic not match-------------2');
        }
      });
    } catch (e) {
      print("----------userLogin Fail------------$e");
      emit(LoginPageError("Unable to userLogin: ${e.toString()}"));
    }
  }

  Future<void> login(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      emit(LoginPageError("Please enter phone number"));
      return;
    }

    emit(LoginPageLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Check if user exists in SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      final storedPhone = prefs.getString("phone_number");

      if (storedPhone == phoneNumber) {
        // User exists, proceed to PIN page
        await prefs.setBool("isUser", true);
        emit(LoginPageSuccess("Login successful"));
      } else {
        // User doesn't exist, navigate to registration
        emit(LoginPageSuccess("User not found, redirecting to registration"));
        CustomNavigation.pushNamed(const RegistrationPageView());
      }
    } catch (e) {
      emit(LoginPageError("Login failed: ${e.toString()}"));
    }
  }


  void reset() {
    emit(LoginPageInitial());
  }
}