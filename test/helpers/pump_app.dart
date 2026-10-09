import 'dart:convert';
import 'dart:io';

import 'package:bloc_test/bloc_test.dart';
import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/theme/app_theme.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:mocktail/mocktail.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MockSettingsCubit extends MockCubit<SettingsState> implements SettingsCubit {}

/// Reads translations synchronously from disk: rootBundle loads are real
/// async I/O, which `pumpAndSettle` does not wait for.
class _FileAssetLoader extends AssetLoader {
  const _FileAssetLoader();

  @override
  Future<Map<String, dynamic>> load(String path, Locale locale) => Future.value(
    jsonDecode(File('$path/${locale.languageCode}.json').readAsStringSync()) as Map<String, dynamic>,
  );
}

SettingsState testSettings({bool westernDigits = false, int? defaultWalletId, int? viewedWalletId}) => SettingsState(
  themeMode: ThemeMode.light,
  currency: CurrencyUtils.defaultCurrency,
  westernDigits: westernDigits,
  firstWeekday: DateTime.saturday,
  defaultWalletId: defaultWalletId,
  viewedWalletId: viewedWalletId,
);

/// Pumps [child] inside the real theme and translations, in [locale], with
/// a mocked [SettingsCubit] (pass your own as [settingsCubit] to verify calls
/// on it) and any extra [providers].
Future<void> pumpApp(
  WidgetTester tester,
  Widget child, {
  Locale locale = const Locale('en'),
  List<BlocProvider> providers = const [],
  SettingsState? settings,
  MockSettingsCubit? settingsCubit,
}) async {
  SharedPreferences.setMockInitialValues({});
  EasyLocalization.logger.enableBuildModes = [];
  await EasyLocalization.ensureInitialized();

  final appSettings = settingsCubit ?? MockSettingsCubit();
  when(() => appSettings.state).thenReturn(settings ?? testSettings());
  when(() => appSettings.setViewedWallet(any())).thenAnswer((_) async {});
  when(() => appSettings.setDefaultWallet(any())).thenAnswer((_) async {});

  await tester.pumpWidget(
    EasyLocalization(
      supportedLocales: const [Locale('en'), Locale('ar')],
      path: 'assets/translations',
      assetLoader: const _FileAssetLoader(),
      fallbackLocale: const Locale('en'),
      startLocale: locale,
      useOnlyLangCode: true,
      ignorePluralRules: false,
      saveLocale: false,
      child: MultiBlocProvider(
        providers: [
          BlocProvider<SettingsCubit>.value(value: appSettings),
          ...providers,
        ],
        child: Builder(
          builder: (context) => MaterialApp(
            theme: AppTheme.light(arabic: context.locale.languageCode == 'ar'),
            localizationsDelegates: context.localizationDelegates,
            supportedLocales: context.supportedLocales,
            locale: context.locale,
            home: child,
          ),
        ),
      ),
    ),
  );
  // Translations load asynchronously.
  await tester.pumpAndSettle();
}
