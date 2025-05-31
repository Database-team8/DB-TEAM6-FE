class ItemType {
  final int id; 
  final String itemType;

  ItemType({
    required this.id,
    required this.itemType,
  });

  factory ItemType.fromJson(Map<String, dynamic> json) {
    return ItemType(
      id: json['itemTypeId'],
      itemType: json['itemType'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemTypeId': id,
      'itemType': itemType,
    };
  }

  
}
