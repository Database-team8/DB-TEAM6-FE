import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';
import 'package:ajoufinder/domain/usecases/my_comments_usecase.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:flutter/material.dart';

class CommentViewModel extends ChangeNotifier{
  final MyCommentsUsecase _myCommentsUsecase;

  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _error;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  CommentViewModel(this._myCommentsUsecase){}

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _clearComments() {
    _comments = [];
    _error = null;
  }

  Future<void> fetchMyComments() async {
    _clearComments();
    _setLoading(true);

    try {
      _comments = await _myCommentsUsecase.execute();
      _error = null;
      print('CommentViewModel: 내 댓글 목록 로드 성공 - ${_comments.length}개');
    } catch (e) {
      _comments = []; // 실패 시 빈 리스트
      _error = '내 댓글을 불러오는 중 오류가 발생했습니다.';
      print('CommentViewModel: 내 댓글 목록 로드 중 오류: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCommentsByBoardId({required int boardId}) async {
    _clearComments();
    final repository = getIt<CommentRepository>();
    _setLoading(true);

    try {
      _comments = await repository.getAllCommentsByBoardId(boardId);
      _error = null;
    } catch (e) {
      _error = '댓글을 불러오는 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> postComments({required String comment}) {
    throw UnimplementedError();
  }
}