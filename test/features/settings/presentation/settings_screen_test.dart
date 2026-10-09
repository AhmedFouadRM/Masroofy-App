import 'dart:ui' as ui;

import 'package:bloc_test/bloc_test.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show Right, unit;
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/settings/domain/entities/app_info.dart';
import 'package:masroofy/features/settings/domain/entities/backup_preview.dart';
import 'package:masroofy/features/settings/presentation/cubits/data_management_cubit.dart';
import 'package:masroofy/features/settings/presentation/cubits/wallet_count_cubit.dart';
import 'package:masroofy/features/settings/presentation/screens/settings_screen.dart';
import 'package:masroofy/features/settings/presentation/widgets/hold_to_delete_button.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/auth/pin_flow.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';

import '../../../helpers/pump_app.dart';
import '../../../helpers/router_host.dart';

class _MockAuth extends MockCubit<AuthState> implements AuthCubit {}

class _MockData extends MockCubit<DataManagementState> implements DataManagementCubit {}

class _MockWalletCount extends MockCubit<int?> implements WalletCountCubit {}

void main() {
  late MockSettingsCubit settings;
  late _MockAuth auth;
  late _MockData data;
  late _MockWalletCount walletCount;
  late List<Object?> opened;

  const appInfo = AppInfo(version: '1.0.0', buildNumber: '1');
  const lockOff = AuthState(isEnabled: false, isLocked: false);
  const lockOn = AuthState(isEnabled: true, isLocked: false, biometricEnabled: true, biometricAvailable: true);

  setUpAll(() {
    registerFallbackValue(ThemeMode.system);
    registerFallbackValue(CurrencyUtils.defaultCurrency);
    registerFallbackValue(_label);
    registerFallbackValue(_walletLabel);
  });

  setUp(() {
    settings = MockSettingsCubit();
    auth = _MockAuth();
    data = _MockData();
    walletCount = _MockWalletCount();
    opened = [];
    when(() => settings.setThemeMode(any())).thenAnswer((_) async {});
    when(() => settings.setWesternDigits(enabled: any(named: 'enabled'))).thenAnswer((_) async {});
    when(() => settings.reload()).thenReturn(null);
    when(() => auth.disable()).thenAnswer((_) async => const Right(unit));
    when(() => auth.setBiometricEnabled(enabled: any(named: 'enabled'))).thenAnswer((_) async => const Right(unit));
    when(() => data.clearAll()).thenAnswer((_) async {});
    when(() => data.exportBackup()).thenAnswer((_) async {});
    when(() => data.pickBackup()).thenAnswer((_) async {});
    when(() => data.confirmRestore()).thenAnswer((_) async {});
    when(
      () => data.exportCsv(
        currency: any(named: 'currency'),
        categoryLabel: any(named: 'categoryLabel'),
        walletLabel: any(named: 'walletLabel'),
      ),
    ).thenAnswer((_) async {});
  });

  Future<void> pump(
    WidgetTester tester, {
    Locale locale = const Locale('en'),
    AuthState authState = lockOff,
    bool westernDigits = false,
    int? wallets = 3,
    Stream<DataManagementState>? dataStates,
  }) async {
    tester.view
      ..physicalSize = const Size(400, 2400)
      ..devicePixelRatio = 1;
    addTearDown(tester.view.reset);
    final settingsState = testSettings(westernDigits: westernDigits);
    whenListen(settings, const Stream<SettingsState>.empty(), initialState: settingsState);
    whenListen(auth, const Stream<AuthState>.empty(), initialState: authState);
    whenListen(walletCount, const Stream<int?>.empty(), initialState: wallets);
    whenListen(
      data,
      dataStates ?? const Stream<DataManagementState>.empty(),
      initialState: const DataManagementState(),
    );
    await pumpApp(
      tester,
      RouterHost(
        routes: [
          GoRoute(
            path: '/',
            builder: (context, state) => const SettingsScreen(appInfo: appInfo),
          ),
          // Stand-ins for the routes the screen opens: they record what for,
          // and pop `true` or `false`.
          for (final path in [RoutePaths.verifyPin, RoutePaths.setPin, RoutePaths.currency, RoutePaths.wallets])
            GoRoute(
              path: path,
              builder: (context, state) {
                opened.add((path, state.extra));
                return Scaffold(
                  body: Column(
                    children: [
                      Text('opened $path'),
                      TextButton(onPressed: () => context.pop(true), child: const Text('pass')),
                      TextButton(onPressed: () => context.pop(false), child: const Text('close')),
                    ],
                  ),
                );
              },
            ),
        ],
      ),
      locale: locale,
      providers: [
        BlocProvider<SettingsCubit>.value(value: settings),
        BlocProvider<AuthCubit>.value(value: auth),
        BlocProvider<DataManagementCubit>.value(value: data),
        BlocProvider<WalletCountCubit>.value(value: walletCount),
      ],
    );
  }

  group('layout', () {
    testWidgets('English: General, Security, Data and About with every tile', (tester) async {
      await pump(tester);

      for (final text in [
        'Settings',
        'General',
        'Wallets',
        'Currency',
        'EGP',
        'Language',
        'English',
        'Theme',
        'Light',
        'Security',
        'App lock',
        'Off',
        'Data',
        'Manage categories',
        'Manage budgets',
        'Export expenses (CSV)',
        'Export backup',
        'Restore backup',
        'Clear all data',
        'About',
        'Version',
        '1.0.0 (1)',
        'Open-source licences',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      // Arabic-only and lock-only rows stay hidden.
      expect(find.text('Use Western digits (123)'), findsNothing);
      expect(find.text('Change PIN'), findsNothing);
      expect(find.text('Unlock with fingerprint'), findsNothing);
    });

    testWidgets('with App Lock on: the subtitle, Change PIN and the fingerprint switch', (tester) async {
      await pump(tester, authState: lockOn);

      expect(find.text('PIN and fingerprint'), findsOneWidget);
      expect(find.text('Change PIN'), findsOneWidget);
      expect(find.text('Unlock with fingerprint'), findsOneWidget);
    });

    testWidgets('no fingerprint switch when the device has no biometrics', (tester) async {
      await pump(tester, authState: lockOn.copyWith(biometricAvailable: false, biometricEnabled: false));

      expect(find.text('PIN'), findsOneWidget);
      expect(find.text('Change PIN'), findsOneWidget);
      expect(find.text('Unlock with fingerprint'), findsNothing);
    });

    testWidgets('Arabic: translated, right to left, with the Western digits switch', (tester) async {
      await pump(tester, locale: const Locale('ar'));

      for (final text in [
        'الإعدادات',
        'عام',
        'المحافظ',
        'العملة',
        'ج.م.',
        'اللغة',
        'العربية',
        'المظهر',
        'الأمان',
        'قفل التطبيق',
        'متوقف',
        'البيانات',
        'إدارة الفئات',
        'إدارة الميزانيات',
        'تصدير المصروفات (CSV)',
        'تصدير نسخة احتياطية',
        'استعادة نسخة احتياطية',
        'مسح كل البيانات',
        'حول التطبيق',
        'الإصدار',
        'استخدام الأرقام الغربية (123)',
      ]) {
        expect(find.text(text), findsOneWidget, reason: text);
      }
      expect(Directionality.of(tester.element(find.text('الإعدادات'))), ui.TextDirection.rtl);
    });

    testWidgets('the Western digits switch changes the setting', (tester) async {
      await pump(tester, locale: const Locale('ar'));

      await tester.tap(find.byType(Switch).first);

      verify(() => settings.setWesternDigits(enabled: true)).called(1);
    });

    testWidgets('Manage categories and budgets keep navigating', (tester) async {
      await pump(tester);

      expect(find.text('Manage budgets'), findsOneWidget);
      expect(tester.widget<ListTile>(find.widgetWithText(ListTile, 'Manage budgets')).onTap, isNotNull);
    });
  });

  group('General', () {
    testWidgets('Theme opens a sheet of Light / Dark / System and applies the pick', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Theme'));
      await tester.pumpAndSettle();
      expect(find.text('Dark'), findsOneWidget);
      expect(find.text('System'), findsOneWidget);

      await tester.tap(find.text('Dark'));
      await tester.pumpAndSettle();

      verify(() => settings.setThemeMode(ThemeMode.dark)).called(1);
      expect(find.text('System'), findsNothing);
    });

    testWidgets('Language lists English and العربية and switches the app to Arabic', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Language'));
      await tester.pumpAndSettle();
      expect(find.text('العربية'), findsOneWidget);

      await tester.tap(find.text('العربية'));
      await tester.pumpAndSettle();

      expect(find.text('الإعدادات'), findsOneWidget);
      expect(find.text('Settings'), findsNothing);
    });

    testWidgets('Wallets shows how many wallets there are, and opens the Wallets screen', (tester) async {
      await pump(tester);

      expect(find.descendant(of: find.widgetWithText(ListTile, 'Wallets'), matching: find.text('3')), findsOneWidget);
      await tester.tap(find.text('Wallets'));
      await tester.pumpAndSettle();

      expect(opened, [(RoutePaths.wallets, null)]);
    });

    testWidgets('Wallets is the first row of General', (tester) async {
      await pump(tester);

      final wallets = tester.getTopLeft(find.text('Wallets')).dy;
      expect(wallets, lessThan(tester.getTopLeft(find.text('Currency')).dy));
      expect(wallets, greaterThan(tester.getTopLeft(find.text('General')).dy));
    });

    testWidgets('the count follows the wallets, and is hidden until it is known', (tester) async {
      await pump(tester, wallets: null);

      expect(find.descendant(of: find.widgetWithText(ListTile, 'Wallets'), matching: find.text('3')), findsNothing);
      expect(tester.widget<ListTile>(find.widgetWithText(ListTile, 'Wallets')).onTap, isNotNull);
    });

    testWidgets('Wallets in Arabic shapes its count', (tester) async {
      await pump(tester, locale: const Locale('ar'), wallets: 12);

      expect(
        find.descendant(of: find.widgetWithText(ListTile, 'المحافظ'), matching: find.text('١٢')),
        findsOneWidget,
      );
    });

    testWidgets('Currency opens the picker route', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Currency'));
      await tester.pumpAndSettle();

      expect(opened, [(RoutePaths.currency, null)]);
    });
  });

  group('Security', () {
    testWidgets('turning App Lock on opens Set PIN', (tester) async {
      await pump(tester);

      await tester.tap(find.byType(Switch));
      await tester.pumpAndSettle();

      expect(opened, [(RoutePaths.setPin, PinSetupMode.enable)]);
    });

    testWidgets('turning it off needs the PIN first, then disables', (tester) async {
      await pump(tester, authState: lockOn);

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();
      expect(opened, [(RoutePaths.verifyPin, PinPurpose.disableLock)]);
      verifyNever(() => auth.disable());

      await tester.tap(find.text('pass'));
      await tester.pumpAndSettle();

      verify(() => auth.disable()).called(1);
    });

    testWidgets('closing the PIN screen leaves App Lock on', (tester) async {
      await pump(tester, authState: lockOn);

      await tester.tap(find.byType(Switch).first);
      await tester.pumpAndSettle();
      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      verifyNever(() => auth.disable());
    });

    testWidgets('Change PIN verifies the current PIN, then opens Set PIN for a change', (tester) async {
      await pump(tester, authState: lockOn);

      await tester.tap(find.text('Change PIN'));
      await tester.pumpAndSettle();
      expect(opened, [(RoutePaths.verifyPin, PinPurpose.changePin)]);

      await tester.tap(find.text('pass'));
      await tester.pumpAndSettle();

      expect(opened.last, (RoutePaths.setPin, PinSetupMode.change));
      await tester.tap(find.text('pass'));
      await tester.pumpAndSettle();
      expect(find.text('PIN changed'), findsOneWidget);
    });

    testWidgets('Change PIN stops when the current PIN is not confirmed', (tester) async {
      await pump(tester, authState: lockOn);

      await tester.tap(find.text('Change PIN'));
      await tester.pumpAndSettle();
      await tester.tap(find.text('close'));
      await tester.pumpAndSettle();

      expect(opened, hasLength(1));
    });

    testWidgets('the fingerprint switch can be turned off', (tester) async {
      await pump(tester, authState: lockOn);

      await tester.tap(find.byType(Switch).at(1));

      verify(() => auth.setBiometricEnabled(enabled: false)).called(1);
    });
  });

  group('Data', () {
    testWidgets('Export expenses starts the CSV export in the current currency', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Export expenses (CSV)'));

      final captured = verify(
        () => data.exportCsv(
          currency: captureAny(named: 'currency'),
          categoryLabel: captureAny(named: 'categoryLabel'),
          walletLabel: captureAny(named: 'walletLabel'),
        ),
      ).captured;
      expect((captured[0] as dynamic).code, 'EGP');
      final label = captured[1] as String Function({String? seedKey, String? name});
      expect(label(seedKey: 'food'), 'Food');
      expect(label(name: 'Gym'), 'Gym');
      // Wallets are named like categories: Me from the translations, the others as typed.
      final walletLabel = captured[2] as String Function({String? seedKey, String? name});
      expect(walletLabel(seedKey: 'me'), 'Me');
      expect(walletLabel(name: 'Son'), 'Son');
    });

    testWidgets('Export backup and Restore backup start their actions', (tester) async {
      await pump(tester);

      await tester.tap(find.text('Export backup'));
      await tester.tap(find.text('Restore backup'));

      verify(() => data.exportBackup()).called(1);
      verify(() => data.pickBackup()).called(1);
    });

    testWidgets('a failed export shows the message in a snackbar', (tester) async {
      await pump(
        tester,
        dataStates: Stream.value(
          const DataManagementState(
            failedAction: DataAction.exportCsv,
            failure: Failure.exportFailed(message: 'x'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text("Couldn't create the export. Try again."), findsOneWidget);
    });

    testWidgets('a failed backup says so', (tester) async {
      await pump(
        tester,
        dataStates: Stream.value(
          const DataManagementState(
            failedAction: DataAction.exportBackup,
            failure: Failure.exportFailed(message: 'x'),
          ),
        ),
      );
      await tester.pump();

      expect(find.text("Couldn't create the backup. Try again."), findsOneWidget);
    });

    testWidgets('an invalid backup file is reported and nothing is asked', (tester) async {
      await pump(
        tester,
        dataStates: Stream.value(
          const DataManagementState(
            failedAction: DataAction.restore,
            failure: Failure.validation(field: 'backup', reason: ValidationReason.invalidFormat),
          ),
        ),
      );
      await tester.pump();

      expect(find.text("This file isn't a valid Masroofy backup. Nothing was changed."), findsOneWidget);
      expect(find.text('Restore this backup?'), findsNothing);
    });

    group('restore confirmation', () {
      final picked = PickedBackup(
        json: '{}',
        preview: BackupPreview(
          exportedAt: DateTime(2026, 10, 9, 12),
          expenses: 1284,
          categories: 9,
          budgets: 6,
          recurring: 2,
        ),
      );

      testWidgets('says what is replaced and what the backup holds', (tester) async {
        await pump(tester, dataStates: Stream.value(DataManagementState(pendingRestore: picked)));
        await tester.pumpAndSettle();

        expect(find.text('Restore this backup?'), findsOneWidget);
        expect(
          find.text('It replaces all current data with the backup from Oct 9, 2026 (1,284 expenses, 6 budgets).'),
          findsOneWidget,
        );
      });

      testWidgets('Restore goes ahead, Cancel drops the file', (tester) async {
        when(() => data.cancelRestore()).thenReturn(null);
        await pump(tester, dataStates: Stream.value(DataManagementState(pendingRestore: picked)));
        await tester.pumpAndSettle();
        await tester.tap(find.widgetWithText(FilledButton, 'Restore'));
        await tester.pumpAndSettle();

        verify(() => data.confirmRestore()).called(1);
        verifyNever(() => data.cancelRestore());
      });

      testWidgets('Cancel does not restore', (tester) async {
        when(() => data.cancelRestore()).thenReturn(null);
        await pump(tester, dataStates: Stream.value(DataManagementState(pendingRestore: picked)));
        await tester.pumpAndSettle();
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        verify(() => data.cancelRestore()).called(1);
        verifyNever(() => data.confirmRestore());
      });

      testWidgets('after a restore the preferences are reloaded', (tester) async {
        await pump(tester, dataStates: Stream.value(const DataManagementState(completed: DataAction.restore)));
        await tester.pump();

        verify(() => settings.reload()).called(1);
        expect(find.text('Backup restored'), findsOneWidget);
      });

      testWidgets('after clearing, the default and viewed wallet are Me again, so the preferences are reloaded', (
        tester,
      ) async {
        await pump(tester, dataStates: Stream.value(const DataManagementState(completed: DataAction.clearAll)));
        await tester.pump();

        verify(() => settings.reload()).called(1);
      });
    });

    group('Clear all data', () {
      Future<void> startClearing(WidgetTester tester) async {
        await tester.tap(find.text('Clear all data'));
        await tester.pumpAndSettle();
      }

      testWidgets('step 1 is a red confirmation that can be cancelled', (tester) async {
        await pump(tester);
        await startClearing(tester);

        expect(find.text('Delete all data?'), findsOneWidget);
        await tester.tap(find.text('Cancel'));
        await tester.pumpAndSettle();

        expect(find.text('Delete all data?'), findsNothing);
        verifyNever(() => data.clearAll());
      });

      testWidgets('without App Lock, step 2 is a hold: a tap does nothing', (tester) async {
        await pump(tester);
        await startClearing(tester);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
        expect(find.text('Hold to delete'), findsNWidgets(2)); // title and button

        await tester.tap(find.byType(HoldToDeleteButton));
        await tester.pump(const Duration(milliseconds: 500));
        await tester.pumpAndSettle();

        verifyNever(() => data.clearAll());
        expect(find.text('Hold to delete'), findsNWidgets(2));
      });

      testWidgets('releasing before 3 seconds cancels the hold', (tester) async {
        await pump(tester);
        await startClearing(tester);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        final gesture = await tester.startGesture(tester.getCenter(find.byType(HoldToDeleteButton)));
        await tester.pump(); // the first frame starts the clock
        await tester.pump(const Duration(milliseconds: 2900));
        await gesture.up();
        await tester.pump(const Duration(seconds: 1));
        await tester.pumpAndSettle();

        verifyNever(() => data.clearAll());
      });

      testWidgets('holding for 3 seconds deletes', (tester) async {
        await pump(tester);
        await startClearing(tester);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        final gesture = await tester.startGesture(tester.getCenter(find.byType(HoldToDeleteButton)));
        await tester.pump(); // the first frame starts the clock
        await tester.pump(const Duration(seconds: 1));
        verifyNever(() => data.clearAll());
        await tester.pump(const Duration(milliseconds: 2100));
        await gesture.up();
        await tester.pumpAndSettle();

        verify(() => data.clearAll()).called(1);
        expect(find.text('Hold to delete'), findsNothing);
      });

      testWidgets('with App Lock on, step 2 is the PIN, not the hold', (tester) async {
        await pump(tester, authState: lockOn);
        await startClearing(tester);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();

        expect(opened, [(RoutePaths.verifyPin, PinPurpose.clearData)]);
        expect(find.text('Hold to delete'), findsNothing);
        verifyNever(() => data.clearAll());

        await tester.tap(find.text('pass'));
        await tester.pumpAndSettle();

        verify(() => data.clearAll()).called(1);
      });

      testWidgets('a PIN screen that is closed deletes nothing', (tester) async {
        await pump(tester, authState: lockOn);
        await startClearing(tester);
        await tester.tap(find.text('Continue'));
        await tester.pumpAndSettle();
        await tester.tap(find.text('close'));
        await tester.pumpAndSettle();

        verifyNever(() => data.clearAll());
      });

      testWidgets('confirms it when finished', (tester) async {
        await pump(tester, dataStates: Stream.value(const DataManagementState(completed: DataAction.clearAll)));
        await tester.pump();

        expect(find.text('All data deleted'), findsOneWidget);
      });
    });
  });
}

String _label({String? seedKey, String? name}) => seedKey ?? name ?? '';

String _walletLabel({String? seedKey, String? name}) => seedKey ?? name ?? '';
