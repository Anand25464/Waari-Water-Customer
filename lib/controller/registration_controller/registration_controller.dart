
import 'package:flutter_riverpod/flutter_riverpod.dart';

// Registration State
class RegistrationState {
  final int currentStep;
  final String name;
  final String phoneNumber;
  final String pin;
  final bool isLoading;
  final String? message;
  final String? error;

  const RegistrationState({
    this.currentStep = 0,
    this.name = '',
    this.phoneNumber = '',
    this.pin = '',
    this.isLoading = false,
    this.message,
    this.error,
  });

  RegistrationState copyWith({
    int? currentStep,
    String? name,
    String? phoneNumber,
    String? pin,
    bool? isLoading,
    String? message,
    String? error,
  }) {
    return RegistrationState(
      currentStep: currentStep ?? this.currentStep,
      name: name ?? this.name,
      phoneNumber: phoneNumber ?? this.phoneNumber,
      pin: pin ?? this.pin,
      isLoading: isLoading ?? this.isLoading,
      message: message ?? this.message,
      error: error ?? this.error,
    );
  }
}

// Registration Controller using Riverpod
class RegistrationController extends StateNotifier<RegistrationState> {
  RegistrationController() : super(const RegistrationState());

  void setName(String name) {
    state = state.copyWith(name: name);
  }

  void setPhoneNumber(String phoneNumber) {
    state = state.copyWith(phoneNumber: phoneNumber);
  }

  void setPin(String pin, String confirmPin) {
    if (pin.isEmpty || confirmPin.isEmpty) {
      state = state.copyWith(error: "Please enter both PIN and confirmation PIN");
      return;
    }
    
    if (pin.length != 4 || confirmPin.length != 4) {
      state = state.copyWith(error: "PIN must be 4 digits");
      return;
    }
    
    if (pin != confirmPin) {
      state = state.copyWith(error: "PINs do not match");
      return;
    }
    
    state = state.copyWith(pin: pin, isLoading: true, error: null);
    
    // Simulate API call delay
    Future.delayed(const Duration(seconds: 1), () {
      state = state.copyWith(
        isLoading: false,
        message: "PIN set successfully",
      );
    });
  }

  void nextStep() {
    state = state.copyWith(currentStep: state.currentStep + 1);
  }

  void previousStep() {
    if (state.currentStep > 0) {
      state = state.copyWith(currentStep: state.currentStep - 1);
    }
  }

  Future<void> register() async {
    state = state.copyWith(isLoading: true, error: null);
    try {
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      state = state.copyWith(
        isLoading: false,
        message: "Registration successful",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Registration failed: ${e.toString()}",
      );
    }
  }

  Future<void> registerUserDetails(String name, String email) async {
    if (name.isEmpty) {
      state = state.copyWith(error: "Please enter your name");
      return;
    }
    
    if (email.isEmpty) {
      state = state.copyWith(error: "Please enter your email");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      setName(name);
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        isLoading: false,
        message: "User details registered successfully",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to register user details: ${e.toString()}",
      );
    }
  }

  Future<void> registerPhone(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      state = state.copyWith(error: "Please enter phone number");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      setPhoneNumber(phoneNumber);
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        isLoading: false,
        message: "Phone number registered successfully",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to register phone number: ${e.toString()}",
      );
    }
  }

  Future<void> resetPassword(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      state = state.copyWith(error: "Please enter phone number");
      return;
    }

    state = state.copyWith(isLoading: true, error: null);

    try {
      await Future.delayed(const Duration(seconds: 2));
      state = state.copyWith(
        isLoading: false,
        message: "Reset link sent to $phoneNumber",
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: "Failed to send reset link: ${e.toString()}",
      );
    }
  }

  void reset() {
    state = const RegistrationState();
  }

  void clearMessages() {
    state = state.copyWith(message: null, error: null);
  }
}

// Provider for Registration Controller
final registrationControllerProvider = StateNotifierProvider<RegistrationController, RegistrationState>((ref) {
  return RegistrationController();
});
