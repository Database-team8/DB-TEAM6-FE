import 'package:ajoufinder/domain/entities/condition.dart';
import 'package:flutter/material.dart';

class ConditionListWidget extends StatelessWidget{
  final List<Condition> conditions;

  const ConditionListWidget({
    super.key, 
    required this.conditions
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (conditions.isEmpty) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.notifications_outlined,
            size: 70,
            color: theme.colorScheme.surface,
          ),
          SizedBox(height: 24),
          Text(
            '받은 키워드 알림이 없어요.',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.colorScheme.surface,
              fontSize: 18,
            ),
          ),
        ],
      );
    } else {
      
      return ListView.builder(
        itemCount: conditions.length,
        itemBuilder: (context, index) => _ConditionCard(condition: conditions[index])
      );
    }
  }
}

class _ConditionCard extends StatefulWidget{
  final Condition condition;

  const _ConditionCard({required this.condition,});

  @override
  State<StatefulWidget> createState() => _ConditionCardState();
}

class _ConditionCardState extends State<_ConditionCard> {
  bool _isLoading = true;

  @override
  Widget build(BuildContext context) {

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 12.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          //_buildLocationalConditionArgument(),
          SizedBox(width: 12,),
          //_buildTypeConditionArgument(),
          SizedBox(width: 12,),
        ],
      ),
      );
  }
}