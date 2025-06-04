import 'package:ajoufinder/data/dto/board/boards/boards_request.dart';
import 'package:ajoufinder/data/dto/board/boards/boards_response.dart';
import 'package:ajoufinder/data/dto/board/detailed_board/detailed_board_request.dart';
import 'package:ajoufinder/data/dto/board/detailed_board/detailed_board_response.dart';
import 'package:ajoufinder/data/dto/board/post_board/post_board_request.dart';
import 'package:ajoufinder/data/dto/board/post_board/post_board_response.dart';
import 'package:ajoufinder/data/dto/itemtype/itemtypes/itemtypes_response.dart';
import 'package:ajoufinder/domain/entities/board_item.dart';

abstract class BoardRepository {
  Future<List<BoardItem>> getAllBoardItemsByCategory(String category);
  Future<PostBoardResponse> postFoundBoard(PostBoardRequest request);
  Future<PostBoardResponse> postLostBoard(PostBoardRequest request);
  Future<ItemtypesResponse> getAllItemTypes();
  Future<List<String>> getAllItemStatuses();
  Future<BoardsResponse> getFoundBoards(BoardsRequest request);
  Future<BoardsResponse> getLostBoards(BoardsRequest request);
  Future<DetailedBoardResponse> getBoardById(DetailedBoardRequest request);
}