class PostBoardResponse {
  final String code;
  final String message;
  final int result;
  final bool isSuccess;

  PostBoardResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory PostBoardResponse.fromJson(Map<String, dynamic> json) {
    return PostBoardResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as int,
      isSuccess: json['isSuccess'] as bool,
    );
  }
}
