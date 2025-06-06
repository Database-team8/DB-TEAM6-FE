class PostCommentResponse {
  final int commentId;
  final String content;
  final bool isSecret;
  final String status;
  final DateTime createdAt;

  PostCommentResponse({
    required this.commentId,
    required this.content,
    required this.isSecret,
    required this.status,
    required this.createdAt,
  });

  factory PostCommentResponse.fromJson(Map<String, dynamic> json) {
    return PostCommentResponse(
      commentId: json['comment_id'],
      content: json['content'],
      isSecret: json['is_secret'],
      status: json['status'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'comment_id': commentId,
      'content': content,
      'is_secret': isSecret,
      'status': status,
      'created_at': createdAt.toIso8601String(),
    };
  }
}
