import 'package:ajoufinder/data/dto/board/patch_board/patch_board_request.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class PatchBoardUsecase {
  final BoardRepository _boardRepository;

  PatchBoardUsecase(this._boardRepository);

  Future<bool> execute({
    required int boardId,
    String? title,
    int? locationId,
    int? itemTypeId,
    String? description,
    String? detailedLocation,
    String? image,
    String? relatedDate,
  })  async {
    final request = PatchBoardRequest(
      boardId: boardId,
      title: title,
      locationId: locationId,
      itemTypeId: itemTypeId,
      description: description,
      detailedLocation: detailedLocation,
      image: image,
      relatedDate: relatedDate,
    );

    try {
      final response = await _boardRepository.patchBoard(request);

      if (response.isSuccess) {
        print('게시글 수정 성공 (Usecase): 게시글 ID $boardId의 수정');
      } else {
        print('게시글 수정 실패 (Usecase): ${response.message}, 코드: ${response.code}');
      }
      return response.isSuccess;
    } catch (e) {
      print('게시글 수정 유스케이스 실행 중 오류 발생: $e');
      rethrow;
    }
  }
}