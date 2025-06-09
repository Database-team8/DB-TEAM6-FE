import 'package:ajoufinder/ui/shared/widgets/alarm_list_widget.dart';
import 'package:ajoufinder/ui/viewmodels/alarm_view_model.dart';
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
    final alarmViewModel = Provider.of<AlarmViewModel>(context, listen: false);
    await alarmViewModel.fetchMyAlarms();    
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final alarmViewModel = Provider.of<AlarmViewModel>(context);

    return Scaffold(
      backgroundColor: theme.colorScheme.surface,
      appBar: AppBar(
        iconTheme: theme.iconTheme.copyWith(color: theme.colorScheme.onSurface),
        backgroundColor: theme.colorScheme.surface,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded),
          onPressed: () => Navigator.of(context).pop(),
        ),
        centerTitle: true,
        title: Text(
          '알림',
          style: TextStyle(
            color: theme.colorScheme.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        child: _buildBody(context, alarmViewModel, theme),
      ),
    );
  }

  Widget _buildBody(BuildContext context, AlarmViewModel alarmViewModel, ThemeData theme) {
    if (alarmViewModel.isLoading && alarmViewModel.alarms.isEmpty) {
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
                style: theme.textTheme.bodyLarge
                    ?.copyWith(color: theme.colorScheme.error),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 16),
              ElevatedButton.icon(
                icon: Icon(Icons.refresh, color: theme.colorScheme.onError),
                label: Text('다시 시도',
                    style: TextStyle(color: theme.colorScheme.onError)),
                style: ElevatedButton.styleFrom(
                    backgroundColor: theme.colorScheme.primary),
                onPressed: _fetchAlarms,
              )
            ],
          ),
        ),
      );
    }

    if (alarmViewModel.alarms.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.notifications_none,
              size: 70,
              color: theme.colorScheme.onSurfaceVariant,
            ),
            const SizedBox(height: 24),
            Text(
              '새로운 알림이 없습니다.',
              style: theme.textTheme.titleMedium?.copyWith(
                color: theme.colorScheme.onSurfaceVariant,
              ),
            ),
          ],
        ),
      );
    }

    return RefreshIndicator(
      onRefresh: _fetchAlarms, 
      color: theme.colorScheme.primary,
      child: AlarmListWidget(),
    );
  }
}
