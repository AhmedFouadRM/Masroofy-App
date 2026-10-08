import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/analytics/domain/repositories/i_analytics_repository.dart';
import 'package:masroofy/features/analytics/presentation/cubits/analytics_cubit.dart';
import 'package:masroofy/features/analytics/presentation/screens/analytics_screen.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockAnalytics extends Mock implements IAnalyticsRepository {}

class _MockCategories extends Mock implements ICategoryRepository {}

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

final _food = _category(1, 'food', 0xFFF97316);
final _transport = _category(2, 'transport', 0xFF3B82F6);

void main() {
  setUpAll(() => registerFallbackValue(DateRange(LocalDate(2026, 1, 1), LocalDate(2026, 1, 1))));

  group('AnalyticsCubit', () {
    late _MockAnalytics analytics;
    late _MockCategories categories;
    final today = LocalDate(2026, 10, 9);
    final ranges = <DateRange>[];

    setUp(() {
      analytics = _MockAnalytics();
      categories = _MockCategories();
      ranges.clear();
      when(() => categories.watchAll(includeHidden: true)).thenAnswer((_) => Stream.value(Right([_food])));
      when(() => analytics.watchTotal(any())).thenAnswer((invocation) {
        ranges.add(invocation.positionalArguments.single as DateRange);
        return Stream.value(Right(Money(ranges.length * 100)));
      });
      when(() => analytics.watchTotalsByCategory(any())).thenAnswer((_) => Stream.value(const Right({1: Money(100)})));
      when(() => analytics.watchDailyTotals(any())).thenAnswer((_) => Stream.value(Right({today: const Money(100)})));
    });

    AnalyticsCubit build() =>
        AnalyticsCubit(analytics, categories, firstWeekday: DateTime.saturday, today: () => today);

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
      total: const Money(100000),
      previousTotal: const Money(80000),
      byCategory: {1: const Money(75000), 2: const Money(25000)},
      daily: {today: const Money(100000)},
      categories: {1: _food, 2: _transport},
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

    testWidgets('picking Last month asks the cubit', (tester) async {
      await pump(tester, loaded);

      await tester.tap(find.text('Last month'));
      verify(() => cubit.selectPeriod(AnalyticsPeriod.lastMonth)).called(1);
    });

    testWidgets('an empty period shows the empty state', (tester) async {
      await pump(tester, loaded.copyWith(total: Money.zero, byCategory: {}, daily: {}, previousTotal: Money.zero));

      expect(find.text('No spending data for this period'), findsOneWidget);
      expect(find.text('By category'), findsNothing);
    });

    testWidgets('Arabic shapes digits and mirrors', (tester) async {
      await pump(tester, loaded, locale: const Locale('ar'));

      expect(find.text('حسب الفئة'), findsOneWidget);
      expect(find.text('٧٥%'), findsOneWidget);
      expect(Directionality.of(tester.element(find.text('حسب الفئة'))), TextDirection.rtl);
    });
  });
}
