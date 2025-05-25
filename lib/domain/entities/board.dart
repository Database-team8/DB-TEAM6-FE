class Board {
  final int id; 
  final String title;
  final int userId; 
  final int? locationId; 
  final String? detailedLocation;
  final String description; 
  final DateTime? relatedDate;
  final String? image; 
  final String status; 
  final String category; 
  final DateTime createdAt;
  final DateTime updatedAt;
  final String? itemType; 

  Board({
    required this.id,
    required this.title,
    required this.userId,
    this.locationId,
    this.detailedLocation,
    required this.description,
    this.relatedDate,
    this.image,
    required this.status,
    required this.category,
    required this.createdAt,
    required this.updatedAt,
    this.itemType,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: json['id'],
      title: json['title'],
      userId: json['user_id'],
      locationId: json['location_id'],
      detailedLocation: json['detailed_location'],
      description: json['description'],
      relatedDate: json['related_date'] != null
          ? DateTime.parse(json['related_date'])
          : null,
      image: json['image'],
      status: json['status'],
      category: json['category'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      itemType: json['item_type'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'user_id': userId,
      'location_id': locationId,
      'detailed_location': detailedLocation,
      'description': description,
      'related_date': relatedDate?.toIso8601String(),
      'image': image,
      'status': status,
      'category': category,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'item_type': itemType,
    };
  }
}
