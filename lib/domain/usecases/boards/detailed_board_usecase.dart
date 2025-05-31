import 'package:ajoufinder/data/dto/board/detailed_board/detailed_board_request.dart';
import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class DetailedBoardUsecase {
  final BoardRepository _repository;

  DetailedBoardUsecase(this._repository);

  Future<Board?> execute(int boardId) async {
    final request = DetailedBoardRequest(boardId: boardId);

    try {
      final response = await _repository.getBoardById(request);

      if (response.isSuccess && response.result != null) {
        print('게시글 상세 조회 성공 (Usecase): 게시글 ID ${boardId}의 상세 정보 수신');
        // 필요한 경우, response.content를 사용하여 게시글 상세 정보를 처리합니다.
        return response.result!;
      } else {
        print(
          '게시글 상세 조회 실패 (Usecase): ${response.message}, 코드: ${response.code}',
        );
        // 실패 시, 예외를 던지거나 다른 처리를 할 수 있습니다.
        throw Exception('게시글 상세 조회 실패: ${response.message}');
      }
    } catch (e) {
      // 네트워크 오류 또는 리포지토리에서 발생한 기타 예외 처리
      print('게시글 상세 조회 유스케이스 실행 중 오류 발생: $e');
      // 필요에 따라 특정 타입의 예외로 변환하여 다시 던집니다.
      rethrow; // 원본 예외를 다시 던져서 상위 계층에서 처리하도록 함
    }
  }
}
