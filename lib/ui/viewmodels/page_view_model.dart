import 'package:ajoufinder/domain/utils/action_bar_type.dart';
import 'package:flutter/material.dart';

class PageViewModel extends ChangeNotifier{
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

  void _clearFab() {
    _showFab = false;
    _fabIconData = null;
    _fabLabelText = null;
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
        _showAppbar = true;
        _extendAppbar = true;
        _onClear = () {
          //추후 작성
        };
        _toggleSearchBarWidgetActivated = () {
          _isSearchBarWidgetActivated = !_isSearchBarWidgetActivated;
          
          if (_isSearchBarWidgetActivated) {
            Future.delayed(const Duration(microseconds: 75),() {
              _searchFocusNode.requestFocus();
              _actionTypes = [ActionBarType.close];
            }
          );
          } else {
            _searchController.clear();
            _searchController.clear();
            _actionTypes = [ActionBarType.filter, ActionBarType.alarms];
          }
        };
        _performSearch = (query) {
          //추후 작성
        };
        _actionTypes = [ActionBarType.filter, ActionBarType.alarms];
        _hintText = '분실글 검색';
        break;
      case 1:
        _showAppbar = true;
        _extendAppbar = true;
        _onClear = () {
          //추후 작성
        };
        _toggleSearchBarWidgetActivated = () {
          _isSearchBarWidgetActivated = !_isSearchBarWidgetActivated;
          
          if (_isSearchBarWidgetActivated) {
            Future.delayed(const Duration(microseconds: 75),() {
              _searchFocusNode.requestFocus();
            }
          );
          } else {
            _searchController.clear();
            _searchController.clear();
          }
        };
        _performSearch = (query) {
          //추후 작성
        };
        _actionTypes = [ActionBarType.filter, ActionBarType.alarms];
        _hintText = '분실글 검색';
        break;
      case 2:
        //_showAppbar = true;
        //_extendAppbar = false;
        _hideAppbar();
        //추후 작성
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