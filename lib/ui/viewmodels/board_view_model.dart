import 'package:ajoufinder/domain/entities/board.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:flutter/material.dart';

class BoardViewModel extends ChangeNotifier{
  List<Board> _boards = [];
  bool _isLoading = false;
  String? _error;

  List<Board> get boards => _boards;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clear() {
    _boards = [];
    _error = null;
  }

  Future<void> fetchBoards({String? category, int? uuid}) async {
    _clear();
    final repository = getIt<BoardRepository>();
    _setLoading(true);
    
    try {
      if (category == null && uuid != null) {
        _boards = await repository.getAllBoardsByUserId(uuid);
      }else if (category != null && uuid == null) {
        _boards = await repository.getAllBoardsByCategory(category);
      }else {
        throw UnimplementedError();
      }

      _error = null;
    } catch (e) {
      _error = '게시글을 불러오는 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }

  Future<void> addBoard() async {

  }
}