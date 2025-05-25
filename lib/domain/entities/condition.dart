import 'package:ajoufinder/domain/entities/location.dart';

class Condition {
  final int id;
  final int itemTypeId;
  final int userId;
  final String category;
  final List<Location>? locations;

  Condition({
    required this.id,
    required this.itemTypeId,
    required this.userId,
    required this.category,
    this.locations,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      id: json['id'],
      itemTypeId: json['item_type_id'],
      userId: json['user_id'],
      category: json['category'],
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_type_id': itemTypeId,
      'user_id': userId,
      'category': category,
    };
  }
}
