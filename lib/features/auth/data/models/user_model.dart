
import '../../domain/entities/user.dart';

class UserModel extends User {
  const UserModel({
    required super.phone,
    required super.isVerified,
    super.pin,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) {
    return UserModel(
      phone: json['phone'] ?? '',
      isVerified: json['isVerified'] ?? false,
      pin: json['pin'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'phone': phone,
      'isVerified': isVerified,
      'pin': pin,
    };
  }
}
