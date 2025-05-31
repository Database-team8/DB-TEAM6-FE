import 'package:ajoufinder/domain/entities/alarm.dart';
import 'package:ajoufinder/domain/repository/alarm_repository.dart';

class MyAlarmsUsecase {
  final AlarmRepository _alarmRepository;

  MyAlarmsUsecase(this._alarmRepository);

  Future<List<Alarm>> execute() async {
    throw UnimplementedError('MyCommentsUsecase는 아직 구현되지 않았습니다.');
  }
}