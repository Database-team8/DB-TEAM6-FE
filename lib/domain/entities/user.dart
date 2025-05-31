class User {
  final String name; 
  final String nickname;
  final String? description;
  final String? profileImage;
  final String? phoneNumber;

  User({
    required this.name,
    required this.nickname,
    this.description,
    this.profileImage,
    this.phoneNumber,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      description: json['description'] as String?,
      profileImage: json['profileImage'] as String?,
      phoneNumber: json['phoneNumber'] as String?,
    );
  }

    Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'nickname': nickname,
    };
    if (description != null) {
      data['description'] = description;
    }
    if (profileImage != null) {
      data['profileImage'] = profileImage;
    }
    if (phoneNumber != null) {
      data['phoneNumber'] = phoneNumber;
    }
    return data;
  }
}