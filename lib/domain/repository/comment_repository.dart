import 'package:ajoufinder/data/dto/comment/fetch_comments/comments_request.dart';
import 'package:ajoufinder/data/dto/comment/fetch_comments/comments_response.dart';
import 'package:ajoufinder/data/dto/comment/post_comment/post_comment_request.dart';
import 'package:ajoufinder/data/dto/comment/post_comment/post_comment_response.dart';
import 'package:ajoufinder/data/dto/comment/update_comment/update_comment_request.dart';
import 'package:ajoufinder/data/dto/comment/update_comment/update_comment_response.dart';
import 'package:ajoufinder/data/dto/comment/user_comments/user_comments_request.dart';
import 'package:ajoufinder/data/dto/comment/user_comments/user_comments_response.dart';

abstract class CommentRepository {
  Future<PageCommentResponse> fetchComments(
    int boardId,
    CommentsRequest request,
  );
  Future<PostCommentResponse> postComment(
    int boardId,
    PostCommentRequest request,
  );
  Future<UpdateCommentResponse> updateComment(
    int boardId,
    int commentId,
    UpdateCommentRequest request,
  );
  Future<void> deleteComment(int boardId, int commentId);
  Future<PageUserCommentsResponse> fetchUserComments(
    UserCommentsRequest request,
  );
}
