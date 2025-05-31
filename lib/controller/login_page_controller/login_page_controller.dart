import 'package:flutter_riverpod/flutter_riverpod.dart';

// Login Page State
class LoginPageState {
  final bool isLoading;
  final String? message;
  final String? error;
  final bool isLoginSuccessful;

  const LoginPageState({
    this.isLoading = false,
    this.message,
    this.error,
    this.isLoginSuccessful = false,
  });

  LoginPageState copyWith({
    bool? isLoading,
    String? message,
    String? error,
    bool? isLoginSuccessful,
  }) {
    return LoginPageState(
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      error: error ?? this.error,
      isLoginSuccessful: isLoginSuccessful ?? this.isLoginSuccessful,
    );
  }
}

// Login Page Controller using Riverpod
class LoginPageController extends StateNotifier<LoginPageState> {
  LoginPageController() : super(const LoginPageState());

  Future<void> login(String phoneNumber, String password) async {
    if (phoneNumber.isEmpty) {
      state = state.copyWith(error: "Please enter phone number");
      return;
    }

    if (password.isEmpty) {
      state = state.copyWith(error: "Please enter password");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Mock login validation
      if (phoneNumber == "1234567890" && password == "password") {
        state = state.copyWith(
          isLoading: false,
          isLoginSuccessful: true,
          message: "Login successful",
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Invalid credentials",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Login failed: ${e.toString()}",
      );
    }
  }

  Future<void> sendOtp(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      state = state.copyWith(error: "Please enter phone number");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        isLoading: false,
        message: "OTP sent to $phoneNumber",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to send OTP: ${e.toString()}",
      );
    }
  }

  Future<void> verifyOtp(String phoneNumber, String otp) async {
    if (phoneNumber.isEmpty || otp.isEmpty) {
      state = state.copyWith(error: "Please enter phone number and OTP");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));

      // Mock OTP validation
      if (otp == "1234") {
        state = state.copyWith(
          isLoading: false,
          isLoginSuccessful: true,
          message: "OTP verified successfully",
        );
      } else {
        state = state.copyWith(
          isLoading: false,
          error: "Invalid OTP",
        );
      }
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "OTP verification failed: ${e.toString()}",
      );
    }
  }

  void clearMessages() {
    state = state.copyWith(message: null, error: null);
  }

  void reset() {
    state = const LoginPageState();
  }
}

// Provider for Login Page Controller
final loginPageControllerProvider = StateNotifierProvider<LoginPageController, LoginPageState>((ref) {
  return LoginPageController();
});