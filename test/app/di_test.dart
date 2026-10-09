import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/app/di.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_form_cubit.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_list_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_cubit.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(getIt.reset);

  test('registers app-lifetime singletons', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await configureDependencies(openDatabase: () => AppDatabase(NativeDatabase.memory()));

    expect(getIt<SettingsCubit>(), same(getIt<SettingsCubit>()));
    expect(getIt<AppDatabase>(), same(getIt<AppDatabase>()));
    expect(getIt<SettingsCubit>().state.currency.code, 'EGP');

    final categories = getIt<CategoriesCubit>();
    expect(categories, isNot(same(getIt<CategoriesCubit>())));
    expect(getIt<CategoryFormCubit>(param1: 3).state.id, 3);
    expect(getIt<CategoryFormCubit>().state.isEditing, isFalse);
    await categories.close();

    final recurring = getIt<RecurringListCubit>();
    expect(getIt<RecurringFormCubit>(param1: 2, param2: 5).state.id, 5);
    await recurring.close();

    final budgets = getIt<BudgetListCubit>(param1: DateTime.saturday);
    expect(getIt<BudgetFormCubit>(param1: 2, param2: 4).state.id, 4);
    await budgets.close();
  });
}
