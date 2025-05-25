import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/shared/widgets/comment_list_widget.dart';
import 'package:ajoufinder/ui/shared/widgets/custom_comment_fab.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class BoardViewWidget extends StatefulWidget{
  final Board board;

  const BoardViewWidget({
    super.key,
    required this.board,
  });

  @override
  State<BoardViewWidget> createState() => _BoardViewWidgetState();
}

class _BoardViewWidgetState extends State<BoardViewWidget> {
  late TextEditingController _commentController;
  late Future<User> _authorFuture;
  bool _isSecretComment = false;

  @override
  void initState() {
    super.initState();
    _commentController = TextEditingController();
    _authorFuture = getIt<UserRepository>().findById(widget.board.id);

    WidgetsBinding.instance.addPostFrameCallback((_){
      final commentsViewModel = Provider.of<CommentViewModel>(context, listen: false);
      commentsViewModel.fetchCommentsByBoardId(boardId: widget.board.id);
      }
    );
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  void _submitComment(BuildContext context) {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    final commentViewModel = Provider.of<CommentViewModel>(context, listen: false);

    final currentUser = authViewModel.currentUser;

    if (_commentController.text.isNotEmpty && currentUser != null) {
      commentViewModel.postComments(comment: _commentController.text);//나중에 postComments 메서드 수정할 것
      _commentController.clear();
    }
    FocusScope.of(context).unfocus();
  }
  
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
  
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        iconTheme: theme.iconTheme,
        leading: IconButton(
          onPressed: () => Navigator.of(context).pop(),
          icon: Icon(Icons.arrow_back_ios_new_rounded),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            _buildImageTab(),
            const SizedBox(height: 8,),
            _buildUserInfoSection(authorFuture: _authorFuture),
            const SizedBox(height: 8,),
            _buildBoardContent(),
            Divider(
              height: 1.0,
              thickness: 1.0,
              color: theme.colorScheme.surfaceTint,
              indent: 20.0,
              endIndent: 20.0,
            ),
            CommentListWidget.forBoard(boardId: widget.board.id,),
          ],
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      floatingActionButton: _buildCommentAddButton(),
    );
  }

  Widget _buildImageTab({ double? height, }) {
    final board = widget.board;
    final theme = Theme.of(context);
    final double imageHeight = height ?? 200.0;

    Widget imageContent;

    if (board.image != null && board.image!.isNotEmpty) {
      imageContent = Image.network(
        board.image!,
        fit: BoxFit.cover,
        width: double.infinity,
        height: imageHeight,
        loadingBuilder: (context, child, loadingProgress) {
          if (loadingProgress == null) {
            return child;
          } else {
            return Center(
              child: CircularProgressIndicator(
                value: loadingProgress.expectedTotalBytes != null
                ? loadingProgress.cumulativeBytesLoaded / loadingProgress.expectedTotalBytes!
                : null,
              )
            );
          }
        },
        errorBuilder: (context, exception, stackTrace) {
          return Center(
            child: Icon(
             Icons.image_not_supported_rounded,
             color: theme.iconTheme.color!.withValues(alpha: 0.1), 
             size: 50,
            ),
          );
        },
      );
    } else {
      imageContent = Container(
        height: imageHeight,
        width: double.infinity,
        color: theme.colorScheme.surfaceTint,
        child: Center(
          child: Icon(
            Icons.image_rounded,
            color: theme.iconTheme.color!.withValues(alpha: 0.3),
            size: 50,
          ),
        ),
      );
    }

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0),
      child: GestureDetector(
        onLongPress: (){
          //추후 정의
        },
        child: Container(
          decoration: BoxDecoration(
            border: Border.all(color: theme.colorScheme.onSurface.withValues(alpha: 0.15), width: 2.0),
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                spreadRadius: 3,
                blurRadius: 5,
                offset: Offset(0, 3)
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(16),
            child: imageContent
          ),
        ),
      ),
    );
  }

  Widget _buildUserInfoSection({ required Future<User> authorFuture,}) {
    final theme = Theme.of(context);
    final board = widget.board;
    final authViewModel = Provider.of<AuthViewModel>(context);

    return FutureBuilder(
      future: authorFuture, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.surfaceTint,
                  backgroundImage: (board.image != null && board.image!.isNotEmpty)
                  ? NetworkImage(board.image!)
                  : null,
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '로딩중',
                        style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600),
                      ),
                      Text(
                        '로딩중',
                        style: theme.textTheme.labelMedium!.copyWith(color: theme.colorScheme.surfaceTint),
                      ),
                    ],
                  )
                ),              
              ],
            ),
          );
        } else if (snapshot.hasError) {
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Text(
              "작성자 정보를 불러올 수 없습니다: ${snapshot.error}", 
              style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.w600, color: theme.colorScheme.error),
            ),
          );
        } else if (snapshot.hasData) {
          final author = snapshot.data!;

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32.0, vertical: 6.0),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                CircleAvatar(
                  radius: 22,
                  backgroundColor: theme.colorScheme.surfaceTint,
                  backgroundImage: (board.image != null && board.image!.isNotEmpty)
                  ? NetworkImage(board.image!)
                  : null,
                ),
                const SizedBox(width: 12,),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        author.nickname,
                        style: theme.textTheme.bodySmall!.copyWith(fontSize: 14.0),
                      ),
                      Text(
                        author.email,
                        style: theme.textTheme.labelMedium!.copyWith(color: theme.colorScheme.surfaceTint),
                      ),
                    ],
                  )
                ),
                (author.id == authViewModel.userUid) 
                ? TextButton.icon(onPressed: 
                (){
                  // 수정 기능 구현
                }, 
                label: Text(
                  '수정하기',
                  style: theme.textTheme.labelMedium!.copyWith(
                  color: theme.colorScheme.onSurfaceVariant,
                  fontWeight: FontWeight.w500
                ),
              ),
              icon: Icon(Icons.edit_rounded, color: theme.colorScheme.onSurfaceVariant,),
              style: TextButton.styleFrom(
                backgroundColor: theme.colorScheme.surfaceTint,
              ),
            )
            : SizedBox()
          ],
        ),
      );
        } else {
          return const Padding(
            padding: EdgeInsets.all(16.0),
            child: Text("작성자 정보 없음."),
          );
        }
      }
    );
  }

  Widget _buildBoardContent() {
    final theme = Theme.of(context);
    final board = widget.board;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            board.title,
            style: theme.textTheme.titleMedium!.copyWith(fontWeight: FontWeight.bold),
          ),
          __buildBoardInfoRow(Icons.fmd_good_outlined, board.detailedLocation),
          __buildBoardInfoRow(Icons.shopping_bag_outlined, board.category),
          __buildBoardInfoRow(Icons.calendar_today_outlined, DateFormat('yyyy.MM.dd').format(board.createdAt)),
          __buildBoardInfoRow(CupertinoIcons.checkmark_shield, board.status),
          const SizedBox(height: 5,),
          Text(
            board.description,
            style: theme.textTheme.bodySmall,
            textAlign: TextAlign.left,
          ),
          const SizedBox(height: 14,),
          Text(
            DateFormat('yyyy.MM.dd HH:mm').format(board.updatedAt),
            style: theme.textTheme.labelSmall!.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),
            textAlign: TextAlign.left,
          ),
        ],
      ),
    );

  }

  Widget __buildBoardInfoRow(IconData icon, String? text) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Icon(icon, color: theme.iconTheme.color!.withValues(alpha: 0.3), size: 18,),
          const SizedBox(width: 5,),
          Expanded(
            child: Text(text ?? '?', style: theme.textTheme.labelMedium!.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.5),
            ),),
          ),
        ],
      ),
    );
  }

  Widget _buildCommentAddButton() {
  final theme = Theme.of(context);

  return CustomCommentFab(
    commentController: _commentController,
    onCommentSubmitted: (commentText) {
      setState(() {
        _isSecretComment = false;
      });
      _submitComment(context);
      _commentController.clear();
    },
    collapsedHeight: 28.0,    
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
            side: BorderSide(color: (theme.colorScheme.onSurface).withValues(alpha: 0.7)),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(),
          child: _isSecretComment
          ? Text(
            '비밀댓글',
            style: theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurfaceVariant),
          )
          : Text(
            '일반댓글',
            style: theme.textTheme.labelSmall!.copyWith(fontWeight: FontWeight.w500, color: theme.colorScheme.onSurfaceVariant),
          ) 
        ),
      ],
    ),
    mainContentWhenCollapsed: Padding(
      padding: const EdgeInsets.only(left: 36.0),
        child: Text('댓글을 작성해주세요', style: theme.textTheme.labelSmall!.copyWith(color: theme.colorScheme.onSurfaceVariant),),
    ),
    onMorePressed: () {
    },
    backgroundColor: theme.colorScheme.surfaceTint,
  );
}
}