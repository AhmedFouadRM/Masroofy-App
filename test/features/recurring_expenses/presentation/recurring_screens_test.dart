import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_list_cubit.dart';
import 'package:masroofy/features/recurring_expenses/presentation/screens/recurring_form_screen.dart';
import 'package:masroofy/features/recurring_expenses/presentation/screens/recurring_list_screen.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';

class _MockList extends MockCubit<RecurringListState> implements RecurringListCubit {}

class _MockForm extends MockCubit<RecurringFormState> implements RecurringFormCubit {}

final _today = LocalDate.today();
final _epoch = DateTime.utc(2026);

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

final _bills = Category(
  id: 1,
  seedKey: 'bills',
  icon: 'receipt_long',
  color: 0xFF3B82F6,
  sortOrder: 3,
  createdAt: _epoch,
  updatedAt: _epoch,
);

RecurringExpense _template(
  int id,
  String title, {
  bool active = true,
  LocalDate? due,
  TransactionKind kind = TransactionKind.expense,
}) => RecurringExpense(
  id: id,
  title: title,
  amount: const Money(500000),
  walletId: 1,
  categoryId: 1,
  frequency: RecurringFrequency.monthly,
  startDate: _today,
  nextDueDate: due ?? _today,
  isActive: active,
  createdAt: _epoch,
  updatedAt: _epoch,
  kind: kind,
);

WalletSummary _wallet(int id, {String? name}) => WalletSummary(
  wallet: Wallet(
    id: id,
    seedKey: id == 1 ? 'me' : null,
    name: id == 1 ? null : (name ?? 'Wallet $id'),
    icon: 'person',
    color: 0xFF059669,
    sortOrder: id,
    createdAt: _epoch,
    updatedAt: _epoch,
  ),
  balance: Money.zero,
  transactionCount: 0,
  transferCount: 0,
  templateCount: 0,
);

final WalletSummary _me = _wallet(1);
final WalletSummary _son = _wallet(2, name: 'Son');

