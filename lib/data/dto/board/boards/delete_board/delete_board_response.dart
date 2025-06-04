class DeleteBoardResponse {
  final String code;
  final String message;
  final int result;
  final bool isSuccess;

  DeleteBoardResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory DeleteBoardResponse.fromJson(Map<String, dynamic> json) {
    return DeleteBoardResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as int,
      isSuccess: json['isSuccess'] as bool,
    );
  }
}
