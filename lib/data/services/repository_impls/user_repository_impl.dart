import 'dart:convert';

import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/user/signup/signup_request.dart';
import 'package:ajoufinder/data/dto/user/signup/signup_response.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:http/http.dart' as http;

class UserRepositoryImpl extends UserRepository {
  final http.Client _client;

  UserRepositoryImpl(this._client);

  @override
  Future<User> findById(int id) async {
    await Future.delayed(Duration(milliseconds: 500));
    return User(name: '장한', nickname: '별명');
  }

  @override
  Future<SignUpResponse> signUp(SignUpRequest request) async {
    final url = Uri.parse('$baseUrl/user/signup');

    try {
      final response = await _client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
        body: json.encode(request.toJson()),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return SignUpResponse.fromJson(responseBody);
      } else {
        throw Exception(
          '회원가입 실패 (HTTP ${response.statusCode}): ${response.reasonPhrase}',
        );
      }
    } catch (e) {
      print('회원가입 처리 중 예외 발생: $e');
      throw Exception('회원가입 중 오류가 발생했습니다: ${e.toString()}');
    }
  }
}
