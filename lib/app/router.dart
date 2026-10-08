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
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_list_screen.dart';
import 'package:masroofy/features/settings/presentation/screens/settings_screen.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/widgets/app_shell.dart';

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
        return AppShell(child: child);
      },
      routes: [
        GoRoute(
          path: RoutePaths.expenses,
          builder: (context, state) => BlocProvider(
            create: (context) => _expenseList(context.read<SettingsCubit>().state.firstWeekday),
            child: const ExpenseListScreen(),
          ),
          routes: [
            // Full-screen pages above the tab bar (root navigator). `new` and
            // `recurring` are listed before `:id` so they match first.
            GoRoute(
              path: 'new',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (context) => _expenseForm(context, null),
                child: const ExpenseFormScreen(),
              ),
            ),
            GoRoute(
              path: 'recurring',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => const DummyScreen(title: 'Recurring'),
            ),
            GoRoute(
              path: ':id',
              parentNavigatorKey: _rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (context) => _expenseForm(context, int.parse(state.pathParameters['id']!)),
                child: const ExpenseFormScreen(),
              ),
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

ExpenseListCubit _expenseList(int firstWeekday) {
  return getIt<ExpenseListCubit>(param1: firstWeekday)..load();
}

ExpenseFormCubit _expenseForm(BuildContext context, int? id) {
  final cubit = getIt<ExpenseFormCubit>(
    param1: context.read<SettingsCubit>().state.currency.fractionDigits,
    param2: id,
  );
  unawaited(cubit.load());
  return cubit;
}
