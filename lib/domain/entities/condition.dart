import 'package:ajoufinder/domain/entities/location.dart';

class Condition {
  final int id;
  final int itemTypeId;
  final int userId;
  final String status;
  final List<Location>? locations;

  Condition({
    required this.id,
    required this.itemTypeId,
    required this.userId,
    required this.status,
    this.locations,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      id: json['id'],
      itemTypeId: json['item_type_id'],
      userId: json['user_id'],
      status: json['status'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_type_id': itemTypeId,
      'user_id': userId,
      'status': status,
    };
  }
}
