import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class ItemtypesUsecase {
  final BoardRepository _boardRepository;

  ItemtypesUsecase(this._boardRepository);

  Future<List<ItemType>> execute() async {
    try {
      final response = await _boardRepository.getAllItemTypes();

      if (response.isSuccess) {
        print('아이템 종류 조회 성공: ${response.result.length}개 아이템 종류 수신');
        return response.result;
      } else {
        // 서버에서 isSuccess: false로 응답한 경우
        print('아이템 타입 조회 실패: ${response.message}, 코드: ${response.code}');
        throw Exception(response.message);
      }
    } catch (e) {
      // 네트워크 오류 또는 리포지토리에서 발생한 기타 예외 처리
      print('아이템 종류 조회 유스케이스 실행 중 오류 발생: $e');
      // 필요에 따라 특정 타입의 예외로 변환하여 다시 던집니다.
      // 예: throw ItemTypesFetchException('아이템 종류를 가져오는 중 오류가 발생했습니다: ${e.toString()}');
      rethrow; // 원본 예외를 다시 던져서 상위 계층에서 처리하도록 함
    }
  }
}