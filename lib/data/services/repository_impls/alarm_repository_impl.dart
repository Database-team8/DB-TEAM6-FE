import 'package:ajoufinder/domain/entities/alarm.dart';
import 'package:ajoufinder/domain/repository/alarm_repository.dart';

class AlarmRepositoryImpl extends AlarmRepository{

  @override
  Future<List<Alarm>> getAllAlarmsByUserId(int userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Alarm(
        id: 1, 
        userId: userId, 
        content: '알림1', 
        relatedUrl: 'example.com', 
        isRead: true, 
        createdAt: DateTime(2021,1,1,),
      ),
    ];
  }

  @override
  Future<void> addNewAlarm(Alarm notification) async {
    throw UnimplementedError();
  }
  
  @override
  Future<void> markAsRead(int alarmId) {
    // TODO: implement markAsRead
    throw UnimplementedError();
  }
}