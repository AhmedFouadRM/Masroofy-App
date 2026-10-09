import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_draft.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';
import 'package:masroofy/features/budgets/domain/usecases/save_budget.dart';
import 'package:masroofy/features/budgets/domain/usecases/take_new_budget_alerts.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_form_cubit.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_list_cubit.dart';
import 'package:masroofy/features/budgets/presentation/screens/budget_list_screen.dart';
import 'package:masroofy/features/budgets/presentation/widgets/budget_alert_listener.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockBudgets extends Mock implements IBudgetRepository {}

class _MockCategories extends Mock implements ICategoryRepository {}

class _MockSave extends Mock implements SaveBudget {}

class _MockAlerts extends Mock implements TakeNewBudgetAlerts {}

class _MockList extends MockCubit<BudgetListState> implements BudgetListCubit {}

final _epoch = DateTime.utc(2026);
final _monthStart = LocalDate(2026, 10, 1);

Category _category(int id, String seedKey) => Category(
  id: id,
  seedKey: seedKey,
  icon: 'restaurant',
  color: 0xFFF97316,
  sortOrder: id,
  createdAt: _epoch,
  updatedAt: _epoch,
);

final Category _food = _category(1, 'food');
final Category _transport = _category(2, 'transport');

BudgetProgress _progress(int id, int categoryId, {required int spent, int limit = 100000}) => BudgetProgress(
  budget: Budget(
    id: id,
    categoryId: categoryId,
    limit: Money(limit),
    period: BudgetPeriod.monthly,
    createdAt: _epoch,
    updatedAt: _epoch,
  ),
  periodStart: _monthStart,
  periodEnd: LocalDate(2026, 10, 31),
  spent: Money(spent),
);

void main() {
  setUpAll(() {
    registerFallbackValue(const BudgetDraft(categoryId: 0, limit: Money.zero, period: BudgetPeriod.monthly));
    registerFallbackValue(LocalDate(2026, 1, 1));
  });

  late _MockBudgets budgets;
  late _MockCategories categories;

  setUp(() {
    budgets = _MockBudgets();
    categories = _MockCategories();
    when(
      () => categories.watchAll(includeHidden: any(named: 'includeHidden')),
    ).thenAnswer((_) => Stream.value(Right([_food, _transport])));
  });

  group('BudgetFormCubit', () {
    late _MockSave save;

    setUp(() {
      save = _MockSave();
      when(
        () => budgets.watchProgress(any(), firstWeekday: any(named: 'firstWeekday')),
      ).thenAnswer((_) => Stream.value(Right([_progress(1, 1, spent: 0)])));
    });

    BudgetFormCubit build({int? id}) => BudgetFormCubit(budgets, categories, save, fractionDigits: 2, budgetId: id);

    blocTest<BudgetFormCubit, BudgetFormState>(
      'the picker offers only categories without a budget',
      build: build,
      act: (cubit) => cubit.load(),
      verify: (cubit) => expect(cubit.state.available, [_transport]),
    );

    blocTest<BudgetFormCubit, BudgetFormState>(
      'saves the parsed limit and period',
      build: build,
      setUp: () => when(() => save(any(), id: any(named: 'id'))).thenAnswer((_) async => const Right(3)),
      act: (cubit) async {
        await cubit.load();
        cubit
          ..categorySelected(2)
          ..limitChanged('٢٠٠٠')
          ..periodSelected(BudgetPeriod.weekly);
        await cubit.save();
      },
      verify: (cubit) {
        expect(cubit.state.status, BudgetFormStatus.saved);
        verify(
          () => save(const BudgetDraft(categoryId: 2, limit: Money(200000), period: BudgetPeriod.weekly)),
        ).called(1);
      },
    );

    blocTest<BudgetFormCubit, BudgetFormState>(
      'saving without a category or limit shows field errors',
      build: build,
      act: (cubit) async {
        await cubit.load();
        await cubit.save();
      },
      verify: (cubit) => expect(cubit.state.errors.keys, containsAll(['categoryId', 'limit'])),
    );
  });

  group('BudgetListScreen', () {
    late _MockList cubit;
    final loaded = BudgetListState(
      status: BudgetListStatus.loaded,
      budgets: [_progress(1, 1, spent: 85000), _progress(2, 2, spent: 120000)],
      categories: {1: _food, 2: _transport},
    );

    setUp(() {
      cubit = _MockList();
      when(() => cubit.delete(any())).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, BudgetListState state, {Locale locale = const Locale('en')}) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        const BudgetListScreen(),
        locale: locale,
        providers: [BlocProvider<BudgetListCubit>.value(value: cubit)],
      );
    }

    testWidgets('shows each budget with what is left or over', (tester) async {
      await pump(tester, loaded);

      expect(find.text('Food'), findsOneWidget);
      expect(find.text('EGP 150 remaining'), findsOneWidget);
      expect(find.text('850 / 1,000'), findsOneWidget);
      expect(find.text('Monthly'), findsNWidgets(2));
      expect(find.text('Over by EGP 200'), findsOneWidget);
    });

    testWidgets('when every category has a budget, + explains why it is muted', (tester) async {
      await pump(tester, loaded);

      await tester.tap(find.byType(FloatingActionButton));
      await tester.pump();
      expect(find.text('Every category already has a budget'), findsOneWidget);
    });

    testWidgets('swiping asks first, and deletes on confirm', (tester) async {
      await pump(tester, loaded);

      await tester.drag(find.text('Food'), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(find.text('Delete the Food budget?'), findsOneWidget);
      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      verify(() => cubit.delete(1)).called(1);
    });

    testWidgets('empty list offers to add the first one', (tester) async {
      await pump(tester, loaded.copyWith(budgets: []));

      expect(find.text('No budgets yet'), findsOneWidget);
      expect(find.text('Add a budget'), findsOneWidget);
    });

    testWidgets('Arabic shapes digits', (tester) async {
      await pump(tester, loaded, locale: const Locale('ar'));

      expect(find.text('تجاوز بـ٢٠٠ ج.م.'), findsOneWidget);
    });
  });

  group('BudgetAlertListener', () {
    late _MockAlerts alerts;

    setUp(() {
      alerts = _MockAlerts();
      when(
        () => budgets.watchProgress(any(), firstWeekday: any(named: 'firstWeekday')),
      ).thenAnswer((_) => Stream.value(Right([_progress(2, 2, spent: 120000)])));
    });

    testWidgets('lists every newly exceeded budget in one dialog, once', (tester) async {
      when(
        () => alerts(any()),
      ).thenAnswer((invocation) async => invocation.positionalArguments.single as List<BudgetProgress>);
      final navigatorKey = GlobalKey<NavigatorState>();
      await pumpApp(
        tester,
        BudgetAlertListener(
          budgets: budgets,
          categories: categories,
          takeAlerts: alerts,
          navigatorKey: navigatorKey,
          child: Navigator(
            key: navigatorKey,
            onGenerateRoute: (_) => MaterialPageRoute<void>(builder: (_) => const SizedBox()),
          ),
        ),
      );
      await tester.pumpAndSettle();

      expect(find.text('Over budget'), findsOneWidget);
      expect(find.text('Transport'), findsOneWidget);
      expect(find.text('Over by EGP 200'), findsOneWidget);

      await tester.tap(find.text('Got it'));
      await tester.pumpAndSettle();
      expect(find.text('Over budget'), findsNothing);
      verify(() => alerts(any())).called(1);
    });
  });
}
