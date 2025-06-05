class PostConditionResponse {
  final String code;
  final String message;
  final int result;
  final bool isSuccess;

  PostConditionResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory PostConditionResponse.fromJson(Map<String, dynamic> json) {
    return PostConditionResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as int,
      isSuccess: json['isSuccess'] as bool,
    );
  }
}