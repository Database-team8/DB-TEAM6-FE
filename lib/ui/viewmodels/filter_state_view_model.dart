import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/usecases/boards/board_statuses_usecase.dart';
import 'package:ajoufinder/domain/usecases/itemtype/itemtypes_usecase.dart';
import 'package:ajoufinder/domain/usecases/location/locations_usecase.dart';
import 'package:flutter/widgets.dart';

class FilterStateViewModel extends ChangeNotifier{
  final LocationsUsecase _locationsUsecase;
  final ItemtypesUsecase _itemTypesUsecase;
  final BoardStatusesUsecase _boardStatusesUsecase;

  FilterStateViewModel(
    this._locationsUsecase,
    this._itemTypesUsecase,
    this._boardStatusesUsecase,
  ) {
    _initialize();
  }
  List<Location> _availableLocations = [];
  List<ItemType> _availableItemTypes = [];
  List<String> _availableStatuses = [];

  bool _isLoadingLocations = false;
  bool _isLoadingItemTypes = false;
  bool _isLoadingStatuses = false;

  String? _locationsError;
  String? _itemTypesError;
  String? _statusesError;

  Location? _selectedLocation;
  ItemType? _selectedItemType;
  String? _selectedStatus;
  DateTime? _startDate;
  DateTime? _endDate;

  List<String> get availableStatuses => _availableStatuses;
  List<Location> get availableLocations => _availableLocations;
  List<ItemType> get availableItemTypes => _availableItemTypes;

  bool get isLoadingLocations => _isLoadingLocations;
  bool get isLoadingItemTypes => _isLoadingItemTypes;
  bool get isLoadingStatuses => _isLoadingStatuses;

  String? get locationsError => _locationsError;
  String? get itemTypesError => _itemTypesError;
  String? get statusesError => _statusesError;

  Location? get selectedLocation => _selectedLocation;
  ItemType? get selectedItemType => _selectedItemType;
  String? get selectedStatus => _selectedStatus;
  DateTime? get startDate => _startDate;
  DateTime? get endDate => _endDate;

  void setSelectedLocation(Location? location) {
    if (_selectedLocation?.id != location?.id) {
      _selectedLocation = location;
      notifyListeners();
    }
  }

  void setSelectedItemType(ItemType? itemType) {
    if (_selectedItemType?.id != itemType?.id) {
      _selectedItemType = itemType;
      notifyListeners();
    }
  }

  void setSelectedStatus(String? status) {
    if (_selectedStatus != status) {
      _selectedStatus = status;
      notifyListeners();
    }
  }
  void setStartDate(DateTime? date) {
    if (_startDate != date) {
      _startDate = date;
      notifyListeners();
    }
  }
  void setEndDate(DateTime? date) {
    if (_endDate != date) {
      _endDate = date;
      notifyListeners();
    }
  }
  void resetFilters() {
    _selectedLocation = null;
    _selectedItemType = null;
    _selectedStatus = null;
    _startDate = null;
    _endDate = null;
    notifyListeners();
  }

  void _initialize() async {
    await fetchLocations();
    await fetchItemTypes();
    await fetchStatuses();
  }

  Future<void> fetchLocations() async {
    _clearLocations();
    _setLoadingLocations(true);

    try {
      final fetchedLocations = await _locationsUsecase.execute();
      _availableLocations = fetchedLocations;
      _locationsError = null;
      print('FilterStateViewModel : 위치 목록 로드 성공 : ${_availableLocations.length} 개의'); 
    } catch (e) {
      _availableLocations = [];
      _locationsError = '위치 목록 로드 실패: $e';
      print('FilterStateViewModel : 위치 목록 로드 실패 : $e');
      rethrow; // 예외를 다시 던져서 상위 계층에서 처리하도록 함
    } finally {
      _setLoadingLocations(false);
    }
  }
  
  void _clearLocations() {
    _availableLocations = [];
    _selectedLocation = null;
    _locationsError = null;
  }
  
  void _setLoadingLocations(bool loading) {
    if (_isLoadingLocations != loading) {
      _isLoadingLocations = loading;
      notifyListeners();
    }
  }

  Future<void> fetchItemTypes() async {
    _clearItemTypes();
    _setLoadingItemTypes(true);

    try {
      final fetchedItemTypes = await _itemTypesUsecase.execute();
      _availableItemTypes = fetchedItemTypes;
      _itemTypesError = null;
      print('FilterStateViewModel : 아이템타입 목록 로드 성공 : ${_availableItemTypes.length} 개'); 
    } catch (e) {
      _availableItemTypes = [];
      _itemTypesError = '아이템타입 목록 로드 실패: $e';
      print('FilterStateViewModel : 아이템타입 목록 로드 실패 : $e');
      rethrow; // 예외를 다시 던져서 상위 계층에서 처리하도록 함
    } finally {
      _setLoadingItemTypes(false);
    }
  }

  void _clearItemTypes() {
    _availableItemTypes = [];
    _selectedItemType = null;
    _itemTypesError = null;
  }
  
  void _setLoadingItemTypes(bool loading) {
    if (_isLoadingItemTypes != loading) {
      _isLoadingItemTypes = loading;
      notifyListeners();
    }
  }
  
  Future<void> fetchStatuses() async {
    _clearStatuses();
    _setLoadingStatuses(true);

    try {
      final fetchedStatuses = await _boardStatusesUsecase.execute();
      _availableStatuses = fetchedStatuses;
      _statusesError = null;
      print('FilterStateViewModel : 게시글 상태 목록 로드 성공 : ${_availableStatuses.length} 개'); 
    } catch (e) {
      _availableStatuses = [];
      _statusesError = '게시글 상태 목록 로드 실패: $e';
      print('FilterStateViewModel : 게시글 상태 목록 로드 실패 : $e');
      rethrow; // 예외를 다시 던져서 상위 계층에서 처리하도록 함
    } finally {
      _setLoadingStatuses(false);
    }
  }
  
  void _setLoadingStatuses(bool loading) {
    if (_isLoadingStatuses != loading) {
      _isLoadingStatuses = loading;
      notifyListeners();
    }
  }
  
  void _clearStatuses() {
    _availableStatuses = [];
    _selectedStatus = null;
    _statusesError = null;
  }
}