class ItemType {
  final int id; 
  final String itemType;

  ItemType({
    required this.id,
    required this.itemType,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
      id: json['id'],
      itemType: json['item_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'item_type': itemType,
    };
  }
}
