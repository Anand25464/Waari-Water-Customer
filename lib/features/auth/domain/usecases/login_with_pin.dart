
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/user.dart';
import '../repositories/auth_repository.dart';

class LoginWithPin implements UseCase<User, LoginWithPinParams> {
  final AuthRepository repository;

  LoginWithPin(this.repository);

  @override
  Future<Either<Failure, User>> call(LoginWithPinParams params) async {
    return await repository.loginWithPin(params.phoneNumber, params.pin);
  }
}

class LoginWithPinParams extends Equatable {
  final String phoneNumber;
  final String pin;

  const LoginWithPinParams({
    required this.phoneNumber,
    required this.pin,
  });

  @override
  List<Object> get props => [phoneNumber, pin];
}
