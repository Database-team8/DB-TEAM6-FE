class DeleteConditionResponse {
  final String code;
  final String message;
  final String result;
  final bool isSuccess;

  DeleteConditionResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory DeleteConditionResponse.fromJson(Map<String, dynamic> json) {
    return DeleteConditionResponse(
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