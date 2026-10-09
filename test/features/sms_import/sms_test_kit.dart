import 'package:drift/drift.dart' show OrderingTerm, Value, driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:masroofy/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:masroofy/features/expenses/domain/usecases/delete_expense.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';
import 'package:masroofy/features/sms_import/data/datasources/sms_import_local_datasource.dart';
import 'package:masroofy/features/sms_import/data/repositories/sms_import_repository_impl.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_inbox.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/usecases/add_catch_up_selection.dart';
import 'package:masroofy/features/sms_import/domain/usecases/handle_incoming_sms.dart';
import 'package:masroofy/features/sms_import/domain/usecases/import_recent.dart';
import 'package:masroofy/features/sms_import/domain/usecases/resolve_category.dart';
import 'package:masroofy/features/sms_import/domain/usecases/sms_import_actions.dart';

/// [ISmsSettings] in memory.
class FakeSmsSettings implements ISmsSettings {
  FakeSmsSettings({this.enabled = true, this.mode = SmsMode.auto, this.defaultWalletId = 1, this.currencyCode = 'EGP'});

  bool enabled;
  SmsMode mode;
  int? defaultWalletId;
  String currencyCode;
  bool offered = false;

  @override
  Future<SmsSettings> load() async =>
      SmsSettings(enabled: enabled, mode: mode, defaultWalletId: defaultWalletId, currencyCode: currencyCode);

  @override
  Future<void> setEnabled({required bool enabled}) async => this.enabled = enabled;

  @override
  Future<void> setMode(SmsMode mode) async => this.mode = mode;

  @override
  Future<bool> catchUpOffered() async => offered;

  @override
  Future<void> markCatchUpOffered() async => offered = true;
}

/// [ISmsInbox] with a fixed inbox.
class FakeInbox implements ISmsInbox {
  FakeInbox([this.messages = const []]);

  List<RawSms> messages;
  Failure? failure;

  @override
  Future<Either<Failure, List<RawSms>>> read({required DateTime since}) async => failure != null
      ? Left(failure!)
      : Right([
          for (final message in messages)
            if (!message.receivedAt.isBefore(since)) message,
        ]);
}

/// SMS Import over an in-memory database, with the real repositories.
class SmsTestKit {
  SmsTestKit({FakeSmsSettings? settings, FakeInbox? inbox, DateTime Function()? now})
    : settings = settings ?? FakeSmsSettings(),
      inbox = inbox ?? FakeInbox(),
      _now = now ?? DateTime.now {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    database = AppDatabase(NativeDatabase.memory());
    imports = SmsImportRepositoryImpl(SmsImportLocalDatasource(database));
    expenses = ExpenseRepositoryImpl(ExpenseLocalDatasource(database));
    saveExpense = SaveExpense(expenses, today: () => LocalDate.fromDateTime(_now()));
    resolveCategory = ResolveCategory(imports);
    handle = HandleIncomingSms(
      settings: this.settings,
      imports: imports,
      resolveCategory: resolveCategory,
      saveExpense: saveExpense,
      deleteExpense: DeleteExpense(expenses),
    );
    actions = SmsImportActions(imports, imports);
    importRecent = ImportRecent(
      inbox: this.inbox,
      imports: imports,
      settings: this.settings,
      resolveCategory: resolveCategory,
      now: _now,
    );
    addCatchUp = AddCatchUpSelection(
      settings: this.settings,
      imports: imports,
      saveExpense: saveExpense,
      today: () => LocalDate.fromDateTime(_now()),
    );
  }

  final FakeSmsSettings settings;
  final FakeInbox inbox;
  final DateTime Function() _now;

  late final AppDatabase database;
  late final SmsImportRepositoryImpl imports;
  late final ExpenseRepositoryImpl expenses;
  late final SaveExpense saveExpense;
  late final ResolveCategory resolveCategory;
  late final HandleIncomingSms handle;
  late final SmsImportActions actions;
  late final ImportRecent importRecent;
  late final AddCatchUpSelection addCatchUp;

  Future<void> close() => database.close();

  /// The id of a default category.
  Future<int> category(String seedKey) async {
    final id = (await imports.categoryIdBySeedKey(seedKey)).toNullable();
    return id!;
  }

  Future<List<ExpensesTableData>> allExpenses() =>
      (database.select(database.expensesTable)..orderBy([(e) => OrderingTerm.asc(e.id)])).get();

  /// Adds a transaction typed by the user.
  Future<int> addManual({
    required int amountMinor,
    required LocalDate date,
    TransactionKind kind = TransactionKind.expense,
    ExpenseSource source = ExpenseSource.manual,
    String? categorySeed,
  }) async {
    final seed = categorySeed ?? (kind == TransactionKind.income ? 'other_income' : 'other');
    return database
        .into(database.expensesTable)
        .insert(
          ExpensesTableCompanion.insert(
            amountMinor: amountMinor,
            walletId: 1,
            categoryId: Value(await category(seed)),
            date: date,
            source: Value(source.name),
          ),
        );
  }
}
