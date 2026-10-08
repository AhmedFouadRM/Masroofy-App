import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:masroofy/app/app.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await EasyLocalization.ensureInitialized();
  await initializeDateFormatting();

  final sharedPreferences = await SharedPreferences.getInstance();

  runApp(
    // App-lifetime dependencies. Feature repositories are added here as
    // RepositoryProviders; screen-scoped cubits are provided by their routes.
    MultiRepositoryProvider(
      providers: [
        RepositoryProvider<SharedPreferences>.value(value: sharedPreferences),
        RepositoryProvider<AppDatabase>(
          create: (_) => AppDatabase(),
          dispose: (database) => database.close(),
        ),
      ],
      child: BlocProvider(
        create: (context) => SettingsCubit(
          preferences: context.read<SharedPreferences>(),
          database: context.read<AppDatabase>(),
        ),
        child: EasyLocalization(
          supportedLocales: const [Locale('en'), Locale('ar')],
          path: 'assets/translations',
          fallbackLocale: const Locale('en'),
          useOnlyLangCode: true,
          child: const MasroofyApp(),
        ),
      ),
    ),
  );
}
