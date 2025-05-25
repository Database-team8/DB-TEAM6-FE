import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';

class CommentRepositoryImpl extends CommentRepository{

  @override
  Future<List<Comment>> getAllCommentsByUserId(int userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Comment(
        id: 1, 
        userId: userId, 
        boardId: 1, 
        title: 'test', 
        content: '집보내도', 
        status: 'status', 
        isSecret: true, 
        updatedAt: DateTime(2022, 1, 1), 
        createdAt: DateTime(2021, 1, 1)
      )
    ];
  }

  @override
  Future<void> addNewComment(Comment comment) async {
    throw UnimplementedError();
  }

  @override
  Future<List<Comment>> getAllCommentsByBoardId(int boardId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Comment(
        id: 1, 
        userId: 1, 
        boardId: boardId, 
        title: 'test', 
        content: '집보내도', 
        status: 'DELETED', 
        isSecret: false, 
        updatedAt: DateTime(2022, 1, 1), 
        createdAt: DateTime(2021, 1, 1)
      ),
      Comment(
        id: 2, 
        userId: 1, 
        boardId: boardId, 
        title: 'test2', 
        content: 'VISIBLE', 
        status: 'status', 
        isSecret: true, 
        updatedAt: DateTime(2022, 1, 1), 
        createdAt: DateTime(2021, 1, 1)
      ),
      Comment(
        id: 3, 
        userId: 2, 
        boardId: boardId, 
        title: 'test3', 
        content: '집보내도', 
        status: 'DELETED', 
        isSecret: true, 
        updatedAt: DateTime(2022, 1, 1), 
        createdAt: DateTime(2021, 1, 1)
      ),
      Comment(
        id: 4, 
        userId: 1, 
        boardId: boardId, 
        title: 'test4', 
        content: '집보내도', 
        status: 'status', 
        isSecret: true, 
        updatedAt: DateTime(2022, 1, 1), 
        createdAt: DateTime(2021, 1, 1)
      ),
      Comment(
        id: 5, 
        userId: 6, 
        boardId: boardId, 
        title: 'test8', 
        content: '보이면 안됨', 
        status: 'status', 
        isSecret: true, 
        updatedAt: DateTime(2022, 1, 1), 
        createdAt: DateTime(2021, 1, 1)
      )
    ];
  }
}