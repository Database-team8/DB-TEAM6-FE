import 'package:ajoufinder/data/dto/board/board_author.dart';
import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';

class Board {
  final int id;
  final String title;
  final String description;
  final String? image;
  final Location location;
  final BoardAuthor user;
  final String status;
  final String category;
  final ItemType itemType;
  final DateTime createdAt;
  final DateTime updatedAt;

  Board({
    required this.id,
    required this.title,
    required this.description,
    this.image,
    required this.location,
    required this.user,
    required this.status,
    required this.category,
    required this.itemType,
    required this.createdAt,
    required this.updatedAt,
  });

  factory Board.fromJson(Map<String, dynamic> json) {
    return Board(
      id: (json['board_id'] as int?) ?? 0,
      title: (json['title'] as String?) ?? '기본 제목',
      description: (json['description'] as String?) ?? ' ',
      image: (json['image'] as String?) ?? ' ',
      location: Location.fromJson(json['location'] as Map<String, dynamic>),
      user: BoardAuthor.fromJson(json['user'] as Map<String, dynamic>),
      status: (json['status'] as String?) ?? 'unknown',
      category: (json['category'] as String?) ?? '기타',
      itemType: ItemType.fromJson(json['item_type'] as Map<String, dynamic>),
      createdAt: (json['created_at'] as DateTime?) ?? DateTime.now(),
      updatedAt: (json['updated_at'] as DateTime?) ?? DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'board_id': id,
      'title': title,
      'description': description,
      'image': image,
      'location': location.toJson(),
      'user': user.toJson(),
      'status': status,
      'category': category,
      'item_type': itemType.toJson(),
      'created_at': createdAt,
      'updated_at': updatedAt,
    };
  }
}
