import 'package:ajoufinder/ui/shared/widgets/alarm_list_widget.dart';
import 'package:ajoufinder/ui/viewmodels/alarm_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/auth_view_model.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class AlarmScreen extends StatefulWidget {
  const AlarmScreen({super.key});

  @override
  State<AlarmScreen> createState() => _AlarmScreenState();
}

class _AlarmScreenState extends State<AlarmScreen> {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _fetchAlarms();
    });
  }

  Future<void> _fetchAlarms() async {
    final authViewModel = Provider.of<AuthViewModel>(context, listen: false);
    await Provider.of<AlarmViewModel>(context, listen:false).fetchAlarms(uuid: authViewModel.userUid!);
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      body: SafeArea(
        child: _buildBody(context),
        ),
    );
  }

  Widget _buildBody(BuildContext context) {
    final alarmViewModel = Provider.of<AlarmViewModel>(context);
    final theme = Theme.of(context);

    if (alarmViewModel.isLoading &&  alarmViewModel.alarms.isEmpty) {
      return Center(
        child: CircularProgressIndicator(
          color: theme.colorScheme.primary,
        ),
      );
    } 

    if (alarmViewModel.error != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.error_outline, color: theme.colorScheme.error, size: 48),
              const SizedBox(height: 16),
              Text(
                alarmViewModel.error!,
                style: theme.textTheme.bodyLarge?.copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh, color: theme.colorScheme.onError),
                label: Text('다시 시도', style: TextStyle(color: theme.colorScheme.onError)),
                style: ElevatedButton.styleFrom(backgroundColor: theme.colorScheme.primary),
                onPressed: _fetchAlarms,
              )
            ],
          ),
        ),
      );
    }
    
    return RefreshIndicator(
      onRefresh: _fetchAlarms,
      color: theme.colorScheme.primary,
      child: AlarmListWidget(
        alarms: alarmViewModel.alarms,
      ),
    );
  }
}