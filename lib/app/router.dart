import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/app_redirect.dart';
import 'package:masroofy/app/di.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/app/streams_listenable.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:masroofy/features/auth/presentation/cubits/pin_setup_cubit.dart';
import 'package:masroofy/features/auth/presentation/screens/lock_screen.dart';
import 'package:masroofy/features/auth/presentation/screens/pin_setup_screen.dart';
import 'package:masroofy/features/auth/presentation/screens/pin_verify_screen.dart';
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
import 'package:masroofy/features/settings/presentation/cubits/data_management_cubit.dart';
import 'package:masroofy/features/settings/presentation/cubits/wallet_count_cubit.dart';
import 'package:masroofy/features/settings/presentation/screens/currency_picker_screen.dart';
import 'package:masroofy/features/settings/presentation/screens/first_launch_screen.dart';
import 'package:masroofy/features/settings/presentation/screens/settings_screen.dart';
import 'package:masroofy/features/sms_import/presentation/cubits/sms_import_cubit.dart';
import 'package:masroofy/features/sms_import/presentation/screens/sms_disclosure_screen.dart';
import 'package:masroofy/features/sms_import/presentation/screens/sms_import_screen.dart';
import 'package:masroofy/features/wallets/domain/wallet_preselect.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallet_form_cubit.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallets_cubit.dart';
import 'package:masroofy/features/wallets/presentation/screens/wallet_form_screen.dart';
import 'package:masroofy/features/wallets/presentation/screens/wallets_screen.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/auth/pin_flow.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/widgets/app_shell.dart';

export 'package:masroofy/app/routes.dart';

/// The root navigator; app-wide dialogs (the budget alert) open on it.
final rootNavigatorKey = GlobalKey<NavigatorState>();
final _shellNavigatorKey = GlobalKey<NavigatorState>();

/// The app's router, built on first use (after `configureDependencies`).
final GoRouter appRouter = buildRouter(auth: getIt(), settings: getIt());

/// Builds the router. The redirect re-runs whenever the lock or settings
/// state changes, so locking, unlocking and finishing first launch navigate
/// by themselves.
GoRouter buildRouter({required AuthCubit auth, required SettingsCubit settings}) => GoRouter(
  navigatorKey: rootNavigatorKey,
  initialLocation: RoutePaths.expenses,
  refreshListenable: StreamsListenable([auth.stream, settings.stream]),
  redirect: (context, state) => appRedirect(auth: auth.state, settings: settings.state, location: state.uri),
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
            create: (context) => _expenseList(context.read<SettingsCubit>().state),
            child: const ExpenseListScreen(),
          ),
          routes: [
            // Full-screen pages above the tab bar (root navigator). `new` and
            // `recurring` are listed before `:id` so they match first.
            GoRoute(
              path: 'new',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                // `?kind=income` opens the form on Income; + always opens on Expense.
                // `?sms=12` pre-fills the form from SMS import 12 (a notification's
                // Add button, or a row of Recent imports).
                create: (context) => _expenseForm(
                  context,
                  null,
                  kind: state.uri.queryParameters['kind'] == TransactionKind.income.name
                      ? TransactionKind.income
                      : TransactionKind.expense,
                  smsImportId: int.tryParse(state.uri.queryParameters['sms'] ?? ''),
                ),
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
            create: (context) {
              final settings = context.read<SettingsCubit>().state;
              return getIt<AnalyticsCubit>(param1: settings.firstWeekday, param2: settings.viewedWalletId)..load();
            },
            child: const AnalyticsScreen(),
          ),
        ),
        GoRoute(
          path: RoutePaths.settings,
          builder: (context, state) => MultiBlocProvider(
            providers: [
              BlocProvider(create: (_) => getIt<DataManagementCubit>()),
              BlocProvider(create: (_) => getIt<WalletCountCubit>()..load()),
            ],
            child: SettingsScreen(appInfo: getIt()),
          ),
          routes: [
            // Full-screen pages above the tab bar (root navigator).
            GoRoute(
              path: 'currency',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => const CurrencyPickerScreen(),
            ),
            GoRoute(
              path: 'pin/set',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<PinSetupCubit>(),
                child: PinSetupScreen(mode: state.extra as PinSetupMode? ?? PinSetupMode.enable),
              ),
            ),
            GoRoute(
              path: 'pin/verify',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => PinVerifyScreen(purpose: state.extra as PinPurpose? ?? PinPurpose.changePin),
            ),
            GoRoute(
              path: 'wallets',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (_) => getIt<WalletsCubit>()..load(),
                child: const WalletsScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'new',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (context) => _walletForm(context, null),
                    child: const WalletFormScreen(),
                  ),
                ),
                GoRoute(
                  path: ':id',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => BlocProvider(
                    create: (context) => _walletForm(context, int.parse(state.pathParameters['id']!)),
                    child: const WalletFormScreen(),
                  ),
                ),
              ],
            ),
            GoRoute(
              path: 'sms',
              parentNavigatorKey: rootNavigatorKey,
              builder: (context, state) => BlocProvider(
                create: (_) {
                  final cubit = getIt<SmsImportCubit>();
                  unawaited(cubit.load());
                  return cubit;
                },
                child: const SmsImportScreen(),
              ),
              routes: [
                GoRoute(
                  path: 'disclosure',
                  parentNavigatorKey: rootNavigatorKey,
                  builder: (context, state) => const SmsDisclosureScreen(),
                ),
              ],
            ),
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
    GoRoute(path: RoutePaths.lock, builder: (context, state) => const LockScreen()),
    GoRoute(path: RoutePaths.firstLaunch, builder: (context, state) => const FirstLaunchScreen()),
  ],
);

