import 'package:ajoufinder/data/dto/user/signup/signup_request.dart';
import 'package:ajoufinder/data/dto/user/signup/signup_response.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository{
  @override
  Future<User> findById(int id) async {
    await Future.delayed(Duration(milliseconds: 500));
    return User(
      name: '장한', 
      nickname: '별명', 
    );
  }

  @override
  Future<SignUpResponse> signUp(SignUpRequest request) async {
    //추후 구현
    throw UnimplementedError();
  }
}