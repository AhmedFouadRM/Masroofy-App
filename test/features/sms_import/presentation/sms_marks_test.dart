import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show Right, unit;
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_cubit.dart';
import 'package:masroofy/features/expenses/presentation/screens/expense_form_screen.dart';
import 'package:masroofy/features/expenses/presentation/widgets/expense_row.dart';
import 'package:masroofy/features/settings/domain/entities/app_info.dart';
import 'package:masroofy/features/settings/presentation/cubits/data_management_cubit.dart';
import 'package:masroofy/features/settings/presentation/cubits/wallet_count_cubit.dart';
import 'package:masroofy/features/settings/presentation/screens/settings_screen.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/sms/sms_badge.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/router_host.dart';

class _MockForm extends MockCubit<ExpenseFormState> implements ExpenseFormCubit {}

class _MockAuth extends MockCubit<AuthState> implements AuthCubit {}

class _MockData extends MockCubit<DataManagementState> implements DataManagementCubit {}

class _MockWalletCount extends MockCubit<int?> implements WalletCountCubit {}

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

Expense _expense({
  ExpenseSource source = ExpenseSource.manual,
  String? title = 'Groceries',
  String? note = 'Carrefour',
}) => Expense(
  id: 1,
  amount: const Money(68800),
  walletId: 1,
  categoryId: 1,
  date: LocalDate(2026, 10, 8),
  title: title,
  note: note,
  createdAt: _epoch,
  updatedAt: _epoch,
  source: source,
);

