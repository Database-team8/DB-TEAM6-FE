import 'package:ajoufinder/domain/utils/action_bar_type.dart';
import 'package:ajoufinder/ui/viewmodels/navigator_bar_view_model.dart';
import 'package:flutter/material.dart';

class PageViewModel extends ChangeNotifier{
  final NavigatorBarViewModel navigatorBarViewModel;
  
  bool _showFab = false;
  IconData? _fabIconData;
  String? _fabLabelText;

  bool _showAppbar = false;
  bool _extendAppbar = false;
  bool _isSearchBarWidgetActivated = false;
  void Function(String query)? _performSearch;
  VoidCallback? _onClear;
  VoidCallback? _toggleSearchBarWidgetActivated;
  final _searchController = TextEditingController();
  final _searchFocusNode = FocusNode();
  String? _hintText;
  List<ActionBarType> _actionTypes = [];

  bool get showFab => _showFab;
  IconData? get fabIconData => _fabIconData;
  String? get fabLabelText => _fabLabelText;

  bool get showAppbar => _showAppbar;
  bool get extendAppbar => _extendAppbar;
  bool get isSearchBarWidgetActivated => _isSearchBarWidgetActivated;
  void Function(String query)? get performSearch => _performSearch;
  VoidCallback? get onClear => _onClear;
  VoidCallback? get toggleSearchBarWidgetActivated => _toggleSearchBarWidgetActivated;
  TextEditingController get searchController => _searchController;
  FocusNode get searchFocusNode => _searchFocusNode;
  String? get hintText => _hintText;
  List<ActionBarType> get actionTypes => _actionTypes;

  PageViewModel(this.navigatorBarViewModel) {
    navigatorBarViewModel.addListener(_onNavBarChanged);
    _searchFocusNode.addListener(_onSearchFocusChanged);
    _applyConfig(navigatorBarViewModel.currentIndex);
  }

  void _clearFab() {
    _showFab = false;
    _fabIconData = null;
    _fabLabelText = null;
  }

  @override
  void dispose() {
    navigatorBarViewModel.removeListener(_onNavBarChanged);
    _searchFocusNode.removeListener(_onSearchFocusChanged);
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _onSearchFocusChanged() {
    if (_showAppbar && !_isSearchBarWidgetActivated) {
      // 수동으로 검색바를 활성화하지 않았지만 포커스가 있는 경우
      if (_searchFocusNode.hasFocus) {
        _actionTypes = []; // 액션 버튼들 숨기기
      } else {
        // 포커스를 잃었을 때 원래 액션 버튼들 복원
        _restoreActionTypes();
      }
      notifyListeners(); // UI 업데이트
    }
  }

  void _restoreActionTypes() {
    final currentIndex = navigatorBarViewModel.currentIndex;
    if (currentIndex == 0 || currentIndex == 1 || currentIndex == 2) {
      _actionTypes = [ActionBarType.configCondtions, ActionBarType.alarms];
    }
  }

  void _clearAppbar() {
    _showAppbar = false;
    _extendAppbar = false;
    _isSearchBarWidgetActivated = false;
    _onClear = null;
    _toggleSearchBarWidgetActivated = null;
    _performSearch = null;
    _searchController.clear();
    _searchFocusNode.unfocus();
    _hintText = null;
    _actionTypes = [];
  }

   void _onNavBarChanged() {
    _applyConfig(navigatorBarViewModel.currentIndex);
  }

  void _applyConfig(int barIndex) {
    configureFab(barIndex);
    configureAppbar(barIndex);
    notifyListeners();
  }

  void configureFab(int barIndex) {
    if (barIndex == 0) {
      _showFab = true;
      _fabIconData = Icons.add_rounded;
      _fabLabelText = '잃어버렸어요';
    }
    else if (barIndex == 1) {
      _showFab = true;
      _fabIconData = Icons.add_rounded;
      _fabLabelText = '주웠어요';
    } else {
      _hideFab();
    }  
    notifyListeners();
  }

  void configureAppbar(int barIndex) {
    switch (barIndex) {
      case 0:
        _actionTypes = [ActionBarType.configCondtions, ActionBarType.alarms];
        _showAppbar = true;
        _extendAppbar = true;
        _onClear = () {
          //추후 작성
        };
        _performSearch = (query) {
          print('검색어: $query');
        };
        _toggleSearchBarWidgetActivated = () {
          _isSearchBarWidgetActivated = !_isSearchBarWidgetActivated;
          
          if (_isSearchBarWidgetActivated) {
            _actionTypes = [];
            Future.delayed(const Duration(microseconds: 75),() {
              _searchFocusNode.requestFocus();
            }
          );
          } else {
            _searchController.clear();
            _actionTypes = [ActionBarType.configCondtions, ActionBarType.alarms];
          }
          notifyListeners();
        };
        _hintText = '분실글 검색';
        break;
      case 1:
        _actionTypes = [ActionBarType.configCondtions, ActionBarType.alarms];
        _showAppbar = true;
        _extendAppbar = true;
        _onClear = () {
          //추후 작성
        };
        _performSearch = (query) {
          print('검색어: $query');
        };
        _toggleSearchBarWidgetActivated = () {
          _isSearchBarWidgetActivated = !_isSearchBarWidgetActivated;
          
          if (_isSearchBarWidgetActivated) {
            _actionTypes = [];
            Future.delayed(const Duration(microseconds: 75),() {
              _searchFocusNode.requestFocus();
            }
          );
          } else {
            _searchController.clear();
            _actionTypes = [ActionBarType.configCondtions, ActionBarType.alarms];
          }
          notifyListeners();
        };
        _hintText = '분실글 검색';
        break;
      case 2:
        _actionTypes = [ActionBarType.configCondtions, ActionBarType.alarms];
        _showAppbar = true;
        _extendAppbar = true;
        _onClear = () {
          //추후 작성
        };
        _performSearch = (query) {
          print('검색어: $query');
        };
        _toggleSearchBarWidgetActivated = () {
          _isSearchBarWidgetActivated = !_isSearchBarWidgetActivated;
          
          if (_isSearchBarWidgetActivated) {
            _actionTypes = [];
            Future.delayed(const Duration(microseconds: 75),() {
              _searchFocusNode.requestFocus();
            }
          );
          } else {
            _searchController.clear();
            _actionTypes = [ActionBarType.configCondtions, ActionBarType.alarms];
          }
          notifyListeners();
        };
        _hintText = '장소 검색';
        break;
      default:
        _hideAppbar();
        break;
    }
    notifyListeners();
  }

  void _hideFab() {
    _showFab = false;
    _clearFab();
  }

  void _hideAppbar() {
    _showAppbar = false;
    _clearAppbar();
  }
}