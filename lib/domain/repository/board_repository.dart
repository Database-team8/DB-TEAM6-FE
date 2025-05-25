import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/domain/entities/item_type.dart';

abstract class BoardRepository {
  Future<List<Board>> getAllBoardsByUserId(int userId);
  Future<List<Board>> getAllBoardsByCategory(String category);
  Future<void> addNewBoard(Board board);
  Future<List<int>> getAllDepartmentIds();
  Future<List<ItemType>> getAllItemTypes();
  Future<List<String>> getAllItemStatuses();
}