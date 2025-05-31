class LogoutResponse {
  final String code;
  final String message;
  final String result;
  final bool isSuccess;

  LogoutResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory LogoutResponse.fromJson(Map<String, dynamic> json) {
    return LogoutResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as String,
      isSuccess: json['isSuccess'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'result': result,
      'isSuccess': isSuccess,
    };
  }
}
