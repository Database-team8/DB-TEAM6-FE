import 'package:ajoufinder/data/dto/alarm/alarm_read/alarm_read_response.dart';
import 'package:ajoufinder/data/dto/alarm/alarm_read/alrarm_read_request.dart';
import 'package:ajoufinder/data/dto/alarm/alarms/alarms_response.dart';

abstract class AlarmRepository {
  Future<AlarmsResponse> getAlarms();
  Future<AlarmReadResponse> markAsRead(AlarmReadRequest request);
  Future<void> readAll();
}