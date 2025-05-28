
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../../core/error/exceptions.dart';
import '../../../mqtt/mqtt_service.dart';
import '../models/user_model.dart';
import '../models/otp_response_model.dart';

abstract class AuthRemoteDataSource {
  Future<OtpResponseModel> sendOtp(String phoneNumber);
  Future<UserModel> loginWithOtp(String phoneNumber, String otp);
  Future<UserModel> loginWithPin(String phoneNumber, String pin);
  Future<bool> setPin(String phoneNumber, String pin);
}

class AuthRemoteDataSourceImpl implements AuthRemoteDataSource {
  final MqttService mqttService;
  final SharedPreferences sharedPreferences;

  AuthRemoteDataSourceImpl({
    required this.mqttService,
    required this.sharedPreferences,
  });

  @override
  Future<OtpResponseModel> sendOtp(String phoneNumber) async {
    try {
      final clientId = sharedPreferences.getString('RandomNum');
      if (clientId == null) {
        throw const ServerException('Client ID not found');
      }

      final data = {'phone': phoneNumber};
      final topic = "WaariWater/FE/User/SendLoginOtp/$clientId";
      final resultTopic = "WaariWater/FE/User/SendLoginOtp/Result/$clientId";

      final response = await mqttService.publishAndSubscribe(
        topic,
        resultTopic,
        data,
      );

      final responseData = jsonDecode(response);
      return OtpResponseModel.fromJson(responseData);
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithOtp(String phoneNumber, String otp) async {
    try {
      final clientId = sharedPreferences.getString('RandomNum');
      if (clientId == null) {
        throw const ServerException('Client ID not found');
      }

      final data = {'phone': phoneNumber, 'otp': otp};
      final topic = "WaariWater/FE/User/Login/$clientId";
      final resultTopic = "WaariWater/FE/User/Login/Result/$clientId";

      final response = await mqttService.publishAndSubscribe(
        topic,
        resultTopic,
        data,
      );

      final responseData = jsonDecode(response);
      if (responseData['success'] == true) {
        return UserModel.fromJson(responseData['data']);
      } else {
        throw ServerException(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<UserModel> loginWithPin(String phoneNumber, String pin) async {
    try {
      final clientId = sharedPreferences.getString('RandomNum');
      if (clientId == null) {
        throw const ServerException('Client ID not found');
      }

      final data = {'phone': phoneNumber, 'pin': pin};
      final topic = "WaariWater/FE/User/LoginWithPin/$clientId";
      final resultTopic = "WaariWater/FE/User/LoginWithPin/Result/$clientId";

      final response = await mqttService.publishAndSubscribe(
        topic,
        resultTopic,
        data,
      );

      final responseData = jsonDecode(response);
      if (responseData['success'] == true) {
        return UserModel.fromJson(responseData['data']);
      } else {
        throw ServerException(responseData['message'] ?? 'Login failed');
      }
    } catch (e) {
      throw ServerException(e.toString());
    }
  }

  @override
  Future<bool> setPin(String phoneNumber, String pin) async {
    try {
      final clientId = sharedPreferences.getString('RandomNum');
      if (clientId == null) {
        throw const ServerException('Client ID not found');
      }

      final data = {'phone': phoneNumber, 'pin': pin};
      final topic = "WaariWater/FE/User/SetPin/$clientId";
      final resultTopic = "WaariWater/FE/User/SetPin/Result/$clientId";

      final response = await mqttService.publishAndSubscribe(
        topic,
        resultTopic,
        data,
      );

      final responseData = jsonDecode(response);
      return responseData['success'] == true;
    } catch (e) {
      throw ServerException(e.toString());
    }
  }
}
