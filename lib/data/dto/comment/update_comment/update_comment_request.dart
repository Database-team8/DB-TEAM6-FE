class UpdateCommentRequest {
  final String content;
  final bool isSecret;

  UpdateCommentRequest({required this.content, required this.isSecret});

  Map<String, dynamic> toJson() {
    return {'content': content, 'is_secret': isSecret};
  }
}
