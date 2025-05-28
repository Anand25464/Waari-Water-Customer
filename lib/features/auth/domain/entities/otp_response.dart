
import 'package:equatable/equatable.dart';

class OtpResponse extends Equatable {
  final bool success;
  final String message;

  const OtpResponse({
    required this.success,
    required this.message,
  });

  @override
  List<Object> get props => [success, message];
}
