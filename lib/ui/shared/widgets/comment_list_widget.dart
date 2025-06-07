import 'package:ajoufinder/data/dto/comment/comment_dto.dart';
import 'package:ajoufinder/data/dto/comment/update_comment/update_comment_request.dart';
import 'package:ajoufinder/data/dto/comment/user_comments/user_comments_response.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:ajoufinder/ui/shared/widgets/custom_comment_fab.dart';

class CommentListWidget extends StatefulWidget {
  final int? boardId;

  const CommentListWidget.forBoard({super.key, required this.boardId});
  const CommentListWidget.forCurrentUser({super.key}) : boardId = null;

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  
  void _loadComments() {
    final commentViewModel = context.read<CommentViewModel>();

    if (widget.boardId != null) {
      commentViewModel.fetchComments(widget.boardId!);
    } else {
      commentViewModel.fetchUserComments();
    }
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadComments();
    });
  }

  @override
  void didUpdateWidget(covariant CommentListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    if (widget.boardId != oldWidget.boardId) {
      _loadComments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentViewModel = context.watch<CommentViewModel>();
    final authViewModel = context.watch<AuthViewModel>();

    if (authViewModel.isLoading || commentViewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.boardId == null) {
      final userComments = commentViewModel.userComments;
      if (userComments.isEmpty) {
        return const Center(child: Text('내가 작성한 댓글이 없습니다.'));
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: userComments.length,
        itemBuilder: (context, index) {
          final comment = userComments[index];
          return _CommentCard.userComment(
            userComment: comment,
            currentUser: authViewModel.currentUser!,
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
      );
    } else {
      final comments = commentViewModel.comments;
      if (comments.isEmpty) return const Center(child: Text('댓글이 없습니다.'));

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return _CommentCard.boardComment(
            comment: comment,
            currentUser: authViewModel.currentUser!,
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
      );
    }
  }
}

class _CommentCard extends StatefulWidget {
  final Comment? comment;
  final UserComment? userComment;
  final User currentUser;

  const _CommentCard.userComment({
    required this.userComment,
    required this.currentUser,
  }) : comment = null;

  const _CommentCard.boardComment({
    required this.comment,
    required this.currentUser,
  }) : userComment = null;

  @override
  State<_CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> {
  late TextEditingController _editController;
  late FocusNode _editFocusNode;
  bool get _isBoardComment => widget.comment != null;

  String get content =>
      _isBoardComment ? widget.comment!.content : widget.userComment!.content;
  DateTime get createdAt =>
      _isBoardComment
          ? widget.comment!.createdAt
          : widget.userComment!.createdAt;
  int get commentId =>
      _isBoardComment
          ? widget.comment!.commentId
          : widget.userComment!.commentId;
  int get boardId =>
      _isBoardComment ? context.read<BoardViewModel>().selectedBoard!.id : widget.userComment!.boardId;
  bool get isSecret =>
      _isBoardComment ? widget.comment!.isSecret : widget.userComment!.isSecret;
  bool get isMyComment =>
      _isBoardComment
          ? (widget.comment!.userId == widget.currentUser.userId)
          : true;
  String get authorNickname =>
      _isBoardComment
          ? (widget.comment!.user.nickname)
          : widget.currentUser.nickname;
  String? get authorProfileImage =>
      _isBoardComment
          ? (widget.comment!.user.profileImage)
          : widget.currentUser.profileImage;

  @override
  void initState() {
    super.initState();
    _editController = TextEditingController(text: content);
    _editFocusNode = FocusNode();
  }

  @override
  void dispose() {
    _editController.dispose();
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.all(12.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          const SizedBox(height: 6),
          Text(content, style: theme.textTheme.bodyMedium),
          if (isMyComment)
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: () => _showEditBottomSheet(),
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    icon: const Icon(Icons.delete, size: 16),
                    onPressed:
                        () async {
                          await context.read<CommentViewModel>().deleteComment(
                            boardId,
                            commentId,
                          );
                        },
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final theme = Theme.of(context);
    return Row(
      children: [
        _buildUserInfo(),
        const Spacer(),
        Text(
          DateFormat('MM.dd HH:mm').format(createdAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo() {
    final theme = Theme.of(context);
    const gap = SizedBox(width: 8);

    return Row(
      children: [
        CircleAvatar(
          radius: 10,
          backgroundColor: theme.colorScheme.onSurfaceVariant,
          child:
              authorProfileImage != null
                  ? ClipOval(
                    child: Image.network(
                      authorProfileImage!,
                      fit: BoxFit.cover,
                      width: 20,
                      height: 20,
                    ),
                  )
                  : null,
        ),
        gap,
        Text(authorNickname, style: theme.textTheme.bodySmall),
      ],
    );
  }

  void _showEditBottomSheet() {
    final theme = Theme.of(context);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder:
          (bottomSheetContext) => Padding(
            padding: EdgeInsets.only(
              bottom: MediaQuery.of(context).viewInsets.bottom + 16,
              left: 16,
              right: 16,
            ),
            child: CustomCommentFab(
              boardId: boardId,
              isSecret: isSecret,
              commentController: _editController,
              editingCommentId: commentId,
              collapsedHeight: 56.0,
              backgroundColor: ElevationOverlay.colorWithOverlay(
                theme.colorScheme.surface,
                theme.colorScheme.primary,
                3.0,
              ),
              leadingWidget: Row(
                // ✅ 체크박스 포함 라벨 일치
                mainAxisSize: MainAxisSize.min,
                children: [
                  Transform.scale(
                    scale: 0.8,
                    child: Checkbox(
                      value: isSecret,
                      onChanged: null, // ✅ 수정 중 비활성화
                      activeColor: theme.colorScheme.surfaceTint,
                      checkColor: theme.colorScheme.onSurfaceVariant,
                      visualDensity: VisualDensity.compact,
                      materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
                      side: BorderSide(
                        color: (theme.colorScheme.onSurface).withOpacity(0.7),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(),
                    child: Text(
                      isSecret ? '비밀댓글' : '일반댓글',
                      style: theme.textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
                  ),
                ],
              ),
              mainContentWhenCollapsed: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: Text(
                  '댓글을 수정합니다...',
                  style: theme.textTheme.bodyMedium!.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ),
              commentFocusNode: _editFocusNode,
              onCommentSubmittedAsync: (updatedText) async {
                await _handleCommentUpdate(updatedText);
                if (!bottomSheetContext.mounted) return;
                Navigator.pop(bottomSheetContext); 
              },
              onMorePressed: () {},
            ),
          ),
    );
  }

  Future<void> _handleCommentUpdate(String updatedText) async {
  // ViewModel과 request 객체는 async gap 이전에 준비합니다.
  final commentViewModel = context.read<CommentViewModel>();
  final request = UpdateCommentRequest(
    content: updatedText,
    isSecret: isSecret,
  );

  try {
    await commentViewModel.updateComment(boardId, commentId, request);
    await commentViewModel.fetchComments(boardId);

  } catch (e) {
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('댓글 수정에 실패했습니다: $e')),
    );
  }
}

}
