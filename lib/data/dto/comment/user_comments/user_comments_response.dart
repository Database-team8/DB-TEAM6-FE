class UserComment {
  final int commentId;
  final int? parentId;
  final int boardId;
  final String relatedContent;
  final String content;
  final bool isSecret;
  final DateTime createdAt;
  final DateTime updatedAt;

  UserComment({
    required this.commentId,
    this.parentId,
    required this.boardId,
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
      'related_content': relatedContent,
      'content': content,
      'is_secret': isSecret,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}

class Sort {
  final bool empty;
  final bool sorted;
  final bool unsorted;

  Sort({required this.empty, required this.sorted, required this.unsorted});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      empty: json['empty'],
      sorted: json['sorted'],
      unsorted: json['unsorted'],
    );
  }

  Map<String, dynamic> toJson() => {
    'empty': empty,
    'sorted': sorted,
    'unsorted': unsorted,
  };
}

class Pageable {
  final int offset;
  final Sort sort;
  final bool paged;
  final int pageNumber;
  final int pageSize;
  final bool unpaged;

  Pageable({
    required this.offset,
    required this.sort,
    required this.paged,
    required this.pageNumber,
    required this.pageSize,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      offset: json['offset'],
      sort: Sort.fromJson(json['sort']),
      paged: json['paged'],
      pageNumber: json['pageNumber'],
      pageSize: json['pageSize'],
      unpaged: json['unpaged'],
    );
  }

  Map<String, dynamic> toJson() => {
    'offset': offset,
    'sort': sort.toJson(),
    'paged': paged,
    'pageNumber': pageNumber,
    'pageSize': pageSize,
    'unpaged': unpaged,
  };
}

class PageUserCommentsResponse {
  final int totalElements;
  final int totalPages;
  final int size;
  final List<UserComment> content;
  final int number;
  final Sort sort;
  final int numberOfElements;
  final Pageable pageable;
  final bool first;
  final bool last;
  final bool empty;

  PageUserCommentsResponse({
    required this.totalElements,
    required this.totalPages,
    required this.size,
    required this.content,
    required this.number,
    required this.sort,
    required this.numberOfElements,
    required this.pageable,
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
      sort: Sort.fromJson(json['sort']),
      numberOfElements: json['numberOfElements'],
      pageable: Pageable.fromJson(json['pageable']),
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
      'sort': sort.toJson(),
      'numberOfElements': numberOfElements,
      'pageable': pageable.toJson(),
      'first': first,
      'last': last,
      'empty': empty,
    };
  }
}
