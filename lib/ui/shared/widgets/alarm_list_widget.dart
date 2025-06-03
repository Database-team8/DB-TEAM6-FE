import 'package:ajoufinder/domain/entities/alarm.dart';
import 'package:ajoufinder/ui/viewmodels/alarm_view_model.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

class AlarmListWidget extends StatelessWidget{
  final List<Alarm> alarms;

  const AlarmListWidget({
    super.key, 
    required this.alarms, 
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (alarms.isEmpty) {
      return Center(
        child: Text(
          '받은 알림이 없습니다.',
          style: theme.textTheme.bodyLarge!.copyWith(color: theme.colorScheme.onSurface.withValues(alpha: 0.7)),
        ),
      );
    } else {
      return ListView.builder(
        itemCount: alarms.length,
        itemBuilder: (context, index) => _AlarmCard(alarm: alarms[index],),
      );
    }
  }
}

class _AlarmCard extends StatefulWidget {
  final Alarm alarm;

  const _AlarmCard({
    super.key,
    required this.alarm,
  });

  @override
  State<_AlarmCard> createState() => _AlarmCardState();
}

class _AlarmCardState extends State<_AlarmCard> {
  bool _isExpanded = false;

  String _formatTimeAgo(DateTime dateTime) {
    final now = DateTime.now();
    final difference = now.difference(dateTime);

    if (difference.inDays >= 7) {
      return DateFormat('MM.dd').format(dateTime);
    } else if (difference.inDays > 0) {
      return '${difference.inDays}일 전';
    } else if (difference.inHours > 0) {
      return '${difference.inHours}시간 전';
    } else if (difference.inMinutes > 0) {
      return '${difference.inMinutes}분 전';
    } else {
      return '방금 전';
    }
  }

  void _toggleExpandAndRead() {
    setState(() {
      if (!_isExpanded) { // 처음 확장될 때만 읽음 처리
        _isExpanded = true;
        if (!widget.alarm.isRead) {
          Provider.of<AlarmViewModel>(context, listen: false).markAsRead(widget.alarm.id);
        }
      } else {
        // 이미 확장된 상태에서 클릭 시 URL로 이동
        _launchURL(widget.alarm.url);
      }
    });
  }

  Future<void> _launchURL(String urlString) async {
    final Uri url = Uri.parse(urlString);
    // if (await canLaunchUrl(url)) {
    //   await launchUrl(url);
    // } else {
    //   // URL 실행 실패 시 사용자에게 알림 (예: 스낵바)
    //   ScaffoldMessenger.of(context).showSnackBar(
    //     SnackBar(content: Text('연결된 페이지를 열 수 없습니다: $urlString')),
    //   );
    //   print('Could not launch $urlString');
    // }
     print('URL 실행 시도: $urlString (url_launcher 패키지 필요)');
  }

@override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final timeAgo = _formatTimeAgo(widget.alarm.createdAt);
    final bool isCurrentlyRead = widget.alarm.isRead; // isRead 상태는 위젯 빌드 시점의 값 사용

    // 읽음 여부에 따른 배경색 및 텍스트 색상
    final cardBackgroundColor = isCurrentlyRead
        ? theme.colorScheme.surface.withValues(alpha: 0.5) // 읽은 알림은 약간 흐리게
        : theme.cardColor; // 안 읽은 알림은 기본 카드 색상
    final contentColor = isCurrentlyRead
        ? theme.colorScheme.onSurface.withValues(alpha: 0.6) // 읽은 알림 텍스트는 약간 흐리게
        : theme.colorScheme.onSurface;

    // 보여줄 내용 결정 (확장 시 전체, 아닐 시 일부)
    final displayContent = _isExpanded
        ? widget.alarm.content
        : (widget.alarm.content.length > 50 // 50자 초과 시 일부만 표시
            ? '${widget.alarm.content.substring(0, 50)}...'
            : widget.alarm.content);

    return Card(
      elevation: isCurrentlyRead ? 1.0 : 2.0, // 읽음 여부에 따라 그림자 조절
      margin: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 6.0),
      color: cardBackgroundColor,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10.0),
        side: BorderSide(
          color: isCurrentlyRead ? theme.dividerColor.withValues(alpha: 0.5) : theme.dividerColor,
          width: 0.5,
        ),
      ),
      child: InkWell(
        onTap: _toggleExpandAndRead,
        borderRadius: BorderRadius.circular(10.0),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // 아이콘 (선택적, 여기서는 간단하게 알림 아이콘 사용)
                  Icon(
                    isCurrentlyRead ? Icons.notifications_none_outlined : Icons.notifications_active,
                    color: isCurrentlyRead ? contentColor.withValues(alpha: 0.7) : theme.colorScheme.primary,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      '새로운 알림', // 제목은 content 기반으로 생성하거나 고정 텍스트 사용
                      style: theme.textTheme.titleSmall?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: contentColor,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  Text(
                    timeAgo,
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: contentColor.withValues(alpha: 0.8),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 10),
              // 알림 내용
              Text(
                displayContent,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: contentColor,
                  height: 1.4, // 줄 간격
                ),
                // 확장되지 않았을 때는 최대 2줄, 확장 시 제한 없음 (substring으로 처리했으므로 maxLines는 선택적)
                maxLines: _isExpanded ? null : 2,
                overflow: _isExpanded ? TextOverflow.visible : TextOverflow.ellipsis,
              ),
              // 확장 시 URL 이동 안내 (선택적)
              if (_isExpanded && widget.alarm.url.isNotEmpty)
                Padding(
                  padding: const EdgeInsets.only(top: 10.0),
                  child: Align(
                    alignment: Alignment.centerRight,
                    child: Text(
                      '자세히 보기',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.primary,
                        decoration: TextDecoration.underline,
                        decorationColor: theme.colorScheme.primary,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}