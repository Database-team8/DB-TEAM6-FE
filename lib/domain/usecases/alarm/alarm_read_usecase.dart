import 'package:ajoufinder/data/dto/alarm/alarm_read/alrarm_read_request.dart';
import 'package:ajoufinder/domain/repository/alarm_repository.dart';

class AlarmReadUsecase {
 final AlarmRepository _alarmRepository;

 AlarmReadUsecase(this._alarmRepository);

 Future<bool> execute(int alarmId) async {
  try {
    await _alarmRepository.markAsRead(AlarmReadRequest(alarmId: alarmId));
    print('markAsRead 성공 (Usecase)');
    return true;
  } catch (e) {
    print('markAsRead 유스케이스 실행 중 오류 발생: $e');
    rethrow;
  }
 } 
}