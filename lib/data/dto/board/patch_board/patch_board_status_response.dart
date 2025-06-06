class PatchBoardStatusResponse {
  final String code;
  final String message;
  final int result;
  final bool isSuccess;

  PatchBoardStatusResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory PatchBoardStatusResponse.fromJson(Map<String, dynamic> json) {
    return PatchBoardStatusResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] as int,
      isSuccess: json['isSuccess'] as bool,
    );
  }
}