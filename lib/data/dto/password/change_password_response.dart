class ChangePasswordResponse {
  final String code;
  final String message;
  final String result;
  final bool isSuccess;

  ChangePasswordResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });
  factory ChangePasswordResponse.fromJson(Map<String, dynamic> json) {
    return ChangePasswordResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as String,
      isSuccess: json['isSuccess'] as bool,
    );
  }
}

