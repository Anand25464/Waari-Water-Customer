
import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/error/failures.dart';
import '../../../../core/usecases/usecase.dart';
import '../entities/otp_response.dart';
import '../repositories/auth_repository.dart';

class SendOtp implements UseCase<OtpResponse, SendOtpParams> {
  final AuthRepository repository;

  SendOtp(this.repository);

  @override
  Future<Either<Failure, OtpResponse>> call(SendOtpParams params) async {
    return await repository.sendOtp(params.phoneNumber);
  }
}

class SendOtpParams extends Equatable {
  final String phoneNumber;

  const SendOtpParams({required this.phoneNumber});

  @override
  List<Object> get props => [phoneNumber];
}
