import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/domain/entities/board_item.dart';
import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/usecases/boards/delete_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/detailed_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/found_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/post_found_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/post_lost_board_usecase.dart';
import 'package:ajoufinder/domain/usecases/itemtype/itemtypes_usecase.dart';
import 'package:ajoufinder/domain/usecases/location/locations_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/lost_boards_usecase.dart';
import 'package:ajoufinder/domain/usecases/boards/my_boards_usecase.dart';
import 'package:flutter/material.dart';

class BoardViewModel extends ChangeNotifier{
  final ItemtypesUsecase _itemtypesUsecase;
  final LocationsUsecase _locationsUsecase;
  final MyBoardsUsecase _myBoardsUsecase;
  final LostBoardsUsecase _lostBoardsUsecase;
  final FoundBoardsUsecase _foundBoardsUsecase;
  final DetailedBoardUsecase _detailedBoardUsecase;
  final PostLostBoardUsecase _postLostBoardUseCase;
  final PostFoundBoardUsecase _postFoundBoardUseCase;
  final DeleteBoardUsecase _deleteBoardUsecase;

  List<BoardItem> _boardItems = [];
  Board? _selectedBoard;
  List<ItemType> _itemTypes = [];
  List<Location> _locations = [];
  bool _isLoadingBoardItems = false;
  bool _isLoadingItemTypes = false;
  bool _isLoadingLocations = false;
  bool _isLoadingBoardDetails = false;
  bool _isPosting = false;
  String? _boardError;
  String? _itemTypeError; 
  String? _locationError;
  String? _boardDetailsError;
  String? _postError;

  List<BoardItem> get boards => _boardItems;
  Board? get selectedBoard => _selectedBoard;
  List<ItemType> get itemTypes => _itemTypes;
  List<Location> get locations => _locations;
  bool get isLoadingBoardItems => _isLoadingBoardItems;
  bool get isLoadingItemTypes => _isLoadingItemTypes;
  bool get isLoadingLocations => _isLoadingLocations;
  bool get isLoadingBoardDetails => _isLoadingBoardDetails;
  bool get isPosting => _isPosting;
  String? get boardError => _boardError;
  String? get itemTypeError => _itemTypeError;
  String? get locationError => _locationError;
  String? get boardDetailsError => _boardDetailsError;
  String? get postError => _postError;

  bool get isLoading => _isLoadingBoardItems || _isLoadingItemTypes || _isLoadingLocations || _isLoadingBoardDetails;

  BoardViewModel(
    this._itemtypesUsecase, 
    this._locationsUsecase, 
    this._myBoardsUsecase,
    this._lostBoardsUsecase,
    this._foundBoardsUsecase,
    this._detailedBoardUsecase,
    this._postLostBoardUseCase,
    this._postFoundBoardUseCase,
    this._deleteBoardUsecase,
    ) {
    initialize();
  }

  void initialize() async {
    await fetchItemTypes();
    await fetchLocations();
  }

  void _setLoadingBoards(bool loading) {
    if (_isLoadingBoardItems != loading) {
      _isLoadingBoardItems = loading;
      notifyListeners();
    }
  }

  void _setLoadingItemTypes(bool loading) {
    if (_isLoadingItemTypes != loading) {
      _isLoadingItemTypes = loading;
      notifyListeners();
    }
  }

  void _setLoadingLocations(bool loading) {
    if (_isLoadingLocations != loading) {
      _isLoadingLocations = loading;
      notifyListeners();
    }
  }

  void _setLoadingBoardDetails(bool loading) {
    if (_isLoadingBoardDetails != loading) {
      _isLoadingBoardDetails = loading;
      notifyListeners();
    }
  }

  void _setPosting(bool posting) {
    if (_isPosting != posting) {
      _isPosting = posting;
      notifyListeners();
    }
  }

  void _clearBoards() {
    _boardItems = [];
    _boardError = null;
  }

  void _clearSelectedBoard() {
    _selectedBoard = null;
    _boardError = null;
  }

  void _clearItemTypes() {
    _itemTypes = [];
    _itemTypeError = null;
  }

  void _clearLocations() {
    _locations = [];
    _locationError = null;
  }

  void clearBoardDetails() {
    _clearSelectedBoard();
    _boardDetailsError = null;
  }

  Future<void> fetchItemTypes() async {
    _clearItemTypes();
    _setLoadingItemTypes(true);

    try {
      final fetchedItemTypes = await _itemtypesUsecase.execute();
      _itemTypes = fetchedItemTypes;
      _itemTypeError = null; // 성공 시 오류 메시지 초기화
      print('BoardViewModel: 아이템 타입 목록 로드 성공 - ${fetchedItemTypes.length}개');
    } catch (e) {
      _itemTypes = []; // 실패 시 빈 리스트로 설정
      _itemTypeError = '아이템 종류를 불러오는 중 오류가 발생했습니다.';
      print('BoardViewModel: 아이템 타입 목록 로드 중 오류: $e');
    } finally {
      _setLoadingItemTypes(false);
    }
  }

  Future<void> fetchCategoricalBoardItems(String category) async {
    _clearBoards();
    _setLoadingBoards(true);
    
    try {
      if (category == 'lost') {
        _boardItems = await _lostBoardsUsecase.execute();
      } else if (category == 'found') {
        _boardItems = await _foundBoardsUsecase.execute();
      } else {
        _boardItems = [];
      }

      _boardError = null;
    } catch (e) {
      _boardItems = [];
      _boardError = '게시글을 불러오는 중 오류가 발생했습니다.';
    } finally {
      _setLoadingBoards(false);
    }
  }

