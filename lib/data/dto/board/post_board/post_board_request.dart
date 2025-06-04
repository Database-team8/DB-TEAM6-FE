class PostBoardRequest {
  final String title;
  final String detailedLocation;
  final String description;
  final DateTime relatedDate;
  final String image;
  final String category;
  final int itemTypeId;
  final int locationId;

  PostBoardRequest({
    required this.title,
    required this.detailedLocation,
    required this.description,
    required this.relatedDate,
    required this.image,
    required this.category,
    required this.itemTypeId,
    required this.locationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'detailed_location': detailedLocation,
      'description': description,
      'related_date': relatedDate.toIso8601String(),
      'image': image,
      'category': category,
      'item_type_id': itemTypeId,
      'location_id': locationId,
    };
  }
}
