class LoginResponse {
  final String code;
  final String message;
  final String result;
  final bool isSuccess;

  LoginResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory LoginResponse.fromJson(Map<String, dynamic> json) {
    return LoginResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as String, // sessionId
      isSuccess: json['isSuccess'] as bool,
    );
  }
}
