import 'package:ajoufinder/domain/repository/alarm_repository.dart';

class AlarmsReadAllUsecase {
  final AlarmRepository _alarmRepository;
  
  AlarmsReadAllUsecase(this._alarmRepository);

  Future<bool> execute() async {
    try {
    await _alarmRepository.readAll();
    print('readAll 성공 (Usecase)');
    return true;
  } catch (e) {
    print('readAll 유스케이스 실행 중 오류 발생: $e');
    rethrow;
  }
  }
}