class BoardAuthor {
  final int userId;
  final String name;
  final String nickname;
  final String? profileImage;

  BoardAuthor({
    required this.userId,
    required this.name,
    required this.nickname,
    this.profileImage,
  });

  factory BoardAuthor.fromJson(Map<String, dynamic> json) {
    return BoardAuthor(
      userId: json['userId'] as int,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      profileImage: json['profileImage'] as String?,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'user_id': userId,
      'name': name,
      'nickname': nickname,
      'profile_image': profileImage,
    };
  }
}