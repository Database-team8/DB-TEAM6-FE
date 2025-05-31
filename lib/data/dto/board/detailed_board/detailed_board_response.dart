import 'package:ajoufinder/domain/entities/board.dart';

class DetailedBoardResponse {
  final String code;
  final String message;
  final Board? result;
  final bool isSuccess;

  DetailedBoardResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory DetailedBoardResponse.fromJson(Map<String, dynamic> json) {
    return DetailedBoardResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: json['result'] != null ? Board.fromJson(json['result'] as Map<String, dynamic>) : null,
      isSuccess: json['isSuccess'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'result': result?.toJson(),
      'isSuccess': isSuccess,
    };
  }
}