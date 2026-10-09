import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/analytics/domain/repositories/i_analytics_repository.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockAnalytics extends Mock implements IAnalyticsRepository {}

class _MockCategories extends Mock implements ICategoryRepository {}

class _MockBudgets extends Mock implements IBudgetRepository {}

class _MockWallets extends Mock implements IWalletRepository {}

class _MockCubit extends MockCubit<AnalyticsState> implements AnalyticsCubit {}

final _epoch = DateTime.utc(2026);

Category _category(int id, String seedKey, int color) => Category(
  id: id,
  seedKey: seedKey,
  icon: 'restaurant',
  color: color,
  sortOrder: id,
  createdAt: _epoch,
  updatedAt: _epoch,
);

Wallet _wallet(int id, {String? name}) => Wallet(
  id: id,
  seedKey: id == 1 ? 'me' : null,
  name: id == 1 ? null : (name ?? 'Wallet $id'),
  icon: id == 1 ? 'person' : 'child',
  color: id == 1 ? 0xFF059669 : 0xFF3B82F6,
  sortOrder: id,
  createdAt: _epoch,
  updatedAt: _epoch,
);

final Wallet _me = _wallet(1);
final Wallet _son = _wallet(2, name: 'Son');

final Category _food = _category(1, 'food', 0xFFF97316);
final Category _transport = _category(2, 'transport', 0xFF3B82F6);

