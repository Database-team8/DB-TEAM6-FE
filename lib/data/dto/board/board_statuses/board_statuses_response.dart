class BoardStatusesResponse {
  final String code;
  final String message;
  final List<String> result;
  final bool isSuccess;

  BoardStatusesResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory BoardStatusesResponse.fromJson(Map<String, dynamic> json) {
    return BoardStatusesResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      //result: (json['result'] as List<dynamic>).map((item) => item as String).toList(),
      result: ['ACTIVE', 'COMPLETED'], // Mocking the result for simplicity
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