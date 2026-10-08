import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:masroofy/app/app.dart';
import 'package:masroofy/app/di.dart';
import 'package:masroofy/core/theme/thmanyah_font_loader.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();
  await configureDependencies();
  await ThmanyahFontLoader.load();
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Sora'], await rootBundle.loadString('assets/fonts/sora/OFL.txt'));
  });

  runApp(
    // App-wide cubits are owned by get_it, so they are provided with `.value`
    // (BlocProvider must not close them). Screen cubits are provided by routes.
    BlocProvider<SettingsCubit>.value(
      value: getIt<SettingsCubit>(),
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        // Use CLDR plural rules, so Arabic gets its few / many forms.
        ignorePluralRules: false,
        child: const MasroofyApp(),
      ),
    ),
  );
}
