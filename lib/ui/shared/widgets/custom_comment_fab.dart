import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:ajoufinder/data/dto/comment/post_comment/post_comment_request.dart';
import 'package:ajoufinder/data/dto/comment/update_comment/update_comment_request.dart';

class CustomCommentFab extends StatefulWidget {
  final int boardId;
  final bool isSecret;
  final Widget? leadingWidget;
  final VoidCallback onMorePressed;
  final Widget mainContentWhenCollapsed;
  final double collapsedHeight;
  final double expandedHeight;
  final double? width;
  final Color? backgroundColor;
  final Color? foregroundColor;

  final TextEditingController commentController;
  final FocusNode? commentFocusNode;

  /// ✅ 수정 모드일 경우 commentId 지정
  final int? editingCommentId;

  const CustomCommentFab({
    super.key,
    required this.boardId,
    required this.isSecret,
    this.leadingWidget,
    required this.onMorePressed,
    this.mainContentWhenCollapsed = const Text(
      '댓글을 작성해주세요.',
      textAlign: TextAlign.center,
      overflow: TextOverflow.ellipsis,
      maxLines: 1,
    ),
    this.collapsedHeight = 28.0,
    this.expandedHeight = 200.0,
    this.width,
    this.backgroundColor,
    this.foregroundColor,
    required this.commentController,
    this.commentFocusNode,
    this.editingCommentId, // ✅ 추가
  });

  @override
  _CustomCommentFabState createState() => _CustomCommentFabState();
}

class _CustomCommentFabState extends State<CustomCommentFab>
    with SingleTickerProviderStateMixin {
  bool _isExpanded = false;
  late AnimationController _animationController;
  late Animation<double> _heightAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _heightAnimation = Tween<double>(
      begin: widget.collapsedHeight,
      end: widget.expandedHeight,
    ).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    // 수정 모드면 자동 펼침
    if (widget.editingCommentId != null) {
      _isExpanded = true;
      _animationController.forward();
    }
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _toggleExpand() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _animationController.forward();
        if (widget.commentFocusNode != null) {
          Future.delayed(const Duration(milliseconds: 100), () {
            widget.commentFocusNode?.requestFocus();
          });
        }
      } else {
        _animationController.reverse();
        FocusScope.of(context).unfocus();
      }
    });
  }

  void _submitAndCollapse() {
    final commentText = widget.commentController.text.trim();
    if (commentText.isNotEmpty) {
      final commentViewModel = Provider.of<CommentViewModel>(
        context,
        listen: false,
      );

      if (widget.editingCommentId != null) {
        // ✅ 수정 모드
        final request = UpdateCommentRequest(
          content: commentText,
          isSecret: widget.isSecret, // ✅ 추가
        );
        commentViewModel
            .updateComment(widget.boardId, widget.editingCommentId!, request)
            .then((_) => commentViewModel.fetchComments(widget.boardId));
      } else {
        // ✅ 작성 모드
        final request = PostCommentRequest(
          content: commentText,
          isSecret: widget.isSecret,
        );
        commentViewModel
            .postComment(widget.boardId, request)
            .then((_) => commentViewModel.fetchComments(widget.boardId));
      }

      widget.commentController.clear();
    }

    _toggleExpand();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bgColor = widget.backgroundColor ?? theme.colorScheme.surfaceTint;
    final fgColor =
        widget.foregroundColor ?? theme.colorScheme.onSurfaceVariant;

    return AnimatedBuilder(
      animation: _heightAnimation,
      builder: (context, child) {
        return Container(
          height: _heightAnimation.value,
          width: widget.width ?? MediaQuery.of(context).size.width * 0.9,
          margin: EdgeInsets.symmetric(
            horizontal:
                widget.width == null
                    ? (MediaQuery.of(context).size.width * 0.05)
                    : 0,
          ),
          decoration: BoxDecoration(
            color: bgColor,
            borderRadius: BorderRadius.circular(
              _isExpanded ? 20.0 : widget.collapsedHeight / 2,
            ),
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                spreadRadius: 1,
                blurRadius: 3,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child:
              _isExpanded
                  ? _buildExpandedContent(theme, fgColor)
                  : _buildCollapsedContent(theme, fgColor),
        );
      },
    );
  }

  Widget _buildCollapsedContent(ThemeData theme, Color fgColor) {
    return GestureDetector(
      onTap: _toggleExpand,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0),
        child: Row(
          children: <Widget>[
            if (widget.leadingWidget != null) ...[
              widget.leadingWidget!,
              const SizedBox(width: 8),
            ],
            Expanded(
              child: DefaultTextStyle(
                style:
                    theme.textTheme.bodyMedium?.copyWith(color: fgColor) ??
                    TextStyle(color: fgColor, fontSize: 14),
                textAlign:
                    widget.leadingWidget == null
                        ? TextAlign.center
                        : TextAlign.start,
                child: widget.mainContentWhenCollapsed,
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(Icons.more_horiz_rounded, color: fgColor),
              onPressed: widget.onMorePressed,
              padding: EdgeInsets.zero,
              constraints: const BoxConstraints(),
              splashRadius: 20,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildExpandedContent(ThemeData theme, Color fgColor) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              if (widget.leadingWidget != null) widget.leadingWidget!,
              IconButton(
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: fgColor),
                onPressed: _toggleExpand,
              ),
            ],
          ),
          Expanded(
            child: TextField(
              controller: widget.commentController,
              focusNode: widget.commentFocusNode,
              decoration: InputDecoration(
                hintText: '댓글 내용을 입력하세요...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide(color: fgColor.withAlpha(80)),
                ),
                filled: true,
                fillColor: theme.scaffoldBackgroundColor,
                contentPadding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
              ),
              maxLines: null,
              keyboardType: TextInputType.multiline,
              textInputAction: TextInputAction.newline,
            ),
          ),
          ElevatedButton(
            onPressed: _submitAndCollapse,
            style: ElevatedButton.styleFrom(
              backgroundColor: theme.colorScheme.onSurfaceVariant,
              foregroundColor: theme.colorScheme.surfaceTint,
              minimumSize: const Size(double.infinity, 40),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
            child: const Text('제출'),
          ),
        ],
      ),
    );
  }
}
