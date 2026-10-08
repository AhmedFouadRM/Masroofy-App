import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter/material.dart' show ThemeMode;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/database_provider.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/shared/providers/settings_providers.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  late AppDatabase db;

  setUp(() {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
  });
  tearDown(() => db.close());

  Future<ProviderContainer> makeContainer([Map<String, Object> prefs = const {}]) async {
    SharedPreferences.setMockInitialValues(prefs);
    final container = ProviderContainer(
      overrides: [
        sharedPreferencesProvider.overrideWithValue(await SharedPreferences.getInstance()),
        appDatabaseProvider.overrideWithValue(db),
      ],
    );
    addTearDown(container.dispose);
    return container;
  }

  group('currency', () {
    test('defaults to EGP, and an unknown stored code falls back to EGP', () async {
      expect((await makeContainer()).read(currencyProvider).code, 'EGP');
      expect((await makeContainer({PreferenceKeys.currencyCode: 'XYZ'})).read(currencyProvider).code, 'EGP');
      expect((await makeContainer({PreferenceKeys.currencyCode: 'KWD'})).read(currencyProvider).code, 'KWD');
    });

    test('switching fraction digits rescales stored amounts and persists the code', () async {
      final container = await makeContainer();
      final food = await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals('food'))).getSingle();
      await db.into(db.expensesTable).insert(
            ExpensesTableCompanion.insert(amountMinor: 1250, categoryId: food.id, date: LocalDate(2026, 10, 8)),
          );
      Future<int> storedAmount() async => (await db.select(db.expensesTable).getSingle()).amountMinor;

      await container.read(currencyProvider.notifier).setCurrency(CurrencyUtils.byCode('KWD')!);
      expect(container.read(currencyProvider).code, 'KWD');
      expect(container.read(sharedPreferencesProvider).getString(PreferenceKeys.currencyCode), 'KWD');
      expect(await storedAmount(), 12500); // 12.50 → 12.500

      await container.read(currencyProvider.notifier).setCurrency(CurrencyUtils.byCode('BHD')!);
      expect(await storedAmount(), 12500); // same digits: untouched

      await container.read(currencyProvider.notifier).setCurrency(CurrencyUtils.byCode('USD')!);
      expect(await storedAmount(), 1250);
    });
  });

  test('theme mode and western digits persist', () async {
    final container = await makeContainer();
    expect(container.read(themeModeProvider), ThemeMode.system);
    expect(container.read(westernDigitsProvider), isFalse);

    await container.read(themeModeProvider.notifier).setThemeMode(ThemeMode.dark);
    await container.read(westernDigitsProvider.notifier).setWesternDigits(enabled: true);

    final reloaded = await makeContainer({
      PreferenceKeys.themeMode: container.read(sharedPreferencesProvider).getString(PreferenceKeys.themeMode)!,
      PreferenceKeys.westernDigits: true,
    });
    expect(reloaded.read(themeModeProvider), ThemeMode.dark);
    expect(reloaded.read(westernDigitsProvider), isTrue);
  });
}
