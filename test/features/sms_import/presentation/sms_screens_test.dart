import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/catch_up_candidate.dart';
import 'package:masroofy/features/sms_import/domain/entities/parsed_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_sender_entry.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/presentation/cubits/sms_import_cubit.dart';
import 'package:masroofy/features/sms_import/presentation/screens/sms_disclosure_screen.dart';
import 'package:masroofy/features/sms_import/presentation/screens/sms_import_screen.dart';
import 'package:masroofy/features/sms_import/presentation/widgets/catch_up_sheet.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/router_host.dart';

class _MockCubit extends MockCubit<SmsImportState> implements SmsImportCubit {}

final _epoch = DateTime.utc(2026);

Category _category(int id, String seedKey, String icon, int color, {TransactionKind kind = TransactionKind.expense}) =>
    Category(
      id: id,
      seedKey: seedKey,
      icon: icon,
      color: color,
      sortOrder: id,
      createdAt: _epoch,
      updatedAt: _epoch,
      kind: kind,
    );

final Category _food = _category(1, 'food', 'restaurant', 0xFFF97316);
final Category _transport = _category(2, 'transport', 'directions_car', 0xFF3B82F6);
final Category _salary = _category(3, 'salary', 'payments', 0xFF6366F1, kind: TransactionKind.income);

SmsImport _import(
  int id,
  String merchant,
  int minor,
  SmsImportStatus status, {
  int? categoryId,
  TransactionKind kind = TransactionKind.expense,
  int? expenseId,
}) => SmsImport(
  id: id,
  smsKey: 'k$id',
  sender: 'CIB',
  receivedAt: DateTime(2026, 10, 9),
  kind: kind,
  amount: Money(minor),
  currency: 'EGP',
  date: LocalDate(2026, 10, 9),
  status: status,
  merchant: merchant,
  categoryId: categoryId,
  cardLast4: '1234',
  expenseId: expenseId,
);

final List<SmsImport> _recent = [
  _import(1, 'Carrefour', 45000, SmsImportStatus.added, categoryId: 1, expenseId: 11),
  _import(2, 'Uber', 8500, SmsImportStatus.pending, categoryId: 2),
  _import(3, 'Salary', 1200000, SmsImportStatus.added, categoryId: 3, kind: TransactionKind.income, expenseId: 12),
  _import(4, 'Netflix', 24000, SmsImportStatus.ignored, categoryId: 1),
];

const _senders = [
  SmsSenderEntry(key: 'cib', name: 'CIB', type: SmsSenderType.bank, trusted: true, addedByUser: false),
  SmsSenderEntry(key: 'nbe', name: 'NBE', type: SmsSenderType.bank, trusted: false, addedByUser: false),
  SmsSenderEntry(
    key: 'vodafonecash',
    name: 'Vodafone Cash',
    type: SmsSenderType.wallet,
    trusted: true,
    addedByUser: false,
  ),
  SmsSenderEntry(key: 'BANQUEMIS', name: 'BANQUEMIS', type: SmsSenderType.bank, trusted: true, addedByUser: true),
];

CatchUpCandidate _candidate(
  String key,
  String merchant,
  int minor,
  int day, {
  bool duplicate = false,
  SmsKind kind = SmsKind.expense,
}) => CatchUpCandidate(
  smsKey: key,
  sender: 'CIB',
  receivedAt: DateTime(2026, 10, day),
  parsed: ParsedSms(
    kind: kind,
    amount: Money(minor),
    currency: 'EGP',
    occurredAt: DateTime(2026, 10, day),
    confidence: 0.5,
    merchant: merchant,
    bankName: 'CIB',
    cardLast4: '1234',
  ),
  categoryId: 1,
  likelyDuplicate: duplicate,
);

