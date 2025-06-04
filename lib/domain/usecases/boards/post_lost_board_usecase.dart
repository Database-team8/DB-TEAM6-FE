import 'package:ajoufinder/data/dto/board/post_board/post_board_request.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class PostLostBoardUsecase {
  final BoardRepository _boardRepository;

  PostLostBoardUsecase(this._boardRepository);

  Future<int?> execute({
    required String title,
    String? detailedLocation,
    required String description,
    DateTime? relatedDate,
    String? image,
    required String category,
    required int itemTypeId,
    required int locationId,
  }) async {
    final request = PostBoardRequest(
      title: title, 
      detailedLocation: detailedLocation, 
      description: description, 
      relatedDate: relatedDate, 
      image: image, 
      category: category, 
      itemTypeId: itemTypeId, 
      locationId: locationId
    );

    try {
      final response = await _boardRepository.postLostBoard(request);

      if (response.isSuccess) {
        // 게시글 작성 성공
        print('게시글 작성 성공 (Usecase): 게시글 ID - ${response.result}');
        return response.result; // 게시글 ID 반환
      } else {
        // 서버에서 isSuccess: false로 응답한 경우
        print('게시글 작성 실패 (Usecase): ${response.message}, 코드: ${response.code}');
        return null; // 실패 시 null 반환
      }
    } on ArgumentError catch (e) {
      // 유효성 검사 실패 등 ArgumentError 처리
      print('게시글 작성 유스케이스 입력 오류: ${e.message}');
      // 이 경우, 호출한 곳에서 예외를 처리하도록 그대로 전파하거나, 특정 오류 응답 DTO를 반환할 수 있습니다.
      // 예: return PostBoardResponseDto(code: "VALIDATION_ERROR", message: e.message, result: null, isSuccess: false);
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
    catch (e) {
      // 네트워크 오류, 파싱 오류 등 리포지토리에서 발생한 예외 처리
      print('게시글 작성 유스케이스 실행 중 오류 발생: $e');
      // 이 유스케이스에 특화된 예외로 변환하거나, 기본 오류 응답 DTO를 반환할 수 있습니다.
      // 예: return PostBoardResponseDto(code: "CLIENT_ERROR", message: "게시글 작성 중 오류가 발생했습니다: ${e.toString()}", result: null, isSuccess: false);
      rethrow; // 호출한 곳에서 예외를 처리하도록 그대로 전파
    }
  }
}