void main() {
  setUpAll(() {
    registerFallbackValue(DateRange(LocalDate(2026, 1, 1), LocalDate(2026, 1, 1)));
    registerFallbackValue(LocalDate(2026, 1, 1));
    registerFallbackValue(TransactionKind.expense);
  });

  group('AnalyticsCubit', () {
    late _MockAnalytics analytics;
    late _MockCategories categories;
    late _MockBudgets budgets;
    late _MockWallets wallets;
    final today = LocalDate(2026, 10, 9);
    final ranges = <DateRange>[];

    setUp(() {
      analytics = _MockAnalytics();
      categories = _MockCategories();
      budgets = _MockBudgets();
      wallets = _MockWallets();
      when(() => wallets.watchSummaries(any())).thenAnswer(
        (_) => Stream.value(
          Right([
            for (final wallet in [_me, _son])
              WalletSummary(
                wallet: wallet,
                balance: Money.zero,
                transactionCount: 0,
                transferCount: 0,
                templateCount: 0,
              ),
          ]),
        ),
      );
      when(() => analytics.watchTotalsByWallet(any())).thenAnswer(
        (_) => Stream.value(
          const Right({
            1: PeriodTotals(income: Money(500000), spent: Money(75000)),
            2: PeriodTotals(income: Money.zero, spent: Money(25000)),
          }),
        ),
      );
      when(
        () => budgets.watchProgress(any(), firstWeekday: any(named: 'firstWeekday')),
      ).thenAnswer((_) => Stream.value(const Right([])));
      ranges.clear();
      when(() => categories.watchAll(includeHidden: true)).thenAnswer((_) => Stream.value(Right([_food])));
      when(() => analytics.watchTotals(any(), walletId: any(named: 'walletId'))).thenAnswer((invocation) {
        ranges.add(invocation.positionalArguments.single as DateRange);
        return Stream.value(Right(PeriodTotals(income: const Money(5000), spent: Money(ranges.length * 100))));
      });
      when(
        () => analytics.watchTotalsByCategory(any(), any(), walletId: any(named: 'walletId')),
      ).thenAnswer((_) => Stream.value(const Right({1: Money(100)})));
      when(
        () => analytics.watchDailyTotals(any(), walletId: any(named: 'walletId')),
      ).thenAnswer((_) => Stream.value(const Right({})));
    });

    AnalyticsCubit build({int? walletId}) => AnalyticsCubit(
      analytics,
      categories,
      budgets,
      wallets,
      firstWeekday: DateTime.saturday,
      walletId: walletId,
      today: () => today,
    );

    blocTest<AnalyticsCubit, AnalyticsState>(
      'starts on this month, compared with the same days of last month',
      build: build,
      act: (cubit) => cubit.load(),
      verify: (cubit) {
        expect(ranges, [
          DateRange(LocalDate(2026, 10, 1), today),
          DateRange(LocalDate(2026, 9, 1), LocalDate(2026, 9, 9)),
        ]);
        expect(cubit.state.status, AnalyticsStatus.loaded);
        expect(cubit.state.byCategory, {1: const Money(100)});
        // The comparison is of spending only.
        expect(cubit.state.totals.income, const Money(5000));
        expect(cubit.state.previousTotal, const Money(200));
      },
    );

    blocTest<AnalyticsCubit, AnalyticsState>(
      'the breakdown switch re-reads the categories of the other kind',
      build: build,
      act: (cubit) => cubit
        ..load()
        ..selectBreakdown(TransactionKind.income),
      verify: (cubit) {
        expect(cubit.state.breakdownKind, TransactionKind.income);
        // The explicit null is All wallets.
        // ignore: avoid_redundant_argument_values
        verify(() => analytics.watchTotalsByCategory(any(), TransactionKind.income, walletId: null)).called(1);
      },
    );

    blocTest<AnalyticsCubit, AnalyticsState>(
      'last month is the whole of September, compared with August',
      build: build,
      act: (cubit) => cubit
        ..load()
        ..selectPeriod(AnalyticsPeriod.lastMonth),
      verify: (cubit) {
        expect(ranges.skip(2), [
          DateRange(LocalDate(2026, 9, 1), LocalDate(2026, 9, 30)),
          DateRange(LocalDate(2026, 8, 1), LocalDate(2026, 8, 31)),
        ]);
      },
    );

    group('wallets', () {
      blocTest<AnalyticsCubit, AnalyticsState>(
        'All wallets queries every wallet, and adds the By wallet totals',
        build: build,
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          expect(cubit.state.walletId, isNull);
          expect(cubit.state.showsByWallet, isTrue);
          expect(cubit.state.wallets, [_me, _son]);
          expect(cubit.state.byWallet.keys, [1, 2]);
          // The explicit null is All wallets.
          // ignore: avoid_redundant_argument_values
          verify(() => analytics.watchTotals(any(), walletId: null)).called(2);
          verify(() => analytics.watchTotalsByWallet(DateRange(LocalDate(2026, 10, 1), today))).called(1);
        },
      );

      blocTest<AnalyticsCubit, AnalyticsState>(
        'a wallet scopes the totals, the comparison, the days and the breakdown to it',
        build: () => build(walletId: 2),
        act: (cubit) => cubit.load(),
        verify: (cubit) {
          expect(cubit.state.showsByWallet, isFalse);
          verify(() => analytics.watchTotals(any(), walletId: 2)).called(2);
          verify(() => analytics.watchDailyTotals(any(), walletId: 2)).called(1);
          verify(() => analytics.watchTotalsByCategory(any(), TransactionKind.expense, walletId: 2)).called(1);
          // By wallet compares wallets, so it isn't asked for.
          verifyNever(() => analytics.watchTotalsByWallet(any()));
        },
      );

      blocTest<AnalyticsCubit, AnalyticsState>(
        'switching wallet re-queries everything, and drops the By wallet totals for a single wallet',
        build: build,
        act: (cubit) async {
          cubit.load();
          await Future<void>.delayed(Duration.zero);
          cubit.selectWallet(2);
          await Future<void>.delayed(Duration.zero);
        },
        verify: (cubit) {
          expect(cubit.state.walletId, 2);
          expect(cubit.state.byWallet, isEmpty);
          verify(() => analytics.watchTotals(any(), walletId: 2)).called(2);
          verify(() => analytics.watchTotalsByCategory(any(), any(), walletId: 2)).called(1);
        },
      );

      blocTest<AnalyticsCubit, AnalyticsState>(
        'going back to All wallets brings the By wallet totals back',
        build: () => build(walletId: 2),
        act: (cubit) async {
          cubit.load();
          await Future<void>.delayed(Duration.zero);
          cubit.selectWallet(null);
          await Future<void>.delayed(Duration.zero);
        },
        verify: (cubit) {
          expect(cubit.state.walletId, isNull);
          expect(cubit.state.byWallet.keys, [1, 2]);
        },
      );

      blocTest<AnalyticsCubit, AnalyticsState>(
        'picking the wallet already shown asks for nothing new',
        build: () => build(walletId: 2),
        act: (cubit) async {
          cubit.load();
          await Future<void>.delayed(Duration.zero);
          clearInteractions(analytics);
          cubit.selectWallet(2);
        },
        verify: (_) => verifyZeroInteractions(analytics),
      );

      blocTest<AnalyticsCubit, AnalyticsState>(
        'budgets stay global: they are read without any wallet',
        build: () => build(walletId: 2),
        act: (cubit) => cubit.load(),
        verify: (_) => verify(() => budgets.watchProgress(any(), firstWeekday: any(named: 'firstWeekday'))).called(1),
      );
    });

    blocTest<AnalyticsCubit, AnalyticsState>(
      'this week starts on the region week day',
      build: build,
      act: (cubit) => cubit
        ..load()
        ..selectPeriod(AnalyticsPeriod.week),
      verify: (cubit) => expect(cubit.state.range, DateRange(LocalDate(2026, 10, 3), today)),
    );
  });

  group('AnalyticsScreen', () {
    late _MockCubit cubit;
    final today = LocalDate.today();
    final range = DateRange.monthToDate(today);
    final loaded = AnalyticsState(
      period: AnalyticsPeriod.month,
      range: range,
      firstWeekday: DateTime.saturday,
      status: AnalyticsStatus.loaded,
      totals: const PeriodTotals(income: Money(500000), spent: Money(100000)),
      previousTotal: const Money(80000),
      byCategory: {1: const Money(75000), 2: const Money(25000)},
      daily: {today: const PeriodTotals(income: Money(500000), spent: Money(100000))},
      categories: {1: _food, 2: _transport},
    );
    final withWallets = loaded.copyWith(
      wallets: [_me, _son],
      byWallet: const {
        1: PeriodTotals(income: Money(500000), spent: Money(75000)),
        2: PeriodTotals(income: Money(20000), spent: Money(25000)),
      },
    );

    setUp(() => cubit = _MockCubit());

    Future<void> pump(WidgetTester tester, AnalyticsState state, {Locale locale = const Locale('en')}) {
      when(() => cubit.state).thenReturn(state);
      tester.view
        ..physicalSize = const Size(400, 1600)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      return pumpApp(
        tester,
        const AnalyticsScreen(),
        locale: locale,
        providers: [BlocProvider<AnalyticsCubit>.value(value: cubit)],
      );
    }

    testWidgets('shows the summary, the breakdown and the chart', (tester) async {
      await pump(tester, loaded);

      expect(find.text('Spent this month'), findsOneWidget);
      expect(find.text('25% (+EGP 200) vs last month'), findsOneWidget);
      expect(find.text('By category'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('75%'), findsOneWidget);
      expect(find.text('Spending over time'), findsOneWidget);
    });

    testWidgets('the Income vs spending card shows income, spent, balance and savings rate', (tester) async {
      await pump(tester, loaded);

      expect(find.text('Income vs spending'), findsOneWidget);
      expect(find.text('EGP 5,000'), findsOneWidget);
      expect(find.text('EGP 4,000'), findsOneWidget);
      expect(find.text('Savings rate'), findsOneWidget);
      expect(find.text('80%'), findsOneWidget);
    });

    testWidgets('the savings rate is hidden when there is no income', (tester) async {
      await pump(
        tester,
        loaded.copyWith(
          totals: const PeriodTotals(income: Money.zero, spent: Money(100000)),
        ),
      );

      expect(find.text('Income vs spending'), findsOneWidget);
      expect(find.text('Savings rate'), findsNothing);
    });

    testWidgets('a negative balance shows with a minus sign', (tester) async {
      await pump(
        tester,
        loaded.copyWith(
          totals: const PeriodTotals(income: Money(20000), spent: Money(100000)),
        ),
      );

      expect(find.text('−EGP 800'), findsOneWidget);
    });

    testWidgets('the breakdown switch asks the cubit', (tester) async {
      await pump(tester, loaded);

      await tester.tap(find.descendant(of: find.byType(SegmentedPills), matching: find.text('Income')));
      verify(() => cubit.selectBreakdown(TransactionKind.income)).called(1);
    });

    testWidgets('the income breakdown with no income says so', (tester) async {
      await pump(tester, loaded.copyWith(breakdownKind: TransactionKind.income, byCategory: {}));

      expect(find.text('No income in this period'), findsOneWidget);
    });

    testWidgets('the chart has a legend for both series', (tester) async {
      await pump(tester, loaded);

      expect(find.text('Spent'), findsWidgets);
      expect(find.text('Spending over time'), findsOneWidget);
    });

    testWidgets('tapping a slice shows its share in the centre', (tester) async {
      await pump(tester, loaded);

      // Food is 75%, starting at 12 o'clock and running clockwise: its
      // middle is at about 4:30, so tap the ring on the right.
      final centre = tester.getCenter(find.text('Total'));
      await tester.tapAt(centre + const Offset(84, 0));
      await tester.pumpAndSettle();
      expect(find.text('75% of total'), findsOneWidget);
    });

    testWidgets('picking Last month asks the cubit', (tester) async {
      await pump(tester, loaded);

      await tester.tap(find.text('Last month'));
      verify(() => cubit.selectPeriod(AnalyticsPeriod.lastMonth)).called(1);
    });

    testWidgets('budgets show their own current period', (tester) async {
      final budget = BudgetProgress(
        budget: Budget(
          id: 1,
          categoryId: 2,
          limit: const Money(50000),
          period: BudgetPeriod.weekly,
          createdAt: _epoch,
          updatedAt: _epoch,
        ),
        periodStart: today,
        periodEnd: today.addDays(6),
        spent: const Money(25000),
      );
      await pump(tester, loaded.copyWith(budgets: [budget]));

      expect(find.text('Budgets'), findsOneWidget);
      expect(find.text('250 / 500'), findsOneWidget);
      expect(find.text('This week'), findsWidgets);
    });

    testWidgets('an empty period shows the empty state', (tester) async {
      await pump(
        tester,
        loaded.copyWith(totals: PeriodTotals.zero, byCategory: {}, daily: {}, previousTotal: Money.zero),
      );

      expect(find.text('No spending data for this period'), findsOneWidget);
      expect(find.text('By category'), findsNothing);
    });

    testWidgets('Arabic shapes digits and mirrors', (tester) async {
      await pump(tester, loaded, locale: const Locale('ar'));

      expect(find.text('حسب الفئة'), findsOneWidget);
      expect(find.text('٧٥%'), findsOneWidget);
      expect(Directionality.of(tester.element(find.text('حسب الفئة'))), TextDirection.rtl);
    });

    group('By wallet', () {
      testWidgets("in All wallets: each wallet's spending and income, with a thin bar for its share", (tester) async {
        await pump(tester, withWallets);

        expect(find.text('By wallet'), findsOneWidget);
        expect(find.text('Me'), findsOneWidget);
        expect(find.text('Son'), findsOneWidget);
        final card = find.ancestor(of: find.text('Me'), matching: find.byType(Card));
        expect(find.descendant(of: card, matching: find.text('EGP 750')), findsOneWidget);
        expect(find.descendant(of: card, matching: find.text('EGP 250')), findsOneWidget);
        expect(find.text('Income +EGP 5,000'), findsOneWidget);
        expect(find.text('Income +EGP 200'), findsOneWidget);
        final bars = tester
            .widgetList<LinearProgressIndicator>(
              find.descendant(
                of: find.ancestor(of: find.text('Me'), matching: find.byType(Card)),
                matching: find.byType(LinearProgressIndicator),
              ),
            )
            .toList();
        expect(bars.map((b) => b.value), [0.75, 0.25]);
        expect(bars.every((b) => b.minHeight == 4), isTrue, reason: 'thin');
        // Between the income card and the categories.
        final income = tester.getTopLeft(find.text('Income vs spending')).dy;
        final byWallet = tester.getTopLeft(find.text('By wallet')).dy;
        final byCategory = tester.getTopLeft(find.text('By category')).dy;
        expect(income, lessThan(byWallet));
        expect(byWallet, lessThan(byCategory));
      });

      testWidgets('a wallet without income shows no income line', (tester) async {
        await pump(
          tester,
          withWallets.copyWith(
            byWallet: const {
              1: PeriodTotals(income: Money(500000), spent: Money(75000)),
              2: PeriodTotals(income: Money.zero, spent: Money(25000)),
            },
          ),
        );

        expect(find.textContaining('Income +'), findsOneWidget);
      });

      testWidgets('a single wallet has no By wallet card', (tester) async {
        await pump(tester, withWallets.copyWith(walletId: 2));

        expect(find.text('By wallet'), findsNothing);
        expect(find.text('Income vs spending'), findsOneWidget);
      });

      testWidgets('Arabic: the card and its names', (tester) async {
        await pump(
          tester,
          withWallets.copyWith(
            wallets: [
              _me,
              _wallet(2, name: 'ابني'),
            ],
          ),
          locale: const Locale('ar'),
        );

        expect(find.text('حسب المحفظة'), findsOneWidget);
        expect(find.text('أنا'), findsOneWidget);
        expect(find.text('ابني'), findsOneWidget);
        final card = find.ancestor(of: find.text('أنا'), matching: find.byType(Card));
        expect(find.descendant(of: card, matching: find.text('٧٥٠ ج.م.')), findsOneWidget);
      });
    });
  });
}
