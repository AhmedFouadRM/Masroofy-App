import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/shared/widgets/app_bottom_nav_bar.dart';

// Temporary dummy screens for the router
class DummyScreen extends StatelessWidget {
  final String title;
  const DummyScreen({super.key, required this.title});
  @override
  Widget build(BuildContext context) => Scaffold(appBar: AppBar(title: Text(title)), body: Center(child: Text(title)));
}

class RoutePaths {
  static const expenses = '/expenses';
  static const analytics = '/analytics';
  static const settings = '/settings';
  static const addExpense = 'add-expense';
  static const editExpense = 'edit-expense';
  static const lock = '/lock';
}

final _rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: RoutePaths.expenses,
  routes: [
    ShellRoute(
      navigatorKey: _shellNavigatorKey,
      builder: (context, state, child) {
        return AppBottomNavBar(child: child);
      },
      routes: [
        GoRoute(
          path: RoutePaths.expenses,
          builder: (context, state) => const DummyScreen(title: 'Expenses'),
          routes: [
            GoRoute(
              path: RoutePaths.addExpense,
              builder: (context, state) => const DummyScreen(title: 'Add Expense'),
            ),
            GoRoute(
              path: '${RoutePaths.editExpense}/:id',
              builder: (context, state) => const DummyScreen(title: 'Edit Expense'),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.analytics,
          builder: (context, state) => const DummyScreen(title: 'Analytics'),
        ),
        GoRoute(
          path: RoutePaths.settings,
          builder: (context, state) => const DummyScreen(title: 'Settings'),
        ),
      ],
    ),
    GoRoute(
      path: RoutePaths.lock,
      builder: (context, state) => const DummyScreen(title: 'Lock Screen'),
    ),
  ],
);
