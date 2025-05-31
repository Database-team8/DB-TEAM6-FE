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
      boardId: json['board_id'] as int,
      title: json['title'] as String,
      nickname: json['nickname'] as String,
      createdAt: json['created_at'] as String,
      status: json['status'] as String,
      image: json['image'] as String?,
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