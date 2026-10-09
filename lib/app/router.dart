import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/di.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_form_cubit.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_list_cubit.dart';
import 'package:masroofy/features/budgets/presentation/screens/budget_form_screen.dart';
import 'package:masroofy/features/budgets/presentation/screens/budget_list_screen.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
import 'package:masroofy/features/categories/presentation/screens/category_form_screen.dart';
import 'package:masroofy/features/categories/presentation/screens/category_list_screen.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_list_screen.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/screens/recurring_form_screen.dart';
import 'package:masroofy/features/recurring_expenses/presentation/screens/recurring_list_screen.dart';
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

/// The root navigator; app-wide dialogs (the budget alert) open on it.
final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

final appRouter = GoRouter(
  navigatorKey: rootNavigatorKey,
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
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (context) => _expenseForm(context, null),
                child: const ExpenseFormScreen(),
              ),
            ),
            GoRoute(
              path: 'recurring',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<RecurringListCubit>()..load(),
                child: const RecurringListScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (context) => _recurringForm(context, null),
                    child: const RecurringFormScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (context) => _recurringForm(context, int.parse(state.pathParameters['id']!)),
                    child: const RecurringFormScreen(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: ':id',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (context) => _expenseForm(context, int.parse(state.pathParameters['id']!)),
                child: const ExpenseFormScreen(),
              ),
            ),
          ],
        ),
        GoRoute(
          path: RoutePaths.analytics,
          builder: (context, state) => BlocProvider(
            create: (context) =>
                getIt<AnalyticsCubit>(param1: context.read<SettingsCubit>().state.firstWeekday)..load(),
            child: const AnalyticsScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.settings,
          builder: (context, state) => const SettingsScreen(),
          routes: [
            // Full-screen pages above the tab bar (root navigator).
            GoRoute(
              path: 'budgets',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (context) =>
                    getIt<BudgetListCubit>(param1: context.read<SettingsCubit>().state.firstWeekday)..load(),
                child: const BudgetListScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (context) => _budgetForm(context, null),
                    child: const BudgetFormScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (context) => _budgetForm(context, int.parse(state.pathParameters['id']!)),
                    child: const BudgetFormScreen(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'categories',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<CategoriesCubit>()..load(),
                child: const CategoryListScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (_) => _categoryForm(null),
                    child: const CategoryFormScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
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

RecurringFormCubit _recurringForm(BuildContext context, int? id) {
  final cubit = getIt<RecurringFormCubit>(
    param1: context.read<SettingsCubit>().state.currency.fractionDigits,
    param2: id,
  );
  unawaited(cubit.load());
  return cubit;
}

BudgetFormCubit _budgetForm(BuildContext context, int? id) {
  final cubit = getIt<BudgetFormCubit>(
    param1: context.read<SettingsCubit>().state.currency.fractionDigits,
    param2: id,
  );
  unawaited(cubit.load());
  return cubit;
}
