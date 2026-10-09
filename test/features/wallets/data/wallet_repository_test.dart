import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/wallets/data/datasources/wallet_local_datasource.dart';
import 'package:masroofy/features/wallets/data/repositories/wallet_repository_impl.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_draft.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/domain/usecases/delete_wallet.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_wallet.dart';

import '../../../helpers/db_rows.dart';

void main() {
  late AppDatabase db;
  late WalletRepositoryImpl repository;
  late SaveWallet save;
  late DeleteWallet delete;
  late int me;
  final october = DateRange(LocalDate(2026, 10, 1), LocalDate(2026, 10, 31));
  final today = LocalDate(2026, 10, 8);

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repository = WalletRepositoryImpl(WalletLocalDatasource(db));
    save = SaveWallet(repository);
    delete = DeleteWallet(repository);
    me = await db.seedDefaultWallet();
  });
  tearDown(() => db.close());

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));
  Failure left<T>(Either<Failure, T> result) => result.getLeft().getOrElse(() => fail('expected Left'));

  WalletDraft draft(String? name, {String icon = 'child', int color = 0xFF26C6DA}) =>
      WalletDraft(name: name, icon: icon, color: color);

  Future<int> seedCategory(String key) async =>
      (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals(key))).getSingle()).id;

  Future<void> spend(int wallet, int minor, {LocalDate? date, int? category}) async => db
      .into(db.expensesTable)
      .insert(
        ExpensesTableCompanion.insert(
          amountMinor: minor,
          walletId: wallet,
          categoryId: Value(category ?? await seedCategory('food')),
          date: date ?? today,
        ),
      );

  Future<void> earn(int wallet, int minor, {LocalDate? date}) async =>
      spend(wallet, minor, date: date, category: await seedCategory('salary'));

  Future<List<WalletSummary>> summaries([DateRange? range]) async =>
      right(await repository.watchSummaries(range ?? october).first);

  group('save', () {
    test('creates a wallet after the existing ones, trimming its name', () async {
      final son = right(await save(draft('  My   Son ')));
      final wife = right(await save(draft('Wife')));

      final wallets = await summaries();
      expect(wallets.map((w) => w.wallet.id), [me, son, wife]);
      expect(wallets.map((w) => w.wallet.sortOrder), [0, 1, 2]);
      expect(wallets[1].wallet.name, 'My Son');
      expect(wallets[1].wallet.seedKey, isNull);
      expect((wallets[1].wallet.icon, wallets[1].wallet.color), ('child', 0xFF26C6DA));
    });

    test('names are unique ignoring case and spacing', () async {
      right(await save(draft('Son')));

      for (final name in ['son', ' SON ', 'sOn']) {
        expect(
          left(await save(draft(name))),
          const Failure.validation(field: 'name', reason: ValidationReason.duplicate),
        );
      }
      expect(await summaries(), hasLength(2));
    });

    test('a name is required, up to 30 characters, and the icon must be one of the set', () async {
      expect(left(await save(draft(''))), const Failure.validation(field: 'name', reason: ValidationReason.required));
      expect(
        left(await save(draft('   '))),
        const Failure.validation(field: 'name', reason: ValidationReason.required),
      );
      expect(left(await save(draft(null))), const Failure.validation(field: 'name', reason: ValidationReason.required));
      expect(
        left(await save(draft('x' * 31))),
        const Failure.validation(field: 'name', reason: ValidationReason.tooLong),
      );
      expect(right(await save(draft('x' * 30))), greaterThan(0));
      expect(
        left(await save(draft('Home', icon: 'rocket'))),
        const Failure.validation(field: 'icon', reason: ValidationReason.invalidFormat),
      );
    });

    test('editing may keep its own name, and changes icon and colour', () async {
      final son = right(await save(draft('Son')));

      right(await save(draft('Son', icon: 'school', color: 0xFF000001), id: son));

      final wallet = right(await repository.getById(son));
      expect((wallet.name, wallet.icon, wallet.color), ('Son', 'school', 0xFF000001));
      expect(left(await save(draft('Son'), id: 999)), const Failure.notFound());
    });

    test('Me keeps its seeded name when none is given, and a typed name replaces the seed key', () async {
      right(await save(draft(null, icon: 'home'), id: me));
      var wallet = right(await repository.getById(me));
      expect((wallet.seedKey, wallet.name, wallet.icon), (DefaultWallets.meSeedKey, null, 'home'));

      right(await save(draft('Mine'), id: me));
      wallet = right(await repository.getById(me));
      expect((wallet.seedKey, wallet.name), (null, 'Mine'));
    });
  });

  group('summaries', () {
    test("carry this month's balance: income minus spending, with transfers in and out", () async {
      final son = right(await save(draft('Son')));
      await earn(me, 500000, date: LocalDate(2026, 10, 1));
      await spend(me, 12000);
      await spend(me, 9999, date: LocalDate(2026, 9, 30)); // another month
      await addTransferRows(db, from: me, to: son, amountMinor: 50000, date: today);
      await spend(son, 700);

      final wallets = await summaries();
      expect(wallets.map((w) => w.balance), [const Money(438000), const Money(49300)]);
      // Over all wallets the transfer cancels out.
      expect(Money.sum(wallets.map((w) => w.balance)), const Money(487300));
    });

    test('count rows, transfer legs and templates', () async {
      final son = right(await save(draft('Son')));
      await spend(me, 100);
      await addTransferRows(db, from: me, to: son, amountMinor: 500, date: today);
      await db
          .into(db.recurringExpensesTable)
          .insert(
            RecurringExpensesTableCompanion.insert(
              title: 'Pocket money',
              amountMinor: 1000,
              walletId: son,
              categoryId: await seedCategory('food'),
              frequency: 'monthly',
              startDate: today,
              nextDueDate: today,
            ),
          );

      final wallets = await summaries();
      expect(wallets.map((w) => (w.transactionCount, w.transferCount, w.templateCount)), [(2, 1, 0), (1, 1, 1)]);
      expect(wallets.map((w) => w.isInUse), [true, true]);
    });

    test('the stream updates after a change', () async {
      final counts = <int>[];
      final sub = repository.watchSummaries(october).listen((r) => counts.add(right(r).length));
      await pumpEventQueue();
      await save(draft('Son'));
      await pumpEventQueue();
      await sub.cancel();
      expect(counts, [1, 2]);
    });
  });

  group('delete', () {
    test("the last wallet can't be deleted", () async {
      expect(left(await delete(me)), const Failure.validation(field: 'wallet', reason: ValidationReason.lastWallet));
      expect(await summaries(), hasLength(1));
    });

    test('an unused wallet goes without a move target', () async {
      final son = right(await save(draft('Son')));

      right(await delete(son));

      expect((await summaries()).map((w) => w.wallet.id), [me]);
      expect(left(await delete(son)), const Failure.notFound());
    });

    test('a wallet with rows or templates needs a wallet to move them to', () async {
      final son = right(await save(draft('Son')));
      await spend(son, 100);

      expect(left(await delete(son)), const Failure.validation(field: 'moveTo', reason: ValidationReason.required));
      expect(left(await delete(son, moveTo: son)), isA<ValidationFailure>());
      expect(await summaries(), hasLength(2));
    });

    test('moves its rows and templates to the chosen wallet, then deletes it', () async {
      final son = right(await save(draft('Son')));
      final wife = right(await save(draft('Wife')));
      await spend(son, 100);
      await spend(wife, 300);
      await db
          .into(db.recurringExpensesTable)
          .insert(
            RecurringExpensesTableCompanion.insert(
              title: 'Pocket money',
              amountMinor: 1000,
              walletId: son,
              categoryId: await seedCategory('food'),
              frequency: 'monthly',
              startDate: today,
              nextDueDate: today,
            ),
          );

      right(await delete(son, moveTo: wife));

      final wallets = await summaries();
      expect(wallets.map((w) => w.wallet.id), [me, wife]);
      expect(wallets.last.transactionCount, 2);
      expect(wallets.last.templateCount, 1);
      expect((await db.select(db.expensesTable).get()).map((e) => e.walletId), [wife, wife]);
      expect((await db.select(db.recurringExpensesTable).getSingle()).walletId, wife);
    });

    test('transfers with it become ordinary rows: expense in Other, income in Other income', () async {
      final son = right(await save(draft('Son')));
      await addTransferRows(db, from: me, to: son, amountMinor: 50000, date: today, note: 'Pocket money');

      right(await delete(son, moveTo: me));

      expect(await db.select(db.transfersTable).get(), isEmpty);
      final rows = await (db.select(db.expensesTable)..orderBy([(e) => OrderingTerm(expression: e.id)])).get();
      expect(rows, hasLength(2));
      final other = await seedCategory('other');
      final otherIncome = await seedCategory('other_income');
      // The out leg is an expense, the in leg income, both now in Me; neither is a transfer leg.
      expect(rows.map((e) => (e.walletId, e.categoryId, e.transferId, e.direction, e.amountMinor, e.note)), [
        (me, other, null, null, 50000, 'Pocket money'),
        (me, otherIncome, null, null, 50000, 'Pocket money'),
      ]);
      // Me's balance is unchanged by the deletion.
      expect((await summaries()).single.balance, Money.zero);
    });

    test('a transfer between two other wallets is left alone', () async {
      final son = right(await save(draft('Son')));
      final wife = right(await save(draft('Wife')));
      await addTransferRows(db, from: me, to: son, amountMinor: 500, date: today);

      right(await delete(wife));

      expect(await db.select(db.transfersTable).get(), hasLength(1));
      expect((await summaries()).map((w) => w.transferCount), [1, 1]);
    });
  });
}
