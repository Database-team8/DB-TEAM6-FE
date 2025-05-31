class SignUpRequest {
  final String name;
  final String nickname;
  final String email;
  final String password;
  final String? description;
  final String? profileImage;
  final String? phoneNumber;
  final String role;

  SignUpRequest({
    required this.name,
    required this.nickname,
    required this.email,
    required this.password,
    this.description,
    this.profileImage,
    this.phoneNumber,
    required this.role,
  });
  
  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = {
      'name': name,
      'nickname': nickname,
      'email': email,
      'password': password,
      'role': role,
    };
    if (description != null) {
      data['description'] = description;
    }
    if (profileImage != null) {
      data['profile_image'] = profileImage;
    }
    if (phoneNumber != null) {
      data['phone_number'] = phoneNumber;
    }
    return data;
  }
}
