class UserComment {
  final int commentId;
  final int? parentId;
  final int boardId;
  final int userId;
  final String relatedContent;
  final String content;
  final bool isSecret;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserComment({
    required this.commentId,
    required this.parentId,
    required this.boardId,
    required this.userId,
    required this.relatedContent,
    required this.content,
    required this.isSecret,
    required this.createdAt,
    required this.updatedAt,
  });

  factory UserComment.fromJson(Map<String, dynamic> json) {
    return UserComment(
      commentId: json['comment_id'],
      parentId: json['parent_id'],
      boardId: json['board_id'],
      userId: json['user'],
      relatedContent: json['related_content'],
      content: json['content'],
      isSecret: json['is_secret'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'parent_id': parentId,
      'board_id': boardId,
      'user_id': userId,
      'related_content': relatedContent,
      'content': content,
      'is_secret': isSecret,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class PageUserCommentsResponse {
  final int totalElements;
  final int totalPages;
  final int size;
  final List<UserComment> content;
  final int number;
  final int numberOfElements;
  final bool first;
  final bool last;
  final bool empty;

  PageUserCommentsResponse({
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

  factory PageUserCommentsResponse.fromJson(Map<String, dynamic> json) {
    return PageUserCommentsResponse(
      totalElements: json['totalElements'],
      totalPages: json['totalPages'],
      size: json['size'],
      content:
          (json['content'] as List)
              .map((e) => UserComment.fromJson(e))
              .toList(),
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
