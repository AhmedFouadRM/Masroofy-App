import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/app/router.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_theme.dart';
import 'package:masroofy/features/auth/presentation/widgets/auth_lifecycle_gate.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';

class MasroofyApp extends StatelessWidget {
  const MasroofyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<SettingsCubit, ThemeMode>((cubit) => cubit.state.themeMode);
    final arabic = context.locale.languageCode == 'ar';

    return MaterialApp.router(
      onGenerateTitle: (_) => StringManager.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(arabic: arabic),
      darkTheme: AppTheme.dark(arabic: arabic),
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: appRouter,
      // Inside the theme; relocks after the grace period and hides the app switcher snapshot.
      builder: (context, child) => AuthLifecycleGate(child: child!),
    );
  }
}
