import 'dart:convert';
import 'package:ajoufinder/const/network.dart';
import 'package:ajoufinder/data/dto/location/locations/locations_response.dart';
import 'package:ajoufinder/domain/repository/location_repository.dart';
import 'package:http/http.dart' as http;

class LocationRepositoryImpl extends LocationRepository{
  final http.Client _client;
  
  LocationRepositoryImpl(this._client);

  @override
  Future<String> getNameById(int departmentId) async {
    throw UnimplementedError();
  }

  @override
  Future<LocationsResponse> getAllLocations() async {
    final url = Uri.parse('$baseUrl/locations');

    try {
      final response = await _client.get(
        url,
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          // 이 API는 별도의 인증 헤더가 필요 없을 수 있습니다. (API 명세에 따라 확인)
          // 만약 JSESSIONID 쿠키 등이 필요하다면, http.Client가 자동으로 보내거나
          // 인터셉터 등을 통해 추가해야 합니다.
        },
      );

      final responseBody = json.decode(response.body);

      if (response.statusCode >= 200 && response.statusCode < 300) {
        return LocationsResponse.fromJson(responseBody);
      } else {
        // 서버 오류 응답 처리
        print('위치 정보 API 오류: ${response.statusCode}, 본문: ${response.body}');
        throw Exception('위치 정보 조회 실패 (서버 오류 ${response.statusCode})');
      }
    } on http.ClientException catch (e) {
      print('위치 정보 API 네트워크 오류 발생: $e');
      throw Exception('위치 정보 조회 중 네트워크 연결에 실패했습니다.');
    } catch (e) {
      print('위치 정보 API 응답 처리 중 예외 발생: $e');
      throw Exception('위치 정보 응답 처리 중 오류가 발생했습니다.');
    }
  }
}