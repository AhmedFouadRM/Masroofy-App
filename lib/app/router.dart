import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/di.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
import 'package:masroofy/features/categories/presentation/screens/category_form_screen.dart';
import 'package:masroofy/features/categories/presentation/screens/category_list_screen.dart';
import 'package:masroofy/features/settings/presentation/screens/settings_screen.dart';
import 'package:masroofy/shared/widgets/app_bottom_nav_bar.dart';

export 'package:masroofy/app/routes.dart';

// Temporary placeholder until each tab's feature is built.
class DummyScreen extends StatelessWidget {
  const DummyScreen({required this.title, super.key});

  final String title;

  @override
  Widget build(BuildContext context) => Scaffold(
    appBar: AppBar(title: Text(title)),
    body: Center(child: Text(title)),
  );
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
          builder: (context, state) => const SettingsScreen(),
          routes: [
            // Full-screen pages above the tab bar (root navigator).
            GoRoute(
              path: 'categories',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<CategoriesCubit>()..load(),
                child: const CategoryListScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (_) => _categoryForm(null),
                    child: const CategoryFormScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: _rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (_) => _categoryForm(int.parse(state.pathParameters['id']!)),
                    child: const CategoryFormScreen(),
                  ),
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    GoRoute(
      path: RoutePaths.lock,
      builder: (context, state) => const DummyScreen(title: 'Lock Screen'),
    ),
  ],
);

/// A screen cubit whose `load()` starts as the route opens.
CategoryFormCubit _categoryForm(int? id) {
  final cubit = getIt<CategoryFormCubit>(param1: id);
  unawaited(cubit.load());
  return cubit;
}
