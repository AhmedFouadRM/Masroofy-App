import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:liquid_glass_widgets/liquid_glass_widgets.dart';
import 'package:masroofy/app/app.dart';
import 'package:masroofy/app/di.dart';
import 'package:masroofy/app/router.dart';
import 'package:masroofy/core/theme/thmanyah_font_loader.dart';
import 'package:masroofy/features/budgets/presentation/widgets/budget_alert_listener.dart';
import 'package:masroofy/features/recurring_expenses/presentation/widgets/recurring_auto_generator.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();
  await configureDependencies();
  // The default and viewed wallet must exist before the first screen reads them.
  await getIt<SettingsCubit>().repairWalletPreferences();
  // The persisted lockout and biometric support, so the lock screen is right at the first frame.
  await getIt<AuthCubit>().load();
  await ThmanyahFontLoader.load();
  // Loads the liquid glass shaders off the UI thread before the first frame.
  await LiquidGlassWidgets.initialize(enablePerformanceMonitor: false);
  LicenseRegistry.addLicense(() async* {
    yield LicenseEntryWithLineBreaks(['Sora'], await rootBundle.loadString('assets/fonts/sora/OFL.txt'));
  });

  runApp(
    // App-wide cubits are owned by get_it, so they are provided with `.value`
    // (BlocProvider must not close them). Screen cubits are provided by routes.
    MultiBlocProvider(
      providers: [
        BlocProvider<SettingsCubit>.value(value: getIt<SettingsCubit>()),
        BlocProvider<AuthCubit>.value(value: getIt<AuthCubit>()),
      ],
      child: EasyLocalization(
        supportedLocales: const [Locale('en'), Locale('ar')],
        path: 'assets/translations',
        fallbackLocale: const Locale('en'),
        useOnlyLangCode: true,
        // Use CLDR plural rules, so Arabic gets its few / many forms.
        ignorePluralRules: false,
        // Glass follows the app theme (not the OS) and degrades on slow devices.
        child: LiquidGlassWidgets.wrap(
          brightnessResolver: Theme.maybeBrightnessOf,
          adaptiveQuality: true,
          child: RecurringAutoGenerator(
            processDue: getIt(),
            child: BudgetAlertListener(
              budgets: getIt(),
              categories: getIt(),
              takeAlerts: getIt(),
              navigatorKey: rootNavigatorKey,
              auth: getIt(),
              child: const MasroofyApp(),
            ),
          ),
        ),
      ),
    ),
  );
}
