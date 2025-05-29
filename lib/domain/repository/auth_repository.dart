import 'package:ajoufinder/data/dto/login/login_request.dart';
import 'package:ajoufinder/data/dto/login/login_response.dart';
import 'package:ajoufinder/data/dto/logout/logout_response.dart';

abstract class AuthRepository {
  Future<LogoutResponse> logout(String accessToken);
  Future<LoginResponse> login(LoginRequest request);
}