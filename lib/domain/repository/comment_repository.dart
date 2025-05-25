import 'package:ajoufinder/domain/entities/comment.dart';

abstract class CommentRepository {
  Future<List<Comment>> getAllCommentsByUserId(int userId);
  Future<List<Comment>> getAllCommentsByBoardId(int boardId);
  Future<void> addNewComment(Comment comment);
}