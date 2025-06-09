import 'package:ajoufinder/domain/entities/alarm.dart';

class AlarmsResponse {
  final List<Alarm> alarms;

  AlarmsResponse({required this.alarms});

  factory AlarmsResponse.fromJson(List<dynamic>? jsonList) {
    return AlarmsResponse(
      alarms: (jsonList == null)
          ? <Alarm>[]
          : jsonList
              .map((item) => Alarm.fromJson(item as Map<String, dynamic>))
              .toList(),
    );
  }
}
