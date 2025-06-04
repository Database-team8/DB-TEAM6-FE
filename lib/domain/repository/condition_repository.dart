import 'package:ajoufinder/data/dto/condition/conditions/conditions_response.dart';
import 'package:ajoufinder/data/dto/condition/post_condition.dart/post_condition_request.dart';
import 'package:ajoufinder/data/dto/condition/post_condition.dart/post_condition_response.dart';

abstract class ConditionRepository {
  Future<ConditionsResponse> getAllConditions();
  Future<PostConditionResponse> postCondition(PostConditionRequest request);
}