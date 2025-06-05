import 'package:ajoufinder/data/dto/board/delete_board/delete_board_request.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class DeleteBoardUsecase {
  final BoardRepository _boardRepository;

  DeleteBoardUsecase(this._boardRepository);

  Future<bool> execute(int boardId) async {
    if (boardId <= 0) {
      print('DeleteBoardUsecase: 유효하지 않은 boardId: $boardId');
      return false;
    }

    try {
      final response = await _boardRepository.deleteBoard(DeleteBoardRequest(boardId: boardId));

      if (response.isSuccess) {
        print('게시글 삭제 성공 (Usecase): 게시글 ID $boardId');
        return true;
      } else {
        print('게시글 삭제 실패 (Usecase): ${response.message}, 코드: ${response.code}');
        return false;
      }
    } catch (e) {
      // 리포지토리에서 발생한 예외를 그대로 다시 던지거나,
      // 이 유스케이스에 특화된 예외로 변환하여 던질 수 있습니다.
      print('게시글 삭제 유스케이스 실행 중 오류 발생: $e');
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
  }
}