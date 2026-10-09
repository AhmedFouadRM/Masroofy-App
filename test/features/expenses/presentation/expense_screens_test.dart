import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/entities/list_entry.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_list_screen.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:material_symbols_icons/symbols.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockList extends MockCubit<ExpenseListState> implements ExpenseListCubit {}

class _MockForm extends MockCubit<ExpenseFormState> implements ExpenseFormCubit {}

final _today = LocalDate.today();
final _epoch = DateTime.utc(2026);

final _food = Category(
  id: 1,
  seedKey: 'food',
  icon: 'restaurant',
  color: 0xFFF97316,
  sortOrder: 0,
  createdAt: _epoch,
  updatedAt: _epoch,
);

final _salary = Category(
  id: 2,
  seedKey: 'salary',
  icon: 'payments',
  color: 0xFF6366F1,
  sortOrder: 8,
  createdAt: _epoch,
  updatedAt: _epoch,
  kind: TransactionKind.income,
);

ListEntry _expense(
  int id,
  int minor, {
  String? title,
  String? note,
  LocalDate? date,
  int wallet = 1,
  TransactionKind kind = TransactionKind.expense,
}) => ListEntry.transaction(
  Expense(
    id: id,
    amount: Money(minor),
    walletId: wallet,
    categoryId: kind == TransactionKind.income ? 2 : 1,
    date: date ?? _today,
    title: title,
    note: note,
    createdAt: _epoch,
    updatedAt: _epoch,
    kind: kind,
  ),
);

/// A transfer of [minor] from wallet 1 (Me) to wallet 2 (Son), listed by the leg in [wallet].
ListEntry _transfer(int rowId, int minor, {required int wallet, String? note}) => ListEntry.transfer(
  Transfer(
    id: 7,
    fromWalletId: 1,
    toWalletId: 2,
    amount: Money(minor),
    date: _today,
    note: note,
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
    icon: id == 1 ? 'person' : 'child',
    color: 0xFF059669,
    sortOrder: id,
    createdAt: _epoch,
    updatedAt: _epoch,
  ),
  balance: Money(balance),
  transactionCount: 0,
  transferCount: 0,
  templateCount: 0,
);

final WalletSummary _me = _wallet(1, balance: 450000);
final WalletSummary _son = _wallet(2, name: 'Son', balance: 50000);

// Bidi isolates that wrap signed amounts.
const _lri = '\u2066';
const _pdi = '\u2069';

