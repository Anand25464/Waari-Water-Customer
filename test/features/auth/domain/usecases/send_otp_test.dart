
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waari_water/core/error/failures.dart';
import 'package:waari_water/features/auth/domain/entities/otp_response.dart';
import 'package:waari_water/features/auth/domain/repositories/auth_repository.dart';
import 'package:waari_water/features/auth/domain/usecases/send_otp.dart';

class MockAuthRepository extends Mock implements AuthRepository {}

void main() {
  late SendOtp usecase;
  late MockAuthRepository mockAuthRepository;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    usecase = SendOtp(mockAuthRepository);
  });

  const tPhoneNumber = '1234567890';
  const tOtpResponse = OtpResponse(success: true, message: 'OTP sent successfully');

  test('should get OTP response from the repository', () async {
    // arrange
    when(() => mockAuthRepository.sendOtp(any()))
        .thenAnswer((_) async => const Right(tOtpResponse));

    // act
    final result = await usecase(const SendOtpParams(phoneNumber: tPhoneNumber));

    // assert
    expect(result, const Right(tOtpResponse));
    verify(() => mockAuthRepository.sendOtp(tPhoneNumber));
    verifyNoMoreInteractions(mockAuthRepository);
  });

  test('should return ServerFailure when repository fails', () async {
    // arrange
    when(() => mockAuthRepository.sendOtp(any()))
        .thenAnswer((_) async => const Left(ServerFailure('Server Error')));

    // act
    final result = await usecase(const SendOtpParams(phoneNumber: tPhoneNumber));

    // assert
    expect(result, const Left(ServerFailure('Server Error')));
    verify(() => mockAuthRepository.sendOtp(tPhoneNumber));
    verifyNoMoreInteractions(mockAuthRepository);
  });
}
