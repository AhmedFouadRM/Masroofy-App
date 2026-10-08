import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_list_cubit.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_list_screen.dart';
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

Expense _expense(int id, int minor, {String? title, String? note, LocalDate? date}) => Expense(
  id: id,
  amount: Money(minor),
  categoryId: 1,
  date: date ?? _today,
  title: title,
  note: note,
  createdAt: _epoch,
  updatedAt: _epoch,
);

void main() {
  group('ExpenseListScreen', () {
    late _MockList cubit;
    final loaded = ExpenseListState(
      period: ExpensePeriod.month,
      range: DateRange.monthToDate(_today),
      status: ExpenseListStatus.loaded,
      loaded: [
        _expense(2, 15000, title: 'Lunch', note: 'with the team'),
        _expense(1, 8550, date: _today.addDays(-1)),
      ],
      total: const Money(23550),
      previousTotal: const Money(20000),
      dailyTotals: {_today: const Money(15000), _today.addDays(-1): const Money(8550)},
      categories: {1: _food},
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
      await pump(tester, loaded.copyWith(loaded: [], total: Money.zero, previousTotal: Money.zero, dailyTotals: {}));

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
      categories: [_food],
    );

    setUp(() {
      cubit = _MockForm();
      when(() => cubit.save()).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, ExpenseFormState state) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        const ExpenseFormScreen(),
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

    testWidgets('the category field opens the picker', (tester) async {
      await pump(tester, ready);

      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();
      expect(find.text('Choose category'), findsOneWidget);

      await tester.tap(find.text('Food'));
      await tester.pumpAndSettle();
      verify(() => cubit.categorySelected(1)).called(1);
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
