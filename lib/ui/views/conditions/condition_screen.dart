import 'package:ajoufinder/ui/shared/widgets/condition_list_widget.dart';
import 'package:ajoufinder/ui/viewmodels/condition_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConditionScreen extends StatefulWidget {
  const ConditionScreen({super.key});

  @override
  State<ConditionScreen> createState() => _ConditionScreenState();
}

class _ConditionScreenState extends State<ConditionScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchConditions();
    });
  }

  Future<void> _fetchConditions() async {
   await Provider.of<ConditionViewModel>(context, listen:false).fetchConditions();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    
    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: _buildBody(context)
      ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final conditionViewModel = Provider.of<ConditionViewModel>(context);
    final theme = Theme.of(context);

    if (conditionViewModel.isLoading &&  conditionViewModel.conditions.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    }

    if (conditionViewModel.conditionsError != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
              const SizedBox(height: 16),
              Text(
                conditionViewModel.conditionsError!,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh, color: theme.colorScheme.onError),
                label: Text('다시 시도', style: TextStyle(color: theme.colorScheme.onError)),
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                onPressed: _fetchConditions,
              )
            ],
          ),
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _fetchConditions,
      color: theme.colorScheme.primary,
      child: ConditionListWidget(
        conditions: conditionViewModel.conditions,
      ),
    );
  }
}
