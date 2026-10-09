import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:masroofy/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/entities/list_entry.dart';
import 'package:masroofy/features/wallets/data/datasources/wallet_local_datasource.dart';
import 'package:masroofy/features/wallets/data/repositories/transfer_repository_impl.dart';
import 'package:masroofy/features/wallets/data/repositories/wallet_repository_impl.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer_draft.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_transfer.dart';

import '../../../helpers/db_rows.dart';

void main() {
  late AppDatabase db;
  late TransferRepositoryImpl repository;
  late SaveTransfer save;
  late ExpenseRepositoryImpl expenses;
  late WalletRepositoryImpl wallets;
  late int me;
  late int son;
  final today = LocalDate(2026, 10, 8);
  final october = ExpenseFilter(range: DateRange.monthToDate(today));

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repository = TransferRepositoryImpl(WalletLocalDatasource(db));
    save = SaveTransfer(repository, today: () => today);
    expenses = ExpenseRepositoryImpl(ExpenseLocalDatasource(db));
    wallets = WalletRepositoryImpl(WalletLocalDatasource(db));
    me = await db.seedDefaultWallet();
    son = await addWallet(db, 'Son');
  });
  tearDown(() => db.close());

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));
  Failure left<T>(Either<Failure, T> result) => result.getLeft().getOrElse(() => fail('expected Left'));

  TransferDraft draft({int? from, int? to, int minor = 50000, LocalDate? date, String? note}) => TransferDraft(
    fromWalletId: from ?? me,
    toWalletId: to ?? son,
    amount: Money(minor),
    date: date ?? today,
    note: note,
  );

  Future<List<ExpensesTableData>> legs() =>
      (db.select(db.expensesTable)..orderBy([(e) => OrderingTerm(expression: e.id)])).get();

  Future<Map<int, Money>> balances() async => {
    for (final w in right(await wallets.watchSummaries(DateRange.monthToDate(today)).first)) w.wallet.id: w.balance,
  };

  test('a transfer is two linked rows: out of the source wallet, into the target', () async {
    final id = right(await save(draft(note: '  Pocket money ')));

    final rows = await legs();
    expect(rows, hasLength(2));
    expect(rows.map((e) => (e.transferId, e.direction, e.walletId)), [(id, 'out', me), (id, 'in', son)]);
    expect(rows.every((e) => e.amountMinor == 50000 && e.date == today && e.note == 'Pocket money'), isTrue);
    expect(rows.every((e) => e.categoryId == null && e.title == null), isTrue);
    expect(await db.select(db.transfersTable).get(), hasLength(1));
  });

  test('it moves balances and nothing else', () async {
    right(await save(draft()));

    expect(await balances(), {me: const Money(-50000), son: const Money(50000)});
    final totals = right(await expenses.watchTotals(october).first);
    expect((totals.income, totals.spent, totals.balance), (Money.zero, Money.zero, Money.zero));
  });

  test('an empty note is stored as null', () async {
    right(await save(draft(note: '   ')));
    expect((await legs()).map((e) => e.note), [null, null]);
  });

  group('validation', () {
    test('two different wallets', () async {
      expect(
        left(await save(draft(to: me))),
        const Failure.validation(field: 'toWallet', reason: ValidationReason.sameWallet),
      );
      expect(await legs(), isEmpty);
    });

    test('a positive amount, no future date, a note of up to 500 characters', () async {
      expect(
        left(await save(draft(minor: 0))),
        const Failure.validation(field: 'amount', reason: ValidationReason.mustBePositive),
      );
      expect(
        left(await save(draft(date: today.addDays(1)))),
        const Failure.validation(field: 'date', reason: ValidationReason.inFuture),
      );
      expect(
        left(await save(draft(note: 'x' * 501))),
        const Failure.validation(field: 'note', reason: ValidationReason.tooLong),
      );
      expect(right(await save(draft(note: 'x' * 500))), greaterThan(0));
    });

    test('both wallets are required, and must exist', () async {
      expect(
        left(await save(draft(from: 0))),
        const Failure.validation(field: 'fromWallet', reason: ValidationReason.required),
      );
      expect(
        left(await save(draft(to: 0))),
        const Failure.validation(field: 'toWallet', reason: ValidationReason.required),
      );
      expect(left(await save(draft(to: 999))), isA<ConstraintFailure>());
      expect(await legs(), isEmpty, reason: 'a failed save leaves no half transfer');
      expect(await db.select(db.transfersTable).get(), isEmpty);
    });
  });

  group('editing', () {
    test('changes both legs, and the wallets they are in', () async {
      final id = right(await save(draft()));
      final other = await addWallet(db, 'Wife');

      right(
        await save(
          draft(from: son, to: other, minor: 70000, date: today.addDays(-2), note: 'Edited'),
          id: id,
        ),
      );

      final rows = await legs();
      expect(rows.map((e) => (e.direction, e.walletId, e.amountMinor, e.date, e.note)), [
        ('out', son, 70000, today.addDays(-2), 'Edited'),
        ('in', other, 70000, today.addDays(-2), 'Edited'),
      ]);
      expect(await db.select(db.transfersTable).get(), hasLength(1));
      expect(await balances(), {me: Money.zero, son: const Money(-70000), other: const Money(70000)});
    });

    test('an unknown transfer is not found', () async {
      expect(left(await save(draft(), id: 999)), const Failure.notFound());
    });

    test('the list shows the edited transfer once, from either leg', () async {
      final id = right(await save(draft()));
      right(await save(draft(minor: 1234), id: id));

      final all = right(await expenses.watchEntries(october, limit: 50).first);
      expect(all.whereType<TransferEntry>().single.transfer.amount, const Money(1234));
      final his = right(await expenses.watchEntries(october.copyWith(walletId: son), limit: 50).first);
      expect(his.whereType<TransferEntry>().single.transfer.amount, const Money(1234));
    });
  });

  test('deleting either side deletes the other', () async {
    final id = right(await save(draft()));
    final rowIds = [for (final leg in await legs()) leg.id];

    right(await expenses.delete(rowIds.first));
    expect(await legs(), isEmpty);
    expect(await db.select(db.transfersTable).get(), isEmpty);
    expect(left(await expenses.delete(rowIds.last)), const Failure.notFound());
    expect(id, greaterThan(0));
  });
}
