import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:ajoufinder/domain/utils/action_bar_type.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/navigations/bottom_nav_bar.dart';
import 'package:ajoufinder/ui/shared/widgets/conditions_setting_screen.dart';
import 'package:ajoufinder/ui/shared/widgets/post_board_widget.dart';
import 'package:ajoufinder/ui/shared/widgets/search_bar_widget.dart';
import 'package:ajoufinder/ui/viewmodels/alarm_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/board_view_model.dart';
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
  Location? _selectedLocation;
  ItemType? _selectedItemType;
  String? _selectedStatus;

  late Future<List<String>> _statusesFuture;

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

  Future<List<String>> _fetchStatuses() async {
    return getIt<BoardRepository>().getAllItemStatuses();
  }

  @override
  void initState() {
    super.initState();
    _statusesFuture = _fetchStatuses();

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

  void _sendQuery() {}

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigatorBarViewModel = Provider.of<NavigatorBarViewModel>(context);
    final boardViewModel = context.watch<BoardViewModel>();
    final pageViewModel = context.watch<PageViewModel>();

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
                                  _buildLocationDropdown(boardViewModel),
                                  const SizedBox(width: 8),
                                  _buildItemTypeDropdown(boardViewModel),
                                  const SizedBox(width: 8),
                                  _buildStatusDropdown(),
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

  Widget _buildLocationDropdown(BoardViewModel boardViewModel) {
    final theme = Theme.of(context);
    final lineColor = theme.colorScheme.onSurfaceVariant;

    if (boardViewModel.isLoadingLocations) {
      return SizedBox(
        width: 100,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (boardViewModel.locationError != null) {
      return Text('위치 로딩 실패', style: TextStyle(color: theme.colorScheme.error));
    }
    if (boardViewModel.locations.isEmpty) {
      return Text('위치 정보 없음');
    }
    final locations = boardViewModel.locations;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: lineColor, width: 1.0), // 테두리 두께 조정
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(16.0), // 반지름 조정
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<Location>(
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: lineColor),
            hint: Text(
              '위치',
              style: theme.textTheme.labelMedium!.copyWith(color: lineColor),
            ),
            value: _selectedLocation,
            items:
                locations.map((Location location) {
                  return DropdownMenuItem<Location>(
                    value: location,
                    child: Text(
                      location.locationName,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (Location? newValue) {
              setState(() {
                _selectedLocation = newValue;
              });
              _sendQuery();
            },
            isDense: true,
            dropdownColor: theme.colorScheme.surface,
          ),
        ),
      ),
    );
  }

  Widget _buildItemTypeDropdown(BoardViewModel boardViewModel) {
    final theme = Theme.of(context);
    final lineColor = theme.colorScheme.onSurfaceVariant;

    if (boardViewModel.isLoadingItemTypes) {
      return SizedBox(
        width: 100,
        child: Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        ),
      );
    }
    if (boardViewModel.itemTypeError != null) {
      return Text('종류 로딩 실패', style: TextStyle(color: theme.colorScheme.error));
    }
    if (boardViewModel.itemTypes.isEmpty) {
      return Text('종류 정보 없음');
    }
    final itemTypes = boardViewModel.itemTypes;
    return DecoratedBox(
      decoration: BoxDecoration(
        border: Border.all(color: lineColor, width: 1.0),
        color: theme.colorScheme.surface,
        boxShadow: [
          BoxShadow(
            color: theme.colorScheme.shadow,
            blurRadius: 2.0,
            offset: Offset(0, 1),
          ),
        ],
        borderRadius: BorderRadius.circular(16.0),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0),
        child: DropdownButtonHideUnderline(
          child: DropdownButton<ItemType>(
            icon: Icon(Icons.keyboard_arrow_down_rounded, color: lineColor),
            hint: Text(
              '종류',
              style: theme.textTheme.labelMedium!.copyWith(color: lineColor),
            ),
            value: _selectedItemType,
            items:
                itemTypes.map((ItemType type) {
                  return DropdownMenuItem<ItemType>(
                    value: type,
                    child: Text(
                      type.itemType,
                      style: theme.textTheme.labelMedium!.copyWith(
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                  );
                }).toList(),
            onChanged: (ItemType? newValue) {
              setState(() {
                _selectedItemType = newValue;
              });
              _sendQuery();
            },
            isDense: true,
            dropdownColor: theme.colorScheme.surface,
          ),
        ),
      ),
    );
  }

  Widget _buildStatusDropdown() {
    return FutureBuilder<List<String>>(
      future: _statusesFuture,
      builder: (context, snapshot) {
        final theme = Theme.of(context);
        final lineColor = theme.colorScheme.onSurfaceVariant;

        if (snapshot.connectionState == ConnectionState.waiting) {
          return SizedBox(
            width: 120,
            child: Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(strokeWidth: 2),
              ),
            ),
          );
        }
        if (snapshot.hasError) {
          return Text('상태 로딩 실패');
        }
        if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Text('상태 정보 없음');
        }
        final statuses = snapshot.data!;
        return DecoratedBox(
          decoration: BoxDecoration(
            border: Border.all(color: lineColor, width: 1.5),
            color: theme.colorScheme.surface,
            boxShadow: [
              BoxShadow(
                color: theme.colorScheme.shadow,
                blurRadius: 4.0,
                offset: Offset(0, 2),
              ),
            ],
            borderRadius: BorderRadius.circular(20.0),
          ),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 16.0,
              vertical: 8.0,
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<String>(
                icon: Icon(Icons.keyboard_arrow_down_rounded, color: lineColor),
                hint: Text(
                  '상태',
                  style: theme.textTheme.labelLarge!.copyWith(color: lineColor),
                ),
                value: _selectedStatus,
                items:
                    statuses.map((String status) {
                      return DropdownMenuItem<String>(
                        value: status,
                        child: Text(
                          status,
                          style: theme.textTheme.labelLarge!.copyWith(
                            color: lineColor,
                          ),
                        ),
                      );
                    }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    _selectedStatus = newValue;
                  });
                  _sendQuery(); // 선택 변경 시 쿼리
                },
                underline: Container(),
                isDense: true,
                dropdownColor: theme.colorScheme.surface,
              ),
            ),
          ),
        );
      },
    );
  }
}
