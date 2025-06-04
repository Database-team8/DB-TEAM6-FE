class PostBoardRequest {
  final String title;
  final String? detailedLocation;
  final String description;
  final DateTime? relatedDate;
  final String? image;
  final String category;
  final int itemTypeId;
  final int locationId;

  PostBoardRequest({
    required this.title,
    this.detailedLocation,
    required this.description,
    this.relatedDate,
    this.image,
    required this.category,
    required this.itemTypeId,
    required this.locationId,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {
      'title': title,
      'description': description,
      'category': category,
      'item_type_id': itemTypeId,
      'location_id': locationId,
    };

    if (detailedLocation != null) {
      json['detailed_location'] = detailedLocation;
    }
    if (relatedDate != null) {
      json['related_date'] = relatedDate!.toIso8601String();
    }
    if (image != null) {
      json['image'] = image;
    }
    return json;
  }
}
