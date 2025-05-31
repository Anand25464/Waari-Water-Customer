
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Login Page State
class LoginPageState {
  final String phoneNumber;
  final String otp;
  final bool isLoading;
  final String? message;
  final String? error;
  final bool isOtpSent;

  const LoginPageState({
    this.phoneNumber = '',
    this.otp = '',
    this.isLoading = false,
    this.message,
    this.error,
    this.isOtpSent = false,
  });

  LoginPageState copyWith({
    String? phoneNumber,
    String? otp,
    bool? isLoading,
    String? message,
    String? error,
    bool? isOtpSent,
  }) {
    return LoginPageState(
      phoneNumber: phoneNumber ?? this.phoneNumber,
      otp: otp ?? this.otp,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      error: error,
      isOtpSent: isOtpSent ?? this.isOtpSent,
    );
  }
}

// Login Page Controller using Riverpod
class LoginPageController extends StateNotifier<LoginPageState> {
  LoginPageController() : super(const LoginPageState());

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setOtp(String otp) {
    state = state.copyWith(otp: otp);
  }

  Future<void> sendOtp(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      state = state.copyWith(error: "Please enter phone number");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      setPhoneNumber(phoneNumber);
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      state = state.copyWith(
        isLoading: false,
        isOtpSent: true,
        message: "OTP sent successfully to $phoneNumber",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to send OTP: ${e.toString()}",
      );
    }
  }

  Future<void> verifyOtp(String otp) async {
    if (otp.isEmpty) {
      state = state.copyWith(error: "Please enter OTP");
      return;
    }

    if (otp.length != 6) {
      state = state.copyWith(error: "OTP must be 6 digits");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      setOtp(otp);
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      state = state.copyWith(
        isLoading: false,
        message: "OTP verified successfully",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to verify OTP: ${e.toString()}",
      );
    }
  }

  Future<void> loginWithPin(String pin) async {
    if (pin.isEmpty) {
      state = state.copyWith(error: "Please enter PIN");
      return;
    }

    if (pin.length != 4) {
      state = state.copyWith(error: "PIN must be 4 digits");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      state = state.copyWith(
        isLoading: false,
        message: "Login successful",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Login failed: ${e.toString()}",
      );
    }
  }

  void reset() {
    state = const LoginPageState();
  }

  void clearMessages() {
    state = state.copyWith(message: null, error: null);
  }
}

// Provider for Login Page Controller
final loginPageControllerProvider = StateNotifierProvider<LoginPageController, LoginPageState>((ref) {
  return LoginPageController();
});
