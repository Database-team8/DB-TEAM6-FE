class PostBoardRequest {
  final String title;
  final String detailedLocation;
  final String description;
  final String relatedDate;
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
      'related_date': relatedDate,
      'image': image,
      'category': category,
      'item_type_id': itemTypeId,
      'location_id': locationId,
    };
  }

  // DateTime을 받아서 ISO 8601 문자열로 변환하는 편의 생성자
  PostBoardRequest.withDateTime({
    required this.title,
    required this.detailedLocation,
    required this.description,
    required DateTime relatedDateTime,
    required this.image,
    required this.category,
    required this.itemTypeId,
    required this.locationId,
  }) : relatedDate = relatedDateTime.toIso8601String();
}
