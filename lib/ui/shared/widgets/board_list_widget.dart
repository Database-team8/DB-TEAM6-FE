import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/ui/shared/widgets/board_view_widget.dart';
import 'package:ajoufinder/ui/viewmodels/comment_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class BoardListWidget extends StatelessWidget {
  final List<Board> boards;
  const BoardListWidget({super.key, required this.boards});

  @override
  Widget build(BuildContext context) {
    if (boards.isEmpty) {
      return const Center(child: Text('게시글이 없습니다'),);
    } else {
      return ListView.builder(
        shrinkWrap: true,
        physics: NeverScrollableScrollPhysics(),
        itemCount: boards.length,
        itemBuilder: (context, index) => _BoardCard(board: boards[index]),
      );
    }
  }
}

class _BoardCard extends StatelessWidget {
  final Board board;

  const _BoardCard({
    required this.board,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final Color cardBg = theme.colorScheme.surface;
    final Color borderColor = theme.dividerColor.withValues(alpha: 0.7);

    final commentViewModelForSubmit = Provider.of<CommentViewModel>(context, listen: false);

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 8.0),
      child: Card(
        elevation: 1,
        shadowColor: theme.colorScheme.shadow,
        surfaceTintColor: Colors.transparent,
        color: cardBg,
        clipBehavior: Clip.antiAlias,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(14),
          side: BorderSide(color: borderColor, width: 1),
        ),
        margin: EdgeInsets.zero,
        child: InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => Center(
                  child: ConstrainedBox(
                    constraints: const BoxConstraints(maxWidth: 400),
                    child: BoardViewWidget(board: board,),
                  ),
                ),
              ),
            );
          },
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _BoardImageArea(board: board, cardBg: cardBg, borderColor: borderColor),
              Padding(
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 14),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _BoardTitle(title: board.title),
                    const SizedBox(height: 8),
                    _BoardLocationRow(location: board.detailedLocation),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _BoardImageArea extends StatelessWidget {
  final Board board;
  final Color cardBg;
  final Color borderColor;

  const _BoardImageArea({
    required this.board,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        _BoardImage(imageUrl: board.image, cardBg: cardBg, borderColor: borderColor),
        Positioned(
          top: 10,
          right: 10,
          child: _BoardBookmarkButton(
            onTap: () {
              // TODO: 북마크 클릭 시 동작
              print('북마크 클릭됨: ${board.title}');
            },
          ),
        ),
      ],
    );
  }
}

class _BoardImage extends StatelessWidget {
  final String? imageUrl;
  final Color cardBg;
  final Color borderColor;

  const _BoardImage({
    this.imageUrl,
    required this.cardBg,
    required this.borderColor,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      height: 120,
      width: double.infinity,
      decoration: BoxDecoration(
        color: cardBg,
        borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
        border: Border.all(color: borderColor, width: 1),
      ),
      child: imageUrl != null
          ? ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(14)),
              child: Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                width: double.infinity,
                height: 120,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child;
                  return const Center(child: CircularProgressIndicator());
                },
                errorBuilder: (context, error, stackTrace) {
                  return Center(
                    child: Icon(
                      Icons.broken_image_outlined,
                      color: theme.iconTheme.color?.withValues(alpha: 0.25) ?? Colors.grey[400],
                      size: 38,
                    ),
                  );
                },
              ),
            )
          : Center(
              child: Icon(
                Icons.image_outlined,
                color: theme.iconTheme.color?.withValues(alpha: 0.25) ?? Colors.grey[400],
                size: 38,
              ),
            ),
    );
  }
}

class _BoardBookmarkButton extends StatelessWidget {
  final VoidCallback onTap;

  const _BoardBookmarkButton({required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return InkWell(
      borderRadius: BorderRadius.circular(8),
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: theme.cardColor.withOpacity(0.85),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Icon(
          Icons.bookmark_border_rounded,
          color: theme.iconTheme.color ?? Colors.grey[700],
          size: 24,
        ),
      ),
    );
  }
}

class _BoardTitle extends StatelessWidget {
  final String title;

  const _BoardTitle({required this.title});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.w700,
        fontSize: 16.5,
      ),
      maxLines: 1,
      overflow: TextOverflow.ellipsis,
    );
  }
}

class _BoardLocationRow extends StatelessWidget {
  final String? location;

  const _BoardLocationRow({this.location});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: [
        Icon(
          Icons.place_outlined,
          color: theme.iconTheme.color?.withOpacity(0.6) ?? Colors.grey[500],
          size: 18,
        ),
        const SizedBox(width: 4),
        Expanded(
          child: Text(
            location ?? '위치 정보 없음',
            style: theme.textTheme.bodySmall?.copyWith(
              color: theme.textTheme.bodySmall?.color?.withOpacity(0.85) ?? Colors.grey[700],
              fontSize: 13.5,
              fontWeight: FontWeight.w400,
            ),
            overflow: TextOverflow.ellipsis,
            maxLines: 1,
          ),
        ),
      ],
    );
  }
}
