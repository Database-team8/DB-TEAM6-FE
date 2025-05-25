class SignUpResponse {
  final bool isSuccess;
  final String code;
  final String? message;
  final int result;

  SignUpResponse({
    required this.isSuccess,
    required this.code,
    required this.message,
    required this.result,
  }); 

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      isSuccess: json['isSuccess'] as bool,
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as int,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'isSuccess' : isSuccess,
      'code' : code,
      'message' : message,
      'result' : result,
    };
  }
}