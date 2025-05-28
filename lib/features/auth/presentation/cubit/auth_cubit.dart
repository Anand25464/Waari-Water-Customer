
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import '../../domain/entities/user.dart';
import '../../domain/usecases/send_otp.dart';
import '../../domain/usecases/login_with_otp.dart';
import '../../domain/usecases/login_with_pin.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  final SendOtp sendOtpUseCase;
  final LoginWithOtp loginWithOtpUseCase;
  final LoginWithPin loginWithPinUseCase;

  AuthCubit({
    required this.sendOtpUseCase,
    required this.loginWithOtpUseCase,
    required this.loginWithPinUseCase,
  }) : super(AuthInitial());

  Future<void> sendOtp(String phoneNumber) async {
    emit(AuthLoading());
    
    final result = await sendOtpUseCase(SendOtpParams(phoneNumber: phoneNumber));
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (otpResponse) => emit(OtpSent(otpResponse.message)),
    );
  }

  Future<void> loginWithOtp(String phoneNumber, String otp) async {
    emit(AuthLoading());
    
    final result = await loginWithOtpUseCase(
      LoginWithOtpParams(phoneNumber: phoneNumber, otp: otp),
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }

  Future<void> loginWithPin(String phoneNumber, String pin) async {
    emit(AuthLoading());
    
    final result = await loginWithPinUseCase(
      LoginWithPinParams(phoneNumber: phoneNumber, pin: pin),
    );
    
    result.fold(
      (failure) => emit(AuthError(failure.message)),
      (user) => emit(AuthSuccess(user)),
    );
  }
}
