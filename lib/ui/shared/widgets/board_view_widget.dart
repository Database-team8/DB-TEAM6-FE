import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/ui/shared/widgets/comment_list_widget.dart';
import 'package:ajoufinder/ui/shared/widgets/custom_comment_fab.dart';
import 'package:ajoufinder/ui/shared/widgets/post_board_widget.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/navigator_bar_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:ajoufinder/data/dto/comment/post_comment/post_comment_request.dart';

class BoardViewWidget extends StatefulWidget {
  const BoardViewWidget({super.key});

  @override
  State<BoardViewWidget> createState() => _BoardViewWidgetState();
}

class _BoardViewWidgetState extends State<BoardViewWidget> {
  late TextEditingController _commentController;
  bool _isSecretComment = false;
  int? _currentlyDisplayedBoardId;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final boardViewModel = Provider.of<BoardViewModel>(context);
    final Board? selectedBoard = boardViewModel.selectedBoard;

    if (selectedBoard != null &&
        selectedBoard.id != _currentlyDisplayedBoardId) {
      _currentlyDisplayedBoardId = selectedBoard.id;
      _loadCommentsForBoard(selectedBoard);
    }
  }

  void _loadCommentsForBoard(Board board) {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (mounted) {
        final commentsViewModel = Provider.of<CommentViewModel>(
          context,
          listen: false,
        );
        commentsViewModel.fetchComments(board.id);
      }
    });
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  Future<void> _submitComment(BuildContext context, int boardId, String commentText) async {
    final authViewModel = context.read<AuthViewModel>();
    final commentViewModel = context.read<CommentViewModel>();

    if (commentText.isNotEmpty && authViewModel.currentUser != null) {
      await commentViewModel.postComment(boardId, PostCommentRequest(content: commentText, isSecret: _isSecretComment));
      _commentController.clear();
      setState(() {
        _isSecretComment = false;
      });
    }
  }

  void _showBoardManageOptions(Board board) {
    showModalBottomSheet(
      context: context,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (bottomSheetContext) {
        return SafeArea(
          child: Wrap(
            children: <Widget>[
              ListTile(
                leading: const Icon(Icons.edit_outlined),
                title: const Text('게시글 수정'),
                onTap: () {
                  Navigator.pop(bottomSheetContext);
                  final navigatorBarViewModel =
                      context.read<NavigatorBarViewModel>();
                  print('게시글 수정 선택: ${board.id}');

                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (_) => Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: PostBoardWidget(
                                lostCategory:
                                    navigatorBarViewModel.currentIndex == 0
                                        ? 'lost'
                                        : 'found',
                                editedBoard: board,
                              ),
                            ),
                          ),
                    ),
                  );
                },
              ),
              ListTile(
                leading: const Icon(Icons.change_circle_outlined),
                title: const Text('게시글 상태 변경'),
                onTap: () async {
                  Navigator.of(bottomSheetContext).pop();
                  final boardViewModel = context.read<BoardViewModel>();
                  try {
                    await boardViewModel.toggleBoardStatus();

                    if (mounted) {
                      ScaffoldMessenger.of(
                        context,
                      ).showSnackBar(SnackBar(content: Text('상태가 변경되었습니다.')));
                    } else {
                      return;
                    }
                  } catch (e) {
                    if (mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text('상태 변경에 실패했습니다: $e')),
                      );
                    } else {
                      return;
                    }
                  }
                },
              ),
              ListTile(
                leading: Icon(
                  Icons.delete_outline,
                  color: Theme.of(context).colorScheme.error,
                ),
                title: Text(
                  '게시글 삭제',
                  style: TextStyle(color: Theme.of(context).colorScheme.error),
                ),
                onTap: () async {
                  Navigator.pop(bottomSheetContext);
                  final bool? confirmDelete = await showDialog<bool>(
                    context: context,
                    builder:
                        (dialogContext) => AlertDialog(
                          title: const Text('게시글 삭제 확인'),
                          content: const Text(
                            '정말로 이 게시글을 삭제하시겠습니까? 이 작업은 되돌릴 수 없습니다.',
                          ),
                          actions: <Widget>[
                            TextButton(
                              child: const Text('취소'),
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(false),
                            ),
                            TextButton(
                              child: Text(
                                '삭제',
                                style: TextStyle(
                                  color: Theme.of(context).colorScheme.error,
                                ),
                              ),
                              onPressed:
                                  () => Navigator.of(dialogContext).pop(true),
                            ),
                          ],
                        ),
                  );
                  if (confirmDelete == true) {
                    final success = await context
                        .read<BoardViewModel>()
                        .deleteBoard(board.id);

                    if (mounted) {
                      if (success) {
                        print('게시글 삭제 성공. ${board.id}');
                      } else {
                        print('게시글 삭제 실패: ${board.id}');
                      }
                      Navigator.of(context).pop();
                    } else {
                      return;
                    }
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boardViewModel = context.watch<BoardViewModel>();


    if (boardViewModel.isLoadingBoardDetails &&
        boardViewModel.selectedBoard == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: const Center(child: CircularProgressIndicator()),
      );
    }

    if (boardViewModel.boardDetailsError != null &&
        boardViewModel.selectedBoard == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  '오류: ${boardViewModel.boardDetailsError}',
                  style: TextStyle(color: theme.colorScheme.error),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 16),
                ElevatedButton(
                  onPressed: () {
                    if (_currentlyDisplayedBoardId != null) {
                      boardViewModel.fetchBoardDetails(
                        _currentlyDisplayedBoardId!,
                      );
                    }
                  },
                  child: const Text('다시 시도'),
                ),
              ],
            ),
          ),
        ),
      );
    }

    final board = boardViewModel.selectedBoard;

    if (board == null) {
      return Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          elevation: 0,
          leading: IconButton(
            icon: Icon(Icons.close, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          title: Text(
            '게시글 정보 없음',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: const Center(child: Text('게시글 정보를 불러올 수 없습니다.')),
      );
    }

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onSurface),
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
        ),
        title: Text(
          board.title,
          overflow: TextOverflow.ellipsis,
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
        centerTitle: true,
        actions: [
          // 북마크 버튼 등 다른 액션 추가 가능
          // IconButton(icon: Icon(Icons.bookmark_border_outlined), onPressed: () { /* 북마크 로직 */ }),
        ],
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildImageTab(board: board),
            const SizedBox(height: 12), // 간격 조정
            _buildUserInfoSection(board: board, context: context), // context 전달
            const SizedBox(height: 12), // 간격 조정
            _buildBoardContent(board: board),
            Divider(
              height: 32.0, // 간격 조정
              thickness: 0.8,
              color: theme.dividerColor,
              indent: 16.0,
              endIndent: 16.0,
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                16.0,
                0,
                16.0,
                16.0,
              ), // 댓글 목록 위아래 패딩 조정
              child: CommentListWidget.forBoard(boardId: board.id),
            ),
            const SizedBox(height: 80), // FAB 공간 확보
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildCommentAddButton(boardId: board.id),
    );
  }

  Widget _buildImageTab({required Board board, double? height}) {
    final theme = Theme.of(context);
    final double imageHeight = height ?? 220.0; // 이미지 높이 기본값 증가
    Widget imageContent;

    if (board.image != null && board.image!.isNotEmpty) {
      imageContent = Image.network(
        board.image!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: imageHeight,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) return child;
          return Center(
            child: CircularProgressIndicator(
              value:
                  loadingProgress.expectedTotalBytes != null
                      ? loadingProgress.cumulativeBytesLoaded /
                          loadingProgress.expectedTotalBytes!
                      : null,
              strokeWidth: 2.0,
            ),
          );
        },
        errorBuilder: (context, exception, stackTrace) {
          return Container(
            // 오류 시 배경 및 아이콘
            height: imageHeight,
            width: double.infinity,
            color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
            child: Center(
              child: Icon(
                Icons.broken_image_outlined,
                color: theme.colorScheme.onSurfaceVariant.withOpacity(0.5),
                size: 50,
              ),
            ),
          );
        },
      );
    } else {
      imageContent = Container(
        height: imageHeight,
        width: double.infinity,
        color: theme.colorScheme.secondaryContainer.withOpacity(0.2),
        child: Center(
          child: Icon(
            Icons.image_not_supported_outlined,
            color: theme.iconTheme.color?.withAlpha(70),
            size: 50,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Card(
        // Card로 감싸서 그림자 효과와 둥근 모서리 적용
        elevation: 2.0,
        clipBehavior: Clip.antiAlias, // ClipRRect와 함께 사용
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(15.0), // Card보다 약간 작게
          child: imageContent,
        ),
      ),
    );
  }

  Widget _buildUserInfoSection({
    required Board board,
    required BuildContext context,
  }) {
    final theme = Theme.of(context);
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final author = board.user;
    final bool isAuthor =
        (authViewModel.currentUser != null &&
            author.userId == authViewModel.currentUser!.userId);

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20.0,
        vertical: 8.0,
      ), // 패딩 조정
      child: Row(
        children: [
          CircleAvatar(
            radius: 22, // 크기 조정
            backgroundImage:
                (author.profileImage != null && author.profileImage!.isNotEmpty)
                    ? NetworkImage(author.profileImage!)
                    : null,
            backgroundColor: theme.colorScheme.surfaceTint,
            child:
                (author.profileImage == null || author.profileImage!.isEmpty)
                    ? Icon(
                      Icons.person_rounded,
                      size: 22,
                      color: theme.colorScheme.onSurfaceVariant.withOpacity(
                        0.8,
                      ),
                    ) // 아이콘 및 색상 변경
                    : null,
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  author.nickname,
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                    color: theme.colorScheme.onSurface,
                  ),
                ),
                Text(
                  // 작성일 표시 추가
                  '${DateFormat('yyyy.MM.dd HH:mm').format(board.createdAt)} 작성',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onSurfaceVariant,
                  ),
                ),
              ],
            ),
          ),
          if (isAuthor)
            IconButton(
              icon: Icon(
                Icons.more_horiz_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ), // 아이콘 변경
              tooltip: '게시글 관리',
              onPressed: () {
                _showBoardManageOptions(board);
              },
            ),
        ],
      ),
    );
  }

  Widget _buildBoardContent({required Board board}) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildBoardInfoRow(
            context,
            Icons.location_on_outlined,
            '습득/분실 위치',
            board.location.locationName,
          ),
          _buildBoardInfoRow(
            context,
            Icons.category_outlined,
            '물품 종류',
            board.itemType.itemType,
          ),
          _buildBoardInfoRow(
            context,
            Icons.help_outline_rounded,
            '상태',
            board.status,
          ), // 아이콘 변경
          const SizedBox(height: 20),
          Text(
            '상세 내용',
            style: theme.textTheme.titleSmall?.copyWith(
              fontWeight: FontWeight.bold,
              color: theme.colorScheme.onSurface,
            ),
          ),
          const SizedBox(height: 8),
          Container(
            // 상세 내용을 박스로 감싸 가독성 향상
            padding: const EdgeInsets.all(12.0),
            decoration: BoxDecoration(
              color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
              borderRadius: BorderRadius.circular(8.0),
            ),
            width: double.infinity,
            child: Text(
              board.description,
              style: theme.textTheme.bodyLarge?.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.85),
                height: 1.6,
              ),
              textAlign: TextAlign.left,
            ),
          ),
          const SizedBox(height: 20),
          Align(
            alignment: Alignment.centerRight,
            child: Text(
              '최근 수정: ${DateFormat('MM.dd HH:mm').format(board.updatedAt)}', // 날짜 형식 간소화
              style: theme.textTheme.bodySmall!.copyWith(
                color: theme.colorScheme.onSurface.withOpacity(0.6),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBoardInfoRow(
    BuildContext context,
    IconData icon,
    String label,
    String? value,
  ) {
    final theme = Theme.of(context);
    if (value == null || value.isEmpty) return const SizedBox.shrink();

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start, // 다중 라인 텍스트를 위해 start로 정렬
        children: [
          Icon(icon, color: theme.colorScheme.secondary, size: 20),
          const SizedBox(width: 10),
          Text(
            '$label: ',
            style: theme.textTheme.bodyMedium!.copyWith(
              fontWeight: FontWeight.w600, // 라벨 강조
              color: theme.colorScheme.onSurfaceVariant,
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: theme.textTheme.bodyMedium!.copyWith(
                color: theme.colorScheme.onSurface,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentAddButton({required int boardId}) {
    final theme = Theme.of(context);

    return CustomCommentFab(
      boardId: boardId,
      isSecret: _isSecretComment,
      commentController: _commentController,
      onCommentSubmittedAsync : (commentText) async {
        await _submitComment(context, boardId, commentText);
      },
      leadingWidget: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Transform.scale(
            scale: 0.8,
            child: Checkbox(
              value: _isSecretComment,
              onChanged: (value) {
                setState(() {
                  _isSecretComment = value ?? false;
                });
              },
              activeColor: theme.colorScheme.surfaceTint,
              checkColor: theme.colorScheme.onSurfaceVariant,
              visualDensity: VisualDensity.compact,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
              side: BorderSide(
                color: (theme.colorScheme.onSurface).withValues(alpha: 0.7),
              ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(),
            child:
                _isSecretComment
                    ? Text(
                      '비밀댓글',
                      style: theme.textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    )
                    : Text(
                      '일반댓글',
                      style: theme.textTheme.labelSmall!.copyWith(
                        fontWeight: FontWeight.w500,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
                    ),
          ),
        ],
      ),
      onMorePressed: () {},
      collapsedHeight: 56.0, // 표준 FAB 높이에 맞춤
      mainContentWhenCollapsed: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          '댓글을 남겨주세요...',
          style: theme.textTheme.bodyMedium!.copyWith(
            color: theme.colorScheme.onSurfaceVariant,
          ),
        ),
      ),
      backgroundColor: ElevationOverlay.colorWithOverlay(
        theme.colorScheme.surface,
        theme.colorScheme.primary,
        3.0,
      ),
    );
  }
}
