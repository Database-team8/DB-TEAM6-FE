import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:ajoufinder/injection_container.dart';

class CommentListWidget extends StatefulWidget {
  final int? boardId;
  final int? currentUserId;

  const CommentListWidget.forBoard({
    super.key,
    required this.boardId,
    required this.currentUserId,
  });
  const CommentListWidget.forCurrentUser({super.key})
    : boardId = null,
      currentUserId = null;

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<CommentViewModel>(context, listen: false);

    if (widget.boardId != null) {
      viewModel.fetchComments(widget.boardId!);
    }
  }

  @override
  void didUpdateWidget(covariant CommentListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    final viewModel = Provider.of<CommentViewModel>(context, listen: false);

    if (widget.boardId == null) {
      viewModel.fetchUserComments();
    } else {
      viewModel.fetchComments(widget.boardId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = Provider.of<CommentViewModel>(context);
    final theme = Theme.of(context);

    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (widget.boardId == null) {
      final userComments = viewModel.userComments;
      if (userComments.isEmpty)
        return const Center(child: Text('내가 작성한 댓글이 없습니다.'));

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: userComments.length,
        itemBuilder: (context, index) {
          final comment = userComments[index];
          return _CommentCard(
            content: comment.content,
            createdAt: comment.createdAt,
            // userId: comment.userId,
            nickname: null,
            profileImage: null,
            currentUserId: widget.currentUserId,
            boardId: widget.boardId,
            commentId: comment.commentId,
          );
        },
        separatorBuilder: (_, __) => Divider(height: 1),
      );
    } else {
      final comments = viewModel.comments;
      if (comments.isEmpty) return const Center(child: Text('댓글이 없습니다.'));

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: comments.length,
        itemBuilder: (context, index) {
          final comment = comments[index];
          return _CommentCard(
            content: comment.content,
            createdAt: comment.createdAt,
            userId: comment.userId,
            nickname: comment.user.nickname,
            profileImage: comment.user.profileImage,
            currentUserId: widget.currentUserId,
            commentId: comment.commentId,
            boardId: widget.boardId!, // boardId는 null이 아닌 경우만 여기 도달함
          );
        },
        separatorBuilder: (_, __) => Divider(height: 1),
      );
    }
  }
}

class _CommentCard extends StatefulWidget {
  final String content;
  final DateTime createdAt;
  final int? userId;
  final String? nickname;
  final String? profileImage;
  final int? currentUserId;
  final int? boardId;
  final int commentId;

  const _CommentCard({
    required this.content,
    required this.createdAt,
    this.userId,
    required this.boardId,
    required this.commentId,
    this.nickname,
    this.profileImage,
    required this.currentUserId,
  });

  @override
  State<_CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> {
  Future<User>? _userFuture;
  bool _isEditing = false;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();

    _userFuture =
        null; //여기서 _userFuture = getIt<UserRepository>().getUserById(widget.userId!); 이런식으로 userId를 가져와서 userId에 따른 프로필사진이나 이름을 가져오는 것 같은데 추가구현필요

    _editController = TextEditingController(text: widget.content); // 초기값 설정
  }

  @override
  void dispose() {
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
          _buildHeader(theme),
          const SizedBox(height: 6),
          Text(widget.content, style: theme.textTheme.bodyMedium),

          if (widget.currentUserId != null &&
              widget.userId == widget.currentUserId)
            Align(
              alignment: Alignment.bottomRight,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit, size: 16),
                    onPressed: () {
                      final viewModel = context.read<CommentViewModel>();
                      // 수정
                      print('수정 클릭: ${widget.userId}');
                    },
                    visualDensity: const VisualDensity(
                      horizontal: -4,
                      vertical: -4,
                    ),
                    padding: EdgeInsets.zero,
                    constraints: const BoxConstraints(),
                  ),
                  const SizedBox(width: 8), // ← 간격만 추가
                  IconButton(
                    icon: const Icon(Icons.delete, size: 16),
                    onPressed: () {
                      final viewModel = context.read<CommentViewModel>();
                      if (widget.boardId != null) {
                        viewModel.deleteComment(
                          widget.boardId!,
                          widget.commentId,
                        );
                      }
                      print('삭제 클릭: ${widget.userId}');
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

  Widget _buildHeader(ThemeData theme) {
    return Row(
      children: [
        _buildUserInfo(theme),
        const Spacer(),
        Text(
          DateFormat('MM.dd HH:mm').format(widget.createdAt),
          style: theme.textTheme.bodySmall?.copyWith(
            color: theme.hintColor,
            fontSize: 11,
          ),
        ),
      ],
    );
  }

  Widget _buildUserInfo(ThemeData theme) {
    const gap = SizedBox(width: 8);

    if (widget.nickname != null) {
      return Row(
        children: [
          CircleAvatar(
            radius: 10,
            backgroundColor: theme.colorScheme.surfaceVariant,
            child:
                widget.profileImage != null
                    ? Image.network(widget.profileImage!, fit: BoxFit.contain)
                    : null,
          ),
          gap,
          Text(widget.nickname!, style: theme.textTheme.bodySmall),
        ],
      );
    }

    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        final name = snapshot.hasData ? snapshot.data!.nickname : '로딩 중';
        return Row(
          children: [
            CircleAvatar(
              radius: 10,
              backgroundColor: theme.colorScheme.surfaceVariant,
            ),
            gap,
            Text(name, style: theme.textTheme.bodySmall),
          ],
        );
      },
    );
  }
}