void main() {
  group('ExpenseListScreen', () {
    late _MockList cubit;
    // The Expenses filter: today's spending card.
    final loaded = ExpenseListState(
      period: ExpensePeriod.month,
      range: DateRange.monthToDate(_today),
      status: ExpenseListStatus.loaded,
      kind: TransactionKind.expense,
      loaded: [
        _expense(2, 15000, title: 'Lunch', note: 'with the team'),
        _expense(1, 8550, date: _today.addDays(-1)),
      ],
      totals: const PeriodTotals(income: Money.zero, spent: Money(23550)),
      previousTotals: const PeriodTotals(income: Money.zero, spent: Money(20000)),
      dailyTotals: {
        _today: const PeriodTotals(income: Money.zero, spent: Money(15000)),
        _today.addDays(-1): const PeriodTotals(income: Money.zero, spent: Money(8550)),
      },
      categories: {1: _food, 2: _salary},
    );

    // All: the balance card, with a salary row.
    final all = loaded.copyWith(
      kind: null,
      previousTotals: null,
      loaded: [
        _expense(3, 500000, kind: TransactionKind.income),
        ...loaded.loaded,
      ],
      totals: const PeriodTotals(income: Money(500000), spent: Money(23550)),
      dailyTotals: {
        _today: const PeriodTotals(income: Money(500000), spent: Money(15000)),
        _today.addDays(-1): const PeriodTotals(income: Money.zero, spent: Money(8550)),
      },
    );

    late MockSettingsCubit settings;

    setUp(() {
      cubit = _MockList();
      settings = MockSettingsCubit();
      when(() => cubit.commitDelete(any())).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, ExpenseListState state, {Locale locale = const Locale('en')}) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        const ExpenseListScreen(),
        locale: locale,
        settings: testSettings(defaultWalletId: 1, viewedWalletId: state.walletId),
        settingsCubit: settings,
        providers: [BlocProvider<ExpenseListCubit>.value(value: cubit)],
      );
    }

    testWidgets('shows the summary, day groups and rows', (tester) async {
      await pump(tester, loaded);

      expect(find.text('Spent this month'), findsOneWidget);
      expect(find.text('EGP 235.50'), findsOneWidget);
      expect(find.text('18% (+EGP 35.50) vs last month'), findsOneWidget);
      expect(find.text('Today'), findsOneWidget);
      expect(find.text('Yesterday'), findsOneWidget);
      expect(find.text('Lunch'), findsOneWidget);
      expect(find.text('Food · with the team'), findsOneWidget);
      // Untitled: the category is the title, with no repeated subtitle.
      expect(find.text('Food'), findsNWidgets(2), reason: 'filter chip + untitled row');
    });

    testWidgets('Arabic shapes digits and mirrors', (tester) async {
      await pump(tester, loaded, locale: const Locale('ar'));

      expect(find.text('إنفاق هذا الشهر'), findsOneWidget);
      expect(find.text('٢٣٥٫٥٠ ج.م.'), findsOneWidget);
      expect(find.text('اليوم'), findsOneWidget);
      expect(Directionality.of(tester.element(find.text('Lunch'))), TextDirection.rtl);
    });

    testWidgets('the list is called Transactions', (tester) async {
      await pump(tester, loaded);

      expect(find.text('Transactions'), findsOneWidget);
    });

    testWidgets('the list is called المعاملات in Arabic', (tester) async {
      await pump(tester, loaded, locale: const Locale('ar'));

      expect(find.text('المعاملات'), findsOneWidget);
    });

    testWidgets('All shows the balance card with In and Out, and the day net', (tester) async {
      await pump(tester, all);

      expect(find.text('Left this month'), findsOneWidget);
      expect(find.text('EGP 4,764.50'), findsOneWidget, reason: 'no plus sign on a balance');
      expect(find.text('In'), findsOneWidget);
      expect(find.text('Out'), findsOneWidget);
      expect(find.text('EGP 5,000'), findsOneWidget);
      expect(find.text('EGP 235.50'), findsOneWidget);
      expect(find.textContaining('Spent this month'), findsNothing);
      // Day headers: the day's net with a sign.
      expect(find.text('+EGP 4,850'), findsOneWidget);
      expect(find.text('\u2212EGP 85.50'), findsOneWidget);
    });

    testWidgets('a negative balance keeps the label and shows a minus sign', (tester) async {
      await pump(
        tester,
        all.copyWith(
          totals: const PeriodTotals(income: Money(10000), spent: Money(30000)),
        ),
      );

      expect(find.text('Left this month'), findsOneWidget);
      expect(find.text('\u2212EGP 200'), findsOneWidget);
    });

    testWidgets('an income row shows +EGP 5,000 in the positive colour', (tester) async {
      await pump(tester, all);

      final amount = tester.widget<Text>(find.text('+EGP 5,000'));
      expect(amount.style!.color, MasroofyColors.light.textPositive);
      expect(find.text('Salary'), findsWidgets);
      // The expense rows stay unsigned.
      expect(find.text('EGP 150'), findsOneWidget);
    });

    testWidgets('the Income filter shows Earned this month', (tester) async {
      await pump(
        tester,
        all.copyWith(
          kind: TransactionKind.income,
          loaded: [_expense(3, 500000, kind: TransactionKind.income)],
          previousTotals: const PeriodTotals(income: Money(400000), spent: Money.zero),
        ),
      );

      expect(find.text('Earned this month'), findsOneWidget);
      expect(find.text('EGP 5,000'), findsOneWidget);
      expect(find.text('25% (+EGP 1,000) vs last month'), findsOneWidget);
    });

    testWidgets('the filter row starts with All, Income and Expenses', (tester) async {
      await pump(tester, all);

      expect(find.text('All'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Expenses'), findsOneWidget);
      // Both kinds' categories on All.
      expect(find.text('Food'), findsWidgets);

      await tester.tap(find.text('Income'));
      verify(() => cubit.selectKind(TransactionKind.income)).called(1);
      await tester.tap(find.text('Expenses'));
      verify(() => cubit.selectKind(TransactionKind.expense)).called(1);
      await tester.tap(find.text('All'));
      verify(() => cubit.selectKind(null)).called(1);
    });

    testWidgets('the Income filter lists only income categories', (tester) async {
      await pump(
        tester,
        all.copyWith(
          kind: TransactionKind.income,
          loaded: [_expense(3, 500000, kind: TransactionKind.income)],
        ),
      );

      // The chip, plus the row's own category name.
      expect(find.text('Salary'), findsNWidgets(2));
      expect(find.text('Food'), findsNothing);
    });

    testWidgets('an empty Income filter offers to add income', (tester) async {
      await pump(tester, all.copyWith(kind: TransactionKind.income, loaded: [], totals: PeriodTotals.zero));

      expect(find.text('No income yet'), findsOneWidget);
      expect(find.text('Add your salary or other money you receive.'), findsOneWidget);
      expect(find.text('Add income'), findsOneWidget);
    });

    testWidgets('Arabic: the balance card, kind chips and signed amounts', (tester) async {
      await pump(tester, all, locale: const Locale('ar'));

      expect(find.text('المتبقي هذا الشهر'), findsOneWidget);
      expect(find.text('داخل'), findsOneWidget);
      expect(find.text('خارج'), findsOneWidget);
      expect(find.text('الدخل'), findsOneWidget);
      expect(find.text('المصروفات'), findsOneWidget);
      expect(find.text('$_lri+٥٬٠٠٠$_pdi ج.م.'), findsOneWidget);
      expect(Directionality.of(tester.element(find.text('$_lri+٥٬٠٠٠$_pdi ج.م.'))), TextDirection.rtl);
    });

    testWidgets('Arabic: the Income filter and its empty state', (tester) async {
      await pump(
        tester,
        all.copyWith(kind: TransactionKind.income, loaded: [], totals: PeriodTotals.zero),
        locale: const Locale('ar'),
      );

      expect(find.text('الدخل هذا الشهر'), findsOneWidget);
      expect(find.text('لا يوجد دخل بعد'), findsOneWidget);
      expect(find.text('إضافة دخل'), findsOneWidget);
    });

    testWidgets('swiping hides the row, and Undo restores it', (tester) async {
      await pump(tester, loaded);

      await tester.drag(find.text('Lunch'), const Offset(-600, 0));
      await tester.pumpAndSettle();
      verify(() => cubit.hide(2)).called(1);
      expect(find.text('“Lunch” deleted'), findsOneWidget);

      await tester.tap(find.text('Undo'));
      await tester.pumpAndSettle();
      verify(() => cubit.undoDelete(2)).called(1);
      verifyNever(() => cubit.commitDelete(any()));
    });

    testWidgets('picking a category chip filters', (tester) async {
      await pump(tester, loaded);

      await tester.tap(find.text('Food').first);
      verify(() => cubit.selectCategory(1)).called(1);
      await tester.tap(find.text('This week'));
      verify(() => cubit.selectPeriod(ExpensePeriod.week)).called(1);
    });

    testWidgets('first run shows the add prompt, without a comparison', (tester) async {
      await pump(
        tester,
        loaded.copyWith(loaded: [], totals: PeriodTotals.zero, previousTotals: PeriodTotals.zero, dailyTotals: {}),
      );

      expect(find.text('No expenses yet'), findsOneWidget);
      expect(find.text('Add your first expense'), findsOneWidget);
      expect(find.textContaining('vs last month'), findsNothing);
    });

    testWidgets('a filtered empty list offers to clear the filters', (tester) async {
      await pump(tester, loaded.copyWith(loaded: [], categoryId: 1));

      expect(find.text('No expenses match your filters'), findsOneWidget);
      await tester.tap(find.text('Clear filters'));
      verify(() => cubit.clearFilters()).called(1);
    });

    group('wallets', () {
      final inAll = all.copyWith(wallets: [_me, _son]);
      final inMe = inAll.copyWith(walletId: 1);
      final inSon = inAll.copyWith(walletId: 2);
      // Bidi isolate and minus sign of a signed amount.
      const minus = '\u2212';

      testWidgets('the title is the viewed wallet with a caret, and reads as a button to change it', (tester) async {
        final handle = tester.ensureSemantics();
        await pump(tester, inMe);

        expect(find.text('Me'), findsOneWidget);
        expect(find.byIcon(Symbols.expand_more_rounded), findsOneWidget);
        expect(find.text('Transactions'), findsNothing);
        expect(find.bySemanticsLabel('Wallet: Me, double tap to change'), findsOneWidget);
        handle.dispose();
      });

      testWidgets('All wallets is its own title', (tester) async {
        await pump(tester, inAll);

        expect(find.text('All wallets'), findsOneWidget);
      });

      testWidgets('the switcher sheet lists All wallets, then each wallet with its balance this month', (tester) async {
        await pump(tester, inMe);

        await tester.tap(find.text('Me'));
        await tester.pumpAndSettle();

        expect(find.text('Wallets'), findsOneWidget, reason: 'the sheet title');
        expect(find.text('All wallets'), findsOneWidget);
        expect(find.text('Son'), findsOneWidget);
        // Me is the default wallet, and the one viewed.
        expect(find.text('Default'), findsOneWidget);
        expect(find.byIcon(Symbols.check_rounded), findsOneWidget);
        expect(find.text('EGP 4,500 this month'), findsOneWidget);
        expect(find.text('EGP 500 this month'), findsOneWidget);
        expect(find.text('EGP 5,000 this month'), findsOneWidget, reason: 'All wallets adds them up');
        // The order: All wallets, Me, Son.
        final dy = [
          for (final name in ['All wallets', 'Son']) tester.getTopLeft(find.text(name)).dy,
        ];
        expect(dy[0], lessThan(dy[1]));
      });

      testWidgets('the check mark follows the selection, and Default stays on the default wallet', (tester) async {
        await pump(tester, inSon);

        await tester.tap(find.text('Son'));
        await tester.pumpAndSettle();

        expect(find.byIcon(Symbols.check_rounded), findsOneWidget);
        final check = tester.getCenter(find.byIcon(Symbols.check_rounded)).dy;
        final sonRow = tester.getCenter(find.text('EGP 500 this month')).dy;
        expect((check - sonRow).abs(), lessThan(30));
        expect(find.text('Default'), findsOneWidget);
      });

      testWidgets('picking a wallet remembers it and switches the list', (tester) async {
        await pump(tester, inMe);

        await tester.tap(find.text('Me'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Son'));
        await tester.pumpAndSettle();

        // The list follows the stored choice (a listener on SettingsCubit).
        verify(() => settings.setViewedWallet(2)).called(1);
        expect(find.text('Choose wallet'), findsNothing, reason: 'the sheet closed');
      });

      testWidgets('picking All wallets', (tester) async {
        await pump(tester, inMe);

        await tester.tap(find.text('Me'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('All wallets'));
        await tester.pumpAndSettle();

        verify(() => settings.setViewedWallet(null)).called(1);
      });

      testWidgets('closing the sheet changes nothing', (tester) async {
        await pump(tester, inMe);

        await tester.tap(find.text('Me'));
        await tester.pumpAndSettle();
        await tester.tap(find.byIcon(Symbols.close_rounded));
        await tester.pumpAndSettle();

        verifyNever(() => settings.setViewedWallet(any()));
        verifyNever(() => cubit.selectWallet(any()));
      });

      testWidgets('Arabic: the switcher and its sheet', (tester) async {
        await pump(tester, inMe, locale: const Locale('ar'));

        expect(find.text('أنا'), findsOneWidget);
        await tester.tap(find.text('أنا'));
        await tester.pumpAndSettle();

        expect(find.text('المحافظ'), findsOneWidget);
        expect(find.text('كل المحافظ'), findsOneWidget);
        expect(find.text('افتراضية'), findsOneWidget);
        expect(find.text('٤٬٥٠٠ ج.م. هذا الشهر'), findsOneWidget);
        expect(find.byIcon(Symbols.check_rounded), findsOneWidget);
      });

      testWidgets('a typed wallet name takes the direction of its own text', (tester) async {
        final mixed = inAll.copyWith(
          wallets: [
            _me,
            _son,
            _wallet(3, name: 'ابني'),
          ],
        );
        await pump(tester, mixed);
        await tester.tap(find.text('All wallets'));
        await tester.pumpAndSettle();

        expect(tester.widget<Text>(find.text('ابني')).textDirection, TextDirection.rtl);
        expect(tester.widget<Text>(find.text('Son')).textDirection, TextDirection.ltr);
      });

      testWidgets('an empty wallet says so, with the way to fill it', (tester) async {
        await pump(tester, inMe.copyWith(kind: null, loaded: [], totals: PeriodTotals.zero));

        expect(find.text('Nothing in Me yet'), findsOneWidget);
        expect(find.text('Add an expense, income or transfer.'), findsOneWidget);
      });

      testWidgets('an empty wallet in Arabic', (tester) async {
        await pump(
          tester,
          inMe.copyWith(kind: null, loaded: [], totals: PeriodTotals.zero),
          locale: const Locale('ar'),
        );

        expect(find.text('لا شيء في أنا بعد'), findsOneWidget);
        expect(find.text('أضف مصروفًا أو دخلًا أو تحويلًا.'), findsOneWidget);
      });

      testWidgets("a wallet's balance card counts its transfers: income + in - spending - out", (tester) async {
        await pump(
          tester,
          inMe.copyWith(
            loaded: [_transfer(12, 50000, wallet: 1), ...all.loaded],
            totals: const PeriodTotals(income: Money(500000), spent: Money(23550), transfersNet: Money(-50000)),
          ),
        );

        expect(find.text('Left this month'), findsOneWidget);
        expect(find.text('EGP 4,264.50'), findsOneWidget);
        // Net transfers count in Out, so In − Out is the balance.
        expect(find.text('EGP 5,000'), findsOneWidget);
        expect(find.text('EGP 735.50'), findsOneWidget);
      });

      group('rows', () {
        testWidgets('the wallet\'s own outgoing leg reads "To Son" with a minus sign, in the quiet colour', (
          tester,
        ) async {
          await pump(tester, inMe.copyWith(loaded: [_transfer(12, 50000, wallet: 1), ...all.loaded]));

          expect(find.text('To Son'), findsOneWidget);
          final amount = tester.widget<Text>(find.text('${minus}EGP 500'));
          expect(amount.style!.color, MasroofyColors.light.textSecondary);
          expect(find.byIcon(Symbols.sync_alt_rounded), findsOneWidget);
          expect(find.textContaining('Me \u2192'), findsNothing);
        });

        testWidgets('the incoming leg reads "From Me" with a plus sign', (tester) async {
          await pump(tester, inSon.copyWith(loaded: [_transfer(13, 50000, wallet: 2)], totals: PeriodTotals.zero));

          expect(find.text('From Me'), findsOneWidget);
          final amount = tester.widget<Text>(find.text('+EGP 500'));
          expect(amount.style!.color, MasroofyColors.light.textSecondary);
          expect(find.byIcon(Symbols.sync_alt_rounded), findsOneWidget);
        });

        testWidgets('in All wallets a transfer shows once, as Me to Son, with an arrow that mirrors', (tester) async {
          await pump(tester, inAll.copyWith(loaded: [_transfer(12, 50000, wallet: 1, note: 'Pocket money')]));

          expect(find.text('Pocket money'), findsOneWidget);
          expect(find.text('EGP 500'), findsOneWidget, reason: 'no sign across wallets');
          expect(find.byIcon(Symbols.sync_alt_rounded), findsOneWidget);
          final arrow = tester.widget<Icon>(find.byIcon(Symbols.arrow_forward_rounded));
          expect(arrow.icon!.matchTextDirection, isTrue, reason: 'a mirroring icon, not a text arrow');
          // Me, then Son, left to right.
          expect(tester.getCenter(find.text('Me').last).dx, lessThan(tester.getCenter(find.text('Son')).dx));
          expect(find.textContaining('\u2192'), findsNothing);
        });

        testWidgets('Arabic: the same transfer reads from right to left', (tester) async {
          await pump(
            tester,
            inAll.copyWith(
              wallets: [
                _me,
                _wallet(2, name: 'ابني'),
              ],
              loaded: [_transfer(12, 50000, wallet: 1)],
            ),
            locale: const Locale('ar'),
          );

          final me = tester.getCenter(find.text('أنا').last);
          final son = tester.getCenter(find.text('ابني'));
          expect(me.dx, greaterThan(son.dx), reason: 'the source is at the start, on the right');
          expect(tester.widget<Icon>(find.byIcon(Symbols.arrow_forward_rounded)).icon!.matchTextDirection, isTrue);
        });

        testWidgets('Arabic single wallet: To and From in Arabic, with signed amounts', (tester) async {
          await pump(
            tester,
            inMe.copyWith(
              wallets: [
                _me,
                _wallet(2, name: 'ابني'),
              ],
              loaded: [_transfer(12, 50000, wallet: 1)],
            ),
            locale: const Locale('ar'),
          );

          expect(find.text('إلى ابني'), findsOneWidget);
          expect(find.text('\u2066$minus٥٠٠\u2069 ج.م.'), findsOneWidget);
        });

        testWidgets('screen readers get the words, not the colour: outgoing', (tester) async {
          final handle = tester.ensureSemantics();
          await pump(tester, inMe.copyWith(loaded: [_transfer(12, 50000, wallet: 1)]));

          expect(find.bySemanticsLabel('Transfer to Son, minus EGP 500'), findsOneWidget);
          handle.dispose();
        });

        testWidgets('screen readers get the words, not the colour: incoming', (tester) async {
          final handle = tester.ensureSemantics();
          await pump(tester, inSon.copyWith(loaded: [_transfer(13, 50000, wallet: 2)]));

          expect(find.bySemanticsLabel('Transfer from Me, plus EGP 500'), findsOneWidget);
          handle.dispose();
        });

        testWidgets('screen readers get the words, not the colour: between wallets', (tester) async {
          final handle = tester.ensureSemantics();
          await pump(tester, inAll.copyWith(loaded: [_transfer(12, 50000, wallet: 1)]));

          expect(find.bySemanticsLabel('Transfer from Me to Son, EGP 500'), findsOneWidget);
          handle.dispose();
        });

        testWidgets('in All wallets a row shows its wallet under the category', (tester) async {
          await pump(
            tester,
            inAll.copyWith(
              loaded: [
                _expense(5, 1000, title: 'Snack', wallet: 2),
                _expense(6, 2000),
              ],
            ),
          );

          expect(find.text('Food \u00b7 Son'), findsOneWidget, reason: 'a titled row: category and wallet');
          // An untitled row already shows the category as its title; the wallet is the label under it.
          expect(find.text('Me'), findsWidgets);
        });

        testWidgets('in a single wallet the wallet is no news', (tester) async {
          await pump(tester, inMe.copyWith(loaded: [_expense(5, 1000, title: 'Snack')]));

          expect(find.text('Food'), findsWidgets);
          expect(find.textContaining('Food \u00b7'), findsNothing);
        });

        testWidgets('swiping a transfer hides it and Undo restores it', (tester) async {
          await pump(tester, inMe.copyWith(loaded: [_transfer(12, 50000, wallet: 1)]));

          await tester.drag(find.text('To Son'), const Offset(-600, 0));
          await tester.pumpAndSettle();
          verify(() => cubit.hide(12)).called(1);
          expect(find.text('\u201cTransfer\u201d deleted'), findsOneWidget);

          await tester.tap(find.text('Undo'));
          await tester.pumpAndSettle();
          verify(() => cubit.undoDelete(12)).called(1);
          verifyNever(() => cubit.commitDelete(any()));
        });
      });
    });
  });

  group('ExpenseFormScreen', () {
    late _MockForm cubit;
    final ready = ExpenseFormState(
      date: _today,
      fractionDigits: 2,
      status: ExpenseFormStatus.ready,
      categories: [_food, _salary],
    );

    setUp(() {
      cubit = _MockForm();
      when(() => cubit.save()).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, ExpenseFormState state, {Locale locale = const Locale('en')}) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        const ExpenseFormScreen(),
        locale: locale,
        settings: testSettings(defaultWalletId: 1),
        providers: [BlocProvider<ExpenseFormCubit>.value(value: cubit)],
      );
    }

    testWidgets('a new expense: amount first, today by default, save', (tester) async {
      await pump(tester, ready);

      expect(find.text('Add expense'), findsOneWidget);
      expect(find.text('Up to 2 decimals for EGP'), findsOneWidget);
      expect(find.textContaining('Today, '), findsOneWidget);

      await tester.enterText(find.byType(TextField).first, '١٢٫٥');
      verify(() => cubit.amountChanged('١٢٫٥')).called(1);

      await tester.tap(find.text('Save expense'));
      verify(() => cubit.save()).called(1);
    });

    testWidgets('the category field opens the picker with expense categories', (tester) async {
      await pump(tester, ready);

      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();
      expect(find.text('Choose category'), findsOneWidget);
      expect(find.text('Salary'), findsNothing);

      await tester.tap(find.text('Food'));
      await tester.pumpAndSettle();
      verify(() => cubit.categorySelected(1)).called(1);
    });

    testWidgets('the kind switch sits at the top, on Expense by default', (tester) async {
      await pump(tester, ready);

      expect(find.byType(SegmentedPills), findsOneWidget);
      expect(find.text('Expense'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);

      await tester.tap(find.text('Income'));
      verify(() => cubit.kindSelected(TransactionKind.income)).called(1);
    });

    testWidgets('Income: title, green amount, Save income and income categories', (tester) async {
      await pump(tester, ready.copyWith(kind: TransactionKind.income));

      expect(find.text('Add income'), findsOneWidget);
      expect(find.text('Add expense'), findsNothing);
      expect(find.text('Save income'), findsOneWidget);
      final amount = tester.widget<TextField>(find.byType(TextField).first);
      expect(amount.style!.color, MasroofyColors.light.textPositive);

      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('Food'), findsNothing);
      await tester.tap(find.text('Salary'));
      await tester.pumpAndSettle();
      verify(() => cubit.categorySelected(2)).called(1);
    });

    testWidgets('editing an income row opens on Income', (tester) async {
      await pump(tester, ready.copyWith(kind: TransactionKind.income, id: 4, categoryId: 2));

      expect(find.text('Edit income'), findsOneWidget);
      expect(find.text('Salary'), findsWidgets);
    });

    testWidgets('Income in Arabic', (tester) async {
      await pump(tester, ready.copyWith(kind: TransactionKind.income), locale: const Locale('ar'));

      expect(find.text('إضافة دخل'), findsOneWidget);
      expect(find.text('حفظ الدخل'), findsOneWidget);
      expect(find.text('مصروف'), findsOneWidget);
      expect(find.text('دخل'), findsOneWidget);
    });

    testWidgets('a wrong-kind category error names the kind', (tester) async {
      await pump(
        tester,
        ready.copyWith(kind: TransactionKind.income, errors: {'categoryId': ValidationReason.wrongKind}),
      );

      expect(find.text('Pick an income category'), findsOneWidget);
    });

    testWidgets('shows field errors', (tester) async {
      await pump(
        tester,
        ready.copyWith(
          errors: {'amount': ValidationReason.required, 'categoryId': ValidationReason.required},
        ),
      );

      expect(find.text('This field is required'), findsNWidgets(2));
    });

    group('wallets and transfers', () {
      final withWallets = ready.copyWith(wallets: [_me, _son], walletId: 1);

      testWidgets('the Wallet field comes after Category, preselected', (tester) async {
        await pump(tester, withWallets.copyWith(categoryId: 1));

        expect(find.text('Wallet'), findsOneWidget);
        expect(find.text('Me'), findsOneWidget);
        final category = tester.getTopLeft(find.text('Category')).dy;
        final wallet = tester.getTopLeft(find.text('Wallet')).dy;
        final title = tester.getTopLeft(find.text('Title')).dy;
        expect(category, lessThan(wallet));
        expect(wallet, lessThan(title));
      });

      testWidgets('the title stays optional for expenses', (tester) async {
        await pump(tester, withWallets);

        expect(find.text('Title'), findsOneWidget);
        expect(find.text('Optional — defaults to the category name'), findsOneWidget);
      });

      testWidgets('the Wallet field opens the wallet sheet, and a pick records it elsewhere', (tester) async {
        await pump(tester, withWallets);

        await tester.tap(find.text('Me'));
        await tester.pumpAndSettle();
        expect(find.text('Choose wallet'), findsOneWidget);
        expect(find.text('Default'), findsOneWidget);
        await tester.tap(find.text('Son'));
        await tester.pumpAndSettle();

        verify(() => cubit.walletSelected(2)).called(1);
      });

      testWidgets('the type control is Expense, Income, Transfer', (tester) async {
        await pump(tester, withWallets);

        expect(find.text('Expense'), findsOneWidget);
        expect(find.text('Income'), findsOneWidget);
        expect(find.text('Transfer'), findsOneWidget);
        await tester.tap(find.text('Transfer'));
        verify(() => cubit.transferSelected()).called(1);
      });

      testWidgets('Transfer: From and To, amount, date and note; no category, no title', (tester) async {
        await pump(tester, withWallets.copyWith(isTransfer: true, toWalletId: 2));

        expect(find.text('Add transfer'), findsOneWidget);
        expect(find.text('From'), findsOneWidget);
        expect(find.text('To'), findsOneWidget);
        expect(find.text('Me'), findsOneWidget);
        expect(find.text('Son'), findsOneWidget);
        expect(find.text('Amount'), findsOneWidget);
        expect(find.text('Date'), findsOneWidget);
        expect(find.text('Note'), findsOneWidget);
        expect(find.text('Category'), findsNothing);
        expect(find.text('Title'), findsNothing);
        expect(find.text('Wallet'), findsNothing);
        expect(find.text('Save transfer'), findsOneWidget);
        expect(find.text('Save expense'), findsNothing);

        await tester.tap(find.text('Save transfer'));
        verify(() => cubit.save()).called(1);
      });

      testWidgets('the amount of a transfer is neutral, not green', (tester) async {
        await pump(tester, withWallets.copyWith(isTransfer: true, toWalletId: 2, kind: TransactionKind.income));

        final amount = tester.widget<TextField>(find.byType(TextField).first);
        expect(amount.style!.color, isNot(MasroofyColors.light.textPositive));
      });

      testWidgets('From and To open the wallet sheet', (tester) async {
        await pump(tester, withWallets.copyWith(isTransfer: true, toWalletId: 2));

        // The To field shows Son, the From field Me.
        await tester.tap(find.text('Son'));
        await tester.pumpAndSettle();
        expect(find.text('Choose wallet'), findsOneWidget);
        await tester.tap(find.text('Me').last);
        await tester.pumpAndSettle();
        verify(() => cubit.toWalletSelected(1)).called(1);

        await tester.tap(find.text('Me'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Son').last);
        await tester.pumpAndSettle();
        verify(() => cubit.walletSelected(2)).called(1);
      });

      testWidgets('the same wallet on both sides is refused with a clear message', (tester) async {
        await pump(
          tester,
          withWallets.copyWith(isTransfer: true, toWalletId: 1, errors: {'toWallet': ValidationReason.sameWallet}),
        );

        expect(find.text('Pick two different wallets'), findsOneWidget);
      });

      testWidgets('with one wallet there is nothing to move between: add another wallet', (tester) async {
        await pump(tester, ready.copyWith(wallets: [_me], walletId: 1, isTransfer: true));

        expect(find.text('Add another wallet to move money between wallets.'), findsOneWidget);
        expect(find.text('Add wallet'), findsOneWidget);
        expect(find.text('From'), findsNothing);
        final save = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Save transfer'));
        expect(save.onPressed, isNull);
      });

      testWidgets('Arabic: the Transfer form', (tester) async {
        await pump(tester, withWallets.copyWith(isTransfer: true, toWalletId: 2), locale: const Locale('ar'));

        expect(find.text('إضافة تحويل'), findsOneWidget);
        expect(find.text('من'), findsOneWidget);
        expect(find.text('إلى'), findsOneWidget);
        expect(find.text('أنا'), findsOneWidget);
        expect(find.text('حفظ التحويل'), findsOneWidget);
        expect(find.text('تحويل'), findsOneWidget, reason: 'the type control');
        expect(Directionality.of(tester.element(find.text('من'))), TextDirection.rtl);
      });

      testWidgets('Arabic: the Wallet field', (tester) async {
        await pump(tester, withWallets, locale: const Locale('ar'));

        expect(find.text('محفظة'), findsOneWidget);
        expect(find.text('أنا'), findsOneWidget);
      });

      testWidgets('editing a transfer has no type control', (tester) async {
        await pump(tester, withWallets.copyWith(isTransfer: true, toWalletId: 2, id: 12, transferId: 7));

        expect(find.text('Edit transfer'), findsOneWidget);
        expect(find.byType(SegmentedPills), findsNothing);
        expect(find.text('Save transfer'), findsOneWidget);
      });

      testWidgets('editing an expense offers Expense and Income only', (tester) async {
        await pump(tester, withWallets.copyWith(id: 3));

        expect(find.text('Expense'), findsOneWidget);
        expect(find.text('Income'), findsOneWidget);
        expect(find.text('Transfer'), findsNothing);
      });
    });
  });
}