  Future<void> fetchMyBoardItems() async {
    _clearBoards();
    _setLoadingBoards(true);

    try {
      _boardItems = await _myBoardsUsecase.execute();
      _boardError = null; // 성공 시 오류 메시지 초기화
      print('BoardViewModel: 내 게시글 목록 로드 성공 - ${_boardItems.length}개');
    } catch (e) {
      _boardItems = []; // 실패 시 빈 리스트로 설정
      _boardError = '내 게시글을 불러오는 중 오류가 발생했습니다.';
      print('BoardViewModel: 내 게시글 목록 로드 중 오류: $e');
    } finally {
      _setLoadingBoards(false);
    }
  }

  Future<void> fetchLocations() async {
    _clearLocations();
    _setLoadingLocations(true);

    try {
      final fetchedLocations = await _locationsUsecase.execute();
      _locations = fetchedLocations;
      _locationError = null; // 성공 시 오류 메시지 초기화
      print('BoardViewModel: 위치 목록 로드 성공 - ${_locations.length}개');
    } catch (e) {
      _locations = []; // 실패 시 빈 리스트로 설정
      _locationError = '위치를 불러오는 중 오류가 발생했습니다.';
      print('BoardViewModel: 위치 목록 로드 중 오류: $e');
    } finally {
      _setLoadingLocations(false);
    }
  }

  Future<bool> postLostBoard({
    required title,
    required detailedLocation,
    required description,
    required relatedDate,
    required image,
    required category,
    required itemTypeId,
    required locationId,
  }) async {
    _setPosting(true);
    _postError = null;

    bool success = false;

    try {
      final result = await _postLostBoardUseCase.execute(
        title: title,
        detailedLocation: detailedLocation,
        description: description,
        relatedDate: relatedDate,
        image: image,
        category: category,
        itemTypeId: itemTypeId,
        locationId: locationId,
      );

      if (result != null) {
        print('BoardViewModel: 게시글 작성 성공 - ID: $result');
        success = true;
      } else {
        _postError = '게시글 작성에 실패했습니다.';
        print('BoardViewModel: 게시글 작성 실패 - 서버에서 null 반환');
      }
    } on ArgumentError catch (e) {
      _postError = e.message;
      _isPosting = false;
    } catch (e) {
      _postError = '게시글 등록에 실패했습니다. 잠시 후 다시 시도해주세요. : $e';
      _isPosting = false;
    } finally {
      _setPosting(false);
    }
    return success;
  }

  Future<bool> postFoundBoard({
    required title,
    required detailedLocation,
    required description,
    required relatedDate,
    required image,
    required category,
    required itemTypeId,
    required locationId,
  }) async {
    _setPosting(true);
    _postError = null;

    bool success = false;

    try {
      final result = await _postFoundBoardUseCase.execute(
        title: title,
        detailedLocation: detailedLocation,
        description: description,
        relatedDate: relatedDate,
        image: image,
        category: category,
        itemTypeId: itemTypeId,
        locationId: locationId,
      );

      if (result != null) {
        print('BoardViewModel: 게시글 작성 성공 - ID: $result');
        success = true;
      } else {
        _postError = '게시글 작성에 실패했습니다.';
        print('BoardViewModel: 게시글 작성 실패 - 서버에서 null 반환');
      }
    } on ArgumentError catch (e) {
      _postError = e.message;
      _isPosting = false;
    } catch (e) {
      _postError = '게시글 등록에 실패했습니다. 잠시 후 다시 시도해주세요. : $e';
      _isPosting = false;
    } finally {
      _setPosting(false);
    }
    return success;
  }

  Future<void> fetchBoardDetails(int boardId) async {
    _clearSelectedBoard();
    _setLoadingBoards(true);

    try {
      _selectedBoard = await _detailedBoardUsecase.execute(boardId);
      if (_selectedBoard != null) {
        _boardDetailsError = null; // 성공 시 오류 메시지 초기화
        print('BoardViewModel: 게시글 상세 정보 로드 성공 - ID: $boardId');
      } else {
        _boardDetailsError = '게시글을 찾을 수 없습니다.';
      }
    } catch (e) {
      _boardDetailsError = '게시글 상세 정보를 불러오는 중 오류가 발생했습니다.';
      print('BoardViewModel: 게시글 상세 정보 로드 중 오류: $e');
    } finally {
      _setLoadingBoards(false);
    }
  }

  Future<bool> deleteBoard(int boardId) async {
    _setPosting(true);
    _postError = null;

    bool success = false;

    try {
      final result = await _deleteBoardUsecase.execute(boardId);

      if (result) {
        print('BoardViewModel: 게시글 삭제 성공 - ID: $boardId');
        success = true;
      } else {
        _postError = '게시글 삭제에 실패했습니다.';
        print('BoardViewModel: 게시글 삭제 실패 - 서버에서 false 반환');
      }
    } catch (e) {
      _postError = '게시글 삭제 중 오류가 발생했습니다. 잠시 후 다시 시도해주세요. : $e';
      print('BoardViewModel: 게시글 삭제 중 오류: $e');
    } finally {
      _setPosting(false);
    }
    return success;
  }
}