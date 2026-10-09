import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart' show PreferenceKeys;
import 'package:shared_preferences/shared_preferences.dart';

/// [ISmsSettings] over the app's `SharedPreferences`. The background engine
/// has its own copy of the preferences, so every read first re-reads the file.
class SmsSettingsStore implements ISmsSettings {
  SmsSettingsStore(this._preferences);

  final SharedPreferences _preferences;

  @override
  Future<SmsSettings> load() async {
    await _preferences.reload();
    return SmsSettings(
      enabled: _preferences.getBool(PreferenceKeys.smsEnabled) ?? false,
      mode: SmsMode.parse(_preferences.getString(PreferenceKeys.smsMode)),
      defaultWalletId: _preferences.getInt(PreferenceKeys.defaultWalletId),
      currencyCode: _preferences.getString(PreferenceKeys.currencyCode) ?? CurrencyUtils.defaultCode,
    );
  }

  @override
  Future<void> setEnabled({required bool enabled}) => _preferences.setBool(PreferenceKeys.smsEnabled, enabled);

  @override
  Future<void> setMode(SmsMode mode) => _preferences.setString(PreferenceKeys.smsMode, mode.name);

  @override
  Future<bool> catchUpOffered() async => _preferences.getBool(PreferenceKeys.smsCatchUpOffered) ?? false;

  @override
  Future<void> markCatchUpOffered() => _preferences.setBool(PreferenceKeys.smsCatchUpOffered, true);
}
