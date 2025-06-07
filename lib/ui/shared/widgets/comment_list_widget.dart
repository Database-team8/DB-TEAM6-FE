import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/auth_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/shared/widgets/custom_comment_fab.dart';

class CommentListWidget extends StatefulWidget {
  final int? boardId;

  const CommentListWidget.forBoard({super.key, required this.boardId});
  const CommentListWidget.forCurrentUser({super.key}) : boardId = null;

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  Future<User>? _currentUserFuture;
  int? _currentUserId;

  @override
  void initState() {
    super.initState();
    final viewModel = Provider.of<CommentViewModel>(context, listen: false);

    if (widget.boardId != null) {
      viewModel.fetchComments(widget.boardId!);
      // ✅ 로그인 사용자 정보 조회
      _currentUserFuture = getIt<AuthRepository>()
          .getCurrentUserProfile()
          .then((res) {
            final userId = res.result?.userId;
            print('[DEBUG] getCurrentUserProfile 응답 결과: ${res.result}');
            print('[DEBUG] 추출된 userId: $userId');

            setState(() {
              _currentUserId = userId;
              print('[DEBUG] setState 이후 _currentUserId 값: $_currentUserId');
            });

            return res.result!;
          })
          .catchError((e) {
            print('[ERROR] 사용자 정보 조회 실패: $e');
          });
    } else {
      _currentUserFuture = getIt<AuthRepository>().getCurrentUserProfile().then(
        (res) => res.result!,
      );
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

    // ✅ (1) currentUserId가 null이면 기다리기
    if (widget.boardId != null && _currentUserId == null) {
      return const Center(child: CircularProgressIndicator());
    }

    // ✅ (2) 댓글 로딩 중이면 표시
    if (viewModel.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }
    if (widget.boardId == null) {
      final userComments = viewModel.userComments;
      if (userComments.isEmpty) {
        return const Center(child: Text('내가 작성한 댓글이 없습니다.'));
      }

      return ListView.separated(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: userComments.length,
        itemBuilder: (context, index) {
          final comment = userComments[index];
          return _CommentCard(
            content: comment.content,
            createdAt: comment.createdAt,
            userId: null,
            nickname: null,
            profileImage: null,
            currentUserId: null,
            boardId: widget.boardId,
            commentId: comment.commentId,
            currentUserFuture: _currentUserFuture,
            isSecret: comment.isSecret,
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
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
            currentUserId: _currentUserId,
            commentId: comment.commentId,
            boardId: widget.boardId!,
            isSecret: comment.isSecret,
          );
        },
        separatorBuilder: (_, __) => const Divider(height: 1),
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
  final Future<User>? currentUserFuture;
  final bool isSecret;

  const _CommentCard({
    required this.content,
    required this.createdAt,
    this.userId,
    required this.boardId,
    required this.commentId,
    this.nickname,
    this.profileImage,
    required this.currentUserId,
    this.currentUserFuture,
    required this.isSecret,
  });

  @override
  State<_CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> {
  Future<User>? _userFuture;
  late TextEditingController _editController;

  @override
  void initState() {
    super.initState();

    if (widget.nickname == null && widget.currentUserFuture != null) {
      _userFuture = widget.currentUserFuture;
    }

    _editController = TextEditingController(text: widget.content);
  }

  @override
  void dispose() {
    _editController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    print(
      '[CommentCard] comment.userId: ${widget.userId}, currentUserId: ${widget.currentUserId}',
    );

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
                      final theme = Theme.of(context);
                      final controller = TextEditingController(
                        text: widget.content,
                      );

                      showModalBottomSheet(
                        context: context,
                        isScrollControlled: true,
                        backgroundColor: Colors.transparent, // ✅ 작성용과 통일
                        builder:
                            (_) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom +
                                    16,
                                left: 16,
                                right: 16,
                              ),
                              child: CustomCommentFab(
                                boardId: widget.boardId!,
                                isSecret: widget.isSecret,
                                commentController: controller,
                                editingCommentId:
                                    widget.commentId, // ✅ 수정 모드임을 명시
                                collapsedHeight: 56.0, // ✅ 작성용과 동일
                                backgroundColor:
                                    ElevationOverlay.colorWithOverlay(
                                      // ✅ 동일 배경
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
                                        value: widget.isSecret,
                                        onChanged: null, // ✅ 수정 중 비활성화
                                        activeColor:
                                            theme.colorScheme.surfaceTint,
                                        checkColor:
                                            theme.colorScheme.onSurfaceVariant,
                                        visualDensity: VisualDensity.compact,
                                        materialTapTargetSize:
                                            MaterialTapTargetSize.shrinkWrap,
                                        side: BorderSide(
                                          color: (theme.colorScheme.onSurface)
                                              .withOpacity(0.7),
                                        ),
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(),
                                      child: Text(
                                        widget.isSecret ? '비밀댓글' : '일반댓글',
                                        style: theme.textTheme.labelSmall!
                                            .copyWith(
                                              fontWeight: FontWeight.w500,
                                              color:
                                                  theme
                                                      .colorScheme
                                                      .onSurfaceVariant,
                                            ),
                                      ),
                                    ),
                                  ],
                                ),
                                mainContentWhenCollapsed: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                  ),
                                  child: Text(
                                    '댓글을 수정합니다...', // ✅ 작성과는 문구만 다르게
                                    style: theme.textTheme.bodyMedium!.copyWith(
                                      color: theme.colorScheme.onSurfaceVariant,
                                    ),
                                  ),
                                ),
                                onMorePressed: () {}, // 선택적
                              ),
                            ),
                      );
                    },
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

    if (_userFuture == null) {
      return const SizedBox();
    }

    return FutureBuilder<User>(
      future: _userFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            children: [
              const CircleAvatar(radius: 10),
              gap,
              const Text('로딩 중...'),
            ],
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data!;
          return Row(
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: theme.colorScheme.surfaceVariant,
                child:
                    user.profileImage != null
                        ? ClipOval(
                          child: Image.network(
                            user.profileImage!,
                            fit: BoxFit.cover,
                            width: 20,
                            height: 20,
                          ),
                        )
                        : null,
              ),
              gap,
              Text(user.nickname, style: theme.textTheme.bodySmall),
            ],
          );
        } else {
          return const Text('유저 정보 없음');
        }
      },
    );
  }
}
