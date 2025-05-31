class SignUpResponse {
  final String code;
  final String message;
  final int result;
  final bool isSuccess;

  SignUpResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  }); 

  factory SignUpResponse.fromJson(Map<String, dynamic> json) {
    return SignUpResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as int,
      isSuccess: json['isSuccess'] as bool,
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