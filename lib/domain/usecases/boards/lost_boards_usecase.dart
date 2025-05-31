import 'package:ajoufinder/data/dto/board/boards/boards_request.dart';
import 'package:ajoufinder/domain/entities/board_item.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class LostBoardsUsecase {
  final BoardRepository _boardRepository;

  LostBoardsUsecase(this._boardRepository);

  Future<List<BoardItem>> execute({int? page, int? size}) async {
    final request = BoardsRequest(page: page ?? 0, size: size ?? 10);

    try {
      final response = await _boardRepository.getLostBoards(request);
      
      if (response.content.isNotEmpty) {
        print('분실 게시글 목록 조회 성공 (Usecase): ${response.numberOfElements}개 항목 수신 (페이지: ${response.number})');
      } else if (response.content.isEmpty && response.empty) {
        print('분실 게시글 목록 조회 성공 (Usecase): 현재 페이지에 항목이 없습니다 (페이지: ${response.number})');
      } else {
        print('분실 게시글 목록 조회 성공 (Usecase): 예상치 못한 응답 형식입니다.');
      }
      return response.content.map((item) => item.toEntity()).toList();
    } catch (e) {
      // 네트워크 오류 또는 리포지토리에서 발생한 기타 예외 처리
      print('분실 게시글 목록 조회 유스케이스 실행 중 오류 발생: $e');
      // 필요에 따라 특정 타입의 예외로 변환하여 다시 던집니다.
      // 예: throw BoardsFetchException('습득 게시글을 가져오는 중 오류가 발생했습니다: ${e.toString()}');
      rethrow; // 원본 예외를 다시 던져서 상위 계층에서 처리하도록 함
    }
  }
}