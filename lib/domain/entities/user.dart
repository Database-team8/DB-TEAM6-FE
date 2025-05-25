class User {
  final int id;
  final String name; 
  final String nickname;
  final String email;
  final String password;
  final String? description;
  final String? profileImage;
  final String? phoneNumber;
  final String role;
  final DateTime? updatedAt;
  final DateTime joinDate; 

  User({
    required this.id,
    required this.name,
    required this.nickname,
    required this.email,
    required this.password,
    this.description,
    this.profileImage,
    this.phoneNumber,
    required this.role,
    this.updatedAt,
    required this.joinDate,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      name: json['name'],
      nickname: json['nickname'],
      email: json['email'],
      password: json['password'],
      description: json['description'],
      profileImage: json['profile_image'],
      phoneNumber: json['phone_number'],
      role: json['role'],
      updatedAt: DateTime.parse(json['updated_at']),
      joinDate: DateTime.parse(json['join_date']),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'nickname': nickname,
      'email': email,
      'password': password,
      'description': description,
      'profile_image': profileImage,
      'phone_number': phoneNumber,
      'role': role,
      'updated_at': updatedAt,
      'join_date': joinDate,
    };
  }
}