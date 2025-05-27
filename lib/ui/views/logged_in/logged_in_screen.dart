import 'package:ajoufinder/domain/entities/item_type.dart';
import 'package:ajoufinder/domain/entities/location.dart';
import 'package:ajoufinder/domain/repository/board_repository.dart';
import 'package:ajoufinder/domain/repository/location_repository.dart';
import 'package:ajoufinder/domain/utils/action_bar_type.dart';
import 'package:ajoufinder/injection_container.dart';
import 'package:ajoufinder/ui/navigations/bottom_nav_bar.dart';
import 'package:ajoufinder/ui/shared/widgets/keywords_setting_screen.dart';
import 'package:ajoufinder/ui/shared/widgets/post_board_widget.dart';
import 'package:ajoufinder/ui/shared/widgets/search_bar_widget.dart';
import 'package:ajoufinder/ui/viewmodels/alarm_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/navigator_bar_view_model.dart';
import 'package:ajoufinder/ui/viewmodels/page_view_model.dart';
import 'package:ajoufinder/ui/views/account/account_screen.dart';
import 'package:ajoufinder/ui/views/home/home_screen.dart';
import 'package:ajoufinder/ui/views/map/map_screen.dart';
import 'package:ajoufinder/ui/views/alarms/alarm_screen.dart';
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

  late Future<List<Location>> _locationsFuture;
  late Future<List<ItemType>> _itemTypesFuture;
  late Future<List<String>> _statusesFuture;

  final _pages = [
    HomeScreen(lostCategory: 'lost'),
    HomeScreen(lostCategory: 'found'),
    MapScreen(),
    AccountScreen(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      Provider.of<NavigatorBarViewModel>(context, listen: false).updateCurrentPage(index);
      Provider.of<PageViewModel>(context, listen: false).configureFab(index);
      Provider.of<PageViewModel>(context, listen: false).configureAppbar(index);
    });
  }

  Future<List<Location>> _fetchLocations() async {
    return getIt<LocationRepository>().getAllLocations();
  }

  Future<List<ItemType>> _fetchItemTypes() async {
    return getIt<BoardRepository>().getAllItemTypes();
  }

  Future<List<String>> _fetchStatuses() async {
  return getIt<BoardRepository>().getAllItemStatuses();
}

  @override
  void initState() {
    super.initState();
    _locationsFuture = _fetchLocations();
    _itemTypesFuture = _fetchItemTypes();
    _statusesFuture = _fetchStatuses();
    
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final navigatorBarViewModel = Provider.of<NavigatorBarViewModel>(context, listen: false);
      final pageViewModel = Provider.of<PageViewModel>(context, listen: false);
      pageViewModel.configureFab(navigatorBarViewModel.currentIndex);
      pageViewModel.configureAppbar(navigatorBarViewModel.currentIndex);
    });
  }

  void _sendQuery() {

  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final navigatorBarViewModel = Provider.of<NavigatorBarViewModel>(context);

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Provider.of<PageViewModel>(context).extendAppbar ? Size.fromHeight(kToolbarHeight * 2) : Size.fromHeight(kToolbarHeight), 
        child: Consumer<PageViewModel>(
          builder: (context, pageViewModel, child) {
            return pageViewModel.showAppbar
            ? AppBar(
              title: SearchBarWidget(
                controller: pageViewModel.searchController, 
                hintText: pageViewModel.hintText!, 
                onSubmitted: pageViewModel.performSearch!,
                focusNode: pageViewModel.searchFocusNode,
                onClear: pageViewModel.onClear,
              ),
              actions: _buildActions(),
              automaticallyImplyLeading: pageViewModel.isSearchBarWidgetActivated,
              bottom: PreferredSize(
                preferredSize: Provider.of<PageViewModel>(context).extendAppbar ? Size.fromHeight(kToolbarHeight) : Size.fromHeight(0),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      _buildLocationDropdown(),
                      const SizedBox(width: 16,),
                      _buildItemTypeDropdown(),
                      const SizedBox(width: 16),
                      _buildStatusDropdown(),
                    ],
                  ),
              )),
              backgroundColor: Colors.transparent,
              elevation: 6.0,
              scrolledUnderElevation: 12.0,
            )
            : SizedBox();
          }
        ),
        ),
      body: IndexedStack(
        index: navigatorBarViewModel.currentIndex,
        children: _pages
      ),
      bottomNavigationBar: Consumer<NavigatorBarViewModel>(
        builder: (context, navigatorBarViewModel, child) {
          return BottomNavBar(onTap: _onItemTapped);
        }),
      backgroundColor: theme.colorScheme.surface,
      floatingActionButton: Consumer<PageViewModel>(
        builder: (context, pageViewModel, child) {
          return pageViewModel.showFab 
          ? FloatingActionButton.extended(
            onPressed: (){
              Navigator.push(
              context, 
              MaterialPageRoute(builder: (context) => Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: PostBoardWidget(lostCategory: navigatorBarViewModel.currentIndex == 0 ? 'lost' : 'found'),
                ),
              ),)
            );
          }, 
            label: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 4.0),
              child: Text(pageViewModel.fabLabelText!),
            ),
            icon: Icon(pageViewModel.fabIconData, ),  
          )
          : SizedBox();
        }
        ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
      extendBodyBehindAppBar: true,
      extendBody: true,
    );
  }

  List<Widget> _buildActions() {
    List<Widget> actions = [];

    final pageViewModel = Provider.of<PageViewModel>(context);
    final alarmViewModel = Provider.of<AlarmViewModel>(context);
    final theme = Theme.of(context);
    
    for (var actionType in pageViewModel.actionTypes) {
      switch (actionType) {
        case ActionBarType.alarms:
          actions.add(
            IconButton(
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Center(
                      child: ConstrainedBox(
                        constraints: BoxConstraints(maxWidth: 400),
                        child: AlarmScreen(),
                        ),
                    ),
                  )
                );
              }, 
              icon: alarmViewModel.hasNewAlarms() 
              ? Icon(Icons.notifications_active_rounded, color: theme.colorScheme.primary.withValues(alpha: 0.3),)
              : Icon(Icons.notifications_none_rounded, color: theme.colorScheme.onSurfaceVariant,),
              tooltip: '알림',
            ),
          );
          break;
        case ActionBarType.configCondtions:
          actions.add(
            IconButton(
              onPressed: () => Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => Center(
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 400),
                  child: KeywordsSettingScreen()
                ),
              )),
            ),
              icon: Icon(Icons.tune_rounded, color: theme.colorScheme.onSurfaceVariant,),
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

  Widget _buildLocationDropdown() {
  return FutureBuilder<List<Location>>(
    future: _locationsFuture,
    builder: (context, snapshot) {
      final theme = Theme.of(context);
      final lineColor = theme.colorScheme.onSurfaceVariant;

      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(width: 120, child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,))));
      }
      if (snapshot.hasError) {
        return Text('위치 로딩 실패');
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('위치 정보 없음');
      }
      final locations = snapshot.data!;

      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: lineColor,
            width: 1.5,
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<Location>(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: lineColor,),
              hint: Text('위치', style: theme.textTheme.labelLarge!.copyWith(color: lineColor) ),
              value: _selectedLocation,
              items: locations.map((Location location) {
                return DropdownMenuItem<Location>(
                  value: location,
                  child: Text(location.locationName, style: theme.textTheme.labelLarge!.copyWith(color: lineColor)),
                );
              }).toList(),
              onChanged: (Location? newValue) {
                setState(() {
                  _selectedLocation = newValue;
                });
                _sendQuery();
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

Widget _buildItemTypeDropdown() {
  return FutureBuilder<List<ItemType>>(
    future: _itemTypesFuture,
    builder: (context, snapshot) {
      final theme = Theme.of(context);
      final lineColor = theme.colorScheme.onSurfaceVariant;

      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(width: 120, child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,))));
      }
      if (snapshot.hasError) {
        return Text('종류 로딩 실패');
      }
      if (!snapshot.hasData || snapshot.data!.isEmpty) {
        return Text('종류 정보 없음');
      }
      final itemTypes = snapshot.data!;
      return DecoratedBox(
        decoration: BoxDecoration(
          border: Border.all(
            color: lineColor,
            width: 1.5
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ItemType>(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: lineColor,),
              hint: Text('종류', style: theme.textTheme.labelLarge!.copyWith(color: lineColor)),
              value: _selectedItemType,
              items: itemTypes.map((ItemType type) {
                return DropdownMenuItem<ItemType>(
                  value: type,
                  child: Text(type.itemType, style: theme.textTheme.labelLarge!.copyWith(color: lineColor)),
                );
              }).toList(),
              onChanged: (ItemType? newValue) {
                setState(() {
                  _selectedItemType = newValue;
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

Widget _buildStatusDropdown() {
  return FutureBuilder<List<String>>(
    future: _statusesFuture,
    builder: (context, snapshot) {
      final theme = Theme.of(context);
      final lineColor = theme.colorScheme.onSurfaceVariant;

      if (snapshot.connectionState == ConnectionState.waiting) {
        return SizedBox(width: 120, child: Center(child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2,))));
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
          border: Border.all(
            color: lineColor,
            width: 1.5
          ),
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
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<String>(
              icon: Icon(Icons.keyboard_arrow_down_rounded, color: lineColor,),
              hint: Text('상태', style: theme.textTheme.labelLarge!.copyWith(color: lineColor)),
              value: _selectedStatus,
              items: statuses.map((String status) {
                return DropdownMenuItem<String>(
                  value: status,
                  child: Text(status, style: theme.textTheme.labelLarge!.copyWith(color: lineColor)),
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
