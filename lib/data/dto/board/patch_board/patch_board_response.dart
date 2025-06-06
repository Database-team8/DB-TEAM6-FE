class PatchBoardResponse {
  final String code;
  final String message;
  final int result;
  final bool isSuccess;

  PatchBoardResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory PatchBoardResponse.fromJson(Map<String, dynamic> json) {
    return PatchBoardResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as int,
      isSuccess: json['isSuccess'] as bool,
    );
  }
}