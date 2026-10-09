import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_filter.dart';
import 'package:masroofy/features/expenses/domain/entities/list_entry.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/domain/usecases/delete_expense.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer_draft.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_transfer.dart';
import 'package:mocktail/mocktail.dart';

class _MockExpenses extends Mock implements IExpenseRepository {}

class _MockCategories extends Mock implements ICategoryRepository {}

class _MockWallets extends Mock implements IWalletRepository {}

class _MockDelete extends Mock implements DeleteExpense {}

class _MockSave extends Mock implements SaveExpense {}

class _MockSaveTransfer extends Mock implements SaveTransfer {}

final _today = LocalDate(2026, 10, 8);
final _epoch = DateTime.utc(2026, 10, 8);

ListEntry _expense(int id, int minor, {LocalDate? date, TransactionKind kind = TransactionKind.expense}) =>
    ListEntry.transaction(
      Expense(
        id: id,
        amount: Money(minor),
        walletId: 1,
        categoryId: kind == TransactionKind.income ? 2 : 1,
        date: date ?? _today,
        createdAt: _epoch,
        updatedAt: _epoch,
        kind: kind,
      ),
    );

/// A transfer from wallet 1 to wallet 2, listed by [wallet]'s leg.
ListEntry _transfer(int rowId, int minor, {required int wallet}) => ListEntry.transfer(
  Transfer(
    id: 7,
    fromWalletId: 1,
    toWalletId: 2,
    amount: Money(minor),
    date: _today,
    createdAt: _epoch,
    updatedAt: _epoch,
  ),
  rowId: rowId,
  walletId: wallet,
);

WalletSummary _wallet(int id, {String? name, int balance = 0}) => WalletSummary(
  wallet: Wallet(
    id: id,
    seedKey: id == 1 ? 'me' : null,
    name: id == 1 ? null : (name ?? 'Wallet $id'),
    icon: 'person',
    color: 0,
    sortOrder: id,
    createdAt: _epoch,
    updatedAt: _epoch,
  ),
  balance: Money(balance),
  transactionCount: 0,
  transferCount: 0,
  templateCount: 0,
);

final WalletSummary _me = _wallet(1);
final WalletSummary _son = _wallet(2, name: 'Son');

final _food = Category(
  id: 1,
  seedKey: 'food',
  icon: 'restaurant',
  color: 0,
  sortOrder: 0,
  createdAt: _epoch,
  updatedAt: _epoch,
);

final _salary = Category(
  id: 2,
  seedKey: 'salary',
  icon: 'payments',
  color: 0,
  sortOrder: 8,
  createdAt: _epoch,
  updatedAt: _epoch,
  kind: TransactionKind.income,
);

