import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/logout/logout_response.dart';
import 'package:ajoufinder/domain/repository/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AuthRepositoryImpl extends AuthRepository{
  final http.Client _client;

  AuthRepositoryImpl(this._client);

  @override
  Future<LogoutResponse> logout(String accessToken) async {
    final url = Uri.parse('$baseUrl/auth/logout');

    try {
      final response = await _client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Authorization': 'Bearer $accessToken',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
       return LogoutResponse.fromJson(responseBody); 
      } else {
        if (responseBody['code'] != null && responseBody['message'] != null) {
          return LogoutResponse.fromJson(responseBody);
        }

        throw HttpException('로그아웃 실패 (HTTP ${response.statusCode}): ${responseBody['message'] ?? response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      print('네트워크 오류 발생: $e');
      throw HttpException('로그아웃 중 네트워크 연결에 실패했습니다.'); 
    } catch (e) {
      print('로그아웃 처리 중 예외 발생: $e');
      throw Exception(e);
    }
  }
}