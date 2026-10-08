import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/app/router.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/theme/app_theme.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';

class MasroofyApp extends StatelessWidget {
  const MasroofyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeMode = context.select<SettingsCubit, ThemeMode>((cubit) => cubit.state.themeMode);

    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: themeMode,
      localizationsDelegates: context.localizationDelegates,
      supportedLocales: context.supportedLocales,
      locale: context.locale,
      routerConfig: appRouter,
    );
  }
}