/// A screen cubit whose `load()` starts as the route opens.
CategoryFormCubit _categoryForm(int? id) {
  final cubit = getIt<CategoryFormCubit>(param1: id);
  unawaited(cubit.load());
  return cubit;
}

/// A screen cubit whose `load()` starts as the route opens.
WalletFormCubit _walletForm(BuildContext context, int? id) {
  final isDefault = id != null && id == context.read<SettingsCubit>().state.defaultWalletId;
  final cubit = getIt<WalletFormCubit>(param1: id, param2: isDefault);
  unawaited(cubit.load());
  return cubit;
}

/// The list opens on the wallet viewed (null: All wallets).
ExpenseListCubit _expenseList(SettingsState settings) {
  return getIt<ExpenseListCubit>(param1: settings.firstWeekday, param2: settings.viewedWalletId)..load();
}

/// Starts a new transaction (no [id]) in the wallet viewed, or the default one
/// when All wallets is viewed.
void _presetWallet(BuildContext context, int? id, void Function(int walletId) select) {
  if (id != null) return;
  final settings = context.read<SettingsCubit>().state;
  final walletId = WalletPreselect.initial(
    viewedWalletId: settings.viewedWalletId,
    defaultWalletId: settings.defaultWalletId,
  );
  if (walletId != null) select(walletId);
}

ExpenseFormCubit _expenseForm(
  BuildContext context,
  int? id, {
  TransactionKind kind = TransactionKind.expense,
  int? smsImportId,
}) {
  final settings = context.read<SettingsCubit>().state;
  final cubit = getIt<ExpenseFormCubit>(param1: settings.currency.fractionDigits, param2: id)..kindSelected(kind);
  if (smsImportId != null && id == null) {
    // Imports always go to the default wallet; the user can change it here.
    if (settings.defaultWalletId case final walletId?) cubit.walletSelected(walletId);
    cubit.fromSms(smsImportId);
  } else {
    _presetWallet(context, id, cubit.walletSelected);
  }
  unawaited(cubit.load());
  return cubit;
}

RecurringFormCubit _recurringForm(BuildContext context, int? id) {
  final cubit = getIt<RecurringFormCubit>(
    param1: context.read<SettingsCubit>().state.currency.fractionDigits,
    param2: id,
  );
  _presetWallet(context, id, cubit.walletSelected);
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
