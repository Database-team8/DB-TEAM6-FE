class PostConditionRequest {
  final int itemTypeId;
  final int locationId;

  PostConditionRequest({
    required this.itemTypeId,
    required this.locationId,
  });

  Map<String, dynamic> toJson() {
    return {
      'item_type_id': itemTypeId,
      'location_id': locationId,
    };
  }
}