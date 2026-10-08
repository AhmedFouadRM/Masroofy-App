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
                categoryId: food.id,
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
}