void main() {
  late _MockExpenses expenses;
  late _MockCategories categories;
  late _MockWallets wallets;
  late _MockDelete delete;
  late _MockSave save;
  late _MockSaveTransfer saveTransfer;

  setUpAll(() {
    registerFallbackValue(ExpenseFilter(range: DateRange(_today, _today)));
    registerFallbackValue(ExpenseDraft(amount: Money.zero, walletId: 0, categoryId: 0, date: _today));
    registerFallbackValue(
      TransferDraft(fromWalletId: 0, toWalletId: 0, amount: Money.zero, date: _today),
    );
    registerFallbackValue(DateRange(_today, _today));
  });

  setUp(() {
    expenses = _MockExpenses();
    categories = _MockCategories();
    wallets = _MockWallets();
    delete = _MockDelete();
    save = _MockSave();
    saveTransfer = _MockSaveTransfer();
    when(() => categories.watchAll(includeHidden: any(named: 'includeHidden'))).thenAnswer(
      (_) => Stream.value(Right([_food, _salary])),
    );
    when(() => wallets.watchSummaries(any())).thenAnswer((_) => Stream.value(Right([_me, _son])));
  });

  group('ExpenseListCubit', () {
    final page = [_expense(3, 15000), _expense(2, 8550), _expense(1, 24000, date: _today.addDays(-1))];

    void stubData({List<ListEntry>? rows}) {
      final list = rows ?? page;
      when(
        () => expenses.watchEntries(any(), limit: any(named: 'limit')),
      ).thenAnswer((_) => Stream.value(Right(list)));
      when(() => expenses.watchTotals(any())).thenAnswer((invocation) {
        final filter = invocation.positionalArguments.single as ExpenseFilter;
        // The comparison period lies entirely before this month.
        final isComparison = filter.range.end.isBefore(_today.startOfMonth);
        return Stream.value(
          Right(
            PeriodTotals(income: Money(isComparison ? 100000 : 300000), spent: Money(isComparison ? 40000 : 47550)),
          ),
        );
      });
      when(() => expenses.watchDailyTotals(any())).thenAnswer(
        (_) => Stream.value(
          Right({
            _today: const PeriodTotals(income: Money.zero, spent: Money(23550)),
            _today.addDays(-1): const PeriodTotals(income: Money.zero, spent: Money(24000)),
          }),
        ),
      );
    }

    ExpenseListCubit build({int? walletId}) => ExpenseListCubit(
      expenses,
      categories,
      wallets,
      delete,
      firstWeekday: DateTime.saturday,
      walletId: walletId,
      today: () => _today,
    );

    test('loads the month to date on All, with income and spending but no comparison', () async {
      stubData();
      final cubit = build()..load();
      await pumpEventQueue();

      final state = cubit.state;
      expect(state.status, ExpenseListStatus.loaded);
      expect(state.kind, isNull);
      expect(state.range, DateRange(LocalDate(2026, 10, 1), _today));
      expect(state.entries, page);
      expect(state.totals, const PeriodTotals(income: Money(300000), spent: Money(47550)));
      expect(state.totals.balance, const Money(252450));
      expect(state.previousTotals, isNull);
      expect(state.categories, {1: _food, 2: _salary});
      expect(state.hasMore, isFalse);
      verifyNever(
        () => expenses.watchTotals(any(that: isA<ExpenseFilter>().having((f) => f.range.end.month, 'month', 9))),
      );
      await cubit.close();
    });

    test('the Expenses filter compares spending with the same days of last month', () async {
      stubData();
      final cubit = build()..load();
      await pumpEventQueue();
      cubit.selectKind(TransactionKind.expense);
      await pumpEventQueue();

      expect(cubit.state.kind, TransactionKind.expense);
      expect(cubit.state.previousTotals?.spent, const Money(40000));
      verify(
        () => expenses.watchTotals(
          ExpenseFilter(
            range: DateRange(LocalDate(2026, 9, 1), LocalDate(2026, 9, 8)),
            kind: TransactionKind.expense,
            search: '',
          ),
        ),
      ).called(1);
      await cubit.close();
    });

    test('the Income filter queries income rows and offers only income categories', () async {
      stubData();
      final cubit = build()..load();
      await pumpEventQueue();
      cubit.selectKind(TransactionKind.income);
      await pumpEventQueue();

      expect(cubit.state.filterCategories, [_salary]);
      verify(
        () => expenses.watchEntries(
          any(that: isA<ExpenseFilter>().having((f) => f.kind, 'kind', TransactionKind.income)),
          limit: any(named: 'limit'),
        ),
      ).called(1);
      cubit.selectKind(null);
      expect(cubit.state.filterCategories, [_food, _salary]);
      await cubit.close();
    });

    test('switching kind drops a selected category of the other kind', () async {
      stubData();
      final cubit = build()..load();
      await pumpEventQueue();
      cubit
        ..selectCategory(1)
        ..selectKind(TransactionKind.expense);
      expect(cubit.state.categoryId, 1);

      cubit.selectKind(TransactionKind.income);
      expect(cubit.state.categoryId, isNull);
      await cubit.close();
    });

    test('switching to this week re-queries the week to date', () async {
      stubData();
      final cubit = build()..load();
      await pumpEventQueue();
      cubit
        ..selectKind(TransactionKind.expense)
        ..selectPeriod(ExpensePeriod.week);
      await pumpEventQueue();

      expect(cubit.state.range, DateRange(LocalDate(2026, 10, 3), _today));
      verify(
        () => expenses.watchTotals(
          ExpenseFilter(
            range: DateRange(LocalDate(2026, 9, 26), LocalDate(2026, 10, 1)),
            kind: TransactionKind.expense,
            search: '',
          ),
        ),
      ).called(1);
      await cubit.close();
    });

    test('search is debounced', () async {
      stubData();
      final cubit = build()..load();
      await pumpEventQueue();
      cubit
        ..searchChanged('l')
        ..searchChanged('lunch');
      await Future<void>.delayed(ExpenseListCubit.searchDebounce + const Duration(milliseconds: 50));

      expect(cubit.state.search, 'lunch');
      verify(
        () => expenses.watchEntries(
          any(that: _hasSearch('lunch')),
          limit: any(named: 'limit'),
        ),
      ).called(1);
      verifyNever(
        () => expenses.watchEntries(
          any(that: _hasSearch('l')),
          limit: any(named: 'limit'),
        ),
      );
      await cubit.close();
    });

    test('a full page offers more, and loadMore grows the limit', () async {
      stubData(rows: List.generate(50, (i) => _expense(i + 1, 100)));
      final cubit = build()..load();
      await pumpEventQueue();
      expect(cubit.state.hasMore, isTrue);

      cubit.loadMore();
      await pumpEventQueue();
      verify(() => expenses.watchEntries(any(), limit: 100)).called(1);
      await cubit.close();
    });

    test('swipe hides the row and its amount; undo restores it', () async {
      stubData();
      final cubit = build()..load();
      await pumpEventQueue();

      cubit.hide(3);
      expect(cubit.state.entries.map((e) => e.id), [2, 1]);
      expect(cubit.state.visibleTotals.spent, const Money(32550));
      expect(cubit.state.dayTotals(_today).spent, const Money(8550));

      cubit.undoDelete(3);
      expect(cubit.state.entries.map((e) => e.id), [3, 2, 1]);
      await cubit.close();
      verifyNever(() => delete(any()));
    });

    test('swiping an income row takes it off the income, not the spending', () async {
      stubData(
        rows: [
          _expense(9, 100000, kind: TransactionKind.income),
          ...page,
        ],
      );
      when(() => delete(any())).thenAnswer((_) async => const Right(unit));
      final cubit = build()..load();
      await pumpEventQueue();

      cubit.hide(9);
      expect(cubit.state.visibleTotals, const PeriodTotals(income: Money(200000), spent: Money(47550)));
      await cubit.close();
    });

    test('a failed delete brings the row back with a failure', () async {
      stubData();
      when(() => delete(3)).thenAnswer((_) async => const Left(Failure.storage(message: 'disk')));
      final cubit = build()..load();
      await pumpEventQueue();

      cubit.hide(3);
      await cubit.commitDelete(3);
      expect(cubit.state.entries.map((e) => e.id), [3, 2, 1]);
      expect(cubit.state.actionFailure, const Failure.storage(message: 'disk'));
      await cubit.close();
    });

    test('closing the screen commits pending deletes, once', () async {
      stubData();
      when(() => delete(any())).thenAnswer((_) async => const Right(unit));
      final cubit = build()..load();
      await pumpEventQueue();

      cubit
        ..hide(3)
        ..hide(2);
      await cubit.commitDelete(3);
      await cubit.close();
      verify(() => delete(3)).called(1);
      verify(() => delete(2)).called(1);
    });

    group('wallets', () {
      test('loads every wallet with its balance, and starts on All wallets by default', () async {
        stubData();
        final cubit = build()..load();
        await pumpEventQueue();

        expect(cubit.state.walletId, isNull);
        expect(cubit.state.wallet, isNull);
        expect(cubit.state.wallets, [_me, _son]);
        // The balances are this month to date.
        verify(() => wallets.watchSummaries(DateRange(LocalDate(2026, 10, 1), _today))).called(1);
        await cubit.close();
      });

      test('starts on the wallet viewed, and every query follows it', () async {
        stubData();
        final cubit = build(walletId: 2)..load();
        await pumpEventQueue();

        expect(cubit.state.wallet, _son);
        final inSon = isA<ExpenseFilter>().having((f) => f.walletId, 'walletId', 2);
        verify(
          () => expenses.watchEntries(
            any(that: inSon),
            limit: any(named: 'limit'),
          ),
        ).called(1);
        verify(() => expenses.watchTotals(any(that: inSon))).called(1);
        verify(() => expenses.watchDailyTotals(any(that: inSon))).called(1);
        await cubit.close();
      });

      test('switching wallet re-queries rows, totals, filters and search for it', () async {
        stubData();
        final cubit = build()..load();
        await pumpEventQueue();
        cubit
          ..selectKind(TransactionKind.expense)
          ..selectCategory(1)
          ..selectWallet(2);
        await pumpEventQueue();

        expect(cubit.state.walletId, 2);
        // The filters and the period stay as they were.
        expect((cubit.state.kind, cubit.state.categoryId), (TransactionKind.expense, 1));
        verify(
          () => expenses.watchEntries(
            any(
              that: isA<ExpenseFilter>()
                  .having((f) => f.walletId, 'walletId', 2)
                  .having((f) => f.kind, 'kind', TransactionKind.expense)
                  .having((f) => f.categoryId, 'categoryId', 1),
            ),
            limit: any(named: 'limit'),
          ),
        ).called(1);

        cubit.selectWallet(null);
        await pumpEventQueue();
        expect(cubit.state.walletId, isNull);
        await cubit.close();
      });

      test('picking the wallet already viewed re-queries nothing', () async {
        stubData();
        final cubit = build(walletId: 2)..load();
        await pumpEventQueue();
        clearInteractions(expenses);

        cubit.selectWallet(2);
        await pumpEventQueue();
        verifyZeroInteractions(expenses);
        await cubit.close();
      });

      test("a transfer is listed, and swiping it takes its leg out of that wallet's balance", () async {
        // Viewing Son: the transfer's in leg is a +500 in the balance.
        stubData(rows: [_transfer(12, 50000, wallet: 2), ...page]);
        when(() => expenses.watchTotals(any())).thenAnswer(
          (_) => Stream.value(
            const Right(PeriodTotals(income: Money(300000), spent: Money(47550), transfersIn: Money(50000))),
          ),
        );
        final cubit = build(walletId: 2)..load();
        await pumpEventQueue();
        expect(cubit.state.entries.first, isA<TransferEntry>());
        expect(cubit.state.totals.balance, const Money(302450));

        cubit.hide(12);
        expect(cubit.state.entries.map((e) => e.id), [3, 2, 1]);
        expect(cubit.state.visibleTotals.transfersNet, Money.zero);
        expect(cubit.state.visibleTotals.balance, const Money(252450));

        cubit.undoDelete(12);
        expect(cubit.state.visibleTotals.transfersNet, const Money(50000));
        await cubit.close();
      });

      test('in All wallets hiding a transfer leaves the totals alone: its legs cancel out', () async {
        stubData(rows: [_transfer(11, 50000, wallet: 1), ...page]);
        when(() => delete(any())).thenAnswer((_) async => const Right(unit));
        final cubit = build()..load();
        await pumpEventQueue();

        cubit.hide(11);
        expect(cubit.state.visibleTotals, cubit.state.totals);
        await cubit.close();
      });

      test('deleting a transfer row deletes through the one use case, by the row listed', () async {
        stubData(rows: [_transfer(12, 50000, wallet: 2), ...page]);
        when(() => delete(any())).thenAnswer((_) async => const Right(unit));
        final cubit = build(walletId: 2)..load();
        await pumpEventQueue();

        cubit.hide(12);
        await cubit.commitDelete(12);
        verify(() => delete(12)).called(1);
        await cubit.close();
      });
    });
  });

  group('ExpenseFormCubit', () {
    ExpenseFormCubit build({int? id}) => ExpenseFormCubit(
      expenses,
      categories,
      wallets,
      save,
      saveTransfer,
      fractionDigits: 2,
      expenseId: id,
      today: () => _today,
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'switching to Income clears an expense category, and Save asks for one',
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..amountChanged('50')
          ..categorySelected(1)
          ..kindSelected(TransactionKind.income);
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.kind, TransactionKind.income);
        expect(cubit.state.categoryId, isNull);
        expect(cubit.state.pickerCategories, [_salary]);
        expect(cubit.state.errors, {'categoryId': ValidationReason.required});
        verifyNever(() => save(any(), id: any(named: 'id')));
      },
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'switching kind keeps a category of the new kind',
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..kindSelected(TransactionKind.income)
          ..categorySelected(2)
          ..kindSelected(TransactionKind.income);
      },
      verify: (cubit) => expect(cubit.state.categoryId, 2),
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'saves an income row with its kind',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(8)),
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..kindSelected(TransactionKind.income)
          ..amountChanged('5000')
          ..categorySelected(2);
        await cubit.save();
      },
      verify: (cubit) {
        verify(
          () => save(
            ExpenseDraft(
              amount: const Money(500000),
              walletId: 1,
              categoryId: 2,
              date: _today,
              title: '',
              note: '',
              kind: TransactionKind.income,
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'a wrong-kind category from the repository lands on the category field',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer(
        (_) async => const Left(Failure.validation(field: 'categoryId', reason: ValidationReason.wrongKind)),
      ),
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..amountChanged('5')
          ..categorySelected(1);
        await cubit.save();
      },
      verify: (cubit) => expect(cubit.state.errors, {'categoryId': ValidationReason.wrongKind}),
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'editing an income row opens on Income',
      setUp: () => when(() => expenses.getEntry(4)).thenAnswer(
        (_) async => Right(_expense(4, 500000, kind: TransactionKind.income)),
      ),
      build: () => build(id: 4),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect((cubit.state.kind, cubit.state.categoryId), (TransactionKind.income, 2));
        expect(cubit.state.isEditing, isTrue);
      },
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'requires an amount and a category before saving',
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.save();
      },
      skip: 3,
      expect: () => [
        isA<ExpenseFormState>().having((s) => s.errors, 'errors', {
          'amount': ValidationReason.required,
          'categoryId': ValidationReason.required,
        }),
      ],
      verify: (_) => verifyNever(() => save(any(), id: any(named: 'id'))),
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'parses Arabic-Indic input and saves today by default',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(7)),
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..amountChanged('١٢٫٥')
          ..categorySelected(1)
          ..titleChanged(' Lunch ');
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.status, ExpenseFormStatus.saved);
        verify(
          () => save(
            ExpenseDraft(
              amount: const Money(1250),
              walletId: 1,
              categoryId: 1,
              date: _today,
              title: ' Lunch ',
              note: '',
            ),
          ),
        ).called(1);
      },
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'rejects more decimals than the currency allows',
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..amountChanged('1.234')
          ..categorySelected(1);
        await cubit.save();
      },
      verify: (cubit) => expect(cubit.state.errors, {'amount': ValidationReason.invalidFormat}),
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'editing pre-fills the fields',
      setUp: () => when(() => expenses.getEntry(3)).thenAnswer(
        (_) async => Right(
          ListEntry.transaction(
            (_expense(3, 15000) as TransactionEntry).expense.copyWith(title: 'Lunch', note: 'team', walletId: 2),
          ),
        ),
      ),
      build: () => build(id: 3),
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        final s = cubit.state;
        expect(
          (s.status, s.amountText, s.categoryId, s.walletId, s.title, s.note),
          (ExpenseFormStatus.ready, '150.00', 1, 2, 'Lunch', 'team'),
        );
      },
    );

    blocTest<ExpenseFormCubit, ExpenseFormState>(
      'a domain validation failure lands on its field',
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer(
        (_) async => const Left(Failure.validation(field: 'date', reason: ValidationReason.inFuture)),
      ),
      build: build,
      act: (cubit) async {
        await cubit.load();
        cubit
          ..amountChanged('5')
          ..categorySelected(1);
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.status, ExpenseFormStatus.ready);
        expect(cubit.state.errors, {'date': ValidationReason.inFuture});
      },
    );

    group('wallet', () {
      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'starts in the wallet preset before loading (the viewed one, or the default)',
        build: build,
        act: (cubit) async {
          cubit.walletSelected(2);
          await cubit.load();
        },
        verify: (cubit) {
          expect(cubit.state.walletId, 2);
          expect(cubit.state.walletById(2), _son);
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'falls back to the first wallet when the preset one is gone, or nothing was preset',
        build: build,
        act: (cubit) async {
          cubit.walletSelected(99);
          await cubit.load();
        },
        verify: (cubit) => expect(cubit.state.walletId, 1),
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'the Wallet field overrides the preset',
        setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(7)),
        build: build,
        act: (cubit) async {
          cubit.walletSelected(1);
          await cubit.load();
          cubit
            ..walletSelected(2)
            ..amountChanged('5')
            ..categorySelected(1);
          await cubit.save();
        },
        verify: (cubit) {
          verify(
            () => save(
              ExpenseDraft(amount: const Money(500), walletId: 2, categoryId: 1, date: _today, title: '', note: ''),
            ),
          ).called(1);
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'editing keeps the wallet of the row, whatever is preset',
        setUp: () => when(() => expenses.getEntry(3)).thenAnswer((_) async => Right(_expense(3, 15000))),
        build: () => build(id: 3),
        act: (cubit) => cubit.load(),
        verify: (cubit) => expect(cubit.state.walletId, 1),
      );
    });

    group('transfer', () {
      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'the third type has no category and no title; with two wallets To is the other one',
        build: build,
        act: (cubit) async {
          cubit.walletSelected(1);
          await cubit.load();
          cubit.transferSelected();
        },
        verify: (cubit) {
          expect(cubit.state.isTransfer, isTrue);
          expect((cubit.state.walletId, cubit.state.toWalletId), (1, 2));
          expect(cubit.state.needsSecondWallet, isFalse);
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'saves a transfer between the two wallets',
        setUp: () => when(() => saveTransfer(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(5)),
        build: build,
        act: (cubit) async {
          cubit.walletSelected(1);
          await cubit.load();
          cubit
            ..transferSelected()
            ..amountChanged('500')
            ..noteChanged('Pocket money');
          await cubit.save();
        },
        verify: (cubit) {
          expect(cubit.state.status, ExpenseFormStatus.saved);
          verify(
            () => saveTransfer(
              TransferDraft(
                fromWalletId: 1,
                toWalletId: 2,
                amount: const Money(50000),
                date: _today,
                note: 'Pocket money',
              ),
            ),
          ).called(1);
          verifyNever(() => save(any(), id: any(named: 'id')));
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        "picking the other side's wallet swaps the two, so they always differ",
        build: build,
        act: (cubit) async {
          cubit.walletSelected(1);
          await cubit.load();
          cubit
            ..transferSelected()
            ..walletSelected(2);
        },
        verify: (cubit) => expect((cubit.state.walletId, cubit.state.toWalletId), (2, 1)),
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'To needs a choice with more than two wallets, and the same wallet is refused',
        setUp: () {
          when(() => wallets.watchSummaries(any())).thenAnswer((_) => Stream.value(Right([_me, _son, _wallet(3)])));
          when(() => saveTransfer(any(), id: any(named: 'id'))).thenAnswer(
            (_) async => const Left(Failure.validation(field: 'toWallet', reason: ValidationReason.sameWallet)),
          );
        },
        build: build,
        act: (cubit) async {
          cubit.walletSelected(1);
          await cubit.load();
          cubit
            ..transferSelected()
            ..amountChanged('500');
          await cubit.save();
        },
        verify: (cubit) {
          expect(cubit.state.toWalletId, isNull);
          expect(cubit.state.errors, {'toWallet': ValidationReason.required});
          verifyNever(() => saveTransfer(any(), id: any(named: 'id')));
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'the same-wallet failure lands on the To field',
        setUp: () => when(() => saveTransfer(any(), id: any(named: 'id'))).thenAnswer(
          (_) async => const Left(Failure.validation(field: 'toWallet', reason: ValidationReason.sameWallet)),
        ),
        build: build,
        act: (cubit) async {
          cubit.walletSelected(1);
          await cubit.load();
          cubit
            ..transferSelected()
            ..amountChanged('5');
          await cubit.save();
        },
        verify: (cubit) {
          expect(cubit.state.status, ExpenseFormStatus.ready);
          expect(cubit.state.errors, {'toWallet': ValidationReason.sameWallet});
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'with one wallet there is nothing to transfer between, and Save is off',
        setUp: () => when(() => wallets.watchSummaries(any())).thenAnswer((_) => Stream.value(Right([_me]))),
        build: build,
        act: (cubit) async {
          await cubit.load();
          cubit.transferSelected();
        },
        verify: (cubit) {
          expect(cubit.state.needsSecondWallet, isTrue);
          expect(cubit.state.canSave, isFalse);
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'going back to Expense or Income leaves the transfer, and keeps the kind',
        build: build,
        act: (cubit) async {
          await cubit.load();
          cubit
            ..kindSelected(TransactionKind.income)
            ..transferSelected()
            ..kindSelected(TransactionKind.income);
        },
        verify: (cubit) => expect((cubit.state.isTransfer, cubit.state.kind), (false, TransactionKind.income)),
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'editing a transfer opens it, from either leg, with both wallets',
        setUp: () => when(() => expenses.getEntry(12)).thenAnswer(
          (_) async => Right(_transfer(12, 50000, wallet: 2)),
        ),
        build: () => build(id: 12),
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          final s = cubit.state;
          expect((s.isTransfer, s.isEditing, s.transferId, s.walletId, s.toWalletId), (true, true, 7, 1, 2));
          expect((s.amountText, s.status), ('500.00', ExpenseFormStatus.ready));
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        'saving an edited transfer updates it by its transfer id',
        setUp: () {
          when(() => expenses.getEntry(12)).thenAnswer((_) async => Right(_transfer(12, 50000, wallet: 2)));
          when(() => saveTransfer(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(7));
        },
        build: () => build(id: 12),
        act: (cubit) async {
          await cubit.load();
          cubit.amountChanged('600');
          await cubit.save();
        },
        verify: (cubit) {
          verify(
            () => saveTransfer(
              TransferDraft(fromWalletId: 1, toWalletId: 2, amount: const Money(60000), date: _today, note: ''),
              id: 7,
            ),
          ).called(1);
          expect(cubit.state.status, ExpenseFormStatus.saved);
        },
      );

      blocTest<ExpenseFormCubit, ExpenseFormState>(
        "a saved row can't become a transfer",
        setUp: () => when(() => expenses.getEntry(3)).thenAnswer((_) async => Right(_expense(3, 15000))),
        build: () => build(id: 3),
        act: (cubit) async {
          await cubit.load();
          cubit.transferSelected();
        },
        verify: (cubit) => expect(cubit.state.isTransfer, isFalse),
      );
    });
  });
}

Matcher _hasSearch(String text) => isA<ExpenseFilter>().having((f) => f.search, 'search', text);
