
import '../../domain/entities/otp_response.dart';

class OtpResponseModel extends OtpResponse {
  const OtpResponseModel({
    required super.success,
    required super.message,
  });

  factory OtpResponseModel.fromJson(Map<String, dynamic> json) {
    return OtpResponseModel(
      success: json['success'] ?? false,
      message: json['message'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'success': success,
      'message': message,
    };
  }
}