void main() {
  group('the SMS badge on a transaction row', () {
    Future<void> pumpRow(WidgetTester tester, Expense expense, {Locale locale = const Locale('en')}) => pumpApp(
      tester,
      Scaffold(
        body: ExpenseRow(expense: expense, category: _food),
      ),
      locale: locale,
    );

    testWidgets('English: an SMS row shows the badge under the amount', (tester) async {
      await pumpRow(tester, _expense(source: ExpenseSource.sms));

      expect(find.byType(SmsBadge), findsOneWidget);
      expect(find.text('SMS'), findsOneWidget);
      expect(find.text('EGP 688'), findsOneWidget);
    });

    testWidgets('Arabic', (tester) async {
      await pumpRow(tester, _expense(source: ExpenseSource.sms), locale: const Locale('ar'));

      expect(find.byType(SmsBadge), findsOneWidget);
      expect(find.text('رسالة'), findsOneWidget);
    });

    testWidgets('has the semantics label "Added from SMS"', (tester) async {
      final handle = tester.ensureSemantics();
      await pumpRow(tester, _expense(source: ExpenseSource.sms));

      expect(find.bySemanticsLabel(RegExp('Added from SMS')), findsOneWidget);
      handle.dispose();
    });

    testWidgets('a manual row has none', (tester) async {
      await pumpRow(tester, _expense());

      expect(find.byType(SmsBadge), findsNothing);
      expect(find.text('SMS'), findsNothing);
    });

    testWidgets('a generated row has the recurring badge, not the SMS one', (tester) async {
      await pumpRow(tester, _expense(source: ExpenseSource.recurring).copyWith(occurrenceDate: LocalDate(2026, 10, 8)));

      expect(find.byType(SmsBadge), findsNothing);
      expect(find.text('Recurring'), findsOneWidget);
    });

    testWidgets('an income row from an SMS has it too', (tester) async {
      await pumpRow(tester, _expense(source: ExpenseSource.sms).copyWith(kind: TransactionKind.income));

      expect(find.byType(SmsBadge), findsOneWidget);
    });
  });

  group('the "From an SMS" banner on the Add form', () {
    late _MockForm cubit;

    setUp(() {
      cubit = _MockForm();
      when(() => cubit.save()).thenAnswer((_) async {});
    });

    final prefilled = ExpenseFormState(
      date: LocalDate(2026, 10, 9),
      fractionDigits: 2,
      status: ExpenseFormStatus.ready,
      categories: [_food],
      categoryId: 1,
      amountText: '450',
      title: 'Carrefour',
      note: 'CIB ••1234 · Balance EGP 8,320',
      smsImportId: 3,
      smsBank: 'CIB',
    );

    Future<void> pump(WidgetTester tester, ExpenseFormState state, {Locale locale = const Locale('en')}) {
      tester.view
        ..physicalSize = const Size(400, 1400)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      whenListen(cubit, const Stream<ExpenseFormState>.empty(), initialState: state);
      return pumpApp(
        tester,
        const ExpenseFormScreen(),
        locale: locale,
        settings: testSettings(defaultWalletId: 1),
        providers: [BlocProvider<ExpenseFormCubit>.value(value: cubit)],
      );
    }

    testWidgets('English: names the bank above the type control', (tester) async {
      await pump(tester, prefilled);

      expect(find.text('From an SMS · CIB'), findsOneWidget);
      // Above the Expense | Income | Transfer control.
      expect(
        tester.getTopLeft(find.text('From an SMS · CIB')).dy,
        lessThan(tester.getTopLeft(find.text('Expense')).dy),
      );
      expect(find.text('Add expense'), findsOneWidget);
      expect(find.text('Save expense'), findsOneWidget);
    });

    testWidgets('fills the fields once the form is ready: amount, title and note', (tester) async {
      tester.view
        ..physicalSize = const Size(400, 1400)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      // The cubit loads the import, then turns ready: the screen fills its fields.
      whenListen(cubit, Stream.value(prefilled), initialState: prefilled.copyWith(status: ExpenseFormStatus.loading));
      await pumpApp(
        tester,
        const ExpenseFormScreen(),
        settings: testSettings(defaultWalletId: 1),
        providers: [BlocProvider<ExpenseFormCubit>.value(value: cubit)],
      );
      await tester.pump();
      await tester.pump();

      expect(find.widgetWithText(TextField, '450'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'Carrefour'), findsOneWidget);
      expect(find.widgetWithText(TextField, 'CIB ••1234 · Balance EGP 8,320'), findsOneWidget);
      expect(find.text('From an SMS · CIB'), findsOneWidget);
    });

    testWidgets('Arabic', (tester) async {
      await pump(tester, prefilled, locale: const Locale('ar'));

      expect(find.text('من رسالة · CIB'), findsOneWidget);
    });

    testWidgets('an income form from an SMS has it too', (tester) async {
      await pump(tester, prefilled.copyWith(kind: TransactionKind.income));

      expect(find.text('From an SMS · CIB'), findsOneWidget);
      expect(find.text('Add income'), findsOneWidget);
    });

    testWidgets('an ordinary form has no banner', (tester) async {
      await pump(tester, prefilled.copyWith(smsBank: null, smsImportId: null));

      expect(find.textContaining('From an SMS'), findsNothing);
    });
  });

  group('the Add from SMS row in Settings', () {
    late MockSettingsCubit settings;
    late _MockAuth auth;
    late _MockData data;
    late _MockWalletCount walletCount;
    late List<String> opened;

    /// The tile of the row, whatever else on the screen says On or Off.
    final smsRow = find.ancestor(
      of: find.textContaining(RegExp('Add from SMS|الإضافة من الرسائل')),
      matching: find.byType(ListTile),
    );

    setUp(() {
      settings = MockSettingsCubit();
      auth = _MockAuth();
      data = _MockData();
      walletCount = _MockWalletCount();
      opened = [];
      when(() => settings.reload()).thenReturn(null);
      when(() => auth.disable()).thenAnswer((_) async => const Right(unit));
    });

    Future<void> pump(
      WidgetTester tester, {
      bool? smsAvailable,
      bool enabled = false,
      Locale locale = const Locale('en'),
    }) async {
      tester.view
        ..physicalSize = const Size(400, 2400)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      whenListen(
        auth,
        const Stream<AuthState>.empty(),
        initialState: const AuthState(isEnabled: false, isLocked: false),
      );
      whenListen(walletCount, const Stream<int?>.empty(), initialState: 1);
      whenListen(data, const Stream<DataManagementState>.empty(), initialState: const DataManagementState());
      await pumpApp(
        tester,
        RouterHost(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, state) => SettingsScreen(
                appInfo: const AppInfo(version: '1.0.0', buildNumber: '1'),
                smsAvailable: smsAvailable,
              ),
            ),
            GoRoute(
              path: RoutePaths.smsImport,
              builder: (context, state) {
                opened.add(state.uri.path);
                return const Scaffold(body: Text('sms screen'));
              },
            ),
          ],
        ),
        locale: locale,
        settingsCubit: settings,
        settings: testSettings().copyWith(smsEnabled: enabled),
        providers: [
          BlocProvider<AuthCubit>.value(value: auth),
          BlocProvider<DataManagementCubit>.value(value: data),
          BlocProvider<WalletCountCubit>.value(value: walletCount),
        ],
      );
    }

    testWidgets('on Android it is in the Data section, Off by default', (tester) async {
      await pump(tester, smsAvailable: true);

      expect(find.text('Add from SMS'), findsOneWidget);
      expect(find.descendant(of: smsRow, matching: find.text('Off')), findsOneWidget);
      // Between Manage budgets and Export.
      final row = tester.getTopLeft(find.text('Add from SMS')).dy;
      expect(row, greaterThan(tester.getTopLeft(find.text('Manage budgets')).dy));
      expect(row, lessThan(tester.getTopLeft(find.text('Export expenses (CSV)')).dy));
    });

    testWidgets('shows On when the feature is on', (tester) async {
      await pump(tester, smsAvailable: true, enabled: true);

      expect(find.descendant(of: smsRow, matching: find.text('On')), findsOneWidget);
    });

    testWidgets('is hidden where SMS cannot be read (iOS, desktop)', (tester) async {
      await pump(tester, smsAvailable: false);

      expect(find.text('Add from SMS'), findsNothing);
    });

    testWidgets('is hidden in these tests, which do not run on Android', (tester) async {
      await pump(tester);

      expect(find.text('Add from SMS'), findsNothing);
    });

    testWidgets('opens the SMS Import screen', (tester) async {
      await pump(tester, smsAvailable: true);

      await tester.tap(find.text('Add from SMS'));
      await tester.pumpAndSettle();

      expect(opened, [RoutePaths.smsImport]);
      expect(find.text('sms screen'), findsOneWidget);
    });

    testWidgets('Arabic', (tester) async {
      await pump(tester, smsAvailable: true, locale: const Locale('ar'));

      expect(find.text('الإضافة من الرسائل'), findsOneWidget);
      expect(find.descendant(of: smsRow, matching: find.text('متوقف')), findsOneWidget);
    });
  });
}
