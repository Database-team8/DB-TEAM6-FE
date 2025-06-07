import 'package:flutter/material.dart';
import 'package:ajoufinder/data/dto/comment/comment_dto.dart';
import 'package:ajoufinder/data/dto/comment/fetch_comments/comments_request.dart';
import 'package:ajoufinder/data/dto/comment/post_comment/post_comment_request.dart';
import 'package:ajoufinder/data/dto/comment/update_comment/update_comment_request.dart';
import 'package:ajoufinder/data/dto/comment/user_comments/user_comments_request.dart';
import 'package:ajoufinder/data/dto/comment/user_comments/user_comments_response.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';
import 'package:ajoufinder/injection_container.dart';

class CommentViewModel extends ChangeNotifier {
  final CommentRepository _repository = getIt<CommentRepository>();

  List<Comment> _comments = [];
  List<UserComment> _userComments = [];

  bool _isLoading = false;
  String? _error;

  // Getters
  List<Comment> get comments => _comments;
  List<UserComment> get userComments => _userComments;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }
  void _clearComments() {
    _comments = [];
    _userComments = [];
    _error = null;
  }

  Future<void> fetchComments(int boardId, {int page = 0, int size = 10}) async {
    _clearComments();
    print('[ViewModel] fetchComments() 호출됨 → boardId: $boardId');
    _setLoading(true);

    try {
      final response = await _repository.fetchComments(
        boardId,
        CommentsRequest(page: page, size: size),
      );
      _comments = response.content;

      // ✅ 디버깅용 로그 추가
      print('[ViewModel] 댓글 ${_comments.length}개 로드됨');
      for (final comment in _comments) {
        print('[ViewModel] 댓글 내용: ${comment.content}');
      }
      _error = null;
    } catch (e) {
      print('[ViewModel] 댓글 불러오기 예외 발생: $e');
      _error = '댓글을 불러오는 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }

  /// 사용자 댓글 조회
  Future<void> fetchUserComments({int page = 0, int size = 10}) async {
    _setLoading(true);
    try {
      final response = await _repository.fetchUserComments(
        UserCommentsRequest(page: page, size: size),
      );
      _userComments = response.content;

      // ✅ 디버깅용 로그 추가
      print('[ViewModel] 사용자 댓글 ${response.content.length}개 로드됨');
      for (final comment in response.content) {
        print(
          '[ViewModel] 댓글 ID: ${comment.commentId}, 내용: ${comment.content}',
        );
      }
      _error = null;
    } catch (e) {
      print('[ViewModel] 댓글 불러오기 예외 발생: $e');
      _error = '내 댓글을 불러오는 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }

  /// 댓글 작성
  Future<void> postComment(int boardId, PostCommentRequest request) async {
    _setLoading(true);
    _error = null;
    try {
      await _repository.postComment(boardId, request);
      await fetchComments(boardId); // 작성 후 갱신
    } catch (e) {
      _error = '댓글 작성 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }

  /// 댓글 수정
  Future<void> updateComment(
    int boardId,
    int commentId,
    UpdateCommentRequest request,
  ) async {
    _setLoading(true);
    try {
      await _repository.updateComment(boardId, commentId, request);
      await fetchComments(boardId); // 수정 후 갱신
    } catch (e) {
      _error = '댓글 수정 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }

  /// 댓글 삭제
  Future<void> deleteComment(int boardId, int commentId) async {
    _setLoading(true);
    _error = null;

    try {
      await _repository.deleteComment(boardId, commentId);
      await fetchComments(boardId); 
    } catch (e) {
      _error = '댓글 삭제 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }
}
