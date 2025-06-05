import 'package:ajoufinder/domain/repository/board_repository.dart';

class BoardStatusesUsecase {
  final BoardRepository _boardRepository;

  BoardStatusesUsecase(this._boardRepository);

  Future<List<String>> execute() async {
    try {
      final response = await _boardRepository.getAllStatuses();

      if (response.isSuccess) {
        print('게시글 상태 목록 조회 성공 (Usecase): ${response.result.length}개 상태 수신');
        return response.result;
      } else {
        print('게시글 상태 목록 조회 성공 (Usecase): 현재 상태 목록이 비어 있습니다.');
        throw Exception('게시글 상태 목록이 비어 있습니다.');
      };
    } catch (e) {
      // 네트워크 오류 또는 리포지토리에서 발생한 기타 예외 처리
      print('게시글 상태 목록 조회 유스케이스 실행 중 오류 발생: $e');
      rethrow; // 원본 예외를 다시 던져서 상위 계층에서 처리하도록 함
    }
  }
}