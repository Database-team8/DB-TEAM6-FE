import 'dart:convert';
import 'package:ajoufinder/data/dto/comment/fetch_comments/comments_request.dart';
import 'package:ajoufinder/data/dto/comment/fetch_comments/comments_response.dart';
import 'package:ajoufinder/data/dto/comment/post_comment/post_comment_request.dart';
import 'package:ajoufinder/data/dto/comment/post_comment/post_comment_response.dart';
import 'package:ajoufinder/data/dto/comment/update_comment/update_comment_request.dart';
import 'package:ajoufinder/data/dto/comment/update_comment/update_comment_response.dart';
import 'package:ajoufinder/data/dto/comment/user_comments/user_comments_request.dart';
import 'package:ajoufinder/data/dto/comment/user_comments/user_comments_response.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';
import 'package:http/http.dart' as http;

class CommentRepositoryImpl implements CommentRepository {
  final http.Client client;

  CommentRepositoryImpl(this.client);

  final String baseUrl = 'https://ajoufinder.kr';

  @override
  Future<PageCommentResponse> fetchComments(
    int boardId,
    CommentsRequest request,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/comments/$boardId?page=${request.page}&size=${request.size}',
    );
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      return PageCommentResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('댓글 조회 실패: ${response.statusCode}');
    }
  }

  @override
  Future<PageUserCommentsResponse> fetchUserComments(
    UserCommentsRequest request,
  ) async {
    final uri = Uri.parse(
      '$baseUrl/comments/user?page=${request.page}&size=${request.size}',
    );
    final response = await client.get(uri);

    if (response.statusCode == 200) {
      print(
        '[CommentRepositoryImpl] fetchUserComments 성공 (page: ${request.page}, size: ${request.size})',
      );
      return PageUserCommentsResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('내 댓글 조회 실패: ${response.statusCode}');
    }
  }

  @override
  Future<PostCommentResponse> postComment(
    int boardId,
    PostCommentRequest request,
  ) async {
    final uri = Uri.parse('$baseUrl/comments/$boardId');
    final response = await client.post(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      return PostCommentResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('댓글 작성 실패: ${response.statusCode}');
    }
  }

  @override
  Future<UpdateCommentResponse> updateComment(
    int boardId,
    int commentId,
    UpdateCommentRequest request,
  ) async {
    final uri = Uri.parse('$baseUrl/comments/$boardId/$commentId');
    final response = await client.patch(
      uri,
      headers: {'Content-Type': 'application/json'},
      body: jsonEncode(request.toJson()),
    );

    if (response.statusCode == 200) {
      print(
        '[CommentRepositoryImpl] updateComment 성공 (boardId: $boardId, commentId: $commentId)',
      );
      return UpdateCommentResponse.fromJson(jsonDecode(response.body));
    } else {
      throw Exception('댓글 수정 실패: ${response.statusCode}');
    }
  }

  @override
  Future<void> deleteComment(int boardId, int commentId) async {
    final uri = Uri.parse('$baseUrl/comments/$boardId/$commentId');
    final response = await client.delete(uri);

    if (response.statusCode != 204) {
      throw Exception('댓글 삭제 실패: ${response.statusCode}');
    } else {
      print(
        '[CommentRepositoryImpl] deleteComment 성공 (boardId: $boardId, commentId: $commentId)',
      );
    }
  }
}
