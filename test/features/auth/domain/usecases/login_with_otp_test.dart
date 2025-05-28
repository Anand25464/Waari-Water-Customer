
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waari_water/core/error/failures.dart';
import 'package:waari_water/features/auth/domain/entities/user.dart';
import 'package:waari_water/features/auth/domain/repositories/auth_repository.dart';
import 'package:waari_water/features/auth/domain/usecases/login_with_otp.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late LoginWithOtp usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = LoginWithOtp(mockAuthRepository);
  });

  const tPhoneNumber = '1234567890';
  const tOtp = '123456';
  const tUser = User(phone: tPhoneNumber, isVerified: true);

  test('should get user from the repository when login is successful', () async {
    // arrange
    when(() => mockAuthRepository.loginWithOtp(any(), any()))
        .thenAnswer((_) async => const Right(tUser));

    // act
    final result = await usecase(
      const LoginWithOtpParams(phoneNumber: tPhoneNumber, otp: tOtp),
    );

    // assert
    expect(result, const Right(tUser));
    verify(() => mockAuthRepository.loginWithOtp(tPhoneNumber, tOtp));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(() => mockAuthRepository.loginWithOtp(any(), any()))
        .thenAnswer((_) async => const Left(ServerFailure('Invalid OTP')));

    // act
    final result = await usecase(
      const LoginWithOtpParams(phoneNumber: tPhoneNumber, otp: tOtp),
    );

    // assert
    expect(result, const Left(ServerFailure('Invalid OTP')));
    verify(() => mockAuthRepository.loginWithOtp(tPhoneNumber, tOtp));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
