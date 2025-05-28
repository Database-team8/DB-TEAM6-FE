import 'package:ajoufinder/data/dto/logout/logout_response.dart';

abstract class AuthRepository {
  Future<LogoutResponse> logout(String accessToken);
}