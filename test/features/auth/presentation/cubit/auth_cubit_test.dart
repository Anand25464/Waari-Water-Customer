
import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waari_water/core/error/failures.dart';
import 'package:waari_water/features/auth/domain/entities/otp_response.dart';
import 'package:waari_water/features/auth/domain/entities/user.dart';
import 'package:waari_water/features/auth/domain/usecases/send_otp.dart';
import 'package:waari_water/features/auth/domain/usecases/login_with_otp.dart';
import 'package:waari_water/features/auth/domain/usecases/login_with_pin.dart';
import 'package:waari_water/features/auth/presentation/cubit/auth_cubit.dart';

class MockSendOtp extends Mock implements SendOtp {}
class MockLoginWithOtp extends Mock implements LoginWithOtp {}
class MockLoginWithPin extends Mock implements LoginWithPin {}

void main() {
  late AuthCubit authCubit;
  late MockSendOtp mockSendOtp;
  late MockLoginWithOtp mockLoginWithOtp;
  late MockLoginWithPin mockLoginWithPin;

  setUp(() {
    mockSendOtp = MockSendOtp();
    mockLoginWithOtp = MockLoginWithOtp();
    mockLoginWithPin = MockLoginWithPin();
    authCubit = AuthCubit(
      sendOtpUseCase: mockSendOtp,
      loginWithOtpUseCase: mockLoginWithOtp,
      loginWithPinUseCase: mockLoginWithPin,
    );
  });

  tearDown(() {
    authCubit.close();
  });

  group('AuthCubit', () {
    const tPhoneNumber = '1234567890';
    const tOtp = '123456';
    const tPin = '1234';
    const tOtpResponse = OtpResponse(success: true, message: 'OTP sent successfully');
    const tUser = User(phone: tPhoneNumber, isVerified: true);

    test('initial state should be AuthInitial', () {
      expect(authCubit.state, AuthInitial());
    });

    group('sendOtp', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, OtpSent] when OTP is sent successfully',
        build: () {
          when(() => mockSendOtp(any()))
              .thenAnswer((_) async => const Right(tOtpResponse));
          return authCubit;
        },
        act: (cubit) => cubit.sendOtp(tPhoneNumber),
        expect: () => [
          AuthLoading(),
          const OtpSent('OTP sent successfully'),
        ],
        verify: (_) {
          verify(() => mockSendOtp(const SendOtpParams(phoneNumber: tPhoneNumber)));
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthError] when sending OTP fails',
        build: () {
          when(() => mockSendOtp(any()))
              .thenAnswer((_) async => const Left(ServerFailure('Server Error')));
          return authCubit;
        },
        act: (cubit) => cubit.sendOtp(tPhoneNumber),
        expect: () => [
          AuthLoading(),
          const AuthError('Server Error'),
        ],
        verify: (_) {
          verify(() => mockSendOtp(const SendOtpParams(phoneNumber: tPhoneNumber)));
        },
      );
    });

    group('loginWithOtp', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthSuccess] when login is successful',
        build: () {
          when(() => mockLoginWithOtp(any()))
              .thenAnswer((_) async => const Right(tUser));
          return authCubit;
        },
        act: (cubit) => cubit.loginWithOtp(tPhoneNumber, tOtp),
        expect: () => [
          AuthLoading(),
          const AuthSuccess(tUser),
        ],
        verify: (_) {
          verify(() => mockLoginWithOtp(
                const LoginWithOtpParams(phoneNumber: tPhoneNumber, otp: tOtp),
              ));
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthError] when login fails',
        build: () {
          when(() => mockLoginWithOtp(any()))
              .thenAnswer((_) async => const Left(ServerFailure('Invalid OTP')));
          return authCubit;
        },
        act: (cubit) => cubit.loginWithOtp(tPhoneNumber, tOtp),
        expect: () => [
          AuthLoading(),
          const AuthError('Invalid OTP'),
        ],
        verify: (_) {
          verify(() => mockLoginWithOtp(
                const LoginWithOtpParams(phoneNumber: tPhoneNumber, otp: tOtp),
              ));
        },
      );
    });

    group('loginWithPin', () {
      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthSuccess] when login with PIN is successful',
        build: () {
          when(() => mockLoginWithPin(any()))
              .thenAnswer((_) async => const Right(tUser));
          return authCubit;
        },
        act: (cubit) => cubit.loginWithPin(tPhoneNumber, tPin),
        expect: () => [
          AuthLoading(),
          const AuthSuccess(tUser),
        ],
        verify: (_) {
          verify(() => mockLoginWithPin(
                const LoginWithPinParams(phoneNumber: tPhoneNumber, pin: tPin),
              ));
        },
      );

      blocTest<AuthCubit, AuthState>(
        'should emit [AuthLoading, AuthError] when login with PIN fails',
        build: () {
          when(() => mockLoginWithPin(any()))
              .thenAnswer((_) async => const Left(ServerFailure('Invalid PIN')));
          return authCubit;
        },
        act: (cubit) => cubit.loginWithPin(tPhoneNumber, tPin),
        expect: () => [
          AuthLoading(),
          const AuthError('Invalid PIN'),
        ],
        verify: (_) {
          verify(() => mockLoginWithPin(
                const LoginWithPinParams(phoneNumber: tPhoneNumber, pin: tPin),
              ));
        },
      );
    });
  });
}
