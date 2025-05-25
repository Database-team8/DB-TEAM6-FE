class Comment {
  final int id;
  final int? parentId;
  final int userId;
  final int boardId;
  final String title;
  final String content;
  final String status;
  final bool isSecret;
  final DateTime updatedAt;
  final DateTime createdAt;

  Comment({
    required this.id,
    this.parentId,
    required this.userId,
    required this.boardId,
    required this.title,
    required this.content,
    required this.status,
    required this.isSecret,
    required this.updatedAt,
    required this.createdAt,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      id: json['id'],
      parentId: json['parent_id'],
      userId: json['user_id'],
      boardId: json['board_id'],
      title: json['title'],
      content: json['content'],
      status: json['status'],
      isSecret: json['is_secret'],
      updatedAt: DateTime.parse(json['updated_at']),
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'parent_id': parentId,
      'user_id': userId,
      'board_id': boardId,
      'title': title,
      'content': content,
      'status': status,
      'is_secret': isSecret,
      'updated_at': updatedAt.toIso8601String(),
      'created_at': createdAt.toIso8601String(),
    };
  }
}