void main() {
  group('RecurringListScreen', () {
    late _MockList cubit;
    final loaded = RecurringListState(
      status: RecurringListStatus.loaded,
      templates: [_template(1, 'Rent'), _template(2, 'Gym', active: false)],
      categories: {1: _bills},
    );

    setUp(() {
      cubit = _MockList();
      when(() => cubit.setActive(any(), active: any(named: 'active'))).thenAnswer((_) async {});
      when(() => cubit.delete(any())).thenAnswer((_) async {});
    });

    Future<void> pump(WidgetTester tester, RecurringListState state, {Locale locale = const Locale('en')}) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        const RecurringListScreen(),
        locale: locale,
        providers: [BlocProvider<RecurringListCubit>.value(value: cubit)],
      );
    }

    testWidgets('groups active and paused templates', (tester) async {
      await pump(tester, loaded);

      expect(find.text('Active'), findsOneWidget);
      expect(find.text('Paused'), findsOneWidget);
      expect(find.text('Rent'), findsOneWidget);
      expect(find.text('Monthly · Next Today'), findsOneWidget);
      expect(find.text('Monthly · Paused'), findsOneWidget);
      expect(find.text('EGP 5,000'), findsNWidgets(2));
    });

    testWidgets('income templates show a green signed amount', (tester) async {
      await pump(
        tester,
        loaded.copyWith(
          templates: [_template(3, 'Pay day', kind: TransactionKind.income).copyWith(categoryId: 2)],
          categories: {1: _bills, 2: _salary},
        ),
      );

      final amount = tester.widget<Text>(find.text('+EGP 5,000'));
      expect(amount.style!.color, MasroofyColors.light.textPositive);
    });

    testWidgets('the switch pauses a template', (tester) async {
      await pump(tester, loaded);

      await tester.tap(find.byType(Switch).first);
      verify(() => cubit.setActive(1, active: false)).called(1);
    });

    testWidgets('swiping asks first, and deletes on confirm', (tester) async {
      await pump(tester, loaded);

      await tester.drag(find.text('Rent'), const Offset(-600, 0));
      await tester.pumpAndSettle();
      expect(find.text('Delete “Rent”?'), findsOneWidget);
      expect(find.text('Expenses it already added stay in your list.'), findsOneWidget);

      await tester.tap(find.text('Delete'));
      await tester.pumpAndSettle();
      verify(() => cubit.delete(1)).called(1);
    });

    testWidgets('cancelling the delete keeps the row', (tester) async {
      await pump(tester, loaded);

      await tester.drag(find.text('Rent'), const Offset(-600, 0));
      await tester.pumpAndSettle();
      await tester.tap(find.text('Cancel'));
      await tester.pumpAndSettle();
      verifyNever(() => cubit.delete(any()));
      expect(find.text('Rent'), findsOneWidget);
    });

    testWidgets('empty list offers to add the first one', (tester) async {
      await pump(tester, loaded.copyWith(templates: []));

      expect(find.text('No recurring expenses'), findsOneWidget);
      expect(find.text('Add a recurring expense'), findsOneWidget);
      expect(find.byType(FloatingActionButton), findsNothing);
    });

    testWidgets('Arabic shapes digits and mirrors', (tester) async {
      await pump(tester, loaded, locale: const Locale('ar'));

      expect(find.text('النشطة'), findsOneWidget);
      expect(find.text('شهرياً · القادم اليوم'), findsOneWidget);
      expect(find.text('٥٬٠٠٠ ج.م.'), findsNWidgets(2));
      expect(Directionality.of(tester.element(find.text('Rent'))), TextDirection.rtl);
    });
  });

  group('RecurringFormScreen', () {
    late _MockForm cubit;
    final ready = RecurringFormState(
      startDate: _today,
      fractionDigits: 2,
      status: RecurringFormStatus.ready,
      categories: [_bills],
    );

    setUp(() {
      cubit = _MockForm();
      when(() => cubit.save()).thenAnswer((_) async {});
      registerFallbackValue(TransactionKind.expense);
    });

    Future<void> pump(WidgetTester tester, RecurringFormState state) {
      when(() => cubit.state).thenReturn(state);
      return pumpApp(
        tester,
        const RecurringFormScreen(),
        providers: [BlocProvider<RecurringFormCubit>.value(value: cubit)],
      );
    }

    testWidgets('a new template: frequency pills, start date, no active switch', (tester) async {
      await pump(tester, ready);

      expect(find.text('Add recurring expense'), findsOneWidget);
      expect(find.textContaining('Today, '), findsOneWidget);
      expect(find.byType(SwitchListTile), findsNothing);

      await tester.tap(find.text('Weekly'));
      verify(() => cubit.frequencySelected(RecurringFrequency.weekly)).called(1);

      await tester.tap(find.text('Save recurring expense'));
      verify(() => cubit.save()).called(1);
    });

    testWidgets('has the Expense | Income switch, offering only categories of its kind', (tester) async {
      await pump(tester, ready.copyWith(categories: [_bills, _salary]));

      expect(find.text('Expense'), findsOneWidget);
      await tester.tap(find.text('Income'));
      verify(() => cubit.kindSelected(TransactionKind.income)).called(1);

      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();
      expect(find.text('Bills'), findsOneWidget);
      expect(find.text('Salary'), findsNothing);
    });

    testWidgets('an income template has a green amount and income categories', (tester) async {
      await pump(tester, ready.copyWith(kind: TransactionKind.income, categories: [_bills, _salary]));

      final amount = tester.widget<TextField>(find.byType(TextField).first);
      expect(amount.style!.color, MasroofyColors.light.textPositive);
      await tester.tap(find.text('Category'));
      await tester.pumpAndSettle();
      expect(find.text('Salary'), findsOneWidget);
      expect(find.text('Bills'), findsNothing);
    });

    testWidgets('the Wallet field comes after Category, preselected, and opens the wallet sheet', (tester) async {
      await pump(tester, ready.copyWith(wallets: [_me, _son], walletId: 1, categoryId: 1));

      expect(find.text('Wallet'), findsOneWidget);
      expect(find.text('Me'), findsOneWidget);
      expect(
        tester.getTopLeft(find.text('Category')).dy,
        lessThan(tester.getTopLeft(find.text('Wallet')).dy),
      );

      await tester.tap(find.text('Me'));
      await tester.pumpAndSettle();
      expect(find.text('Choose wallet'), findsOneWidget);
      await tester.tap(find.text('Son'));
      await tester.pumpAndSettle();
      verify(() => cubit.walletSelected(2)).called(1);
    });

    testWidgets('the Wallet field in Arabic, and its required error', (tester) async {
      when(() => cubit.state).thenReturn(
        ready.copyWith(wallets: [_me], errors: {'walletId': ValidationReason.required}),
      );
      await pumpApp(
        tester,
        const RecurringFormScreen(),
        locale: const Locale('ar'),
        providers: [BlocProvider<RecurringFormCubit>.value(value: cubit)],
      );

      expect(find.text('محفظة'), findsOneWidget);
      expect(find.text('هذا الحقل مطلوب'), findsOneWidget);
    });

    testWidgets('editing shows the active switch', (tester) async {
      // A phone-sized screen, so the switch is clear of the Save bar.
      tester.view
        ..physicalSize = const Size(400, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      await pump(tester, ready.copyWith(id: 3));

      expect(find.text('Edit recurring expense'), findsOneWidget);
      await tester.tap(find.byType(SwitchListTile));
      verify(() => cubit.activeChanged(active: false)).called(1);
    });

    testWidgets('shows field errors', (tester) async {
      await pump(
        tester,
        ready.copyWith(errors: {'amount': ValidationReason.required, 'title': ValidationReason.required}),
      );

      expect(find.text('This field is required'), findsNWidgets(2));
    });
  });
}
