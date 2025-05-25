import 'package:ajoufinder/domain/entities/alarm.dart';

abstract class AlarmRepository {
  Future<List<Alarm>> getAllAlarmsByUserId(int userId);
  Future<void> addNewAlarm(Alarm notification);
  Future<void> markAsRead(int alarmId);
}