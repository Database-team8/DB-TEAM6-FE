import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:flutter/material.dart';

class CommentViewModel extends ChangeNotifier{
  List<Comment> _comments = [];
  bool _isLoading = false;
  String? _error;

  List<Comment> get comments => _comments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clear() {
    _comments = [];
    _error = null;
  }

  Future<void> fetchCommentsByUserId({required int uuid}) async {
    _clear();
    final repository = getIt<CommentRepository>();
    _setLoading(true);

    try {
      _comments = await repository.getAllCommentsByUserId(uuid);
      _error = null;
    } catch (e) {
      _error = '댓글을 불러오는 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> fetchCommentsByBoardId({required int boardId}) async {
    _clear();
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