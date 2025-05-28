
import 'package:dartz/dartz.dart';
import '../../../../core/error/failures.dart';
import '../entities/user.dart';
import '../entities/otp_response.dart';

abstract class AuthRepository {
  Future<Either<Failure, OtpResponse>> sendOtp(String phoneNumber);
  Future<Either<Failure, User>> loginWithOtp(String phoneNumber, String otp);
  Future<Either<Failure, User>> loginWithPin(String phoneNumber, String pin);
  Future<Either<Failure, bool>> setPin(String phoneNumber, String pin);
}
