import 'package:ajoufinder/data/dto/sign_up/sign_up_request.dart';
import 'package:ajoufinder/data/dto/sign_up/sign_up_response.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';

class UserRepositoryImpl extends UserRepository{
  @override
  Future<User> findById(int id) async {
    await Future.delayed(Duration(milliseconds: 500));
    return User(
      id: 1, 
      name: '장한', 
      nickname: '별명', 
      email: 'egnever4434@ajou.ac.kr', 
      password: '1234', 
      role: 'GUEST', 
      joinDate: DateTime(2021,1,1)
    );
  }

  @override
  Future<SignUpResponse> signUp(SignUpRequest request) async {
    //추후 구현
    throw UnimplementedError();
  }
  
  @override
  Future<User?> findByAccessToken(String accessToken) {
    // TODO: implement findByAccessToken
    throw UnimplementedError();
  }
}