import 'package:flutter/material.dart';

class BottomNavBar extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNavBar({required this.currentIndex, required this.onTap, super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: onTap,
      items: [
        BottomNavigationBarItem(icon: Icon(Icons.help_outline_rounded), label: '잃었어요', backgroundColor: theme.colorScheme.surface, activeIcon: Icon(Icons.help_rounded)),
        BottomNavigationBarItem(icon: Icon(Icons.error_outline_rounded), label: '주웠어요', backgroundColor: theme.colorScheme.surface, activeIcon: Icon(Icons.error_rounded)),
        BottomNavigationBarItem(icon: Icon(Icons.fmd_good_outlined), label: '지도', backgroundColor: theme.colorScheme.surface, activeIcon: Icon(Icons.fmd_good)),
        BottomNavigationBarItem(icon: Icon(Icons.person_outline), label: '나의 정보', backgroundColor: theme.colorScheme.surface, activeIcon: Icon(Icons.person)),
      ],
      elevation: 6.0,
      selectedIconTheme: theme.primaryIconTheme,
      unselectedIconTheme: theme.iconTheme,
      selectedItemColor: theme.colorScheme.primary,
      selectedLabelStyle: theme.textTheme.labelSmall,
      unselectedLabelStyle: theme.textTheme.labelSmall,
      type: BottomNavigationBarType.shifting,
      enableFeedback: true,
    );
  }
}