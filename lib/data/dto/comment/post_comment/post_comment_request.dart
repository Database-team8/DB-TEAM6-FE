class PostCommentRequest {
  final String content;
  final bool isSecret;
  final int? parentCommentId;

  PostCommentRequest({
    required this.content,
    required this.isSecret,
    this.parentCommentId,
  });

  Map<String, dynamic> toJson() {
    return {
      'content': content,
      'is_secret': isSecret,
      'parent_comment_id': parentCommentId,
    };
  }
}
