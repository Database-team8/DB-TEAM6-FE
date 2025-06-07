class PatchBoardResponse {
  final String code;
  final String message;
  final bool isSuccess;

  PatchBoardResponse({
    required this.code,
    required this.message,
    required this.isSuccess,
  });

  factory PatchBoardResponse.fromJson(Map<String, dynamic> json) {
    return PatchBoardResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      isSuccess: json['isSuccess'] as bool,
    );
  }
}