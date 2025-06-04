import 'package:ajoufinder/domain/entities/condition.dart';
import 'package:ajoufinder/domain/repository/condition_repository.dart';

class ConditionsUsecase {
  final ConditionRepository _conditionRepository;

  ConditionsUsecase(this._conditionRepository);

  Future<List<Condition>> execute() async {
    try {
      final response = await _conditionRepository.getAllConditions();

      if (response.isSuccess) {
        // 조건 조회 성공
        print('조건 조회 성공 (Usecase): ${response.result.length}개');
        return response.result; // 성공 시 조건 리스트 반환
      } else {
        // 서버에서 isSuccess: false로 응답한 경우
        print('조건 조회 실패 (Usecase): ${response.message}, 코드: ${response.code}');
        throw Exception('조건 조회 실패: ${response.message}'); // 실패 시 예외 발생
      }
    } catch (e) {
      // 네트워크 오류, 파싱 오류 등 리포지토리에서 발생한 예외 처리
      print('조건 조회 유스케이스 실행 중 오류 발생: $e');
      throw e; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
  }
}