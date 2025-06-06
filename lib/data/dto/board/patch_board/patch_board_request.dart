class PatchBoardRequest {
  final int boardId;
  final String? title;
  final int? locationId;
  final int? itemTypeId;
  final String? description;
  final String? detailedLocation;
  final String? image; 
  final String? relatedDate;

  PatchBoardRequest({
    required this.boardId,
    this.title,
    this.locationId,
    this.itemTypeId,
    this.description,
    this.detailedLocation,
    this.image,
    this.relatedDate,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (title != null) json['title'] = title;
    if (locationId != null) json['location_id'] = locationId;
    if (itemTypeId != null) json['item_type_id'] = itemTypeId;
    if (description != null) json['description'] = description;
    if (detailedLocation != null) json['detailed_location'] = detailedLocation;
    if (image != null) json['image'] = image;
    if (relatedDate != null) json['related_date'] = relatedDate;
    return json;
  }
}
