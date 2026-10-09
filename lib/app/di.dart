import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:get_it/get_it.dart';
import 'package:local_auth/local_auth.dart';
import 'package:masroofy/app/sms_import_services.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:masroofy/features/analytics/data/repositories/analytics_repository_impl.dart';
import 'package:masroofy/features/analytics/domain/repositories/i_analytics_repository.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/auth/data/datasources/pin_secure_datasource.dart';
import 'package:masroofy/features/auth/data/pin_hasher.dart';
import 'package:masroofy/features/auth/data/repositories/auth_repository_impl.dart';
import 'package:masroofy/features/auth/data/services/local_auth_service.dart';
import 'package:masroofy/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:masroofy/features/auth/presentation/cubits/pin_setup_cubit.dart';
import 'package:masroofy/features/budgets/data/datasources/budget_local_datasource.dart';
import 'package:masroofy/features/budgets/data/repositories/budget_repository_impl.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';
import 'package:masroofy/features/budgets/domain/usecases/delete_budget.dart';
import 'package:masroofy/features/budgets/domain/usecases/save_budget.dart';
import 'package:masroofy/features/budgets/domain/usecases/take_new_budget_alerts.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_form_cubit.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_list_cubit.dart';
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
import 'package:masroofy/features/settings/data/datasources/data_management_local_datasource.dart';
import 'package:masroofy/features/settings/data/repositories/data_management_repository_impl.dart';
import 'package:masroofy/features/settings/data/services/file_services.dart';
import 'package:masroofy/features/settings/domain/entities/app_info.dart';
import 'package:masroofy/features/settings/domain/repositories/i_data_management_repository.dart';
import 'package:masroofy/features/settings/domain/repositories/i_file_services.dart';
import 'package:masroofy/features/settings/domain/usecases/clear_all_data.dart';
import 'package:masroofy/features/settings/domain/usecases/export_backup.dart';
import 'package:masroofy/features/settings/domain/usecases/export_expenses_csv.dart';
import 'package:masroofy/features/settings/domain/usecases/pick_backup.dart';
import 'package:masroofy/features/settings/domain/usecases/restore_backup.dart';
import 'package:masroofy/features/settings/presentation/cubits/data_management_cubit.dart';
import 'package:masroofy/features/settings/presentation/cubits/wallet_count_cubit.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_permissions.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';
import 'package:masroofy/features/sms_import/presentation/cubits/sms_import_cubit.dart';
import 'package:masroofy/features/wallets/data/datasources/wallet_local_datasource.dart';
import 'package:masroofy/features/wallets/data/repositories/transfer_repository_impl.dart';
import 'package:masroofy/features/wallets/data/repositories/wallet_repository_impl.dart';
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
  final packageInfo = await PackageInfo.fromPlatform();

  getIt
    // Core
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerSingleton(AppInfo(version: packageInfo.version, buildNumber: packageInfo.buildNumber))
    ..registerLazySingleton<AppDatabase>(openDatabase, dispose: (database) => database.close())
    // App-wide cubits
    ..registerLazySingleton<SettingsCubit>(
      () => SettingsCubit(preferences: getIt(), database: getIt()),
      dispose: (cubit) => cubit.close(),
    );

  _registerAuth();
  _registerSettings();
  _registerWallets();
  _registerCategories();
  _registerExpenses();
  _registerRecurring();
  _registerBudgets();
  _registerAnalytics();
  _registerSmsImport();
}

void _registerAuth() {
  getIt
    ..registerLazySingleton(() => PinSecureDatasource(const FlutterSecureStorage()))
    ..registerLazySingleton(() => LocalAuthService(LocalAuthentication()))
    ..registerLazySingleton<IAuthRepository>(
      () => AuthRepositoryImpl(
        preferences: getIt(),
        secure: getIt(),
        hasher: const PinHasher(),
        biometrics: getIt(),
      ),
    )
    // App-wide: provided above `MaterialApp` and read by the router redirect.
    ..registerLazySingleton<AuthCubit>(() => AuthCubit(getIt()), dispose: (cubit) => cubit.close())
    ..registerFactory(PinSetupCubit.new);
}

void _registerSettings() {
  getIt
    ..registerLazySingleton(() => DataManagementLocalDatasource(getIt()))
    ..registerLazySingleton<IDataManagementRepository>(() => DataManagementRepositoryImpl(getIt(), getIt()))
    ..registerLazySingleton<IFileSharer>(ShareFileService.new)
    ..registerLazySingleton<IBackupFilePicker>(BackupFilePickerService.new)
    ..registerLazySingleton(() => ExportExpensesCsv(getIt(), getIt()))
    ..registerLazySingleton(() => ExportBackup(getIt(), getIt()))
    ..registerLazySingleton(() => PickBackup(getIt(), getIt()))
    ..registerLazySingleton(() => RestoreBackup(getIt()))
    ..registerLazySingleton(() => ClearAllData(getIt()))
    ..registerFactory(() => DataManagementCubit(getIt(), getIt(), getIt(), getIt(), getIt()))
    ..registerFactory(() => WalletCountCubit(getIt()));
}

