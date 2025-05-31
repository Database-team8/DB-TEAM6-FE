import 'package:ajoufinder/domain/entities/condition.dart';
import 'package:flutter/material.dart';

class ConditionViewModel extends ChangeNotifier{
  List<Condition> _conditions = [];
  bool _isLoading = false;
  String? _error;

  List<Condition> get conditions => _conditions;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clear() {
    _conditions = [];
    _error = null;
  }

  Future<void> fetchConditions() async {
    throw UnimplementedError('ConditionViewModel: fetchConditions 메서드는 아직 구현되지 않았습니다.');
    /**cookie 이용해서 구현하기 */
  }
}