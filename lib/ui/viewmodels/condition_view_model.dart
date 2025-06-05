import 'package:ajoufinder/domain/entities/condition.dart';
import 'package:ajoufinder/domain/usecases/condition/conditions_usecase.dart';
import 'package:ajoufinder/domain/usecases/condition/delete_condition_usecase.dart';
import 'package:ajoufinder/domain/usecases/condition/post_condition_usecase.dart';
import 'package:flutter/material.dart';

class ConditionViewModel extends ChangeNotifier{
  final ConditionsUsecase _conditionsUsecase;
  final PostConditionUsecase _postConditionUsecase;
  final DeleteConditionUsecase _deleteConditionUsecase;

  List<Condition> _conditions = [];
  bool _isLoading = false;
  bool _isPosting = false;
  bool _isDeleting = false;
  String? _conditionsError;
  String? _postingError;
  String? _deletingError;

  List<Condition> get conditions => _conditions;
  bool get isLoading => _isLoading;
  bool get isPosting => _isPosting;
  bool get isDeleting => _isDeleting;
  String? get conditionsError => _conditionsError;
  String? get postingError => _postingError;
  String? get deletingError => _deletingError;

  ConditionViewModel(
    this._conditionsUsecase, 
    this._postConditionUsecase,
    this._deleteConditionUsecase,
    ) {
    initialize();
  }

  void initialize() async {
    await fetchConditions();
  }

  void _setLoading(bool loading) {
    if (_isLoading != loading) {
      _isLoading = loading;
      notifyListeners();
    }
  }

  void _setPosting(bool posting) {
    if (_isPosting != posting) {
      _isPosting = posting;
      notifyListeners();
    }
  }

  void _setDeleting(bool deleting) {
    if (_isDeleting != deleting) {
      _isDeleting = deleting;
      notifyListeners();
    }
  }

  void _clear() {
    _conditions = [];
    _conditionsError = null;
  }

  Future<void> fetchConditions() async {
    _setLoading(true);
    _clear();

    try {
      final result = await _conditionsUsecase.execute();
      if (result.isEmpty) {
        _conditions = [];
        _conditionsError = '조건이 없습니다.';
        print('조건 조회 결과가 비어있습니다.');
      } else {
        _conditions = result;
        _conditionsError = null;
        print('조건 조회 성공: ${result.length}개');
      }
      _conditions = conditions;
      _conditionsError = null;
      print('조건 조회 성공: ${conditions.length}개');
    } catch (e) {
      _conditions = [];
      _conditionsError = e.toString();
      print('조건 조회 실패: $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<bool> postCondition(int itemTypeId, int locationId) async {
    _setPosting(true);
    _postingError = null;

    try {
      final result = await _postConditionUsecase.execute(itemTypeId: itemTypeId, locationId: locationId);
      if (result) {
        print('조건 등록 성공');
        _postingError = null;
        return true;
      } else {
        _postingError = '조건 등록 실패';
        print('조건 등록 실패');
        return false;
      }
    } catch (e) {
      _postingError = e.toString();
      print('조건 등록 중 오류 발생: $e');
      return false;
    } finally {
      _setPosting(false);
    }
  }

  Future<bool> deleteCondition(int conditionId) async {
    _setDeleting(true);
    _deletingError = null;

    try {
      final result = await _deleteConditionUsecase.execute(conditionId);

      if (result) {
        print('조건 삭제 성공');
        await fetchConditions();
        _deletingError = null;
        return true;
      } else {
        print('조건 삭제 실패');
        _deletingError = '조건 삭제 실패';
        return false;
      }
    } catch (e) {
      _deletingError = e.toString();
      print('조건 등록 중 오류 발생 : $e');
      return false;
    } finally {
      _setDeleting(false);
    }
  }
}