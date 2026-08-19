import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../core/strings/string_manager.dart';
import '../../app/router.dart';

class AppBottomNavBar extends StatelessWidget {
  final Widget child;

  const AppBottomNavBar({super.key, required this.child});

  int _calculateSelectedIndex(BuildContext context) {
    final String location = GoRouterState.of(context).uri.path;
    if (location.startsWith(RoutePaths.expenses)) return 0;
    if (location.startsWith(RoutePaths.analytics)) return 1;
    if (location.startsWith(RoutePaths.settings)) return 2;
    return 0;
  }

  void _onItemTapped(int index, BuildContext context) {
    switch (index) {
      case 0:
        context.go(RoutePaths.expenses);
        break;
      case 1:
        context.go(RoutePaths.analytics);
        break;
      case 2:
        context.go(RoutePaths.settings);
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: _calculateSelectedIndex(context),
        onDestinationSelected: (index) => _onItemTapped(index, context),
        destinations: [
          NavigationDestination(
            icon: const Icon(Icons.receipt_long_outlined),
            selectedIcon: const Icon(Icons.receipt_long),
            label: StringManager.expensesTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.analytics_outlined),
            selectedIcon: const Icon(Icons.analytics),
            label: StringManager.analyticsTitle,
          ),
          NavigationDestination(
            icon: const Icon(Icons.settings_outlined),
            selectedIcon: const Icon(Icons.settings),
            label: StringManager.settingsTitle,
          ),
        ],
      ),
    );
  }
}
