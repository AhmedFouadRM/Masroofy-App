// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'settings_providers.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning
/// Overridden in `main()` with the instance loaded before `runApp`.

@ProviderFor(sharedPreferences)
final sharedPreferencesProvider = SharedPreferencesProvider._();

/// Overridden in `main()` with the instance loaded before `runApp`.

final class SharedPreferencesProvider
    extends
        $FunctionalProvider<
          SharedPreferences,
          SharedPreferences,
          SharedPreferences
        >
    with $Provider<SharedPreferences> {
  /// Overridden in `main()` with the instance loaded before `runApp`.
  SharedPreferencesProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'sharedPreferencesProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$sharedPreferencesHash();

  @$internal
  @override
  $ProviderElement<SharedPreferences> $createElement(
    $ProviderPointer pointer,
  ) => $ProviderElement(pointer);

  @override
  SharedPreferences create(Ref ref) {
    return sharedPreferences(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SharedPreferences value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SharedPreferences>(value),
    );
  }
}

String _$sharedPreferencesHash() => r'bdf49748bece142c907bc28d050b90b97094eaa9';

@ProviderFor(ThemeModeNotifier)
final themeModeProvider = ThemeModeNotifierProvider._();

final class ThemeModeNotifierProvider
    extends $NotifierProvider<ThemeModeNotifier, ThemeMode> {
  ThemeModeNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'themeModeProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$themeModeNotifierHash();

  @$internal
  @override
  ThemeModeNotifier create() => ThemeModeNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(ThemeMode value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<ThemeMode>(value),
    );
  }
}

String _$themeModeNotifierHash() => r'3caca7b9fd8e554636406391e7eccebdfde04190';

abstract class _$ThemeModeNotifier extends $Notifier<ThemeMode> {
  ThemeMode build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<ThemeMode, ThemeMode>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<ThemeMode, ThemeMode>,
              ThemeMode,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

@ProviderFor(CurrencyNotifier)
final currencyProvider = CurrencyNotifierProvider._();

final class CurrencyNotifierProvider
    extends $NotifierProvider<CurrencyNotifier, Currency> {
  CurrencyNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'currencyProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$currencyNotifierHash();

  @$internal
  @override
  CurrencyNotifier create() => CurrencyNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(Currency value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<Currency>(value),
    );
  }
}

String _$currencyNotifierHash() => r'53a0b560a5a80dd80eb8f4da11c23b4b52f2a4cb';

abstract class _$CurrencyNotifier extends $Notifier<Currency> {
  Currency build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<Currency, Currency>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<Currency, Currency>,
              Currency,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Show Western digits (123) instead of Eastern Arabic digits (١٢٣) in Arabic.

@ProviderFor(WesternDigitsNotifier)
final westernDigitsProvider = WesternDigitsNotifierProvider._();

/// Show Western digits (123) instead of Eastern Arabic digits (١٢٣) in Arabic.
final class WesternDigitsNotifierProvider
    extends $NotifierProvider<WesternDigitsNotifier, bool> {
  /// Show Western digits (123) instead of Eastern Arabic digits (١٢٣) in Arabic.
  WesternDigitsNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'westernDigitsProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$westernDigitsNotifierHash();

  @$internal
  @override
  WesternDigitsNotifier create() => WesternDigitsNotifier();

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(bool value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<bool>(value),
    );
  }
}

String _$westernDigitsNotifierHash() =>
    r'698139950c63dab2cb690b5c17b38d20650fe29d';

/// Show Western digits (123) instead of Eastern Arabic digits (١٢٣) in Arabic.

abstract class _$WesternDigitsNotifier extends $Notifier<bool> {
  bool build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<bool, bool>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<bool, bool>,
              bool,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// First day of the week as a `DateTime.weekday` value, from the device
/// region (not the app language): Saturday in Egypt, Sunday in Saudi Arabia.

@ProviderFor(firstWeekday)
final firstWeekdayProvider = FirstWeekdayProvider._();

/// First day of the week as a `DateTime.weekday` value, from the device
/// region (not the app language): Saturday in Egypt, Sunday in Saudi Arabia.

final class FirstWeekdayProvider extends $FunctionalProvider<int, int, int>
    with $Provider<int> {
  /// First day of the week as a `DateTime.weekday` value, from the device
  /// region (not the app language): Saturday in Egypt, Sunday in Saudi Arabia.
  FirstWeekdayProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'firstWeekdayProvider',
        isAutoDispose: false,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$firstWeekdayHash();

  @$internal
  @override
  $ProviderElement<int> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  int create(Ref ref) {
    return firstWeekday(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(int value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<int>(value),
    );
  }
}

String _$firstWeekdayHash() => r'ac8d37c8b65b6658e6c6c88110d4fc76af58f73e';
