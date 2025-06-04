import 'package:ajoufinder/data/dto/condition/post_condition.dart/post_condition_request.dart';
import 'package:ajoufinder/domain/repository/condition_repository.dart';

class PostConditionUsecase {
  final ConditionRepository _conditionrepository;

  PostConditionUsecase(this._conditionrepository);

  Future<bool> execute({required int itemTypeId, required int locationId}) async {
    final request = PostConditionRequest(
      itemTypeId: itemTypeId, 
      locationId: locationId
    );

    try {
      final response = await _conditionrepository.postCondition(request);

      if (response.isSuccess) {
        // 조건 등록 성공
        print('조건 등록 성공 (Usecase): ${response.message}');
        return true; // 성공 시 true 반환
      } else {
        // 서버에서 isSuccess: false로 응답한 경우
        print('조건 등록 실패 (Usecase): ${response.message}, 코드: ${response.code}');
        return false; // 실패 시 false 반환
      }
    } on ArgumentError catch (e) {
      // 유효성 검사 실패 등 ArgumentError 처리
      print('조건 등록 유스케이스 입력 오류: ${e.message}');
      // 이 경우, 호출한 곳에서 예외를 처리하도록 그대로 전파하거나, 특정 오류 응답 DTO를 반환할 수 있습니다.
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    } catch (e) {
      // 네트워크 오류, 파싱 오류 등 리포지토리에서 발생한 예외 처리
      print('조건 등록 유스케이스 실행 중 오류 발생: $e');
      // 이 유스케이스에 특화된 예외로 변환하거나, 기본 오류 응답 DTO를 반환할 수 있습니다.
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
  }
}