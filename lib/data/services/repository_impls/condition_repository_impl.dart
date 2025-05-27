import 'package:ajoufinder/domain/entities/condition.dart';
import 'package:ajoufinder/domain/repository/condition_repository.dart';

class ConditionRepositoryImpl extends ConditionRepository{

  @override
  Future<void> addNewCondition(Condition condition) async {
    throw UnimplementedError();  
  }

  @override
  Future<List<Condition>> getAllConditions(int userId) async {
    await Future.delayed(Duration(milliseconds: 500));
    return [
      Condition(
        id: 1, 
        itemTypeId: 1, 
        userId: userId, 
        status: 'category'
      )
    ];
  }

}