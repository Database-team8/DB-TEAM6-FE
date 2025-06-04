import 'package:ajoufinder/data/dto/board/board_item_dto.dart';
import 'package:ajoufinder/data/dto/common/pageable.dart';
import 'package:ajoufinder/data/dto/common/sort.dart';

class BoardsResponse {
  final int totalElements;
  final int totalPages;   
  final int size;         
  final List<BoardItemDto> content;
  final int number;       
  final Sort sort;
  final bool first;       
  final bool last;        
  final int numberOfElements;
  final Pageable pageable;
  final bool empty;          

  BoardsResponse({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.content,
    required this.number,
    required this.sort,
    required this.first,
    required this.last,
    required this.numberOfElements,
    required this.pageable,
    required this.empty,
  });

  factory BoardsResponse.fromJson(Map<String, dynamic> json) {
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

  return BoardsResponse(
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


  Map<String, dynamic> toJson() {
    return {
      'totalElements': totalElements,
      'totalPages': totalPages,
      'size': size,
      'content': content.map((item) => item.toJson()).toList(),
      'number': number,
      'sort': sort.toJson(),
      'first': first,
      'last': last,
      'numberOfElements': numberOfElements,
      'pageable': pageable.toJson(),
      'empty': empty,
    };
  }
}

