
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginWithOtp implements UseCase<User, LoginWithOtpParams> {
  final AuthRepository repository;

  LoginWithOtp(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginWithOtpParams params) async {
    return await repository.loginWithOtp(params.phoneNumber, params.otp);
  }
}

class LoginWithOtpParams extends Equatable {
  final String phoneNumber;
  final String otp;

  const LoginWithOtpParams({
    required this.phoneNumber,
    required this.otp,
  });

  @override
  List<Object> get props => [phoneNumber, otp];
}
