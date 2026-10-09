import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/app/di.dart';
import 'package:masroofy/app/sms_import_services.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/auth/presentation/cubits/pin_setup_cubit.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_form_cubit.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_list_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_cubit.dart';
import 'package:masroofy/features/settings/domain/entities/app_info.dart';
import 'package:masroofy/features/settings/presentation/cubits/data_management_cubit.dart';
import 'package:masroofy/features/settings/presentation/cubits/wallet_count_cubit.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_permissions.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/usecases/sms_import_actions.dart';
import 'package:masroofy/features/sms_import/presentation/cubits/sms_import_cubit.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_transfer_repository.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/features/wallets/domain/usecases/delete_wallet.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_transfer.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_wallet.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallet_form_cubit.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallets_cubit.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() {
    SharedPreferences.setMockInitialValues({});
    PackageInfo.setMockInitialValues(
      appName: 'Masroofy',
      packageName: 'com.masroofy.masroofy',
      version: '1.2.3',
      buildNumber: '45',
      buildSignature: '',
    );
  });
  tearDown(getIt.reset);

  test('registers app-lifetime singletons', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await configureDependencies(openDatabase: () => AppDatabase(NativeDatabase.memory()));

    expect(getIt<SettingsCubit>(), same(getIt<SettingsCubit>()));
    expect(getIt<AppDatabase>(), same(getIt<AppDatabase>()));
    expect(getIt<SettingsCubit>().state.currency.code, 'EGP');

    expect(getIt<AuthCubit>(), same(getIt<AuthCubit>()));
    expect(getIt<AuthCubit>().state.isEnabled, isFalse);
    expect(getIt<AppInfo>().label, '1.2.3 (45)');
    await getIt<PinSetupCubit>().close();
    await getIt<DataManagementCubit>().close();

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

  test('registers the wallets: repositories and use cases as singletons, cubits as factories', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await configureDependencies(openDatabase: () => AppDatabase(NativeDatabase.memory()));

    expect(getIt<IWalletRepository>(), same(getIt<IWalletRepository>()));
    expect(getIt<ITransferRepository>(), same(getIt<ITransferRepository>()));
    expect(getIt<SaveWallet>(), same(getIt<SaveWallet>()));
    expect(getIt<DeleteWallet>(), same(getIt<DeleteWallet>()));
    expect(getIt<SaveTransfer>(), same(getIt<SaveTransfer>()));

    final wallets = getIt<WalletsCubit>();
    expect(wallets, isNot(same(getIt<WalletsCubit>())));
    final form = getIt<WalletFormCubit>(param1: 3, param2: true);
    expect((form.state.id, form.state.makeDefault, form.state.wasDefault), (3, true, true));
    expect(getIt<WalletFormCubit>(param2: false).state.isEditing, isFalse);
    final count = getIt<WalletCountCubit>();
    await wallets.close();
    await form.close();
    await count.close();

    // The cubits that follow the wallet viewed take it as the second parameter.
    final list = getIt<ExpenseListCubit>(param1: DateTime.saturday, param2: 2);
    expect(list.state.walletId, 2);
    expect(getIt<ExpenseListCubit>(param1: DateTime.saturday).state.walletId, isNull);
    final analytics = getIt<AnalyticsCubit>(param1: DateTime.saturday, param2: 2);
    expect(analytics.state.walletId, 2);
    await list.close();
    await analytics.close();
    await getIt<ExpenseFormCubit>(param1: 2).close();
  });

  test(
    'registers SMS Import: one set of services, repositories as singletons, the screen cubit as a factory',
    () async {
      driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
      await configureDependencies(openDatabase: () => AppDatabase(NativeDatabase.memory()));

      expect(getIt<SmsImportServices>(), same(getIt<SmsImportServices>()));
      expect(getIt<ISmsImportRepository>(), same(getIt<SmsImportServices>().repository));
      expect(getIt<ISmsSettings>(), same(getIt<SmsImportServices>().settings));
      expect(getIt<SmsImportActions>(), same(getIt<SmsImportServices>().actions));
      expect(getIt<ISmsPermissions>(), isNotNull);

      final cubit = getIt<SmsImportCubit>();
      expect(cubit, isNot(same(getIt<SmsImportCubit>())));
      expect(cubit.state.loading, isTrue);
      await cubit.close();
    },
  );
}
