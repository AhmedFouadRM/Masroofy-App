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
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_list_screen.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
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

Expense _expense(
  int id,
  int minor, {
  String? title,
  String? note,
  LocalDate? date,
  TransactionKind kind = TransactionKind.expense,
}) => Expense(
  id: id,
  amount: Money(minor),
  categoryId: kind == TransactionKind.income ? 2 : 1,
  date: date ?? _today,
  title: title,
  note: note,
  createdAt: _epoch,
  updatedAt: _epoch,
  kind: kind,
);

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

    setUp(() {
      cubit = _MockList();
      when(() => cubit.commitDelete(any())).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, ExpenseListState state, {Locale locale = const Locale('en')}) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        const ExpenseListScreen(),
        locale: locale,
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
      expect(find.text('${_lri}EGP 4,764.50$_pdi'), findsOneWidget, reason: 'no plus sign on a balance');
      expect(find.text('In'), findsOneWidget);
      expect(find.text('Out'), findsOneWidget);
      expect(find.text('EGP 5,000'), findsOneWidget);
      expect(find.text('EGP 235.50'), findsOneWidget);
      expect(find.textContaining('Spent this month'), findsNothing);
      // Day headers: the day's net with a sign.
      expect(find.text('$_lri+EGP 4,850$_pdi'), findsOneWidget);
      expect(find.text('$_lri\u2212EGP 85.50$_pdi'), findsOneWidget);
    });

    testWidgets('a negative balance keeps the label and shows a minus sign', (tester) async {
      await pump(
        tester,
        all.copyWith(
          totals: const PeriodTotals(income: Money(10000), spent: Money(30000)),
        ),
      );

      expect(find.text('Left this month'), findsOneWidget);
      expect(find.text('$_lri\u2212EGP 200$_pdi'), findsOneWidget);
    });

    testWidgets('an income row shows +EGP 5,000 in the positive colour', (tester) async {
      await pump(tester, all);

      final amount = tester.widget<Text>(find.text('$_lri+EGP 5,000$_pdi'));
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
      expect(find.text('$_lri+٥٬٠٠٠ ج.م.$_pdi'), findsOneWidget);
      expect(Directionality.of(tester.element(find.text('$_lri+٥٬٠٠٠ ج.م.$_pdi'))), TextDirection.rtl);
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
  });
}
