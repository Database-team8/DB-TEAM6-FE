import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/auth/login/login_request.dart';
import 'package:ajoufinder/data/dto/auth/login/login_response.dart';
import 'package:ajoufinder/data/dto/auth/logout/logout_response.dart';
import 'package:ajoufinder/data/dto/password/change_password_request.dart';
import 'package:ajoufinder/data/dto/password/change_password_response.dart';
import 'package:ajoufinder/data/dto/user/profile/profile_response.dart';
import 'package:ajoufinder/domain/interfaces/cookie_service.dart';
import 'package:ajoufinder/domain/repository/auth_repository.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'dart:io';

class AuthRepositoryImpl extends AuthRepository{
  final http.Client _client;
  final CookieService _cookieService;

  AuthRepositoryImpl(this._client, this._cookieService);

  @override
  Future<LogoutResponse> logout() async {
    final url = Uri.parse('$baseUrl/auth/logout');

    try {
      final sessionId = await _cookieService.getCookie(cookieName);
      final response = await _client.post( 
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': '$cookieName=$sessionId',
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

  @override
  Future<LoginResponse> login(LoginRequest request) async {
    final url = Uri.parse('$baseUrl/auth/login');

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
        return LoginResponse.fromJson(responseBody);
      } else {
         if (responseBody['code'] != null && responseBody['message'] != null) { 
          return LoginResponse.fromJson(responseBody);
         }

         throw HttpException('로그인 실패 (HTTP ${response.statusCode}): ${responseBody['message'] ?? response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      print('네트워크 오류 발생: $e');
      throw HttpException('로그아웃 중 네트워크 연결에 실패했습니다.'); 
    } catch (e) {
      print('로그아웃 처리 중 예외 발생: $e');
      throw Exception(e);
    }
  }

  @override
  Future<ProfileResponse> getCurrentUserProfile() async {
    final url = Uri.parse('$baseUrl/user/profile');

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = json.decode(response.body);
        
        if (responseBody['isSuccess'] == true && responseBody['result'] != null) {
          return ProfileResponse.fromJson(responseBody);
        } else {
          print('프로필 조회 실패 (isSuccess:false 또는 result:null): ${responseBody['message']}');
          throw Exception('프로필 조회에 실패했습니다: ${responseBody['message']}');
        }
      } else if (response.statusCode == 401 || response.statusCode == 403) {
        print('프로필 조회 실패: 인증되지 않음 (HTTP ${response.statusCode})');
        throw Exception('인증되지 않았습니다. 다시 로그인해주세요.');
      } else {
        final responseBody = json.decode(response.body); // 오류 응답도 파싱 시도
        print('프로필 조회 실패 (HTTP ${response.statusCode}): ${responseBody['message'] ?? response.reasonPhrase}');
        throw Exception('프로필 조회에 실패했습니다.');
      }
    } on http.ClientException catch(e) {
      print('프로필 조회 중 네트워크 오류 발생: $e');
      throw Exception('프로필 조회 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      throw Exception('프로필 조회 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<ChangePasswordResponse> changePassword(ChangePasswordRequest request) async {
    final url = Uri.parse('$baseUrl/user/password');

    try {
      final sessionId = await _cookieService.getCookie(cookieName);
      final response = await _client.put(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'Cookie': '$cookieName=$sessionId',
          // 이 API는 JSESSIONID 쿠키를 통해 인증될 것으로 예상됩니다.
          // 브라우저는 쿠키를 자동으로 전송하거나, http.Client 설정 또는 인터셉터에서
        },
        body: json.encode(request.toJson()),
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ChangePasswordResponse.fromJson(responseBody);
      } else {
        if (responseBody['code'] != null && responseBody['message'] != null) {
          return ChangePasswordResponse.fromJson(responseBody);
        }

        throw HttpException('비밀번호 변경 실패 (HTTP ${response.statusCode}): ${responseBody['message'] ?? response.reasonPhrase}');
      }
    } on http.ClientException catch (e) {
      print('비밀번호 변경 API 호출 중 네트워크 오류 발생: $e');
      throw Exception('비밀번호 변경 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('비밀번호 변경 응답 처리 중 예외 발생: $e');
      throw Exception('비밀번호 변경 응답 데이터를 처리하는 중 오류가 발생했습니다.');
    }
  } 
}