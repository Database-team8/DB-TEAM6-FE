import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/utils/action_bar_type.dart';
import 'package:ajoufinder/ui/navigations/bottom_nav_bar.dart';
import 'package:ajoufinder/ui/shared/widgets/build_generic_dropdown.dart';
import 'package:ajoufinder/ui/shared/widgets/conditions_setting_screen.dart';
import 'package:ajoufinder/ui/shared/widgets/post_board_widget.dart';
import 'package:ajoufinder/ui/shared/widgets/search_bar_widget.dart';
import 'package:ajoufinder/ui/viewmodels/alarm_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/filter_state_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/navigator_bar_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/page_view_model.dart';
import 'package:ajoufinder/ui/views/alarms/alarm_screen.dart';
import 'package:ajoufinder/ui/views/wrapper/screen_wrapper.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LoggedInScreen extends StatefulWidget {
  const LoggedInScreen({super.key});

  @override
  _LoggedInScreenState createState() => _LoggedInScreenState();
}

class _LoggedInScreenState extends State<LoggedInScreen> {

  void _onItemTapped(int index) {
    setState(() {
      Provider.of<NavigatorBarViewModel>(
        context,
        listen: false,
      ).updateCurrentPage(index);
      Provider.of<PageViewModel>(context, listen: false).configureFab(index);
      Provider.of<PageViewModel>(context, listen: false).configureAppbar(index);
    });
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigatorBarViewModel = Provider.of<NavigatorBarViewModel>(
        context,
        listen: false,
      );
      final pageViewModel = Provider.of<PageViewModel>(context, listen: false);
      pageViewModel.configureFab(navigatorBarViewModel.currentIndex);
      pageViewModel.configureAppbar(navigatorBarViewModel.currentIndex);
    });
  }

  Future<void> _sendQuery() async {
    final filterStateViewModel = context.read<FilterStateViewModel>();

    if (filterStateViewModel.selectedLocation == null &&
        filterStateViewModel.selectedItemType == null &&
        filterStateViewModel.selectedStatus == null &&
        filterStateViewModel.startDate == null &&
        filterStateViewModel.endDate == null) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('적어도 하나의 필터를 선택해야 합니다.')));
      }
      return;
    }

    if (filterStateViewModel.startDate != null &&
        filterStateViewModel.endDate != null &&
        filterStateViewModel.startDate!.isAfter(filterStateViewModel.endDate!)) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('시작 날짜는 종료 날짜보다 이전이어야 합니다.')));
      }
      return;
    }

    final boardViewModel = Provider.of<BoardViewModel>(context, listen: false);
    final navigatorBarViewModel = Provider.of<NavigatorBarViewModel>(
      context,
      listen: false,
    );

    try {
      if (navigatorBarViewModel.currentIndex == 0) {
        await boardViewModel.fetchFilteredLostBoards(
          locationId: filterStateViewModel.selectedLocation?.id,
          itemTypeId: filterStateViewModel.selectedItemType?.id,
          status: filterStateViewModel.selectedStatus,
          startDate: filterStateViewModel.startDate,
          endDate: filterStateViewModel.endDate,
        );
      } else if (navigatorBarViewModel.currentIndex == 1) {
        await boardViewModel.fetchFilteredFoundBoards(
          locationId: filterStateViewModel.selectedLocation?.id,
          itemTypeId: filterStateViewModel.selectedItemType?.id,
          status: filterStateViewModel.selectedStatus,
          startDate: filterStateViewModel.startDate,
          endDate: filterStateViewModel.endDate,
        );
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(SnackBar(content: Text('게시글 필터링 중 오류 발생: $e')));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigatorBarViewModel = Provider.of<NavigatorBarViewModel>(context);
    final pageViewModel = context.watch<PageViewModel>();
    final filterStateViewModel = context.watch<FilterStateViewModel>();

    return Scaffold(
      appBar: PreferredSize(
        preferredSize:
            pageViewModel.extendAppbar
                ? Size.fromHeight(kToolbarHeight * 2)
                : Size.fromHeight(kToolbarHeight),

        child:
            pageViewModel.showAppbar
                ? AppBar(
                  title: SearchBarWidget(
                    controller: pageViewModel.searchController,
                    hintText: pageViewModel.hintText!,
                    onSubmitted: pageViewModel.performSearch!,
                    focusNode: pageViewModel.searchFocusNode,
                    onClear: pageViewModel.onClear,
                  ),
                  actions: _buildActions(),
                  automaticallyImplyLeading:
                      pageViewModel.isSearchBarWidgetActivated,
                  bottom:
                      pageViewModel.extendAppbar
                          ? PreferredSize(
                            preferredSize: Size.fromHeight(kToolbarHeight),
                            child: SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              padding: const EdgeInsets.symmetric(
                                horizontal: 8.0,
                                vertical: 4.0,
                              ),
                              child: Row(
                                children: [
                                  buildGenericDropdown<Location>(
                                    hintText: '위치',
                                    selectedValue: filterStateViewModel.selectedLocation,
                                    items:
                                        filterStateViewModel.availableLocations,
                                    isLoading:
                                        filterStateViewModel.isLoadingLocations,
                                    error: filterStateViewModel.locationsError,
                                    emptyText: '위치 정보 없음',
                                    labelBuilder: (loc) => loc.locationName,
                                    onChanged: (newValue) => filterStateViewModel.setSelectedLocation(newValue),
                                    onChangedAsync: _sendQuery,
                                    theme: theme,
                                  ),

                                  const SizedBox(width: 8),
                                  buildGenericDropdown<ItemType>(
                                    hintText: '종류',
                                    selectedValue: filterStateViewModel.selectedItemType,
                                    items:
                                        filterStateViewModel.availableItemTypes,
                                    isLoading:
                                        filterStateViewModel.isLoadingItemTypes,
                                    error: filterStateViewModel.itemTypesError,
                                    emptyText: '종류 정보 없음',
                                    labelBuilder: (type) => type.itemType,
                                    onChanged: (newValue) => filterStateViewModel.setSelectedItemType(newValue),
                                    onChangedAsync: _sendQuery,
                                    theme: theme,
                                  ),

                                  const SizedBox(width: 8),
                                  buildGenericDropdown<String>(
                                    hintText: '상태',
                                    selectedValue: filterStateViewModel.selectedStatus,
                                    items: filterStateViewModel.availableStatuses,
                                    isLoading: filterStateViewModel.isLoadingStatuses,
                                    error: filterStateViewModel.statusesError,
                                    emptyText: '상태 정보 없음',
                                    labelBuilder: (status) => status,
                                    onChanged: (newValue) => filterStateViewModel.setSelectedStatus(newValue),
                                    onChangedAsync: _sendQuery,
                                    theme: theme,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildDatePickerButton(
                                    label: '시작',
                                    date: filterStateViewModel.startDate,
                                    onPressed: _selectFirstDate,
                                  ),
                                  const SizedBox(width: 8),
                                  _buildDatePickerButton(
                                    label: '끝',
                                    date: filterStateViewModel.endDate,
                                    onPressed: _selectEndDate,
                                  ),
                                  const SizedBox(width: 8),
                                ],
                              ),
                            ),
                          )
                          : null,
                  backgroundColor:
                      Colors.transparent, // 또는 theme.colorScheme.surface
                  elevation: 6.0, // AppBar 그림자 조정 (선택)
                  scrolledUnderElevation:
                      theme.appBarTheme.scrolledUnderElevation ?? 4.0,
                )
                : const SizedBox(),
      ),
      body: ScreenWrapper(),
      bottomNavigationBar: BottomNavBar(onTap: _onItemTapped),
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton:
          pageViewModel.showFab
              ? FloatingActionButton.extended(
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Center(
                            child: ConstrainedBox(
                              constraints: const BoxConstraints(maxWidth: 400),
                              child: PostBoardWidget(
                                lostCategory:
                                    navigatorBarViewModel.currentIndex == 0
                                        ? 'lost'
                                        : 'found',
                              ),
                            ),
                          ),
                    ),
                  );
                },
                label: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: Text(pageViewModel.fabLabelText!),
                ),
                icon: Icon(pageViewModel.fabIconData),
              )
              : const SizedBox(),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [];

    final pageViewModel = Provider.of<PageViewModel>(context, listen: false);
    final theme = Theme.of(context);

    for (var actionType in pageViewModel.actionTypes) {
      switch (actionType) {
        case ActionBarType.alarms:
          actions.add(
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder:
                        (context) => Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: 400),
                            child: AlarmScreen(),
                          ),
                        ),
                  ),
                );
              },
              icon:
                  context.watch<AlarmViewModel>().hasNewAlarms()
                      ? Icon(
                        Icons.notifications_active_rounded,
                        color: theme.colorScheme.primary.withValues(alpha: 0.3),
                      )
                      : Icon(
                        Icons.notifications_none_rounded,
                        color: theme.colorScheme.onSurfaceVariant,
                      ),
              tooltip: '알림',
            ),
          );
          break;
        case ActionBarType.configCondtions:
          actions.add(
            IconButton(
              onPressed:
                  () => Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder:
                          (context) => Center(
                            child: ConstrainedBox(
                              constraints: BoxConstraints(maxWidth: 400),
                              child: ConditionsSettingScreen(),
                            ),
                          ),
                    ),
                  ),
              icon: Icon(
                Icons.tune_rounded,
                color: theme.colorScheme.onSurfaceVariant,
              ),
              tooltip: '관심 물품 설정',
            ),
          );
          break;
        default:
          break;
      }
    }
    return actions;
  }

  Future<void> _selectFirstDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: context.read<FilterStateViewModel>().startDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025).add(const Duration(days: 365)),
    );
    if (mounted) {
      final filterStateViewModel = context.read<FilterStateViewModel>();

      if (picked != null && picked != filterStateViewModel.startDate) {
      filterStateViewModel.setStartDate(picked);
      await _sendQuery();
    }
    } else {
      return;
    }    
  }

  Future<void> _selectEndDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: context.read<FilterStateViewModel>().endDate ?? DateTime.now(),
      firstDate: DateTime(2000),
      lastDate: DateTime(2025).add(const Duration(days: 365)),
    );
    if (mounted) {
      final filterStateViewModel = context.read<FilterStateViewModel>();

      if (picked != null && picked != filterStateViewModel.endDate) {
      filterStateViewModel.setEndDate(picked);
      await _sendQuery();
    }
    } else {
      return;
    }    
  }

  Widget _buildDatePickerButton({
    required String label,
    required DateTime? date,
    required VoidCallback onPressed,
  }) {
    final theme = Theme.of(context);
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: theme.colorScheme.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0),
          side: BorderSide(
            color: theme.colorScheme.onSurfaceVariant,
            width: 1.5,
          ),
        ),
      ),
      child: Text(
        date != null ? '${date.year}-${date.month}-${date.day}' : label,
        style: theme.textTheme.labelLarge!.copyWith(
          color: theme.colorScheme.onSurface,
        ),
      ),
    );
  }
}
