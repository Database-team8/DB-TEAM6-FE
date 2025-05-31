import 'package:ajoufinder/data/dto/user/signup/signup_request.dart';
import 'package:ajoufinder/data/dto/user/signup/signup_response.dart';
import 'package:ajoufinder/domain/entities/user.dart';

abstract class UserRepository {
  Future<User> findById(int id);
  Future<SignUpResponse> signUp(SignUpRequest request);
}