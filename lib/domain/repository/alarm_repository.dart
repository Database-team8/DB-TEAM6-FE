import 'package:ajoufinder/data/dto/alarm/alarms/alarms_response.dart';
import 'package:ajoufinder/domain/entities/alarm.dart';

abstract class AlarmRepository {
  Future<AlarmsResponse> getAlarms();
  Future<void> addNewAlarm(Alarm notification);
  Future<void> markAsRead(int alarmId);
}