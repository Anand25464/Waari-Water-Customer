
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:waari_water/core/error/exceptions.dart';
import 'package:waari_water/core/error/failures.dart';
import 'package:waari_water/features/auth/data/datasources/auth_remote_data_source.dart';
import 'package:waari_water/features/auth/data/models/otp_response_model.dart';
import 'package:waari_water/features/auth/data/models/user_model.dart';
import 'package:waari_water/features/auth/data/repositories/auth_repository_impl.dart';

class MockAuthRemoteDataSource extends Mock implements AuthRemoteDataSource {}

void main() {
  late AuthRepositoryImpl repository;
  late MockAuthRemoteDataSource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockAuthRemoteDataSource();
    repository = AuthRepositoryImpl(remoteDataSource: mockRemoteDataSource);
  });

  group('sendOtp', () {
    const tPhoneNumber = '1234567890';
    const tOtpResponseModel = OtpResponseModel(
      success: true,
      message: 'OTP sent successfully',
    );

    test('should return OtpResponse when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.sendOtp(any()))
          .thenAnswer((_) async => tOtpResponseModel);

      // act
      final result = await repository.sendOtp(tPhoneNumber);

      // assert
      verify(() => mockRemoteDataSource.sendOtp(tPhoneNumber));
      expect(result, const Right(tOtpResponseModel));
    });

    test('should return ServerFailure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(() => mockRemoteDataSource.sendOtp(any()))
          .thenThrow(const ServerException('Server Error'));

      // act
      final result = await repository.sendOtp(tPhoneNumber);

      // assert
      verify(() => mockRemoteDataSource.sendOtp(tPhoneNumber));
      expect(result, const Left(ServerFailure('Server Error')));
    });
  });

  group('loginWithOtp', () {
    const tPhoneNumber = '1234567890';
    const tOtp = '123456';
    const tUserModel = UserModel(phone: tPhoneNumber, isVerified: true);

    test('should return User when the call to remote data source is successful', () async {
      // arrange
      when(() => mockRemoteDataSource.loginWithOtp(any(), any()))
          .thenAnswer((_) async => tUserModel);

      // act
      final result = await repository.loginWithOtp(tPhoneNumber, tOtp);

      // assert
      verify(() => mockRemoteDataSource.loginWithOtp(tPhoneNumber, tOtp));
      expect(result, const Right(tUserModel));
    });

    test('should return ServerFailure when the call to remote data source is unsuccessful', () async {
      // arrange
      when(() => mockRemoteDataSource.loginWithOtp(any(), any()))
          .thenThrow(const ServerException('Invalid OTP'));

      // act
      final result = await repository.loginWithOtp(tPhoneNumber, tOtp);

      // assert
      verify(() => mockRemoteDataSource.loginWithOtp(tPhoneNumber, tOtp));
      expect(result, const Left(ServerFailure('Invalid OTP')));
    });
  });
}
