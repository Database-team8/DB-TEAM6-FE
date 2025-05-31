import 'package:ajoufinder/domain/entities/item_type.dart';

class ItemtypesResponse {
  final String code;
  final String message;
  final List<ItemType> result;
  final bool isSuccess;

  ItemtypesResponse({
    required this.code,
    required this.message,
    required this.result,
    required this.isSuccess,
  });

  factory ItemtypesResponse.fromJson(Map<String, dynamic> json) {
    return ItemtypesResponse(
      code: json['code'] ?? '',
      message: json['message'] ?? '',
      result: (json['result'] as List<dynamic>)
          .map((item) => ItemType.fromJson(item as Map<String, dynamic>))
          .toList(),
      isSuccess: json['isSuccess'] ?? false,
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