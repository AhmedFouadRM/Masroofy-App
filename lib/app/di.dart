import 'package:get_it/get_it.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// The composition root. `getIt` is only called here, in `main()`, in the
/// router, and in `BlocProvider(create: ...)` callbacks. Every class receives
/// its dependencies through its constructor, so tests build them directly.
final GetIt getIt = GetIt.instance;

/// Registers app-lifetime dependencies. Repositories and use cases are lazy
/// singletons registered under their domain interface; screen cubits are
/// factories so each route gets a fresh instance that its BlocProvider closes.
///
/// [openDatabase] lets the DI smoke test use an in-memory database.
Future<void> configureDependencies({AppDatabase Function() openDatabase = AppDatabase.new}) async {
  final sharedPreferences = await SharedPreferences.getInstance();

  getIt
    // Core
    ..registerSingleton<SharedPreferences>(sharedPreferences)
    ..registerLazySingleton<AppDatabase>(openDatabase, dispose: (database) => database.close())
    // App-wide cubits
    ..registerLazySingleton<SettingsCubit>(
      () => SettingsCubit(preferences: getIt(), database: getIt()),
      dispose: (cubit) => cubit.close(),
    );
}
