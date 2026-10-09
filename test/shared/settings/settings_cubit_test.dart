import 'package:bloc_test/bloc_test.dart';
import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;
  late SharedPreferences emptyPreferences;

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    SharedPreferences.setMockInitialValues({});
    emptyPreferences = await SharedPreferences.getInstance();
  });
  tearDown(() => db.close());

  Future<SettingsCubit> makeCubit([
    Map<String, Object> prefs = const {},
  ]) async {
    SharedPreferences.setMockInitialValues(prefs);
    final cubit = SettingsCubit(
      preferences: await SharedPreferences.getInstance(),
      database: db,
      firstWeekday: DateTime.saturday,
    );
    addTearDown(cubit.close);
    return cubit;
  }

  group('currency', () {
    test(
      'defaults to EGP, and an unknown stored code falls back to EGP',
      () async {
        expect((await makeCubit()).state.currency.code, 'EGP');
        expect(
          (await makeCubit({
            PreferenceKeys.currencyCode: 'XYZ',
          })).state.currency.code,
          'EGP',
        );
        expect(
          (await makeCubit({
            PreferenceKeys.currencyCode: 'KWD',
          })).state.currency.code,
          'KWD',
        );
      },
    );

    test(
      'switching fraction digits rescales stored amounts and persists the code',
      () async {
        final cubit = await makeCubit();
        final food = await (db.select(
          db.categoriesTable,
        )..where((c) => c.seedKey.equals('food'))).getSingle();
        await db
            .into(db.expensesTable)
            .insert(
              ExpensesTableCompanion.insert(
                amountMinor: 1250,
                walletId: await db.seedDefaultWallet(),
                categoryId: Value(food.id),
                date: LocalDate(2026, 10, 8),
              ),
            );
        Future<int> storedAmount() async => (await db.select(db.expensesTable).getSingle()).amountMinor;

        await cubit.setCurrency(CurrencyUtils.byCode('KWD')!);
        expect(cubit.state.currency.code, 'KWD');
        expect(
          (await SharedPreferences.getInstance()).getString(
            PreferenceKeys.currencyCode,
          ),
          'KWD',
        );
        expect(await storedAmount(), 12500); // 12.50 → 12.500

        await cubit.setCurrency(CurrencyUtils.byCode('BHD')!);
        expect(await storedAmount(), 12500); // same digits: untouched

        await cubit.setCurrency(CurrencyUtils.byCode('USD')!);
        expect(await storedAmount(), 1250);
      },
    );

    blocTest<SettingsCubit, SettingsState>(
      'selecting the current currency emits nothing',
      build: () => SettingsCubit(
        preferences: emptyPreferences,
        database: db,
        firstWeekday: DateTime.saturday,
      ),
      act: (cubit) => cubit.setCurrency(CurrencyUtils.defaultCurrency),
      expect: () => <SettingsState>[],
    );
  });

  test('theme mode and western digits persist', () async {
    final cubit = await makeCubit();
    expect(cubit.state.themeMode, ThemeMode.system);
    expect(cubit.state.westernDigits, isFalse);
    expect(cubit.state.firstWeekday, DateTime.saturday);

    await cubit.setThemeMode(ThemeMode.dark);
    await cubit.setWesternDigits(enabled: true);

    final preferences = await SharedPreferences.getInstance();
    final reloaded = await makeCubit({
      PreferenceKeys.themeMode: preferences.getString(
        PreferenceKeys.themeMode,
      )!,
      PreferenceKeys.westernDigits: preferences.getBool(
        PreferenceKeys.westernDigits,
      )!,
    });
    expect(reloaded.state.themeMode, ThemeMode.dark);
    expect(reloaded.state.westernDigits, isTrue);
  });

  group('first launch', () {
    test('no stored currency means the first-launch step is pending', () async {
      expect((await makeCubit()).state.currencyChosen, isFalse);
      expect((await makeCubit({PreferenceKeys.currencyCode: 'USD'})).state.currencyChosen, isTrue);
    });

    test('completing it stores the choice, even the preselected EGP', () async {
      final cubit = await makeCubit();

      await cubit.completeFirstLaunch(CurrencyUtils.defaultCurrency);

      expect(cubit.state.currencyChosen, isTrue);
      expect(cubit.state.currency.code, 'EGP');
      expect((await SharedPreferences.getInstance()).getString(PreferenceKeys.currencyCode), 'EGP');
    });

    test('a different choice is stored and applied', () async {
      final cubit = await makeCubit();

      await cubit.completeFirstLaunch(CurrencyUtils.byCode('KWD')!);

      expect(cubit.state.currency.code, 'KWD');
      expect(cubit.state.currencyChosen, isTrue);
      expect((await SharedPreferences.getInstance()).getString(PreferenceKeys.currencyCode), 'KWD');
    });
  });

  test('reload re-reads the stored preferences (after a restore)', () async {
    final cubit = await makeCubit();
    final preferences = await SharedPreferences.getInstance();
    await preferences.setString(PreferenceKeys.currencyCode, 'BHD');
    await preferences.setString(PreferenceKeys.themeMode, 'dark');
    await preferences.setBool(PreferenceKeys.westernDigits, true);

    cubit.reload();

    expect(cubit.state.currency.code, 'BHD');
    expect(cubit.state.themeMode, ThemeMode.dark);
    expect(cubit.state.westernDigits, isTrue);
    expect(cubit.state.currencyChosen, isTrue);
    expect(cubit.state.firstWeekday, DateTime.saturday);
  });

  group('wallets', () {
    Future<SharedPreferences> preferences() => SharedPreferences.getInstance();

    test('nothing is stored on a fresh install', () async {
      final cubit = await makeCubit();

      expect(cubit.state.defaultWalletId, isNull);
      expect(cubit.state.viewedWalletId, isNull);
    });

    test('reads the stored default and viewed wallet, and 0 is All wallets', () async {
      final cubit = await makeCubit({PreferenceKeys.defaultWalletId: 1, PreferenceKeys.viewedWalletId: 2});
      expect((cubit.state.defaultWalletId, cubit.state.viewedWalletId), (1, 2));

      final all = await makeCubit({PreferenceKeys.defaultWalletId: 1, PreferenceKeys.viewedWalletId: 0});
      expect((all.state.defaultWalletId, all.state.viewedWalletId), (1, null));
    });

    test('the default wallet is remembered', () async {
      final cubit = await makeCubit();

      await cubit.setDefaultWallet(3);

      expect(cubit.state.defaultWalletId, 3);
      expect((await preferences()).getInt('default_wallet_id'), 3);
    });

    test('the viewed wallet is remembered, and All wallets too', () async {
      final cubit = await makeCubit();

      await cubit.setViewedWallet(2);
      expect(cubit.state.viewedWalletId, 2);
      expect((await preferences()).getInt('viewed_wallet_id'), 2);

      await cubit.setViewedWallet(null);
      expect(cubit.state.viewedWalletId, isNull);
      expect((await preferences()).getInt('viewed_wallet_id'), PreferenceKeys.allWallets);
      expect(cubit.state.defaultWalletId, isNull, reason: 'the default is a separate choice');
    });

    test('reload re-reads the wallets too (after a restore or a clear)', () async {
      final cubit = await makeCubit();
      final stored = await preferences();
      await stored.setInt(PreferenceKeys.defaultWalletId, 4);
      await stored.setInt(PreferenceKeys.viewedWalletId, 4);

      cubit.reload();

      expect((cubit.state.defaultWalletId, cubit.state.viewedWalletId), (4, 4));
    });

    group('repairWalletPreferences', () {
      late int me;

      setUp(() async => me = await db.seedDefaultWallet());

      test('an upgraded or fresh install: Me is the default and the wallet viewed', () async {
        final cubit = await makeCubit();

        await cubit.repairWalletPreferences();

        expect((cubit.state.defaultWalletId, cubit.state.viewedWalletId), (me, me));
        final stored = await preferences();
        expect((stored.getInt('default_wallet_id'), stored.getInt('viewed_wallet_id')), (me, me));
      });

      test('keeps wallets that exist', () async {
        final son = await db
            .into(db.walletsTable)
            .insert(WalletsTableCompanion.insert(name: const Value('Son'), icon: 'child', color: 0, sortOrder: 1));
        final cubit = await makeCubit({PreferenceKeys.defaultWalletId: son, PreferenceKeys.viewedWalletId: me});

        await cubit.repairWalletPreferences();

        expect((cubit.state.defaultWalletId, cubit.state.viewedWalletId), (son, me));
      });

      test('a choice of All wallets is not undone at the next launch', () async {
        final cubit = await makeCubit({
          PreferenceKeys.defaultWalletId: me,
          PreferenceKeys.viewedWalletId: PreferenceKeys.allWallets,
        });

        await cubit.repairWalletPreferences();

        expect(cubit.state.viewedWalletId, isNull);
        expect((await preferences()).getInt('viewed_wallet_id'), PreferenceKeys.allWallets);
      });

      test('a default wallet that is gone becomes the first wallet', () async {
        final cubit = await makeCubit({PreferenceKeys.defaultWalletId: 99, PreferenceKeys.viewedWalletId: me});

        await cubit.repairWalletPreferences();

        expect(cubit.state.defaultWalletId, me);
      });

      test('a viewed wallet that is gone becomes All wallets', () async {
        final cubit = await makeCubit({PreferenceKeys.defaultWalletId: me, PreferenceKeys.viewedWalletId: 99});

        await cubit.repairWalletPreferences();

        expect(cubit.state.viewedWalletId, isNull);
        expect((await preferences()).getInt('viewed_wallet_id'), PreferenceKeys.allWallets);
      });

      test('with no wallet at all nothing is stored', () async {
        await db.customStatement('DELETE FROM wallets');
        final cubit = await makeCubit();

        await cubit.repairWalletPreferences();

        expect(cubit.state.defaultWalletId, isNull);
        expect((await preferences()).containsKey('default_wallet_id'), isFalse);
      });
    });
  });
}
