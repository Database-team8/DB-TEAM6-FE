class Condition {
  final int id;
  final String itemType;
  final String location;

  Condition({
    required this.id,
    required this.itemType,
    required this.location,
  });

  factory Condition.fromJson(Map<String, dynamic> json) {
    return Condition(
      id: json['condition_id'],
      itemType: json['item_type'] ?? '',
      location: json['location'] ?? '',
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_type': itemType,
      'location': location,
    };
  }
}
