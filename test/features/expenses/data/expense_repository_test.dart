import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:masroofy/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/entities/list_entry.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';

import '../../../helpers/db_rows.dart';

void main() {
  late AppDatabase db;
  late ExpenseRepositoryImpl repository;
  late SaveExpense save;
  late int food;
  late int transport;
  late int salary;
  late int me;
  late int son;
  final today = LocalDate(2026, 10, 8);
  final october = ExpenseFilter(range: DateRange.monthToDate(today));

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repository = ExpenseRepositoryImpl(ExpenseLocalDatasource(db));
    save = SaveExpense(repository, today: () => today);
    Future<int> seed(String key) async =>
        (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(key))).getSingle()).id;
    food = await seed('food');
    transport = await seed('transport');
    salary = await seed('salary');
    me = await db.seedDefaultWallet();
    son = await addWallet(db, 'Son');
  });
  tearDown(() => db.close());

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));
  Failure left<T>(Either<Failure, T> result) => result.getLeft().getOrElse(() => fail('expected Left'));

  Future<int> add(int minor, LocalDate date, {int? category, int? wallet, String? title, String? note}) async => right(
    await save(
      ExpenseDraft(
        amount: Money(minor),
        walletId: wallet ?? me,
        categoryId: category ?? food,
        date: date,
        title: title,
        note: note,
      ),
    ),
  );

  Future<int> addIncome(int minor, LocalDate date, {int? wallet}) async => right(
    await save(
      ExpenseDraft(
        amount: Money(minor),
        walletId: wallet ?? me,
        categoryId: salary,
        date: date,
        kind: TransactionKind.income,
      ),
    ),
  );

  /// The expense or income behind row [id].
  Future<Expense> expense(int id) async => switch (right(await repository.getEntry(id))) {
    TransactionEntry(:final expense) => expense,
    TransferEntry() => fail('expected a transaction'),
  };

  Future<List<ListEntry>> entries(ExpenseFilter filter, {int limit = 50}) async =>
      right(await repository.watchEntries(filter, limit: limit).first);

  test('saves trimmed text, and empty text as null', () async {
    final id = await add(1250, today, title: '  Lunch ', note: '   ');
    final saved = await expense(id);
    expect((saved.title, saved.note, saved.amount), ('Lunch', null, const Money(1250)));
  });

  test('rejects a future date', () async {
    final result = await save(
      ExpenseDraft(amount: const Money(1), walletId: me, categoryId: food, date: today.addDays(1)),
    );
    expect(left(result), const Failure.validation(field: 'date', reason: ValidationReason.inFuture));
  });

  test('lists newest first within the range, and pages by limit', () async {
    final first = await add(100, LocalDate(2026, 10, 1));
    final second = await add(200, today);
    final third = await add(300, today);
    await add(400, LocalDate(2026, 9, 30)); // outside

    expect((await entries(october)).map((e) => e.id), [third, second, first]);
    expect((await entries(october, limit: 2)).map((e) => e.id), [third, second]);
  });

  test('filters by category and searches title and note case-insensitively', () async {
    final lunch = await add(100, today, title: 'Team LUNCH');
    final uber = await add(200, today, category: transport, note: 'uber to work');
    await add(300, today);

    Future<List<int>> ids(ExpenseFilter filter) async => [for (final e in await entries(filter)) e.id];

    expect(await ids(october.copyWith(categoryId: transport)), [uber]);
    expect(await ids(october.copyWith(search: ' lunch ')), [lunch]);
    expect(await ids(october.copyWith(search: 'UBER')), [uber]);
    expect(await ids(october.copyWith(search: '%')), isEmpty, reason: 'no LIKE wildcards');
  });

  test('totals and daily totals follow the filter, with exact sums', () async {
    for (var i = 0; i < 100; i++) {
      await add(10, today); // 100 × 0.10
    }
    await add(250, LocalDate(2026, 10, 2), category: transport);

    expect(right(await repository.watchTotals(october).first).spent, const Money(1250));
    expect(right(await repository.watchTotals(october.copyWith(categoryId: transport)).first).spent, const Money(250));
    expect(right(await repository.watchDailyTotals(october).first), {
      today: const PeriodTotals(income: Money.zero, spent: Money(1000)),
      LocalDate(2026, 10, 2): const PeriodTotals(income: Money.zero, spent: Money(250)),
    });
  });

  group('income', () {
    test('rows carry their category kind, and income never changes spending', () async {
      await add(1000, today);
      final before = right(await repository.watchTotals(october).first);
      final pay = await addIncome(500000, today);

      final after = right(await repository.watchTotals(october).first);
      expect(after.spent, before.spent);
      expect(after.income, const Money(500000));
      expect(after.balance, const Money(499000));
      expect((await expense(pay)).kind, TransactionKind.income);
    });

    test('the kind filter narrows rows and totals', () async {
      await add(1000, today);
      final pay = await addIncome(500000, today);

      final incomeOnly = october.copyWith(kind: TransactionKind.income);
      final rows = await entries(incomeOnly);
      expect(rows.map((e) => (e.id, (e as TransactionEntry).expense.kind)), [(pay, TransactionKind.income)]);
      expect(
        right(await repository.watchTotals(incomeOnly).first),
        const PeriodTotals(income: Money(500000), spent: Money.zero),
      );
      expect(
        right(await repository.watchTotals(october.copyWith(kind: TransactionKind.expense)).first),
        const PeriodTotals(income: Money.zero, spent: Money(1000)),
      );
    });

    test('daily totals hold both series', () async {
      await add(1000, today);
      await addIncome(500000, today);

      expect(right(await repository.watchDailyTotals(october).first), {
        today: const PeriodTotals(income: Money(500000), spent: Money(1000)),
      });
    });

    test('a category of the other kind is rejected', () async {
      const wrongKind = Failure.validation(field: 'categoryId', reason: ValidationReason.wrongKind);
      expect(
        left(await save(ExpenseDraft(amount: const Money(1), walletId: me, categoryId: salary, date: today))),
        wrongKind,
      );
      expect(
        left(
          await save(
            ExpenseDraft(
              amount: const Money(1),
              walletId: me,
              categoryId: food,
              date: today,
              kind: TransactionKind.income,
            ),
          ),
        ),
        wrongKind,
      );
      final id = await add(100, today);
      expect(
        left(
          await save(
            ExpenseDraft(amount: const Money(1), walletId: me, categoryId: salary, date: today),
            id: id,
          ),
        ),
        wrongKind,
      );
      expect((await expense(id)).categoryId, food);
    });
  });

  test('the list stream updates after a change', () async {
    final counts = <int>[];
    final sub = repository.watchEntries(october, limit: 50).listen((r) => counts.add(right(r).length));
    await pumpEventQueue();
    await add(100, today);
    await pumpEventQueue();
    await sub.cancel();
    expect(counts, [0, 1]);
  });

  test('updates and deletes, reporting a missing id', () async {
    final id = await add(100, today);
    right(
      await save(
        ExpenseDraft(amount: const Money(999), walletId: me, categoryId: transport, date: today),
        id: id,
      ),
    );
    final updated = await expense(id);
    expect((updated.amount, updated.categoryId), (const Money(999), transport));

    right(await repository.delete(id));
    expect(left(await repository.delete(id)), const Failure.notFound());
    expect(
      left(
        await repository.update(
          id,
          ExpenseDraft(amount: const Money(1), walletId: me, categoryId: food, date: today),
        ),
      ),
      const Failure.notFound(),
    );
  });

  test('an unknown category is a constraint failure', () async {
    final result = await save(ExpenseDraft(amount: const Money(1), walletId: me, categoryId: 999, date: today));
    expect(left(result), isA<ConstraintFailure>());
  });

  group('wallets', () {
    test('a row belongs to its wallet, and can move to another', () async {
      final id = await add(100, today, wallet: son);
      expect((await expense(id)).walletId, son);

      right(
        await save(
          ExpenseDraft(amount: const Money(100), walletId: me, categoryId: food, date: today),
          id: id,
        ),
      );
      expect((await expense(id)).walletId, me);
    });

    test('an unknown wallet is a constraint failure', () async {
      final result = await save(ExpenseDraft(amount: const Money(1), walletId: 999, categoryId: food, date: today));
      expect(left(result), isA<ConstraintFailure>());
    });

    test('rows, totals and daily totals follow the wallet filter; no wallet is All wallets', () async {
      final mine = await add(1000, today);
      final his = await add(250, today, wallet: son);
      await addIncome(500000, today, wallet: son);

      final sonOnly = october.copyWith(walletId: son);
      expect((await entries(october)).map((e) => e.id), hasLength(3));
      expect((await entries(october.copyWith(walletId: me))).map((e) => e.id), [mine]);
      expect((await entries(sonOnly)).map((e) => e.id), contains(his));
      expect(
        right(await repository.watchTotals(sonOnly).first),
        const PeriodTotals(income: Money(500000), spent: Money(250)),
      );
      expect(
        right(await repository.watchTotals(october).first),
        const PeriodTotals(income: Money(500000), spent: Money(1250)),
      );
      expect(right(await repository.watchDailyTotals(october.copyWith(walletId: me)).first), {
        today: const PeriodTotals(income: Money.zero, spent: Money(1000)),
      });
    });

    test('search and the category filter work inside a wallet', () async {
      await add(100, today, title: 'Pocket money', wallet: son);
      final hers = await add(200, today, title: 'Pocket money');

      expect((await entries(october.copyWith(walletId: me, search: 'pocket'))).map((e) => e.id), [hers]);
      expect(await entries(october.copyWith(walletId: son, categoryId: transport)), isEmpty);
    });
  });

  group('transfers', () {
    late int transferId;

    Future<List<(int, int?)>> idsAndWallets(ExpenseFilter filter) async => [
      for (final e in await entries(filter)) (e.id, e is TransferEntry ? e.walletId : null),
    ];

    setUp(() async {
      await addIncome(500000, LocalDate(2026, 10, 1));
      await add(1000, LocalDate(2026, 10, 2));
      transferId = await addTransferRows(db, from: me, to: son, amountMinor: 50000, date: today, note: 'Pocket money');
    });

    test('a transfer is one entry in All wallets (its out leg), with both wallets', () async {
      final rows = await entries(october);
      expect(rows, hasLength(3));
      final transfer = rows.whereType<TransferEntry>().single;
      expect(transfer.transfer.id, transferId);
      expect((transfer.transfer.fromWalletId, transfer.transfer.toWalletId), (me, son));
      expect((transfer.transfer.amount, transfer.transfer.note), (const Money(50000), 'Pocket money'));
      expect(transfer.walletId, me);
    });

    test("in a single wallet it is that wallet's own leg", () async {
      final mine = (await entries(october.copyWith(walletId: me))).whereType<TransferEntry>().single;
      final his = (await entries(october.copyWith(walletId: son))).whereType<TransferEntry>().single;
      expect(mine.walletId, me);
      expect(his.walletId, son);
      expect(mine.id, isNot(his.id));
      // Both describe the same transfer, from Me to Son.
      expect((mine.transfer.id, mine.transfer.fromWalletId, mine.transfer.toWalletId), (transferId, me, son));
      expect((his.transfer.id, his.transfer.fromWalletId, his.transfer.toWalletId), (transferId, me, son));
    });

    test('a transfer is in no income or spending total, in any view', () async {
      expect(
        right(await repository.watchTotals(october).first),
        const PeriodTotals(income: Money(500000), spent: Money(1000)),
      );
      expect(right(await repository.watchTotals(october.copyWith(walletId: me)).first).income, const Money(500000));
      expect(right(await repository.watchTotals(october.copyWith(walletId: me)).first).spent, const Money(1000));
      expect(right(await repository.watchTotals(october.copyWith(walletId: son)).first).income, Money.zero);
      expect(right(await repository.watchTotals(october.copyWith(walletId: son)).first).spent, Money.zero);
    });

    test('it changes balances: out of one wallet, into the other, and nothing over all wallets', () async {
      final all = right(await repository.watchTotals(october).first);
      final mine = right(await repository.watchTotals(october.copyWith(walletId: me)).first);
      final his = right(await repository.watchTotals(october.copyWith(walletId: son)).first);

      expect(mine.transfersNet, const Money(-50000));
      expect(mine.balance, const Money(449000)); // 500000 − 1000 − 50000
      expect(his.transfersNet, const Money(50000));
      expect(his.balance, const Money(50000));
      expect(all.transfersNet, Money.zero);
      expect(all.balance, const Money(499000));
      expect(mine.balance + his.balance, all.balance, reason: 'no double count in All wallets');
    });

    test('daily totals count transfers in the net, and a kind or category filter leaves them out', () async {
      final daily = right(await repository.watchDailyTotals(october.copyWith(walletId: son)).first);
      expect(daily[today], const PeriodTotals(income: Money.zero, spent: Money.zero, transfersIn: Money(50000)));
      expect(right(await repository.watchDailyTotals(october).first)[today]?.transfersNet, Money.zero);

      expect(await entries(october.copyWith(kind: TransactionKind.expense)), hasLength(1));
      expect(await entries(october.copyWith(kind: TransactionKind.income)), hasLength(1));
      expect(await entries(october.copyWith(categoryId: food)), hasLength(1));
      final expenseTotals = right(
        await repository.watchTotals(october.copyWith(walletId: son, kind: TransactionKind.expense)).first,
      );
      expect(expenseTotals, PeriodTotals.zero);
    });

    test('search finds a transfer by its note', () async {
      expect((await entries(october.copyWith(search: 'pocket'))).whereType<TransferEntry>(), hasLength(1));
      expect(await entries(october.copyWith(search: 'rent')), isEmpty);
    });

    test('getEntry on either leg returns the transfer', () async {
      final legs = await idsAndWallets(october.copyWith(walletId: me));
      final outLeg = legs.firstWhere((l) => l.$2 != null).$1;
      final inLeg = (await idsAndWallets(october.copyWith(walletId: son))).single.$1;

      for (final leg in [outLeg, inLeg]) {
        final entry = right(await repository.getEntry(leg));
        expect(entry, isA<TransferEntry>());
        expect((entry as TransferEntry).transfer.id, transferId);
        expect(entry.rowId, leg);
      }
    });

    test('deleting either leg deletes the whole transfer', () async {
      final inLeg = (await idsAndWallets(october.copyWith(walletId: son))).single.$1;

      right(await repository.delete(inLeg));

      expect(await entries(october.copyWith(walletId: son)), isEmpty);
      expect((await entries(october.copyWith(walletId: me))).whereType<TransferEntry>(), isEmpty);
      expect(await db.select(db.transfersTable).get(), isEmpty);
      expect(await db.select(db.expensesTable).get(), hasLength(2));
      expect(left(await repository.delete(inLeg)), const Failure.notFound());
    });
  });

  group('source', () {
    test('a row typed by the user is manual, and its entry says so', () async {
      final id = await add(1250, today);

      final entry = right(await repository.getEntry(id)) as TransactionEntry;

      expect(entry.expense.source, ExpenseSource.manual);
      expect(entry.expense.isFromSms, isFalse);
    });

    test('an SMS row keeps its source, in lists and when read alone', () async {
      final id = right(
        await save(
          ExpenseDraft(
            amount: const Money(500),
            walletId: me,
            categoryId: transport,
            date: today,
            title: 'Uber',
            source: ExpenseSource.sms,
          ),
        ),
      );

      final entry = right(await repository.getEntry(id)) as TransactionEntry;
      final listed = right(
        await repository.watchEntries(october, limit: 10).first,
      ).whereType<TransactionEntry>().single;

      expect(entry.expense.source, ExpenseSource.sms);
      expect(entry.expense.isFromSms, isTrue);
      expect(listed.expense.source, ExpenseSource.sms);
      expect((await db.select(db.expensesTable).getSingle()).source, 'sms');
    });

    test('editing a row keeps its source, whatever the draft says', () async {
      final id = right(
        await save(
          ExpenseDraft(
            amount: const Money(500),
            walletId: me,
            categoryId: transport,
            date: today,
            source: ExpenseSource.sms,
          ),
        ),
      );

      right(
        await save(
          ExpenseDraft(amount: const Money(700), walletId: me, categoryId: transport, date: today),
          id: id,
        ),
      );

      final row = await db.select(db.expensesTable).getSingle();
      expect(row.amountMinor, 700);
      expect(row.source, 'sms');
    });

    test('the database refuses an unknown source', () async {
      await expectLater(
        db.customStatement(
          "INSERT INTO expenses (amount_minor, date, wallet_id, category_id, source) VALUES (1, '2026-10-08', $me, $food, 'import')",
        ),
        throwsA(anything),
      );
    });
  });
}