void main() {
  late _MockCubit cubit;
  late MockSettingsCubit settings;

  setUp(() {
    cubit = _MockCubit();
    settings = MockSettingsCubit();
    when(() => settings.reload()).thenReturn(null);
    when(() => cubit.enable()).thenAnswer((_) async => true);
    when(() => cubit.disable()).thenAnswer((_) async {});
    when(() => cubit.setMode(any())).thenAnswer((_) async {});
    when(() => cubit.catchUpDue()).thenAnswer((_) async => false);
    when(() => cubit.markCatchUpOffered()).thenAnswer((_) async {});
    when(() => cubit.startCatchUp()).thenAnswer((_) async {});
    when(() => cubit.closeCatchUp()).thenReturn(null);
    when(() => cubit.openSystemSettings()).thenAnswer((_) async {});
    when(() => cubit.refreshPermissions()).thenAnswer((_) async {});
    when(() => cubit.deleteHistory()).thenAnswer((_) async => true);
    when(() => cubit.setSenderTrusted(any(), trusted: any(named: 'trusted'))).thenAnswer((_) async {});
  });

  setUpAll(() {
    registerFallbackValue(SmsMode.ask);
    registerFallbackValue(_senders.first);
  });

  group('SmsImportScreen', () {
    late List<String> opened;

    Future<void> pump(
      WidgetTester tester,
      SmsImportState state, {
      Locale locale = const Locale('en'),
      bool disclosureAccepted = true,
    }) async {
      tester.view
        ..physicalSize = const Size(400, 1800)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      opened = [];
      whenListen(cubit, const Stream<SmsImportState>.empty(), initialState: state);
      await pumpApp(
        tester,
        RouterHost(
          routes: [
            GoRoute(path: '/', builder: (context, _) => const SmsImportScreen()),
            GoRoute(
              path: RoutePaths.smsDisclosure,
              builder: (context, _) => SmsDisclosureScreen(key: ValueKey(disclosureAccepted)),
            ),
            GoRoute(
              path: '/expenses/:id',
              builder: (context, route) {
                opened.add(route.uri.toString());
                return Scaffold(body: Text('expense ${route.pathParameters['id']}'));
              },
            ),
            GoRoute(
              path: '/expenses/new',
              builder: (context, route) {
                opened.add(route.uri.toString());
                return const Scaffold(body: Text('new expense'));
              },
            ),
          ],
        ),
        locale: locale,
        settings: testSettings(),
        settingsCubit: settings,
        providers: [BlocProvider<SmsImportCubit>.value(value: cubit)],
      );
    }

    SmsImportState on({SmsMode mode = SmsMode.ask, List<SmsImport>? recent, List<SmsSenderEntry>? senders}) =>
        SmsImportState(
          loading: false,
          enabled: true,
          mode: mode,
          senders: senders ?? _senders,
          recent: recent ?? _recent,
          categories: [_food, _transport, _salary],
        );

    const off = SmsImportState(loading: false);

    group('off', () {
      testWidgets('English: the intro, the switch and the privacy line, and nothing else', (tester) async {
        await pump(tester, off);

        expect(find.text('Add from SMS'), findsOneWidget);
        expect(
          find.text('Add transactions from your bank and wallet messages. Messages are read on this phone only.'),
          findsOneWidget,
        );
        expect(find.text('Add transactions from bank messages'), findsOneWidget);
        expect(find.text('Android only · Processed on your phone'), findsOneWidget);
        expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);
        expect(find.text('Mode'), findsNothing);
        expect(find.text('Trusted senders'), findsNothing);
        expect(find.text('Recent imports'), findsNothing);
        expect(find.text('Open settings'), findsNothing);
      });

      testWidgets('Arabic', (tester) async {
        await pump(tester, off, locale: const Locale('ar'));

        expect(find.text('الإضافة من الرسائل'), findsOneWidget);
        expect(find.text('إضافة المعاملات من رسائل البنوك'), findsOneWidget);
        expect(find.text('أندرويد فقط · تُعالَج على هاتفك'), findsOneWidget);
        expect(find.text('الوضع'), findsNothing);
      });

      testWidgets('turning it on shows the disclosure first and asks for nothing yet', (tester) async {
        await pump(tester, off);

        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        expect(find.text('Read bank messages?'), findsOneWidget);
        verifyNever(() => cubit.enable());
      });

      testWidgets('Continue on the disclosure asks for the permissions', (tester) async {
        await pump(tester, off);
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        verify(() => cubit.enable()).called(1);
        expect(find.text('Add from SMS'), findsOneWidget);
      });

      testWidgets('Not now leaves it off and asks for nothing', (tester) async {
        await pump(tester, off);
        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();

        await tester.tap(find.text('Not now'));
        await tester.pumpAndSettle();

        verifyNever(() => cubit.enable());
        expect(find.text('Add from SMS'), findsOneWidget);
        expect(find.text('Read bank messages?'), findsNothing);
      });

      testWidgets('after enabling for the first time the catch-up sheet is offered once', (tester) async {
        when(() => cubit.catchUpDue()).thenAnswer((_) async => true);
        await pump(tester, off);

        await tester.tap(find.byType(Switch));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        verify(() => cubit.markCatchUpOffered()).called(1);
        verify(() => cubit.startCatchUp()).called(1);
      });

      testWidgets('a denied permission leaves the switch off and shows the card with Open settings', (tester) async {
        when(() => cubit.enable()).thenAnswer((_) async => false);
        await pump(tester, const SmsImportState(loading: false, permissionDenied: true));

        expect(
          find.text('SMS access is off. Allow it in system settings to add transactions from messages.'),
          findsOneWidget,
        );
        expect(tester.widget<Switch>(find.byType(Switch)).value, isFalse);

        await tester.tap(find.text('Open settings'));
        verify(() => cubit.openSystemSettings()).called(1);
      });

      testWidgets('the denied card in Arabic', (tester) async {
        await pump(tester, const SmsImportState(loading: false, permissionDenied: true), locale: const Locale('ar'));

        expect(
          find.text('الوصول إلى الرسائل متوقف. اسمح به من إعدادات النظام لإضافة المعاملات من الرسائل.'),
          findsOneWidget,
        );
        expect(find.text('فتح الإعدادات'), findsOneWidget);
      });
    });

    group('on', () {
      testWidgets('English: mode, trusted senders and recent imports, like the Figma frame', (tester) async {
        await pump(tester, on());

        expect(tester.widget<Switch>(find.byType(Switch).first).value, isTrue);
        expect(
          find.text('Add transactions from your bank and wallet messages. Messages are read on this phone only.'),
          findsNothing,
        );
        for (final text in [
          'Mode',
          'Ask me',
          'Automatic',
          "We'll send a notification for each transaction.",
          'Trusted senders',
          'CIB',
          'NBE',
          'Vodafone Cash',
          'BANQUEMIS',
          'Trusted by you',
          'Recent imports',
          'Carrefour',
          'Uber',
          'Salary',
          'Netflix',
          'Added',
          'Needs review',
          'Ignored',
          'Scan last 30 days',
          'Delete import history',
        ]) {
          expect(find.text(text), findsWidgets, reason: text);
        }
        expect(find.text('EGP 450'), findsOneWidget);
        expect(find.text('+EGP 12,000'), findsOneWidget);
        expect(find.text('CIB ••1234 · Oct 9'), findsNWidgets(4));
      });

      testWidgets('Arabic: right to left, Arabic digits, the Figma copy', (tester) async {
        await pump(tester, on(), locale: const Locale('ar'));

        for (final text in [
          'الوضع',
          'اسألني',
          'سجّل تلقائيًا',
          'سنرسل إشعارًا لكل معاملة.',
          'المُرسِلون الموثوقون',
          'موثوق من قِبلك',
          'آخر العمليات المستوردة',
          'تمت الإضافة',
          'بحاجة لمراجعة',
          'تم التجاهل',
          'فحص آخر ٣٠ يومًا',
          'حذف سجل الاستيراد',
          '٤٥٠ ج.م.',
        ]) {
          expect(find.text(text), findsWidgets, reason: text);
        }
        expect(find.text('CIB ••١٢٣٤ · ٩ أكتوبر'), findsNWidgets(4));
        expect(Directionality.of(tester.element(find.text('الوضع'))), TextDirection.rtl);
      });

      testWidgets('Automatic mode explains itself', (tester) async {
        await pump(tester, on(mode: SmsMode.auto));

        expect(find.text('Transactions are saved to your default wallet without asking.'), findsOneWidget);
        expect(find.text("We'll send a notification for each transaction."), findsNothing);
      });

      testWidgets('the mode control sets the mode', (tester) async {
        await pump(tester, on());

        await tester.tap(find.text('Automatic'));

        verify(() => cubit.setMode(SmsMode.auto)).called(1);
      });

      testWidgets('turning the switch off turns it off at once', (tester) async {
        await pump(tester, on());

        await tester.tap(find.byType(Switch).first);

        verify(() => cubit.disable()).called(1);
      });

      testWidgets("a sender's switch stops importing from it", (tester) async {
        await pump(tester, on());

        // The first switch is the master one; then CIB.
        await tester.tap(find.byType(Switch).at(1));

        verify(() => cubit.setSenderTrusted(_senders.first, trusted: false)).called(1);
        await tester.tap(find.byType(Switch).at(2));
        verify(() => cubit.setSenderTrusted(_senders[1], trusted: true)).called(1);
      });

      testWidgets('notifications off in Ask mode: the note with Open settings', (tester) async {
        await pump(tester, on().copyWith(notificationsGranted: false));

        expect(
          find.text("Notifications are off, so we can't ask you. Turn them on, or switch to Automatic."),
          findsOneWidget,
        );
        await tester.tap(find.text('Open settings'));
        verify(() => cubit.openSystemSettings()).called(1);
      });

      testWidgets('notifications off does not matter in Automatic mode', (tester) async {
        await pump(tester, on(mode: SmsMode.auto).copyWith(notificationsGranted: false));

        expect(find.textContaining('Notifications are off'), findsNothing);
      });

      testWidgets('no recent imports shows the empty copy', (tester) async {
        await pump(tester, on(recent: const []));

        expect(find.text('Transactions from your bank messages will appear here.'), findsOneWidget);
      });

      testWidgets('no senders hides the list', (tester) async {
        await pump(tester, on(senders: const []));

        expect(find.text('Trusted senders'), findsNothing);
      });

      testWidgets('a row opens its transaction, or the pre-filled form when it was never added', (tester) async {
        await pump(tester, on());

        await tester.tap(find.text('Carrefour'));
        await tester.pumpAndSettle();
        expect(find.text('expense 11'), findsOneWidget);
        tester.state<NavigatorState>(find.byType(Navigator).last).pop();
        await tester.pumpAndSettle();

        await tester.tap(find.text('Uber'));
        await tester.pumpAndSettle();
        expect(opened.last, '/expenses/new?sms=2');
        tester.state<NavigatorState>(find.byType(Navigator).last).pop();
        await tester.pumpAndSettle();

        // An ignored one can still be added.
        await tester.tap(find.text('Netflix'));
        await tester.pumpAndSettle();
        expect(opened.last, '/expenses/new?sms=4');
      });

      testWidgets('a cancelled import does not open anything', (tester) async {
        await pump(tester, on(recent: [_import(5, 'Uber', 500, SmsImportStatus.cancelled, categoryId: 2)]));

        await tester.tap(find.text('Uber'));
        await tester.pumpAndSettle();

        expect(opened, isEmpty);
        expect(find.text('Cancelled'), findsOneWidget);
      });

      testWidgets('an import in another currency keeps its currency', (tester) async {
        final usd = _import(6, 'Amazon', 2550, SmsImportStatus.pending, categoryId: 1).copyWith(currency: 'USD');
        await pump(tester, on(recent: [usd]));

        expect(find.text('USD 25.50'), findsOneWidget);
      });

      testWidgets('an import with no merchant is titled by its category', (tester) async {
        final plain = SmsImport(
          id: 7,
          smsKey: 'k7',
          sender: 'EGBANK',
          receivedAt: DateTime(2026, 10, 9),
          kind: TransactionKind.expense,
          amount: const Money(26000),
          currency: 'EGP',
          date: LocalDate(2026, 10, 9),
          status: SmsImportStatus.pending,
          categoryId: 1,
        );
        await pump(tester, on(recent: [plain]));

        expect(find.text('Food'), findsOneWidget);
        expect(find.text('EG Bank · Oct 9'), findsOneWidget);
      });

      testWidgets('Scan last 30 days opens the review', (tester) async {
        await pump(tester, on());

        await tester.ensureVisible(find.text('Scan last 30 days'));
        await tester.tap(find.text('Scan last 30 days'));
        await tester.pump();

        verify(() => cubit.startCatchUp()).called(1);
      });

      testWidgets('Delete import history asks first, then deletes', (tester) async {
        await pump(tester, on());
        await tester.ensureVisible(find.text('Delete import history'));

        await tester.tap(find.text('Delete import history'));
        await tester.pumpAndSettle();
        expect(find.text('Delete import history?'), findsOneWidget);
        expect(find.text('This clears the list of imported messages. Your transactions stay.'), findsOneWidget);
        verifyNever(() => cubit.deleteHistory());

        await tester.tap(find.text('Delete'));
        await tester.pumpAndSettle();

        verify(() => cubit.deleteHistory()).called(1);
        expect(find.text('Import history deleted'), findsOneWidget);
      });

      testWidgets('cancelling the confirmation deletes nothing', (tester) async {
        await pump(tester, on());
        await tester.ensureVisible(find.text('Delete import history'));

        await tester.tap(find.text('Delete import history'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        verifyNever(() => cubit.deleteHistory());
      });
    });
  });

  group('SmsDisclosureScreen', () {
    late List<bool?> results;

    Future<void> pump(WidgetTester tester, {Locale locale = const Locale('en')}) async {
      tester.view
        ..physicalSize = const Size(400, 900)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      results = [];
      await pumpApp(
        tester,
        RouterHost(
          routes: [
            GoRoute(
              path: '/',
              builder: (context, _) => Scaffold(
                body: TextButton(
                  onPressed: () async => results.add(await context.push<bool>('/disclosure')),
                  child: const Text('open'),
                ),
              ),
            ),
            GoRoute(path: '/disclosure', builder: (context, _) => const SmsDisclosureScreen()),
          ],
        ),
        locale: locale,
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    testWidgets('English: a full page that says what is read, why and where it stays', (tester) async {
      await pump(tester);

      expect(find.text('Read bank messages?'), findsOneWidget);
      expect(
        find.text(
          'To add your transactions for you, Masroofy reads messages from your bank and wallet. Here is how it works:',
        ),
        findsOneWidget,
      );
      expect(find.text('Only messages from banks and wallets'), findsOneWidget);
      expect(find.text('OTP codes and personal messages are ignored'), findsOneWidget);
      expect(find.text('Everything stays on this phone'), findsOneWidget);
      expect(find.text('Continue'), findsOneWidget);
      expect(find.text('Not now'), findsOneWidget);
      expect(find.byType(Dialog), findsNothing);
    });

    testWidgets('Arabic', (tester) async {
      await pump(tester, locale: const Locale('ar'));

      expect(find.text('قراءة رسائل البنوك؟'), findsOneWidget);
      expect(find.text('رسائل البنوك والمحافظ فقط'), findsOneWidget);
      expect(find.text('كل شيء يبقى على هذا الهاتف'), findsOneWidget);
      expect(find.text('متابعة'), findsOneWidget);
      expect(find.text('ليس الآن'), findsOneWidget);
    });

    testWidgets('the title is a header for screen readers', (tester) async {
      await pump(tester);

      final semantics = tester.getSemantics(find.text('Read bank messages?'));
      expect(semantics.getSemanticsData().flagsCollection.isHeader, isTrue);
    });

    testWidgets('Continue answers yes', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Continue'));
      await tester.pumpAndSettle();

      expect(results, [true]);
    });

    testWidgets('Not now answers no', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Not now'));
      await tester.pumpAndSettle();

      expect(results, [false]);
    });
  });

  group('the catch-up review sheet', () {
    late List<int?> results;

    Future<void> pump(WidgetTester tester, CatchUpState? catchUp, {Locale locale = const Locale('en')}) async {
      tester.view
        ..physicalSize = const Size(400, 1000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      results = [];
      when(() => cubit.toggleCandidate(any())).thenReturn(null);
      when(() => cubit.addSelected()).thenAnswer((_) async => 2);
      whenListen(
        cubit,
        const Stream<SmsImportState>.empty(),
        initialState: SmsImportState(loading: false, enabled: true, categories: [_food], catchUp: catchUp),
      );
      await pumpApp(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(
              onPressed: () async => results.add(await showCatchUpSheet(context, cubit)),
              child: const Text('open'),
            ),
          ),
        ),
        locale: locale,
        providers: [BlocProvider<SmsImportCubit>.value(value: cubit)],
      );
      await tester.tap(find.text('open'));
      await tester.pumpAndSettle();
    }

    final ready = CatchUpState(
      status: CatchUpStatus.ready,
      candidates: [
        _candidate('a', 'Carrefour', 45000, 9),
        _candidate('b', 'Uber', 8500, 8),
        _candidate('c', 'Salary', 1200000, 1, kind: SmsKind.income),
        _candidate('d', 'Vodafone', 19900, 7, duplicate: true),
        _candidate('e', 'Netflix', 24000, 5),
      ],
      selected: const {'a', 'b', 'c', 'e'},
    );

    testWidgets('English: the found count, every row, the duplicate note and Add 4 selected', (tester) async {
      await pump(tester, ready);

      expect(find.text('Import the last 30 days?'), findsOneWidget);
      expect(find.text('5 transactions found'), findsOneWidget);
      for (final text in ['Carrefour', 'Uber', 'Salary', 'Vodafone', 'Netflix']) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(find.text('Oct 9 · Expense'), findsOneWidget);
      expect(find.text('Oct 1 · Income'), findsOneWidget);
      expect(find.text('EGP 450'), findsOneWidget);
      expect(find.text('+EGP 12,000'), findsOneWidget);
      expect(find.text('Possible duplicate'), findsOneWidget);
      expect(find.text('Add 4 selected'), findsOneWidget);
      expect(find.text('Skip'), findsOneWidget);
      // Everything is checked except the likely duplicate.
      final boxes = tester.widgetList<Checkbox>(find.byType(Checkbox)).map((c) => c.value).toList();
      expect(boxes, [true, true, true, false, true]);
    });

    testWidgets('Arabic', (tester) async {
      await pump(tester, ready, locale: const Locale('ar'));

      expect(find.text('استيراد آخر ٣٠ يومًا؟'), findsOneWidget);
      expect(find.text('وُجدت ٥ معاملات'), findsOneWidget);
      expect(find.text('قد تكون مكررة'), findsOneWidget);
      expect(find.text('إضافة ٤ المحددة'), findsOneWidget);
      expect(find.text('تخطي'), findsOneWidget);
    });

    testWidgets('tapping a row toggles it', (tester) async {
      await pump(tester, ready);

      await tester.tap(find.text('Vodafone'));
      await tester.tap(find.text('Carrefour'));

      verify(() => cubit.toggleCandidate('d')).called(1);
      verify(() => cubit.toggleCandidate('a')).called(1);
    });

    testWidgets('Add selected adds and closes with the count', (tester) async {
      await pump(tester, ready);

      await tester.tap(find.text('Add 4 selected'));
      await tester.pumpAndSettle();

      verify(() => cubit.addSelected()).called(1);
      expect(results, [2]);
      expect(find.text('Import the last 30 days?'), findsNothing);
    });

    testWidgets('Add is disabled with nothing checked', (tester) async {
      await pump(tester, ready.copyWith(selected: const {}));

      final button = tester.widget<FilledButton>(find.widgetWithText(FilledButton, 'Add 0 selected'));
      expect(button.onPressed, isNull);
    });

    testWidgets('Skip closes without adding', (tester) async {
      await pump(tester, ready);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();

      verifyNever(() => cubit.addSelected());
      expect(results, [null]);
    });

    testWidgets('nothing found: says so, and Skip closes', (tester) async {
      await pump(tester, const CatchUpState(status: CatchUpStatus.ready));

      expect(find.text('No bank transactions in the last 30 days.'), findsOneWidget);
      expect(find.textContaining('Add '), findsNothing);

      await tester.tap(find.text('Skip'));
      await tester.pumpAndSettle();
      expect(results, [null]);
    });

    testWidgets('scanning shows a spinner and the message', (tester) async {
      tester.view
        ..physicalSize = const Size(400, 1000)
        ..devicePixelRatio = 1;
      addTearDown(tester.view.reset);
      whenListen(
        cubit,
        const Stream<SmsImportState>.empty(),
        initialState: const SmsImportState(loading: false, enabled: true, catchUp: CatchUpState()),
      );
      await pumpApp(
        tester,
        Builder(
          builder: (context) => Scaffold(
            body: TextButton(onPressed: () => showCatchUpSheet(context, cubit), child: const Text('open')),
          ),
        ),
        providers: [BlocProvider<SmsImportCubit>.value(value: cubit)],
      );
      await tester.tap(find.text('open'));
      await tester.pump(const Duration(milliseconds: 400));

      expect(find.text('Scanning your messages…'), findsOneWidget);
      expect(find.byType(CircularProgressIndicator), findsOneWidget);
    });

    testWidgets('a failed scan says so', (tester) async {
      await pump(tester, const CatchUpState(status: CatchUpStatus.failed));

      expect(find.text("Couldn't read your messages. Check the SMS permission and try again."), findsOneWidget);
    });
  });
}
