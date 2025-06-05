import 'dart:convert';
import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/condition/conditions/conditions_response.dart';
import 'package:ajoufinder/data/dto/condition/delete_condition/delete_condition_request.dart';
import 'package:ajoufinder/data/dto/condition/delete_condition/delete_condition_response.dart';
import 'package:ajoufinder/data/dto/condition/post_condition.dart/post_condition_request.dart';
import 'package:ajoufinder/data/dto/condition/post_condition.dart/post_condition_response.dart';
import 'package:ajoufinder/domain/repository/condition_repository.dart';
import 'package:http/http.dart' as http;

class ConditionRepositoryImpl extends ConditionRepository{
  final http.Client _client;
  
  ConditionRepositoryImpl(this._client);

  @override
  Future<PostConditionResponse> postCondition(PostConditionRequest request) async {
    final url = Uri.parse('$baseUrl/conditions');

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
        return PostConditionResponse.fromJson(responseBody);
      } else {
        // 서버 오류 응답 처리
        print('조건 등록 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('조건 등록 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('조건 등록 API 네트워크 오류 발생: $e');
      throw Exception('조건 등록 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('조건 등록 API 응답 처리 중 예외 발생: $e');
      throw Exception('조건 등록 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<ConditionsResponse> getAllConditions() async {
    final url = Uri.parse('$baseUrl/conditions');

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return ConditionsResponse.fromJson(responseBody);
      } else {
        // 서버 오류 응답 처리
        print('조건 정보 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('조건 정보 조회 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('조건 정보 API 네트워크 오류 발생: $e');
      throw Exception('조건 정보 조회 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('조건 정보 API 응답 처리 중 예외 발생: $e');
      throw Exception('조건 정보 응답 처리 중 오류가 발생했습니다.');
    }
  }

  @override
  Future<DeleteConditionResponse> deleteCondition(DeleteConditionRequest request) async {
    final url = Uri.parse('$baseUrl/conditions/${request.conditionId}');

    try {
      final response = await _client.delete(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return DeleteConditionResponse.fromJson(responseBody);
      } else {
        // 서버 오류 응답 처리
        print('조건 삭제 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('조건 삭제 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('조건 삭제 API 네트워크 오류 발생: $e');
      throw Exception('조건 삭제 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('조건 삭제 API 응답 처리 중 예외 발생: $e');
      throw Exception('조건 삭제 응답 처리 중 오류가 발생했습니다.');
    }
  }

}