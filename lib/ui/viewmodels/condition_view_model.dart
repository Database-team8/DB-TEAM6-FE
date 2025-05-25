import 'package:ajoufinder/domain/entities/condition.dart';
import 'package:ajoufinder/domain/repository/condition_repository.dart';
import 'package:ajoufinder/injection_container.dart';
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

  Future<void> fetchConditions({required int uuid}) async {
    _clear();
    final repository = getIt<ConditionRepository>();
    _setLoading(true);

    try {
      _conditions = await repository.getAllConditions(uuid);
      _error = null;
    } catch (e) {
      _error = '조건을 불러오는 중 오류가 발생했습니다.';
    } finally {
      _setLoading(false);
    }
  }
}