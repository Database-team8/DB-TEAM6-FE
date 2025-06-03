class Alarm {
  final int id;
  final String content;
  final String relatedContent;
  final String url;
  bool isRead;
  final DateTime createdAt;
  final DateTime updatedAt;

  Alarm({
    required this.id,
    required this.content,
    required this.relatedContent,
    required this.url,
    required this.isRead,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Alarm.fromJson(Map<String, dynamic> json) {
    return Alarm(
      id: json['id'] as int,
      content: json['content'] as String,
      relatedContent: json['related_content'] as String,
      url: json['url'] as String,
      isRead: json['is_read'] as bool,
      createdAt: DateTime.parse(json['created_at'] as String),
      updatedAt: DateTime.parse(json['updated_at'] as String),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'content': content,
      'related_content': relatedContent,
      'url': url,
      'is_read': isRead,
      'created_at': createdAt.toIso8601String(),
      'updated_at': updatedAt.toIso8601String(),
    };
  }
}