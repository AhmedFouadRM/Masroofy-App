import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';
import 'package:masroofy/features/categories/data/repositories/category_repository_impl.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/wallets/data/datasources/wallet_local_datasource.dart';
import 'package:masroofy/features/wallets/data/repositories/transfer_repository_impl.dart';
import 'package:masroofy/features/wallets/data/repositories/wallet_repository_impl.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_transfer.dart';

import '../../sms_import/domain/egbank_samples.dart';
import '../../sms_import/sms_test_kit.dart';

/// The Add form pre-filled from an SMS import, over a real in-memory database.
void main() {
  final received = DateTime(2026, 10, 9, 15, 20, 30);
  final today = LocalDate(2026, 10, 9);
  late SmsTestKit kit;
  late ExpenseFormCubit form;

  setUp(() {
    kit = SmsTestKit(
      now: () => DateTime(2026, 10, 9, 16),
      settings: FakeSmsSettings(mode: SmsMode.ask),
    );
    final wallets = WalletLocalDatasource(kit.database);
    form = ExpenseFormCubit(
      kit.expenses,
      CategoryRepositoryImpl(CategoryLocalDatasource(kit.database)),
      WalletRepositoryImpl(wallets),
      kit.saveExpense,
      SaveTransfer(TransferRepositoryImpl(wallets), today: () => today),
      fractionDigits: 2,
      today: () => today,
      smsImports: kit.imports,
      smsActions: kit.actions,
    );
  });
  tearDown(() async {
    await form.close();
    await kit.close();
  });

  /// Loads the form and waits for the wallets, which arrive on a stream.
  Future<void> loadForm([ExpenseFormCubit? cubit]) async {
    final target = cubit ?? form;
    await target.load();
    await pumpEventQueue();
  }

  Future<SmsImport> pending(String body, {String sender = 'EGBANK'}) async {
    final outcome = (await kit.handle(RawSms(sender: sender, body: body, receivedAt: received))).getOrElse(
      (failure) => throw StateError('$failure'),
    );
    return (outcome as SmsNeedsReview).import;
  }

  Future<void> open(int importId) async {
    form.fromSms(importId);
    await loadForm();
  }

  test('pre-fills type, amount, category, title, date and note, and names the bank', () async {
    final import = await pending(EgBankSamples.purchaseUber);

    await open(import.id);

    final state = form.state;
    expect(state.status, ExpenseFormStatus.ready);
    expect(state.kind, TransactionKind.expense);
    expect(state.amountText, '5');
    expect(state.categoryId, await kit.category('transport'));
    expect(state.title, 'Uber');
    expect(state.date, LocalDate(2026, 10, 9));
    expect(state.note, 'EG Bank ••9033');
    expect(state.smsImportId, import.id);
    expect(state.smsBank, 'EG Bank');
    expect(state.isEditing, isFalse);
  });

  test('an income import opens on Income, dated by the text', () async {
    final import = await pending(EgBankSamples.instaPayCredit);

    await open(import.id);

    expect(form.state.kind, TransactionKind.income);
    expect(form.state.amountText, '200');
    expect(form.state.date, LocalDate(2026, 10, 7));
    expect(form.state.categoryId, await kit.category('other_income'));
    expect(form.state.title, 'NADA MOHAMED ABDELM**');
    expect(form.state.note, 'InstaPay · Ref 65520277090');
  });

  test('a message with no merchant leaves the title empty', () async {
    final import = await pending(EgBankSamples.instaPayDebit);

    await open(import.id);

    expect(form.state.title, isEmpty);
    expect(form.state.smsBank, 'EG Bank');
  });

  test('the wallet is the one chosen before load: the default wallet', () async {
    final import = await pending(EgBankSamples.purchaseUber);
    form.walletSelected(1);

    await open(import.id);

    expect(form.state.walletId, 1);
  });

  test('a form with no import, or one that is gone, stays blank', () async {
    form.fromSms(404);
    await loadForm();

    expect(form.state.status, ExpenseFormStatus.ready);
    expect(form.state.amountText, isEmpty);
    expect(form.state.smsBank, isNull);
  });

  test('a category that was deleted since leaves it to the user', () async {
    final import = await pending(EgBankSamples.purchaseUber);
    await kit.database.customStatement('UPDATE sms_imports SET category_id = NULL');

    await open(import.id);

    expect(form.state.categoryId, isNull);
    expect(form.state.amountText, '5');
  });

  test('saving creates one transaction with source sms, completes the import and learns the category', () async {
    final import = await pending(EgBankSamples.purchaseUber);
    await open(import.id);
    final shopping = await kit.category('shopping');
    // The user changes the category before saving.
    form.categorySelected(shopping);

    await form.save();

    expect(form.state.status, ExpenseFormStatus.saved);
    final expenses = await kit.allExpenses();
    expect(expenses, hasLength(1));
    final expense = expenses.single;
    expect(expense.amountMinor, 500);
    expect(expense.title, 'Uber');
    expect(expense.categoryId, shopping);
    expect(expense.note, 'EG Bank ••9033');
    expect(expense.source, ExpenseSource.sms.name);
    final done = (await kit.imports.getById(import.id)).getOrElse((_) => throw StateError('gone'));
    expect(done.status, SmsImportStatus.added);
    expect(done.expenseId, expense.id);
    // Uber is now shopping.
    expect((await kit.resolveCategory('Uber', TransactionKind.expense)).getOrElse((_) => -1), shopping);
  });

  test('saving with the suggested category also remembers it', () async {
    final import = await pending(EgBankSamples.purchaseGeidea);
    await open(import.id);
    final food = await kit.category('food');
    form.categorySelected(food);

    await form.save();

    expect((await kit.resolveCategory('ALBAN ZAHER 6', TransactionKind.expense)).getOrElse((_) => -1), food);
  });

  test('the user can edit before saving', () async {
    final import = await pending(EgBankSamples.purchaseUber);
    await open(import.id);
    form
      ..amountChanged('6.50')
      ..titleChanged('Uber ride');

    await form.save();

    final expense = (await kit.allExpenses()).single;
    expect(expense.amountMinor, 650);
    expect(expense.title, 'Uber ride');
  });

  test('an invalid form saves nothing and leaves the import pending', () async {
    final import = await pending(EgBankSamples.purchaseUber);
    await open(import.id);
    form.amountChanged('');

    await form.save();

    expect(form.state.status, ExpenseFormStatus.ready);
    expect(await kit.allExpenses(), isEmpty);
    expect(
      (await kit.imports.getById(import.id)).getOrElse((_) => throw StateError('gone')).status,
      SmsImportStatus.pending,
    );
  });

  test('an ordinary new form saves with source manual and touches no import', () async {
    await loadForm();
    form
      ..amountChanged('12')
      ..categorySelected(await kit.category('food'));

    await form.save();

    expect((await kit.allExpenses()).single.source, ExpenseSource.manual.name);
  });

  test('editing a saved SMS transaction keeps its source', () async {
    final import = await pending(EgBankSamples.purchaseUber);
    await open(import.id);
    await form.save();
    final id = (await kit.allExpenses()).single.id;
    final edit = ExpenseFormCubit(
      kit.expenses,
      CategoryRepositoryImpl(CategoryLocalDatasource(kit.database)),
      WalletRepositoryImpl(WalletLocalDatasource(kit.database)),
      kit.saveExpense,
      SaveTransfer(TransferRepositoryImpl(WalletLocalDatasource(kit.database)), today: () => today),
      fractionDigits: 2,
      expenseId: id,
      today: () => today,
      smsImports: kit.imports,
      smsActions: kit.actions,
    );
    addTearDown(edit.close);
    await loadForm(edit);

    edit.amountChanged('7');
    await edit.save();

    final expense = (await kit.allExpenses()).single;
    expect(expense.amountMinor, 700);
    expect(expense.source, 'sms');
    expect(Money(expense.amountMinor), const Money(700));
  });
}
