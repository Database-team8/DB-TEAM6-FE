import 'package:ajoufinder/domain/entities/location.dart';

class LocationsResponse {
  final String code;
  final String message;
  final List<Location> result;
  final bool isSuccess;

  LocationsResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory LocationsResponse.fromJson(Map<String, dynamic> json) {
    return LocationsResponse(
      code: json['code'] as String,
      message: json['message'] as String,
      result: (json['result'] as List<dynamic>)
          .map((item) => Location.fromJson(item as Map<String, dynamic>))
          .toList(),
      isSuccess: json['isSuccess'] as bool,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'code': code,
      'message': message,
      'result': result.map((item) => item.toJson()).toList(),
      'isSuccess': isSuccess,
    };
  }
}