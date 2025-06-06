import 'package:ajoufinder/domain/entities/user.dart';

class ProfileResponse {
  final String code;
  final String message;
  final User? result;
  final bool isSuccess;

  ProfileResponse({
    required this.code,
    required this.message,
    this.result,
    required this.isSuccess,
  });

  factory ProfileResponse.fromJson(Map<String, dynamic> json) {
    return ProfileResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: User.fromJson(json['result'] as Map<String, dynamic>),
      isSuccess: json['isSuccess'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'result': result?.toJson(),
      'isSuccess': isSuccess,
    };
  }
}
