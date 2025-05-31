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
    var contentListFromJson = json['content'] as List<dynamic>?;
    List<BoardItemDto> boardList = contentListFromJson != null
        ? contentListFromJson.map((itemJson) => BoardItemDto.fromJson(itemJson as Map<String, dynamic>)).toList()
        : [];

    return BoardsResponse(
      totalElements: json['totalElements'] as int,
      totalPages: json['totalPages'] as int,
      size: json['size'] as int,
      content: boardList,
      number: json['number'] as int,
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>),
      first: json['first'] as bool,
      last: json['last'] as bool,
      numberOfElements: json['numberOfElements'] as int,
      pageable: Pageable.fromJson(json['pageable'] as Map<String, dynamic>),
      empty: json['empty'] as bool,
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

