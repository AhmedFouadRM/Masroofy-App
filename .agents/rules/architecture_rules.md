---
trigger: always_on
---

# Masroofy Architecture Rules

These rules apply to all code generated for the Masroofy expense tracker project.

## 1. Clean Architecture & Folder Structure
- Follow the feature-first folder structure: `lib/features/<feature_name>/`.
- Each feature must be split into `domain`, `data`, and `presentation` layers.
- Cross-feature dependencies must be minimized (e.g., Analytics can read from Expenses, but Expenses should not depend on Analytics).

## 2. State Management (flutter_bloc)
- Use `Cubit` by default; use a full `Bloc` only when event transformers are needed (e.g. search debounce).
- One cubit per screen or flow in `presentation/cubits/<name>_cubit.dart` + `<name>_state.dart`; states are `freezed` classes.
- App-wide cubits (`SettingsCubit`, `AuthCubit`) are get_it lazy singletons provided with `BlocProvider.value`; screen cubits are get_it factories provided by their route with `BlocProvider(create: (_) => getIt<XCubit>())`.
- No `BuildContext` inside cubits, and cubits never depend on other cubits.

## 2a. Dependency Injection (get_it)
- Register everything by hand in `lib/app/di.dart` (`configureDependencies()`); no `injectable`.
- Register repositories under their domain interface: `registerLazySingleton<ICategoryRepository>(() => CategoryRepositoryImpl(getIt()))`.
- Constructor injection only. Call `getIt<T>()` only in `di.dart`, `main()`, the router and `BlocProvider(create: ...)` callbacks, never inside cubits, repositories or widget bodies.
- Tests construct classes directly with mocktail fakes; never resolve from get_it in unit tests.
- Every cubit has `bloc_test` tests.

## 3. Data Models (Freezed)
- All domain entities must use the `freezed` package.
- Syntax must be Dart 3 compatible: `abstract class EntityName with _$EntityName`.
- Never use `class EntityName with _$EntityName` (missing `abstract` causes analyzer errors).

## 4. Local Database (Drift)
- Use Drift (SQLite) for all structured, relational data (Expenses, Categories, Budgets, Recurring Expenses).
- Use `shared_preferences` ONLY for flat settings (Theme, Currency, Locale, Auth flag).

## 5. Localization (easy_localization)
- NEVER hardcode user-facing strings in UI widgets.
- NEVER use raw string keys (e.g., `'expenses.add'.tr()`) in widgets.
- ALL string access MUST go through `StringManager` (e.g., `StringManager.addExpense`).
- Ensure every new string is added to BOTH `assets/translations/en.json` and `assets/translations/ar.json`.

## 6. UI & Styling
- Use Material 3 (`useMaterial3: true`).
- Use the `gap` package for spacing instead of `SizedBox(height: ...)` where appropriate.
- Refer to `AppColors` and `AppTheme` in `lib/core/theme/` for styling.

## 7. Error Handling
- Use `fpdart` for error propagation from the data/domain layers to the presentation layer.
- Repositories should return `Either<Failure, Type>`. Use the sealed `Failure` classes defined in `lib/core/error/failures.dart`.
