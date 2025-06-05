import 'package:ajoufinder/data/dto/condition/delete_condition/delete_condition_request.dart';
import 'package:ajoufinder/domain/repository/condition_repository.dart';

class DeleteConditionUsecase {
  final ConditionRepository _conditionRepository;

  DeleteConditionUsecase(this._conditionRepository);

  Future<bool> execute(int conditionId) async {
    if (conditionId <= 0) {
      print('DeleteConditionUsecase: 유효하지 않은 conditionId: $conditionId');
      return false;
    }
    
    try {
      final response = await _conditionRepository.deleteCondition(DeleteConditionRequest(conditionId: conditionId));

      if (response.isSuccess) {
        print('조건 삭제 성공 (Usecase): 조건 ID $conditionId');
        return true;
      } else {
        print('조건 삭제 실패 (Usecase): ${response.message}, 코드: ${response.code}');
        return false;
      }
    } catch (e) {
      // 리포지토리에서 발생한 예외를 그대로 다시 던지거나,
      // 이 유스케이스에 특화된 예외로 변환하여 던질 수 있습니다.
      print('조건 삭제 유스케이스 실행 중 오류 발생: $e');
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
  }
}