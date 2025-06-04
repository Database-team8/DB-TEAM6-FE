import 'package:ajoufinder/domain/entities/board_item.dart';

class BoardItemDto {
  final int boardId;
  final String title;
  final String nickname;
  final String createdAt;
  final String status;
  final String? image;

  BoardItemDto({
    required this.boardId,
    required this.title,
    required this.nickname,
    required this.createdAt,
    required this.status,
    this.image,
  });

  factory BoardItemDto.fromJson(Map<String, dynamic> json) {
    return BoardItemDto(
      boardId: (json['board_id'] as int?) ?? 0,
      title: (json['title'] as String?) ?? '기본 제목',
      nickname: (json['nickname'] as String?) ?? '익명',
      createdAt: (json['created_at'] as String?) ?? DateTime.now().toIso8601String(),
      status: (json['status'] as String?) ?? 'unknown',
      image: (json['image'] as String?) ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'board_id': boardId,
      'title': title,
      'nickname': nickname,
      'created_at': createdAt,
      'status': status,
      'image': image,
    };
  }

  BoardItem toEntity() {
    return BoardItem(
      id: boardId,
      title: title,
      authorNickname: nickname,
      createdAt: DateTime.parse(createdAt),
      status: status,
      imageUrl: image,
    );
  }
}