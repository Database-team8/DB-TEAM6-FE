import 'package:ajoufinder/data/dto/comment/comment_dto.dart';

class PageCommentResponse {
  final int totalElements;
  final int totalPages;
  final int size;
  final List<Comment> content;
  final int number;
  final int numberOfElements;
  final bool first;
  final bool last;
  final bool empty;

  PageCommentResponse({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.content,
    required this.number,
    required this.numberOfElements,
    required this.first,
    required this.last,
    required this.empty,
  });

  factory PageCommentResponse.fromJson(Map<String, dynamic> json) {
    return PageCommentResponse(
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      size: json['size'],
      content:
          (json['content'] as List).map((e) => Comment.fromJson(e)).toList(),
      number: json['number'],
      numberOfElements: json['numberOfElements'],
      first: json['first'],
      last: json['last'],
      empty: json['empty'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'totalElements': totalElements,
      'totalPages': totalPages,
      'size': size,
      'content': content.map((e) => e.toJson()).toList(),
      'number': number,
      'numberOfElements': numberOfElements,
      'first': first,
      'last': last,
      'empty': empty,
    };
  }
}
