import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/categories/domain/entities/category_summary.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
import 'package:masroofy/features/categories/presentation/screens/category_form_screen.dart';
import 'package:masroofy/features/categories/presentation/screens/category_list_screen.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockCategoriesCubit extends MockCubit<CategoriesState> implements CategoriesCubit {}

class _MockFormCubit extends MockCubit<CategoryFormState> implements CategoryFormCubit {}

final _epoch = DateTime.utc(2026, 10, 8);

CategorySummary _summary(
  int id, {
  String? seedKey,
  String? name,
  int expenses = 0,
  int recurring = 0,
  Money? budget,
  TransactionKind kind = TransactionKind.expense,
}) => CategorySummary(
  category: Category(
    id: id,
    seedKey: seedKey,
    name: name,
    icon: 'pets',
    color: 0xFF6366F1,
    sortOrder: id,
    createdAt: _epoch,
    updatedAt: _epoch,
    kind: kind,
  ),
  expenseCount: expenses,
  recurringCount: recurring,
  budgetLimit: budget,
  budgetPeriod: budget == null ? null : BudgetPeriod.monthly,
);

void main() {
  group('CategoryListScreen', () {
    late _MockCategoriesCubit cubit;
    final loaded = CategoriesState(
      status: CategoriesStatus.loaded,
      defaults: [
        _summary(1, seedKey: 'food', expenses: 42, budget: const Money(200000)),
        _summary(2, seedKey: 'education'),
        _summary(3, seedKey: 'salary', expenses: 2, kind: TransactionKind.income),
      ],
      custom: [
        _summary(9, name: 'Gym', expenses: 12, recurring: 1),
        _summary(10, name: 'Tips', expenses: 1, kind: TransactionKind.income),
      ],
    );

    setUp(() {
      cubit = _MockCategoriesCubit();
      when(() => cubit.state).thenReturn(loaded);
      when(() => cubit.delete(any())).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, {Locale locale = const Locale('en')}) => pumpApp(
      tester,
      const CategoryListScreen(),
      locale: locale,
      providers: [BlocProvider<CategoriesCubit>.value(value: cubit)],
    );

    testWidgets('shows the Expense and Income sections with usage', (tester) async {
      await pump(tester);

      expect(find.text('Expense'), findsOneWidget);
      expect(find.text('Income'), findsOneWidget);
      expect(find.text('Food'), findsOneWidget);
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('2 income entries'), findsOneWidget);
      expect(find.text('1 income entry'), findsOneWidget);
      expect(find.text('42 expenses · budget EGP 2,000'), findsOneWidget);
      expect(find.text('No expenses yet'), findsOneWidget);
      expect(find.text('12 expenses · 1 recurring'), findsOneWidget);
    });

    testWidgets('Arabic uses Eastern digits and Arabic plurals', (tester) async {
      await pump(tester, locale: const Locale('ar'));

      expect(find.text('المصروفات'), findsOneWidget);
      expect(find.text('الدخل'), findsOneWidget);
      expect(find.text('طعام'), findsOneWidget);
      expect(find.text('عمليتا دخل'), findsOneWidget);
      expect(find.text('عملية دخل واحدة'), findsOneWidget);
      expect(find.text('٤٢ مصروفًا · الميزانية ٢٬٠٠٠ ج.م.'), findsOneWidget);
      expect(find.text('١٢ مصروفًا · متكرر واحد'), findsOneWidget);
      expect(Directionality.of(tester.element(find.text('طعام'))), TextDirection.rtl);
    });

    testWidgets('swiping a custom category asks, then deletes', (tester) async {
      await pump(tester);

      await tester.drag(find.text('Gym'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text('Delete “Gym”?'), findsOneWidget);
      expect(find.text('12 expenses and 1 recurring template will move to Other.'), findsOneWidget);

      await tester.tap(find.widgetWithText(FilledButton, 'Delete'));
      await tester.pumpAndSettle();
      verify(() => cubit.delete(9)).called(1);
    });

    testWidgets('deleting an income category says its rows move to Other income', (tester) async {
      await pump(tester);

      await tester.drag(find.text('Tips'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.text('1 income entry will move to Other income.'), findsOneWidget);
    });

    testWidgets('default categories cannot be swiped away', (tester) async {
      await pump(tester);

      await tester.drag(find.text('Food'), const Offset(-500, 0));
      await tester.pumpAndSettle();
      expect(find.byType(AlertDialog), findsNothing);
    });
  });

  group('CategoryFormScreen', () {
    late _MockFormCubit cubit;

    setUp(() {
      cubit = _MockFormCubit();
      when(() => cubit.save()).thenAnswer((_) async {});
      registerFallbackValue(TransactionKind.expense);
    });

    Future<void> pump(WidgetTester tester, CategoryFormState state) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        const CategoryFormScreen(),
        providers: [BlocProvider<CategoryFormCubit>.value(value: cubit)],
      );
    }

    testWidgets('a new category with a name can be saved', (tester) async {
      await pump(
        tester,
        const CategoryFormState(icon: 'pets', color: 0xFF6366F1, status: CategoryFormStatus.ready, name: 'Gym'),
      );

      expect(find.text('New category'), findsOneWidget);
      expect(find.text('Up to 50 characters'), findsOneWidget);
      expect(find.text('Delete category'), findsNothing);

      await tester.tap(find.widgetWithText(TextButton, 'Save'));
      verify(() => cubit.save()).called(1);
    });

    testWidgets('a new category asks for its type, Expense by default', (tester) async {
      await pump(
        tester,
        const CategoryFormState(icon: 'pets', color: 1, status: CategoryFormStatus.ready, name: 'Gym'),
      );

      expect(find.text('Type'), findsOneWidget);
      expect(find.byType(SegmentedPills), findsOneWidget);

      await tester.tap(find.text('Income'));
      verify(() => cubit.kindSelected(TransactionKind.income)).called(1);
      expect(find.text("This category has transactions, so its type can't change."), findsNothing);
    });

    testWidgets('the type is locked, with a helper line, once the category is used', (tester) async {
      await pump(
        tester,
        CategoryFormState(
          icon: 'pets',
          color: 1,
          status: CategoryFormStatus.ready,
          id: 9,
          name: 'Gym',
          usage: _summary(9, name: 'Gym', expenses: 3),
        ),
      );

      expect(find.text("This category has transactions, so its type can't change."), findsOneWidget);
      await tester.tap(find.text('Income'), warnIfMissed: false);
      verifyNever(() => cubit.kindSelected(any()));
    });

    testWidgets('the type stays editable on an unused category', (tester) async {
      await pump(
        tester,
        CategoryFormState(
          icon: 'pets',
          color: 1,
          status: CategoryFormStatus.ready,
          id: 9,
          name: 'Gym',
          usage: _summary(9, name: 'Gym'),
        ),
      );

      expect(find.text("This category has transactions, so its type can't change."), findsNothing);
    });

    testWidgets('the locked helper in Arabic', (tester) async {
      when(() => cubit.state).thenReturn(
        CategoryFormState(
          icon: 'pets',
          color: 1,
          status: CategoryFormStatus.ready,
          id: 9,
          name: 'Gym',
          usage: _summary(9, name: 'Gym', expenses: 3),
        ),
      );
      await pumpApp(
        tester,
        const CategoryFormScreen(),
        locale: const Locale('ar'),
        providers: [BlocProvider<CategoryFormCubit>.value(value: cubit)],
      );

      expect(find.text('النوع'), findsOneWidget);
      expect(find.text('لهذه الفئة معاملات، لذا لا يمكن تغيير نوعها.'), findsOneWidget);
    });

    testWidgets('Save is disabled without a name', (tester) async {
      await pump(tester, const CategoryFormState(icon: 'pets', color: 1, status: CategoryFormStatus.ready));

      final save = tester.widget<TextButton>(find.widgetWithText(TextButton, 'Save'));
      expect(save.onPressed, isNull);
    });

    testWidgets('shows a duplicate-name error and the delete button when editing', (tester) async {
      await pump(
        tester,
        CategoryFormState(
          icon: 'pets',
          color: 1,
          status: CategoryFormStatus.ready,
          id: 9,
          name: 'Food',
          nameError: ValidationReason.duplicate,
          usage: _summary(9, name: 'Gym'),
        ),
      );

      expect(find.text('Edit category'), findsOneWidget);
      expect(find.text('This name is already used'), findsOneWidget);
      await tester.scrollUntilVisible(find.text('Delete category'), 200, scrollable: find.byType(Scrollable).first);
      expect(find.text('Delete category'), findsOneWidget);
    });
  });
}
