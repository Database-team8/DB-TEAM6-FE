import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/ui/viewmodels/condition_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/filter_state_view_model.dart';
import 'package:ajoufinder/ui/views/conditions/condition_screen.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ConditionsSettingScreen extends StatefulWidget {
  const ConditionsSettingScreen({super.key});

  @override
  State<ConditionsSettingScreen> createState() =>
      _ConditionsSettingScreenState();
}

class _ConditionsSettingScreenState extends State<ConditionsSettingScreen> {
  Location? _selectedLocation;
  ItemType? _selectedItemType;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    final filterStateViewModel = context.read<FilterStateViewModel>();

    await Future.wait([
      filterStateViewModel.fetchLocations(),
      filterStateViewModel.fetchItemTypes(),
    ]);

    if (mounted) {
      setState(() {
        if (filterStateViewModel.availableLocations.isNotEmpty) {
          _selectedLocation = filterStateViewModel.availableLocations[0];
        }
        if (filterStateViewModel.availableItemTypes.isNotEmpty) {
          _selectedItemType = filterStateViewModel.availableItemTypes[0];
        }
      });
    } else {
      return;
    }
  }

  Future<void> _postCondition() async {
    if (_selectedLocation == null || _selectedItemType == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('적어도 하나씩 조건을 선택해야 합니다.')));
      return;
    }

    final conditionViewModel = Provider.of<ConditionViewModel>(
      context,
      listen: false,
    );

    try {
      final success = await conditionViewModel.postCondition(
        _selectedItemType!.id,
        _selectedLocation!.id,
      );

      if (mounted) {
        if (success) {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('조건이 저장되었습니다.')));
          Navigator.of(context).pop(); // 이전 화면으로 돌아가기
        } else {
          ScaffoldMessenger.of(
            context,
          ).showSnackBar(SnackBar(content: Text('조건 저장에 실패했습니다.')));
        }
      } else {
        return;
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('오류 발생: ${e.toString()}')));
      } else {
        return;
      }
    }
    return;
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: theme.colorScheme.surface,
        appBar: AppBar(
          backgroundColor: theme.colorScheme.surface,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: theme.colorScheme.onSurface),
            onPressed: () => Navigator.of(context).pop(),
          ),
          centerTitle: true,
          title: Text(
            '관심 물품',
            style: TextStyle(
              color: theme.colorScheme.onSurface,
              fontWeight: FontWeight.bold,
            ),
          ),
          bottom: TabBar(
            labelColor: theme.colorScheme.primary,
            unselectedLabelColor: theme.colorScheme.surfaceTint,
            indicatorColor: theme.colorScheme.primary,
            indicatorWeight: 3,
            tabs: const [Tab(text: '관심 물품 추가'), Tab(text: '관심 조건 리스트')],
          ),
        ),
        body: TabBarView(children: [_buildBody(), ConditionScreen()]),
      ),
    );
  }

  Widget _buildBody() {
    final filterStateViewModel = Provider.of<FilterStateViewModel>(context, listen: false);
    final theme = Theme.of(context);

    if (filterStateViewModel.isLoadingLocations ||
        filterStateViewModel.isLoadingItemTypes) {
      return const Center(child: CircularProgressIndicator());
    }

    final itemTypeError = filterStateViewModel.itemTypesError;
    if (filterStateViewModel.locationsError != null ||
        filterStateViewModel.itemTypesError != null) {
      final displayError =
          filterStateViewModel.locationsError ??
          filterStateViewModel.itemTypesError ??
          '알 수 없는 오류';
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.error_outline, size: 48, color: theme.colorScheme.error),
            const SizedBox(height: 16),
            Text(displayError, textAlign: TextAlign.center),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () {
                if (filterStateViewModel.locationsError != null) filterStateViewModel.fetchLocations();
                if (itemTypeError != null) filterStateViewModel.fetchItemTypes();
              },
              child: const Text('다시 시도'),
            ),
          ],
        ),
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildConditionSection<Location>(
            '관심 지역',
            filterStateViewModel.availableLocations,
            _selectedLocation,
            (selected) => setState(() {
              _selectedLocation = selected.isNotEmpty ? selected[0] : null;
            }),
          ),
          const SizedBox(height: 24),
          _buildConditionSection<ItemType>(
            '물품 종류',
            filterStateViewModel.availableItemTypes,
            _selectedItemType,
            (selected) => setState(() {
              _selectedItemType = selected.isNotEmpty ? selected[0] : null;
            }),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () => _postCondition(),
              child: Text(
                '설정 저장',
                style: theme.textTheme.labelLarge!.copyWith(
                  color: theme.colorScheme.onPrimary,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildConditionSection<T>(
    String title,
    List<T> availableItems,
    T? selectedItem,
    Function(List<T>) onChanged,
  ) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 8),
        if (availableItems.isEmpty)
          Text(
            '사용 가능한 항목이 없습니다.',
            style: theme.textTheme.bodyMedium?.copyWith(
              color: theme.colorScheme.onSurfaceVariant,
            ),
          )
        else
          MultiSelectContainer<T>(
            maxSelectableCount: 1,
            items:
                availableItems
                    .map(
                      (item) => MultiSelectCard<T>(
                        value: item,
                        label: _getLabel(item),
                      ),
                    )
                    .toList(),
            onChange: (allSelectedItems, selectedItem) {
              onChanged(allSelectedItems);
            },
          ),
      ],
    );
  }

  String _getLabel<T>(item) {
    if (item is Location) {
      return item.locationName;
    } else if (item is ItemType) {
      return item.itemType;
    } else {
      return item.toString();
    }
  }
}
