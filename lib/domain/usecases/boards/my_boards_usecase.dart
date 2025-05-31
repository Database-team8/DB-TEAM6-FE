import 'package:ajoufinder/domain/entities/board_item.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class MyBoardsUsecase {
  final BoardRepository _boardRepository;

  MyBoardsUsecase(this._boardRepository);

  Future<List<BoardItem>> execute() async {
    throw UnimplementedError('MyCommentsUsecase는 아직 구현되지 않았습니다.');
  }
}