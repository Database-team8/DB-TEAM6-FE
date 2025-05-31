import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart'; // _fetchStatuses에서 아직 직접 사용
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/views/conditions/condition_screen.dart';
import 'package:flutter_multi_select_items/flutter_multi_select_items.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class KeywordsSettingScreen extends StatefulWidget {
  const KeywordsSettingScreen({super.key});

  @override
  State<KeywordsSettingScreen> createState() => _KeywordsSettingScreenState();
}

class _KeywordsSettingScreenState extends State<KeywordsSettingScreen> {
  List<Location> _selectedLocations = [];
  List<ItemType> _selectedItemTypes = [];
  List<String> _selectedStatuses = [];

  
  List<String> _availableStatuses = [];

  // _isLoading과 _errorMessage는 이제 BoardViewModel의 상태를 따르거나,
  // 이 화면 자체의 로딩/오류 상태를 별도로 관리할 수 있습니다.
  // 여기서는 _loadData를 위한 로컬 로딩/오류 상태를 유지합니다.
  bool _isScreenLoading = true; // 화면 전체 데이터 로딩 상태
  String? _screenErrorMessage;

  late BoardViewModel _boardViewModel;

  @override
  void initState() {
    super.initState();
    _boardViewModel = Provider.of<BoardViewModel>(context, listen: false);

    WidgetsBinding.instance.addPostFrameCallback((_) {
      _loadInitialData();
    });
  }

  Future<void> _loadInitialData() async {
    setState(() {
      _isScreenLoading = true;
      _screenErrorMessage = null;
    });

    try {
      // locations와 statuses는 여전히 직접 fetch, itemTypes는 ViewModel에서 가져옴
      // ViewModel의 fetchItemTypes는 생성자에서 호출되므로, 여기서는 이미 로드 중이거나 완료되었을 수 있음
      // 만약 ViewModel의 itemTypes가 비어있다면, 여기서 명시적으로 fetchItemTypes를 호출할 수도 있습니다.
      // if (_boardViewModel.itemTypes.isEmpty && !_boardViewModel.isLoadingItemTypes) {
      //   await _boardViewModel.fetchItemTypes();
      // }
      // 위 주석은 ViewModel 생성 시 fetchItemTypes가 이미 호출된다는 전제 하에 불필요할 수 있습니다.
      // 단, ViewModel이 재생성되거나 하는 경우를 대비해 방어적으로 추가할 수 있습니다.

      final results = await Future.wait([
        Future.value(_boardViewModel.locations),
        Future.value(_boardViewModel.itemTypes),
        _fetchStatuses(),
      ]);

      if (mounted) {
        setState(() {
          // ItemTypes는 ViewModel에서 직접 참조하므로 여기서 다시 할당할 필요는 없음
          // _availableItemTypes = results[1] as List<ItemType>;
          _availableStatuses = results[2] as List<String>;
        });
      }
    } catch (e) {
      if (mounted) {
        setState(() {
          _screenErrorMessage = '데이터를 불러오는 중 오류가 발생했습니다: $e';
        });
      }
    } finally {
      if (mounted) {
        setState(() {
          _isScreenLoading = false;
        });
      }
    }
  }

  Future<List<String>> _fetchStatuses() async {
    final boardRepository = getIt<BoardRepository>();
    return boardRepository.getAllItemStatuses();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final boardViewModel = context.watch<BoardViewModel>();

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
            tabs: const [
              Tab(text: '관심 물품 추가'),
              Tab(text: '관심 조건 리스트'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            _buildBody(boardViewModel),
            ConditionScreen(),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(BoardViewModel boardViewModel) {
    final theme = Theme.of(context);

    if (_isScreenLoading || boardViewModel.isLoadingItemTypes) {
      return const Center(child: CircularProgressIndicator());
    }

    final itemTypeError = boardViewModel.itemTypeError;
    if (_screenErrorMessage != null || itemTypeError != null) {
      final displayError = _screenErrorMessage ?? itemTypeError ?? '알 수 없는 오류';
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
                if (_screenErrorMessage != null) _loadInitialData();
                if (itemTypeError != null) boardViewModel.fetchItemTypes();
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
            boardViewModel.locations, // 로컬 상태 (_loadInitialData에서 채워짐)
            _selectedLocations,
            (selected) => setState(() => _selectedLocations = selected),
          ),
          const SizedBox(height: 24),
          _buildConditionSection<ItemType>(
            '물품 종류',
            boardViewModel.itemTypes, // ViewModel에서 가져온 아이템 타입 사용
            _selectedItemTypes,
            (selected) => setState(() => _selectedItemTypes = selected),
          ),
          const SizedBox(height: 24),
          _buildConditionSection<String>(
            '물품 상태',
            _availableStatuses, // 로컬 상태 (_loadInitialData에서 채워짐)
            _selectedStatuses,
            (selected) => setState(() => _selectedStatuses = selected),
          ),
          const SizedBox(height: 24),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed: () {
                // 선택된 조건들을 저장하는 로직 필요
                // 예: _boardViewModel.saveUserPreferences(_selectedLocations, _selectedItemTypes, _selectedStatuses);
                Navigator.of(context).pop();
              },
              child: Text(
                '설정 저장',
                style: theme.textTheme.labelLarge!.copyWith(color: theme.colorScheme.onPrimary),
              ),
            ),
          )
        ],
      ),
    );
  }

  Widget _buildConditionSection<T>(
      String title, List<T> availableItems, List<T> selectedItems, Function(List<T>) onChanged) {
    final theme = Theme.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(title, style: theme.textTheme.titleMedium?.copyWith(fontWeight: FontWeight.bold)),
        const SizedBox(height: 8),
        if (availableItems.isEmpty)
          Text(
            '사용 가능한 항목이 없습니다.',
            style: theme.textTheme.bodyMedium?.copyWith(color: theme.colorScheme.onSurfaceVariant),
          )
        else
          MultiSelectContainer<T>(
              items: availableItems
                  .map((item) => MultiSelectCard<T>(
                        value: item,
                        label: _getLabel(item),
                      ))
                  .toList(),
              onChange: (allSelectedItems, selectedItem) {
                onChanged(allSelectedItems);
              }),
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

  