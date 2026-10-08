import 'package:flutter/services.dart' show rootBundle;
import 'package:get_it/get_it.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:masroofy/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:masroofy/features/analytics/domain/repositories/i_analytics_repository.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';
import 'package:masroofy/features/categories/data/datasources/reserved_category_names_asset.dart';
import 'package:masroofy/features/categories/data/repositories/category_repository_impl.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/categories/domain/usecases/delete_category.dart';
import 'package:masroofy/features/categories/domain/usecases/save_category.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:masroofy/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/domain/usecases/delete_expense.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/recurring_expenses/data/datasources/recurring_expense_local_datasource.dart';
import 'package:masroofy/features/recurring_expenses/data/repositories/recurring_expense_repository_impl.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/delete_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/process_due_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/save_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/set_recurring_active.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_cubit.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The composition root. `getIt` is only called here, in `main()`, in the
/// router, and in `BlocProvider(create: ...)` callbacks. Every class receives
/// its dependencies through its constructor, so tests build them directly.
final GetIt getIt = GetIt.instance;

/// Registers app-lifetime dependencies. Repositories and use cases are lazy
/// singletons registered under their domain interface; screen cubits are
/// factories so each route gets a fresh instance that its BlocProvider closes.
///
/// [openDatabase] lets the DI smoke test use an in-memory database.
Future<void> configureDependencies({AppDatabase Function() openDatabase = AppDatabase.new}) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt
    // Core
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerLazySingleton<AppDatabase>(openDatabase, dispose: (database) => database.close())
    // App-wide cubits
    ..registerLazySingleton<SettingsCubit>(
      () => SettingsCubit(preferences: getIt(), database: getIt()),
      dispose: (cubit) => cubit.close(),
    );

  _registerCategories();
  _registerExpenses();
  _registerRecurring();
  _registerAnalytics();
}

void _registerCategories() {
  getIt
    ..registerLazySingleton(() => CategoryLocalDatasource(getIt()))
    ..registerLazySingleton<ICategoryRepository>(() => CategoryRepositoryImpl(getIt()))
    ..registerLazySingleton<IReservedCategoryNames>(() => ReservedCategoryNamesAsset(rootBundle))
    ..registerLazySingleton(() => SaveCategory(getIt(), getIt()))
    ..registerLazySingleton(() => DeleteCategory(getIt()))
    ..registerFactory(() => CategoriesCubit(getIt(), getIt()))
    // param1: the id of the category to edit, or null for a new one.
    ..registerFactoryParam<CategoryFormCubit, int?, void>(
      (categoryId, _) => CategoryFormCubit(getIt(), getIt(), getIt(), categoryId: categoryId),
    );
}

void _registerExpenses() {
  getIt
    ..registerLazySingleton(() => ExpenseLocalDatasource(getIt()))
    ..registerLazySingleton<IExpenseRepository>(() => ExpenseRepositoryImpl(getIt()))
    ..registerLazySingleton(() => SaveExpense(getIt()))
    ..registerLazySingleton(() => DeleteExpense(getIt()))
    // param1: the device's first weekday (from SettingsCubit).
    ..registerFactoryParam<ExpenseListCubit, int, void>(
      (firstWeekday, _) => ExpenseListCubit(getIt(), getIt(), getIt(), firstWeekday: firstWeekday),
    )
    // param1: the currency's fraction digits; param2: the id to edit, or null.
    ..registerFactoryParam<ExpenseFormCubit, int, int?>(
      (fractionDigits, expenseId) =>
          ExpenseFormCubit(getIt(), getIt(), getIt(), fractionDigits: fractionDigits, expenseId: expenseId),
    );
}

void _registerRecurring() {
  getIt
    ..registerLazySingleton(() => RecurringExpenseLocalDatasource(getIt()))
    ..registerLazySingleton<IRecurringExpenseRepository>(() => RecurringExpenseRepositoryImpl(getIt()))
    ..registerLazySingleton(() => ProcessDueRecurring(getIt()))
    ..registerLazySingleton(() => SaveRecurring(getIt(), getIt()))
    ..registerLazySingleton(() => SetRecurringActive(getIt(), getIt()))
    ..registerLazySingleton(() => DeleteRecurring(getIt()))
    ..registerFactory(() => RecurringListCubit(getIt(), getIt(), getIt(), getIt()))
    // param1: the currency's fraction digits; param2: the id to edit, or null.
    ..registerFactoryParam<RecurringFormCubit, int, int?>(
      (fractionDigits, recurringId) =>
          RecurringFormCubit(getIt(), getIt(), getIt(), fractionDigits: fractionDigits, recurringId: recurringId),
    );
}

void _registerAnalytics() {
  getIt
    ..registerLazySingleton(() => AnalyticsLocalDatasource(getIt()))
    ..registerLazySingleton<IAnalyticsRepository>(() => AnalyticsRepositoryImpl(getIt()))
    // param1: the device's first weekday (from SettingsCubit).
    ..registerFactoryParam<AnalyticsCubit, int, void>(
      (firstWeekday, _) => AnalyticsCubit(getIt(), getIt(), firstWeekday: firstWeekday),
    );
}
