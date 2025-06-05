import 'package:ajoufinder/data/dto/board/boards/boards_request.dart';

class FilterBoardsRequest extends BoardsRequest{
  final String? status;
  final int? itemTypeId;
  final int? locationId;
  final DateTime? startDate;
  final DateTime? endDate;

  FilterBoardsRequest({
    this.status,
    this.itemTypeId,
    this.locationId,
    this.startDate,
    this.endDate,
    int page = 0,
    int size = 10,
  });

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> json = {};
    if (status != null) json['status'] = status;
    if (itemTypeId != null) json['item_type_id'] = itemTypeId;
    if (locationId != null) json['location_id'] = locationId;
    if (startDate != null) json['start_date'] = startDate!.toIso8601String();
    if (endDate != null) json['end_date'] = endDate!.toIso8601String();
    json['page'] = page;
    json['size'] = size;
    return json;
  }
}