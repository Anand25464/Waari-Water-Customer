import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

// States
abstract class RegistrationState extends Equatable {
  const RegistrationState();

  @override
  List<Object> get props => [];
}

class RegistrationInitial extends RegistrationState {}

class RegistrationLoading extends RegistrationState {}

class RegistrationSuccess extends RegistrationState {
  final String message;

  const RegistrationSuccess(this.message);

  @override
  List<Object> get props => [message];
}

class RegistrationError extends RegistrationState {
  final String message;

  const RegistrationError(this.message);

  @override
  List<Object> get props => [message];
}

class RegistrationStepChanged extends RegistrationState {
  final int step;

  const RegistrationStepChanged(this.step);

  @override
  List<Object> get props => [step];
}

// Cubit
class RegistrationCubit extends Cubit<RegistrationState> {
  RegistrationCubit() : super(RegistrationInitial());

  int _currentStep = 0;
  String _name = '';
  String _phoneNumber = '';
  String _pin = '';

  void setName(String name) {
    _name = name;
  }

  void setPhoneNumber(String phoneNumber) {
    _phoneNumber = phoneNumber;
  }

  void setPin(String pin) {
    _pin = pin;
  }

  void nextStep() {
    _currentStep++;
    emit(RegistrationStepChanged(_currentStep));
  }

  void previousStep() {
    if (_currentStep > 0) {
      _currentStep--;
      emit(RegistrationStepChanged(_currentStep));
    }
  }

  void register() async {
    emit(RegistrationLoading());
    try {
      // Add your registration logic here
      await Future.delayed(const Duration(seconds: 2)); // Simulate API call
      emit(RegistrationSuccess("Registration successful"));
    } catch (e) {
      emit(RegistrationError("Registration failed: ${e.toString()}"));
    }
  }

  Future<void> registerUserDetails(String name, String email) async {
    if (name.isEmpty) {
      emit(RegistrationError("Please enter your name"));
      return;
    }
    
    if (email.isEmpty) {
      emit(RegistrationError("Please enter your email"));
      return;
    }

    emit(RegistrationLoading());

    try {
      // Set the user details
      setName(name);
      // You might want to add email field to the cubit state if needed
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically make an API call to register user details
      // For now, we'll just simulate a successful response
      emit(RegistrationSuccess("User details registered successfully"));
    } catch (e) {
      emit(RegistrationError("Failed to register user details: ${e.toString()}"));
    }
  }

  Future<void> registerPhone(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      emit(RegistrationError("Please enter phone number"));
      return;
    }

    emit(RegistrationLoading());

    try {
      // Set the phone number
      setPhoneNumber(phoneNumber);
      
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically make an API call to register/verify phone number
      // For now, we'll just simulate a successful response
      emit(RegistrationSuccess("Phone number registered successfully"));
    } catch (e) {
      emit(RegistrationError("Failed to register phone number: ${e.toString()}"));
    }
  }

  Future<void> resetPassword(String phoneNumber) async {
    if (phoneNumber.isEmpty) {
      emit(RegistrationError("Please enter phone number"));
      return;
    }

    emit(RegistrationLoading());

    try {
      // Simulate API call delay
      await Future.delayed(const Duration(seconds: 2));

      // Here you would typically make an API call to send reset password link
      // For now, we'll just simulate a successful response
      emit(RegistrationSuccess("Reset link sent to $phoneNumber"));
    } catch (e) {
      emit(RegistrationError("Failed to send reset link: ${e.toString()}"));
    }
  }

  void reset() {
    _currentStep = 0;
    _name = '';
    _phoneNumber = '';
    _pin = '';
    emit(RegistrationInitial());
  }

  // Getters
  int get currentStep => _currentStep;
  String get name => _name;
  String get phoneNumber => _phoneNumber;
  String get pin => _pin;
}