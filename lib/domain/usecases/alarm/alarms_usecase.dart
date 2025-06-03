import 'package:ajoufinder/domain/entities/alarm.dart';
import 'package:ajoufinder/domain/repository/alarm_repository.dart';

class AlarmsUsecase {
  final AlarmRepository _alarmRepository;

  AlarmsUsecase(this._alarmRepository);

  Future<List<Alarm>> execute() async {
    try {
      final response = await _alarmRepository.getAlarms();
      final alarms = response.alarms;

      if (alarms.isNotEmpty) {
        print('알림 조회 성공 (Usecase): ${alarms.length}개 알림');
        return alarms;
      } else {
        print('알림 조회 실패 (Usecase - isSuccess:false or result:null): 알림이 없습니다.');
        // 알림이 없을 경우 빈 리스트를 반환
        return [];
      }
    } catch (e) {
      // 네트워크 오류 또는 리포지토리에서 발생한 기타 예외 처리
      print('알림 조회 유스케이스 실행 중 오류 발생: $e');
      // 필요에 따라 특정 타입의 예외로 변환하여 다시 던지거나 빈 리스트를 반환합니다.
      // 여기서는 빈 리스트를 반환합니다.
      return [];
    }
  }
}