import 'package:ajoufinder/domain/entities/condition.dart';

class ConditionsResponse {
  final String code;
  final String message;
  final List<Condition> result;
  final bool isSuccess;

  ConditionsResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory ConditionsResponse.fromJson(Map<String, dynamic> json) {
    return ConditionsResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: (json['result'] as List)
          .map((item) => Condition.fromJson(item as Map<String, dynamic>))
          .toList(),
      isSuccess: json['isSuccess'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'result': result.map((condition) => condition.toJson()).toList(),
      'isSuccess': isSuccess,
    };
  }
}