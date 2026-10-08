import 'package:drift/drift.dart' show driftRuntimeOptions;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/app/di.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() => SharedPreferences.setMockInitialValues({}));
  tearDown(getIt.reset);

  test('registers app-lifetime singletons', () async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    await configureDependencies(openDatabase: () => AppDatabase(NativeDatabase.memory()));

    expect(getIt<SettingsCubit>(), same(getIt<SettingsCubit>()));
    expect(getIt<AppDatabase>(), same(getIt<AppDatabase>()));
    expect(getIt<SettingsCubit>().state.currency.code, 'EGP');
  });
}
