import 'package:ajoufinder/domain/entities/alarm.dart';
import 'package:ajoufinder/domain/usecases/alarm/alarm_read_usecase.dart';
import 'package:ajoufinder/domain/usecases/alarm/alarms_read_all_usecase.dart';
import 'package:ajoufinder/domain/usecases/alarm/alarms_usecase.dart';
import 'package:flutter/material.dart';

class AlarmViewModel extends ChangeNotifier{
  final AlarmsUsecase _alarmsUsecase;
  final AlarmReadUsecase _alarmReadUsecase;
  final AlarmsReadAllUsecase _alarmsReadAllUsecase;

  AlarmViewModel(this._alarmsUsecase, this._alarmReadUsecase, this._alarmsReadAllUsecase);

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

  Future<void> fetchMyAlarms() async {
    _clear();
    _setLoading(true);

    try {
      _alarms = await _alarmsUsecase.execute();
      _error = null;
    } catch (e) {
      _error = '알림을 불러오는 중 오류가 발생했습니다.';
      _alarms = [];
    } finally {
      _setLoading(false);
    }
  }

  Future<void> markAsRead(int alarmId) async {
    _setLoading(true);

    bool success = false;

    try {
      success = await _alarmReadUsecase.execute(alarmId);

      if (success) {
        print('AlarmViewModel : markAsRead 성공');
      } else {
        print('AlarmViewModel : markAsRead 실패');
      }
    } on ArgumentError catch (e) {
      print('AlarmViewModel : $e');
    } catch (e) {
      print('AlarmViewModel : $e');
    } finally {
      _setLoading(false);
    }
  }

  Future<void> readAll() async {
    _setLoading(true);

    bool success = false;

    try {
      success = await _alarmsReadAllUsecase.execute();

      if (success) {
        print('AlarmViewModel : readAll 성공');
      } else {
        print('AlarmViewModel : readAll 실패');
      }
    } on ArgumentError catch (e) {
      print('AlarmViewModel : $e');
    } catch (e) {
      print('AlarmViewModel : $e');
    } finally {
      _setLoading(false);
    }
  }
}