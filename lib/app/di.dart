import 'package:flutter/services.dart' show rootBundle;
import 'package:get_it/get_it.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';
import 'package:masroofy/features/categories/data/datasources/reserved_category_names_asset.dart';
import 'package:masroofy/features/categories/data/repositories/category_repository_impl.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/categories/domain/usecases/delete_category.dart';
import 'package:masroofy/features/categories/domain/usecases/save_category.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_cubit.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_cubit.dart';
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

  _registerCategories();
}

void _registerCategories() {
  getIt
    ..registerLazySingleton(() => CategoryLocalDatasource(getIt()))
    ..registerLazySingleton<ICategoryRepository>(() => CategoryRepositoryImpl(getIt()))
    ..registerLazySingleton<IReservedCategoryNames>(() => ReservedCategoryNamesAsset(rootBundle))
    ..registerLazySingleton(() => SaveCategory(getIt(), getIt()))
    ..registerLazySingleton(() => DeleteCategory(getIt()))
    ..registerFactory(() => CategoriesCubit(getIt(), getIt()))
    // param1: the id of the category to edit, or null for a new one.
    ..registerFactoryParam<CategoryFormCubit, int?, void>(
      (categoryId, _) => CategoryFormCubit(getIt(), getIt(), getIt(), categoryId: categoryId),
    );
}