void _registerWallets() {
  getIt
    ..registerLazySingleton(() => WalletLocalDatasource(getIt()))
    ..registerLazySingleton<IWalletRepository>(() => WalletRepositoryImpl(getIt()))
    ..registerLazySingleton<ITransferRepository>(() => TransferRepositoryImpl(getIt()))
    ..registerLazySingleton(() => SaveWallet(getIt()))
    ..registerLazySingleton(() => DeleteWallet(getIt()))
    ..registerLazySingleton(() => SaveTransfer(getIt()))
    ..registerFactory(() => WalletsCubit(getIt()))
    // param1: the id of the wallet to edit, or null for a new one; param2:
    // whether it is the default wallet.
    ..registerFactoryParam<WalletFormCubit, int?, bool>(
      (walletId, isDefault) => WalletFormCubit(getIt(), getIt(), getIt(), walletId: walletId, isDefault: isDefault),
    );
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
    // param1: the device's first weekday (from SettingsCubit); param2: the
    // wallet viewed, or null for All wallets.
    ..registerFactoryParam<ExpenseListCubit, int, int?>(
      (firstWeekday, walletId) =>
          ExpenseListCubit(getIt(), getIt(), getIt(), getIt(), firstWeekday: firstWeekday, walletId: walletId),
    )
    // param1: the currency's fraction digits; param2: the id to edit, or null.
    ..registerFactoryParam<ExpenseFormCubit, int, int?>(
      (fractionDigits, expenseId) => ExpenseFormCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        fractionDigits: fractionDigits,
        expenseId: expenseId,
        smsImports: getIt(),
        smsActions: getIt(),
      ),
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
      (fractionDigits, recurringId) => RecurringFormCubit(
        getIt(),
        getIt(),
        getIt(),
        getIt(),
        fractionDigits: fractionDigits,
        recurringId: recurringId,
      ),
    );
}

void _registerAnalytics() {
  getIt
    ..registerLazySingleton(() => AnalyticsLocalDatasource(getIt()))
    ..registerLazySingleton<IAnalyticsRepository>(() => AnalyticsRepositoryImpl(getIt()))
    // param1: the device's first weekday (from SettingsCubit); param2: the
    // wallet viewed, or null for All wallets.
    ..registerFactoryParam<AnalyticsCubit, int, int?>(
      (firstWeekday, walletId) =>
          AnalyticsCubit(getIt(), getIt(), getIt(), getIt(), firstWeekday: firstWeekday, walletId: walletId),
    );
}

/// SMS Import is Android only, but its objects are cheap to build and nothing
/// reads SMS until the user turns the feature on, so they are registered on
/// every platform. They come from [SmsImportServices], the same wiring the
/// headless engine uses when an SMS arrives with the app closed.
void _registerSmsImport() {
  getIt
    ..registerLazySingleton(() => SmsImportServices(database: getIt(), preferences: getIt()))
    ..registerLazySingleton<ISmsImportRepository>(() => getIt<SmsImportServices>().repository)
    ..registerLazySingleton<ISmsSettings>(() => getIt<SmsImportServices>().settings)
    ..registerLazySingleton<ISmsPermissions>(() => SmsImportServices.permissions)
    ..registerLazySingleton(() => getIt<SmsImportServices>().actions)
    ..registerFactory(
      () => SmsImportCubit(
        settings: getIt(),
        permissions: getIt(),
        imports: getIt(),
        categories: getIt(),
        listSenders: getIt<SmsImportServices>().listSenders,
        importRecent: getIt<SmsImportServices>().importRecent,
        addCatchUp: getIt<SmsImportServices>().addCatchUpSelection,
        actions: getIt(),
      ),
    );
}

void _registerBudgets() {
  getIt
    ..registerLazySingleton(() => BudgetLocalDatasource(getIt()))
    ..registerLazySingleton<IBudgetRepository>(() => BudgetRepositoryImpl(getIt()))
    ..registerLazySingleton(() => SaveBudget(getIt()))
    ..registerLazySingleton(() => DeleteBudget(getIt()))
    ..registerLazySingleton(() => TakeNewBudgetAlerts(getIt()))
    // param1: the device's first weekday (from SettingsCubit).
    ..registerFactoryParam<BudgetListCubit, int, void>(
      (firstWeekday, _) => BudgetListCubit(getIt(), getIt(), getIt(), firstWeekday: firstWeekday),
    )
    // param1: the currency's fraction digits; param2: the id to edit, or null.
    ..registerFactoryParam<BudgetFormCubit, int, int?>(
      (fractionDigits, budgetId) =>
          BudgetFormCubit(getIt(), getIt(), getIt(), fractionDigits: fractionDigits, budgetId: budgetId),
    );
}
