import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart' show Right, unit;
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/app_redirect.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/app/streams_listenable.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/auth/domain/entities/lockout_record.dart';
import 'package:masroofy/features/auth/domain/repositories/i_auth_repository.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class _MockAuthRepository extends Mock implements IAuthRepository {}

/// The router's guard wired the way `buildRouter` wires it (the redirect plus
/// a refresh on every cubit state change), with stand-in pages, so the whole
/// first-launch and lock navigation is exercised without the real screens.
void main() {
  late AppDatabase db;
  late _MockAuthRepository authRepository;
  late AuthCubit auth;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    authRepository = _MockAuthRepository();
    when(() => authRepository.isEnabled).thenReturn(false);
    when(() => authRepository.isBiometricEnabled).thenReturn(false);
    when(() => authRepository.verifyPin(any())).thenAnswer((_) async => const Right(true));
    when(() => authRepository.saveLockout(any())).thenAnswer((_) async => const Right(unit));
  });
  setUpAll(() => registerFallbackValue(LockoutRecord.none));
  tearDown(() => db.close());

  Future<(GoRouter, SettingsCubit)> pumpRouter(WidgetTester tester, {Map<String, Object> prefs = const {}}) async {
    SharedPreferences.setMockInitialValues({...prefs});
    final settings = SettingsCubit(
      preferences: await SharedPreferences.getInstance(),
      database: db,
      firstWeekday: DateTime.saturday,
    );
    auth = AuthCubit(authRepository);
    addTearDown(() async {
      await settings.close();
      await auth.close();
    });
    final router = GoRouter(
      initialLocation: RoutePaths.expenses,
      refreshListenable: StreamsListenable([auth.stream, settings.stream]),
      redirect: (context, state) => appRedirect(auth: auth.state, settings: settings.state, location: state.uri),
      routes: [
        for (final path in [RoutePaths.expenses, RoutePaths.analytics, RoutePaths.firstLaunch, RoutePaths.lock])
          GoRoute(
            path: path,
            builder: (context, state) => Text('page $path ${state.uri.queryParameters['from'] ?? ''}'),
          ),
      ],
    );
    addTearDown(router.dispose);
    await tester.pumpWidget(MaterialApp.router(routerConfig: router));
    await tester.pumpAndSettle();
    return (router, settings);
  }

  group('first launch', () {
    testWidgets('a fresh install starts on the currency picker, then opens the app once chosen', (tester) async {
      final (_, settings) = await pumpRouter(tester);
      expect(find.text('page ${RoutePaths.firstLaunch} '), findsOneWidget);

      await settings.completeFirstLaunch(CurrencyUtils.byCode('SAR')!);
      await tester.pumpAndSettle();

      expect(find.text('page ${RoutePaths.expenses} '), findsOneWidget);
      expect(find.text('page ${RoutePaths.firstLaunch} '), findsNothing);
    });

    testWidgets('an existing install goes straight to the expense list', (tester) async {
      await pumpRouter(tester, prefs: {PreferenceKeys.currencyCode: 'EGP'});

      expect(find.text('page ${RoutePaths.expenses} '), findsOneWidget);
    });

    testWidgets('the picker cannot be skipped by navigating elsewhere', (tester) async {
      final (router, _) = await pumpRouter(tester);

      router.go(RoutePaths.analytics);
      await tester.pumpAndSettle();

      expect(find.text('page ${RoutePaths.firstLaunch} '), findsOneWidget);
    });
  });

  group('app lock', () {
    testWidgets('a cold launch with the lock on shows the lock screen', (tester) async {
      when(() => authRepository.isEnabled).thenReturn(true);
      await pumpRouter(tester, prefs: {PreferenceKeys.currencyCode: 'EGP'});

      expect(find.textContaining('page ${RoutePaths.lock}'), findsOneWidget);
      expect(find.textContaining('page ${RoutePaths.expenses}'), findsNothing);
    });

    testWidgets('unlocking returns to the page the user was on', (tester) async {
      when(() => authRepository.isEnabled).thenReturn(true);
      final (router, _) = await pumpRouter(tester, prefs: {PreferenceKeys.currencyCode: 'EGP'});
      expect(find.text('page ${RoutePaths.lock} ${RoutePaths.expenses}'), findsOneWidget);

      await auth.unlockWithPin('1234');
      await tester.pumpAndSettle();
      expect(find.text('page ${RoutePaths.expenses} '), findsOneWidget);

      router.go(RoutePaths.analytics);
      await tester.pumpAndSettle();
      expect(find.text('page ${RoutePaths.analytics} '), findsOneWidget);
    });

    testWidgets('relocking after the grace period covers wherever the user is', (tester) async {
      when(() => authRepository.isEnabled).thenReturn(true);
      var now = DateTime.utc(2026, 10, 9, 12);
      SharedPreferences.setMockInitialValues({PreferenceKeys.currencyCode: 'EGP'});
      final settings = SettingsCubit(
        preferences: await SharedPreferences.getInstance(),
        database: db,
        firstWeekday: DateTime.saturday,
      );
      auth = AuthCubit(authRepository, now: () => now);
      addTearDown(() async {
        await settings.close();
        await auth.close();
      });
      final router = GoRouter(
        initialLocation: RoutePaths.analytics,
        refreshListenable: StreamsListenable([auth.stream, settings.stream]),
        redirect: (context, state) => appRedirect(auth: auth.state, settings: settings.state, location: state.uri),
        routes: [
          for (final path in [RoutePaths.analytics, RoutePaths.lock])
            GoRoute(
              path: path,
              builder: (context, state) => Text('page $path ${state.uri.queryParameters['from'] ?? ''}'),
            ),
        ],
      );
      addTearDown(router.dispose);
      await tester.pumpWidget(MaterialApp.router(routerConfig: router));
      await auth.unlockWithPin('1234');
      await tester.pumpAndSettle();
      expect(find.text('page ${RoutePaths.analytics} '), findsOneWidget);

      auth.onBackgrounded();
      now = now.add(const Duration(seconds: 45));
      auth.onResumed();
      await tester.pumpAndSettle();

      expect(find.text('page ${RoutePaths.lock} ${RoutePaths.analytics}'), findsOneWidget);
    });
  });

  test('StreamsListenable notifies on every event of every stream', () async {
    final a = Stream<int>.fromIterable([1, 2]);
    final b = Stream<int>.fromIterable([3]);
    final listenable = StreamsListenable([a, b]);
    var notifications = 0;
    listenable.addListener(() => notifications++);

    await pumpEventQueue();
    expect(notifications, 3);

    listenable.dispose();
  });
}
