import 'package:ajoufinder/data/dto/board/board_item_dto.dart';
import 'package:ajoufinder/data/dto/board/boards/boards_response.dart';
import 'package:ajoufinder/data/dto/common/pageable.dart';
import 'package:ajoufinder/data/dto/common/sort.dart';

class FilterBoardResponse extends BoardsResponse{
  FilterBoardResponse({
    required super.content,
    required super.pageable,
    required super.last,
    required super.totalPages,
    required super.totalElements,
    required super.size,
    required super.number,
    required super.sort,
    required super.first,
    required super.numberOfElements,
    required super.empty,
  });


  factory FilterBoardResponse.fromJson(Map<String, dynamic> json) {
  // content 처리: null이거나 List 타입이 아닌 경우 빈 리스트 반환
  final contentJson = json['content'];
  final List<dynamic>? contentListFromJson = 
    (contentJson is List) ? contentJson : null;

  List<BoardItemDto> boardList = contentListFromJson != null
      ? contentListFromJson
          .map((itemJson) => BoardItemDto.fromJson(
              itemJson as Map<String, dynamic>))
          .toList()
      : <BoardItemDto>[];

  return FilterBoardResponse(
    totalElements: (json['totalElements'] as int?) ?? 0,
    totalPages: (json['totalPages'] as int?) ?? 0,
    size: (json['size'] as int?) ?? 0,
    content: boardList,
    number: (json['number'] as int?) ?? 0,
    sort: Sort.fromJson(json['sort'] as Map<String, dynamic>), 
    first: (json['first'] as bool?) ?? false,
    last: (json['last'] as bool?) ?? false,
    numberOfElements: (json['numberOfElements'] as int?) ?? 0,
    pageable: Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
    empty: (json['empty'] as bool?) ?? true,
  );
}
}