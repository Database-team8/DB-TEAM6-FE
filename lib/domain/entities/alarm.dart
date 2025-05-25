class Alarm {
  final int id;
  final int userId;
  final String content;
  final String relatedUrl;
  bool isRead;
  final DateTime createdAt;

  Alarm({
    required this.id,
    required this.userId,
    required this.content,
    required this.relatedUrl,
    required this.isRead,
    required this.createdAt,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'],
      userId: json['user_id'],
      content: json['content'],
      relatedUrl: json['related_url'],
      isRead: json['is_read'],
      createdAt: DateTime.parse(json['created_at']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'user_id': userId,
      'content': content,
      'related_url': relatedUrl,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
    };
  }
}