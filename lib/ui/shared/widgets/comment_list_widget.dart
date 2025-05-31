import 'package:ajoufinder/domain/entities/comment.dart';
import 'package:ajoufinder/domain/entities/user.dart';
import 'package:ajoufinder/domain/repository/comment_repository.dart';
import 'package:ajoufinder/domain/repository/user_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class CommentListWidget extends StatefulWidget{
  final int? boardId;

  const CommentListWidget.forCurrentUser({super.key,}) : boardId = null;
  const CommentListWidget.forBoard({super.key, required this.boardId});

  @override
  State<CommentListWidget> createState() => _CommentListWidgetState();
}

class _CommentListWidgetState extends State<CommentListWidget> {
  final commentRepository = getIt<CommentRepository>();

  @override
  void initState() {
    super.initState();
    final commentViewModel = Provider.of<CommentViewModel>(context, listen: false);

    if (widget.boardId == null) {
      commentViewModel.fetchMyComments();
    } else {
      commentViewModel.fetchCommentsByBoardId(boardId: widget.boardId!);
    }
  }

  @override
  void didUpdateWidget(CommentListWidget oldWidget) {
    super.didUpdateWidget(oldWidget);

    final commentViewModel = Provider.of<CommentViewModel>(context, listen: false);

    if (widget.boardId == null) {
      commentViewModel.fetchMyComments();
    } else {
      commentViewModel.fetchCommentsByBoardId(boardId: widget.boardId!);
    }
  }

  @override
  Widget build(BuildContext context) {
    final commentViewModel = Provider.of<CommentViewModel>(context);
    final theme = Theme.of(context);

    if (commentViewModel.comments.isEmpty) {
      return Center(child: Text('댓글이 없습니다'),);
    }else {
      return ListView.separated(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: commentViewModel.comments.length,
        itemBuilder: (context, index) => _CommentCard(comment: commentViewModel.comments[index]),
        separatorBuilder: (context, index) {
          return Divider(
            height: 1.0,
            thickness: 1.0,
            color: theme.colorScheme.surfaceTint,
            indent: 20.0,
            endIndent: 20.0,
          );
        },
      );
    }
  }
}

class _CommentCard extends StatefulWidget {
  final Comment comment;

  const _CommentCard({
    required this.comment,
  });

  @override
  State<_CommentCard> createState() => _CommentCardState();
}

class _CommentCardState extends State<_CommentCard> {
  late Future<User> _userFuture;
  
  @override
  void initState() {
    super.initState();
    final userRepository = getIt<UserRepository>();
    _userFuture = userRepository.findById(widget.comment.userId);
  }

  @override
  Widget build(BuildContext context) {

    return Padding(
        padding: const EdgeInsets.all(12.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildUpperRow(),    
            SizedBox(height: 8.0,), 
            _buildUnderRow()
          ],
        )
      );
  }

  Widget _buildUpperRow() {
    final theme = Theme.of(context);

    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        _buildCommentedUserInfo(),
        const Spacer(),
        Text(
          DateFormat('MM.dd HH:mm').format(widget.comment.createdAt),
          style: theme.textTheme.bodySmall!.copyWith(
              color: theme.colorScheme.onSurface.withValues(alpha: 0.6),
              fontSize: 11.0
          ),
        ),
      ],
    );
  }
  
  Widget _buildCommentedUserInfo() {
    final theme = Theme.of(context);
    const separator = SizedBox(width: 8.0,);

    return FutureBuilder<User>(
      future: _userFuture, 
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                child: const SizedBox(width: 16, height: 16, child: CircularProgressIndicator(strokeWidth: 2.0)),
              ),
              separator,
              Text(
                '로딩중',
                style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal),
              ),
            ],
          );          
        } else if (snapshot.hasError) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                child: Icon(Icons.error_outline_rounded, color: theme.colorScheme.error, size: 20)
              ),
              separator,
              Text(
                '사용자 정보 에러',
                style: theme.textTheme.titleSmall!.copyWith(fontWeight: FontWeight.normal, color: theme.colorScheme.error),
              ),
            ],
          );
        } else if (snapshot.hasData) {
          final user = snapshot.data!;

          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                child: (user.profileImage != null && user.profileImage!.isNotEmpty) 
                ? Image.network(user.profileImage!, fit: BoxFit.contain)
                : null,
              ),
              separator,
              Text(
                user.nickname,
                style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
              ),
            ],
          );
        } else {
          return Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              CircleAvatar(
                radius: 10,
                backgroundColor: theme.colorScheme.onSurface.withValues(alpha: 0.1),
                child: null,
              ),
              separator,
              Text(
                '에러',
                style: theme.textTheme.bodySmall!.copyWith(fontWeight: FontWeight.normal),
              ),
            ],
          );
        }
      }
    );
  }
  
  Widget _buildUnderRow() {
    final theme = Theme.of(context);
    
    return Text(
      widget.comment.content,
      style: theme.textTheme.titleSmall!.copyWith(fontSize: 13.0),
    );
  }
}