import 'package:ajoufinder/domain/entities/user.dart';

class Comment {
  final int commentId;
  final int? parentId;
  final int userId;
  final String content;
  final bool isSecret;
  final DateTime createdAt;
  final DateTime updatedAt;
  final User user;
  final List<Comment> childComments;

  Comment({
    required this.commentId,
    required this.parentId,
    required this.userId,
    required this.content,
    required this.isSecret,
    required this.createdAt,
    required this.updatedAt,
    required this.user,
    required this.childComments,
  });

  factory Comment.fromJson(Map<String, dynamic> json) {
    return Comment(
      commentId: json['comment_id'],
      parentId: json['parent_id'],
      userId: json['user']?['userId'], // userId그냥받아오면 오류
      content: json['content'],
      isSecret: json['is_secret'],
      createdAt: DateTime.parse(json['created_at']),
      updatedAt: DateTime.parse(json['updated_at']),
      user: User.fromJson(json['user']),
      childComments:
          (json['child_comments'] as List)
              .map((e) => Comment.fromJson(e))
              .toList(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'parent_id': parentId,
      'user_id': userId,
      'content': content,
      'is_secret': isSecret,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
      'user': user.toJson(),
      'child_comments': childComments.map((e) => e.toJson()).toList(),
    };
  }
}
