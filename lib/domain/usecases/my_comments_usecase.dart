import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';

class MyCommentsUsecase {
  final CommentRepository _commentRepository;

  MyCommentsUsecase(this._commentRepository);

  Future<List<Comment>> execute() async {
    throw UnimplementedError('MyCommentsUsecase는 아직 구현되지 않았습니다.');
  }
}