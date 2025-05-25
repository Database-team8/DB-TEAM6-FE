class SignUpRequest {
  final String email;
  final String password;
  final String name;
  final String nickname;
  final String? phone;
  final String? description;
  final String? profile_image;
  final String role;

  SignUpRequest({
    required this.email,
    required this.password,
    required this.name,
    required this.nickname,
    required this.phone,
    required this.description,
    required this.profile_image,
    required this.role,
  });

    factory SignUpRequest.fromJson(Map<String, dynamic> json) {
    return SignUpRequest(
      email: json['email'] as String,
      password: json['password'] as String,
      name: json['name'] as String,
      nickname: json['nickname'] as String,
      phone: json['phone'] as String,
      description: json['description'] as String,
      profile_image: json['profile_image'] as String,
      role: json['role'] as String,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'email': email,
      'password': password,
      'name': name,
      'nickname': nickname,
      'phone': phone,
      'description': description,
      'profile_image' : profile_image,
      'role' : role,
    };
  }
}
