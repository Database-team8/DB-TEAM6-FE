import 'package:ajoufinder/domain/entities/condition.dart';

abstract class ConditionRepository {
  Future<List<Condition>> getAllConditions(int userId);
  Future<void> addNewCondition(Condition condition);
}