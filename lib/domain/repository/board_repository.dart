import 'package:ajoufinder/data/dto/board/board_statuses/board_statuses_response.dart';
import 'package:ajoufinder/data/dto/board/boards/boards_request.dart';
import 'package:ajoufinder/data/dto/board/boards/boards_response.dart';
import 'package:ajoufinder/data/dto/board/delete_board/delete_board_request.dart';
import 'package:ajoufinder/data/dto/board/delete_board/delete_board_response.dart';
import 'package:ajoufinder/data/dto/board/detailed_board/detailed_board_request.dart';
import 'package:ajoufinder/data/dto/board/detailed_board/detailed_board_response.dart';
import 'package:ajoufinder/data/dto/board/filter_boards/filter_board_response.dart';
import 'package:ajoufinder/data/dto/board/filter_boards/filter_boards_request.dart';
import 'package:ajoufinder/data/dto/board/patch_board/patch_board_request.dart';
import 'package:ajoufinder/data/dto/board/patch_board/patch_board_response.dart';
import 'package:ajoufinder/data/dto/board/patch_board/patch_board_status_request.dart';
import 'package:ajoufinder/data/dto/board/patch_board/patch_board_status_response.dart';
import 'package:ajoufinder/data/dto/board/post_board/post_board_request.dart';
import 'package:ajoufinder/data/dto/board/post_board/post_board_response.dart';
import 'package:ajoufinder/data/dto/itemtype/itemtypes/itemtypes_response.dart';
import 'package:ajoufinder/domain/entities/board_item.dart';

abstract class BoardRepository {
  Future<List<BoardItem>> getAllBoardItemsByCategory(String category);
  Future<PostBoardResponse> postFoundBoard(PostBoardRequest request);
  Future<PostBoardResponse> postLostBoard(PostBoardRequest request);
  Future<ItemtypesResponse> getAllItemTypes();
  Future<BoardStatusesResponse> getAllStatuses();
  Future<BoardsResponse> getFoundBoards(BoardsRequest request);
  Future<BoardsResponse> getLostBoards(BoardsRequest request);
  Future<DetailedBoardResponse> getBoardById(DetailedBoardRequest request);
  Future<BoardsResponse> getMyBoards(BoardsRequest request);
  Future<DeleteBoardResponse> deleteBoard(DeleteBoardRequest request);
  Future<FilterBoardResponse> filterLostBoards(FilterBoardsRequest request);
  Future<FilterBoardResponse> filterFoundBoards(FilterBoardsRequest request);
  Future<PatchBoardStatusResponse> patchBoardAcitve(PatchBoardStatusRequest request);
  Future<PatchBoardStatusResponse> patchBoardCompleted(PatchBoardStatusRequest request);
  Future<PatchBoardResponse> patchBoard(PatchBoardRequest request);
}