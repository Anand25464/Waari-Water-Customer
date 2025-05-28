
import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String phone;
  final bool isVerified;
  final String? pin;

  const User({
    required this.phone,
    required this.isVerified,
    this.pin,
  });

  @override
  List<Object?> get props => [phone, isVerified, pin];
}
