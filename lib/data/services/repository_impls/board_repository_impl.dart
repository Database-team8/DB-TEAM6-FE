import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';

class BoardRepositoryImpl extends BoardRepository{

  @override
  Future<List<Board>> getAllBoardsByUserId(int userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Board(
        id: 1,
        title: '첫 번째 게시글',
        userId: userId,
        locationId: 1,
        detailedLocation: '도곡1동',
        description: '첫 번째 게시글 설명',
        relatedDate: DateTime.now(),
        image: null,
        status: 'active',
        category: 'general',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        itemType: 'type1',
      )
    ];
  }

  @override
  Future<void> addNewBoard(Board board) async {
    throw UnimplementedError();
  }

  @override
  Future<List<int>> getAllDepartmentIds() async {
    throw UnimplementedError();
  }

  @override
  Future<List<ItemType>> getAllItemTypes() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      ItemType(id: 1, itemType: '지갑'),
      ItemType(id: 2, itemType: '악세사리'),
    ];
  }

  @override
  Future<List<String>> getAllItemStatuses() async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      '분실',
      '찾음',
      '?'
    ];
  }

  @override
  Future<List<Board>> getAllBoardsByCategory(String category) async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Board(
        id: 1,
        title: '첫 번째 게시글',
        userId: 101,
        locationId: 1,
        detailedLocation: '도곡1동',
        description: '첫 번째 게시글 설명',
        relatedDate: DateTime.now(),
        image: null,
        status: 'active',
        category: 'general',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        itemType: 'type1',
      ),
      Board(
        id: 2,
        title: '두 번째 게시글',
        userId: 102,
        locationId: 2,
        detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 3,
      title: '세 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 4,
      title: '네 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 5,
      title: '다섯 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 6,
      title: '여섯 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 7,
      title: '일곱 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 8,
      title: '여덟 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 9,
      title: '아홉 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 10,
      title: '열 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ),
    Board(
      id: 11,
      title: '열한 번째 게시글',
      userId: 102,
      locationId: 2,
      detailedLocation: '서초동',
      description: '두 번째 게시글 설명',
      relatedDate: DateTime.now(),
      image: null,
      status: 'active',
      category: 'general',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      itemType: 'type2',
    ), // 추가 게시글 가능
  ];
  }
}