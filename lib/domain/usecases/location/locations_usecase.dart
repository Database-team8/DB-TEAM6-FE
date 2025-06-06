import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/repository/location_repository.dart';

class LocationsUsecase {
  final LocationRepository _locationRepository;

  LocationsUsecase(this._locationRepository);

  Future<List<Location>> execute() async {
    try {
      final response = await _locationRepository.getAllLocations();

      if (response.isSuccess) {
        // API 응답이 성공적이면, 결과 리스트(response.result)를 반환합니다.
        print('위치 정보 조회 성공 (Usecase): ${response.result.length}개 항목 수신');
        return response.result;
      } else {
        // API 응답은 성공(HTTP 200)했으나, 응답 내용상 isSuccess가 false인 경우
        print('위치 정보 조회 실패 (Usecase - isSuccess:false): ${response.message}, 코드: ${response.code}');
        // 이 경우, UI에 메시지를 전달하기 위해 특정 예외를 발생시키거나, 빈 리스트를 반환할 수 있습니다.
        // 여기서는 예외를 발생시키는 것으로 처리합니다.
        throw Exception(response.message);
      }
    } catch (e) {
       // 네트워크 오류 또는 리포지토리에서 발생한 기타 예외 처리
      print('위치 정보 조회 유스케이스 실행 중 오류 발생: $e');
      // 필요에 따라 특정 타입의 예외로 변환하여 다시 던집니다.
      // 예: throw Exception('위치 정보를 가져오는 중 오류가 발생했습니다: ${e.toString()}');
      rethrow; // 원본 예외를 다시 던져서 상위 계층에서 처리하도록 함
    }
  }
}