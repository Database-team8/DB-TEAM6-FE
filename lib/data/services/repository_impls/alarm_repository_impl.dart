import 'dart:convert';
import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/alarm/alarm_read/alarm_read_response.dart';
import 'package:ajoufinder/data/dto/alarm/alarm_read/alrarm_read_request.dart';
import 'package:ajoufinder/data/dto/alarm/alarms/alarms_response.dart';
import 'package:ajoufinder/domain/repository/alarm_repository.dart';
import 'package:http/http.dart' as http;

class AlarmRepositoryImpl extends AlarmRepository{
  final http.Client _client;

  AlarmRepositoryImpl(this._client);

  @override
  Future<AlarmsResponse> getAlarms() async {
    final url = Uri.parse('$baseUrl/alarms');

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );
      if (response.statusCode >= 200 && response.statusCode < 300) {
        final responseBody = json.decode(response.body);

        if (responseBody.isNotEmpty) {
          print('알림 조회 성공: ${responseBody.length}개 알림');
          return AlarmsResponse.fromJson(responseBody);
        } else {
          print('알림 조회 실패: 응답이 비어 있습니다.');
          return AlarmsResponse(alarms: []);
        }
      } else {
        print('알림 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('알림 조회 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('알림 API 네트워크 오류 발생: $e');
      throw Exception('알림 조회 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('알림 API 응답 처리 중 예외 발생: $e');
      throw Exception('알림 응답 처리 중 오류가 발생했습니다.');
    }
  }
  
  @override
  Future<AlarmReadResponse> markAsRead(AlarmReadRequest request) async {
    final url = Uri.parse('$baseUrl/alarms/${request.alarmId}/read');

    try {
      final response = await _client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('markAsRead 성공');
        return AlarmReadResponse();
      } else {
        print('markAsRead 실패');
        throw Exception('markAsRead 실패 (서버 오류 ${response.statusCode})');
      }
    } catch (e) {
      print('markAsRead 응답 처리 중 예외 발생: $e');
      throw Exception('markAsRead 응답 처리 중 오류가 발생했습니다.');
    }
  }
  
  @override
  Future<void> readAll() async {
    final url = Uri.parse('$baseUrl/alarms/read-all');

    try {
      final response = await _client.post(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (response.statusCode >= 200 && response.statusCode < 300) {
        print('readAll 성공');
        return;
      } else {
        print('readAll 실패');
        throw Exception('readAll 실패 (서버 오류 ${response.statusCode})');
      }
    } catch (e) {
      print('readAll 응답 처리 중 예외 발생: $e');
      throw Exception('readAll 응답 처리 중 오류가 발생했습니다.');
    }
  }
}