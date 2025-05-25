import 'package:ajoufinder/domain/repository/alarm_repository.dart';
import 'package:ajoufinder/domain/entities/alarm.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:flutter/material.dart';

class AlarmViewModel extends ChangeNotifier{
  final _repository = getIt<AlarmRepository>();

  List<Alarm> _alarms = [];
  bool _isLoading = false;
  String? _error;

  List<Alarm> get alarms => _alarms;
  bool get isLoading => _isLoading;
  String? get error => _error;

  void _setLoading(bool loading) {
    _isLoading = loading;
    notifyListeners();
  }

  void _clear() {
    _alarms = [];
    _error = null;
  }  

  bool hasNewAlarms() => _alarms.any((alarm) => !alarm.isRead);

  Future<void> fetchAlarms({required int uuid}) async {
    _clear();
    _setLoading(true);

    try {
      _alarms = await _repository.getAllAlarmsByUserId(uuid);
      _error = null;
    } catch (e) {
      _error = '알림을 불러오는 중 오류가 발생했습니다.';
      _alarms = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markAsRead(int alarmId) async {
    final index = _alarms.indexWhere((alarm) => alarm.id == alarmId);

    if (index != -1) {
      if (!_alarms[index].isRead) {
        try {
          await _repository.markAsRead(alarmId);
          _alarms[index].isRead = true;
      } catch (e) {
        _error = '읽음 표시 중 문제가 발생했습니다.';
      } finally {
        notifyListeners();
      }
    }
  } 
  }
}