import 'package:ajoufinder/domain/entities/condition.dart';
import 'package:ajoufinder/ui/viewmodels/condition_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConditionListWidget extends StatelessWidget {
  const ConditionListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final conditionViewModel = context.watch<ConditionViewModel>();
    final List<Condition> conditions = conditionViewModel.conditions;
    
    if (conditions.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.filter_none_rounded,
              size: 70,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              '설정해 둔 관심 물품 조건이 없어요.',
              textAlign: TextAlign.center,
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.surfaceTint,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '새로운 조건을 추가하여 알림을 받아보세요.',
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    } else {
      return ListView.builder(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        itemCount: conditions.length,
        itemBuilder: (context, index) =>
            _ConditionCard(condition: conditions[index]),
      );
    }
  }
}
class _ConditionCard extends StatelessWidget {
  final Condition condition;

  const _ConditionCard({super.key, required this.condition});

  Future<void> _deleteCondition(BuildContext context) async {
    final conditionViewModel = context.read<ConditionViewModel>();

    try {
      final success = await conditionViewModel.deleteCondition(condition.id);
      if (success) {
        print('조건 삭제 성공');
      } else {
        return;
      }
    } catch (e) {
      print('Condition 삭제 중 오류 발생 : ${conditionViewModel.deletingError}');
    } 
  }

  Widget _buildInfoChip(BuildContext context, IconData icon, String label, String value) {
    final theme = Theme.of(context);
    if (value.isEmpty) return const SizedBox.shrink();

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: theme.colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 16, color: theme.colorScheme.onSurfaceVariant),
          const SizedBox(width: 6),
          Text(
            '$label: ',
            style: theme.textTheme.labelMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
              fontWeight: FontWeight.w400,
              fontSize: 13.5,
            ),
          ),
          Flexible(
            child: Text(
              value,
              style: theme.textTheme.labelMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
                fontWeight: FontWeight.w400,
                fontSize: 13.5,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    String locationDisplay = condition.location.isNotEmpty
        ? condition.location
        : '전체';

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      elevation: 6.0,
      shadowColor: theme.colorScheme.shadow,
      color: theme.colorScheme.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12.0),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Wrap(
                spacing: 8.0,
                runSpacing: 8.0,
                children: [
                  _buildInfoChip(context, Icons.shopping_bag_outlined, "종류", condition.itemType),
                  _buildInfoChip(context, Icons.place_outlined, "지역", locationDisplay),
                ],
              ),
            ),
            IconButton(
              icon: Icon(Icons.delete_outline, color: theme.colorScheme.error),
              onPressed: () => _deleteCondition(context),
              tooltip: '조건 삭제',
            ),
          ],
        ),
      ),
    );
  }
}
