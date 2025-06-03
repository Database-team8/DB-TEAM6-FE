import 'package:ajoufinder/ui/viewmodels/navigator_bar_view_model.dart';
import 'package:ajoufinder/ui/views/account/account_screen.dart';
import 'package:ajoufinder/ui/views/home/home_screen.dart';
import 'package:ajoufinder/ui/views/map/map_screen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class ScreenWrapper extends StatelessWidget {
  
  const ScreenWrapper({super.key});

  @override
  Widget build(BuildContext context) {
    final navigatorBarViewModel = Provider.of<NavigatorBarViewModel>(context, listen: true);
    Widget homeScreen = _buildHomeScreen(navigatorBarViewModel);

    return IndexedStack(
      index: navigatorBarViewModel.currentIndex,
      children: [
        homeScreen,
        homeScreen,
        const MapScreen(),
        const AccountScreen(),
      ],
    );
  }

  Widget _buildHomeScreen(NavigatorBarViewModel viewModel) {
    final category = viewModel.currentIndex == 0 ? 'lost' : 'found';
    return HomeScreen(
      key: ValueKey('home'),
      lostCategory: category,
    );
  }
}
