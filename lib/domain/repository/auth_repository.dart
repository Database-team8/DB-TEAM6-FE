import 'package:ajoufinder/data/dto/auth/login/login_request.dart';
import 'package:ajoufinder/data/dto/auth/login/login_response.dart';
import 'package:ajoufinder/data/dto/auth/logout/logout_response.dart';
import 'package:ajoufinder/data/dto/password/change_password_request.dart';
import 'package:ajoufinder/data/dto/password/change_password_response.dart';
import 'package:ajoufinder/data/dto/user/profile/profile_response.dart';

abstract class AuthRepository {
  Future<LogoutResponse> logout(String accessToken);
  Future<LoginResponse> login(LoginRequest request);
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request);
  Future<ProfileResponse> getCurrentUserProfile();
}