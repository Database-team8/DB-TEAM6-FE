import 'package:ajoufinder/data/dto/board/patch_board/patch_board_status_request.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class PatchBoardActiveUsecase {
  final BoardRepository _boardRepository;

  PatchBoardActiveUsecase(this._boardRepository);

  Future<bool> execute(int boardId) async {
    try {
      final response = await _boardRepository.patchBoardAcitve(PatchBoardStatusRequest(boardId: boardId));

      if (response.isSuccess) {
        print('게시글 Activation 성공 (Usecase): 게시글 ID $boardId의 Activation');
      } else {
        print('게시글 Activation 실패 (Usecase): ${response.message}, 코드: ${response.code}');
      }
      return response.isSuccess;
    } catch (e) {
      print('게시글 Activation 유스케이스 실행 중 오류 발생: $e');
      rethrow;
    }
  }
}