import 'dart:async';
import 'dart:io' show Platform;

import 'package:easy_localization/easy_localization.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/domain/digits.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/utils/date_utils.dart';
import 'package:masroofy/features/settings/domain/entities/app_info.dart';
import 'package:masroofy/features/settings/presentation/cubits/data_management_cubit.dart';
import 'package:masroofy/features/settings/presentation/cubits/wallet_count_cubit.dart';
import 'package:masroofy/features/settings/presentation/widgets/choice_sheet.dart';
import 'package:masroofy/features/settings/presentation/widgets/hold_to_delete_button.dart';
import 'package:masroofy/features/settings/presentation/widgets/settings_tile.dart';
import 'package:masroofy/shared/auth/auth_cubit.dart';
import 'package:masroofy/shared/auth/pin_flow.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/widgets/app_shell.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/grouped_list.dart';
import 'package:masroofy/shared/widgets/icon_dialog.dart';
import 'package:material_symbols_icons/symbols.dart';

/// The Settings tab. Expects a [DataManagementCubit] and a [WalletCountCubit],
/// and the app-wide [SettingsCubit] and [AuthCubit], above it.
class SettingsScreen extends StatelessWidget {
  /// [smsAvailable] shows the Add from SMS row; null means on Android, the
  /// only platform that lets an app read SMS.
  const SettingsScreen({required this.appInfo, this.smsAvailable, super.key});

  final AppInfo appInfo;
  final bool? smsAvailable;

  static const _languages = [Locale('en'), Locale('ar')];

  void _showMessage(BuildContext context, String message) => ScaffoldMessenger.of(context)
    ..hideCurrentSnackBar()
    ..showSnackBar(SnackBar(content: Text(message)));

  // ── General ──

  String _themeName(ThemeMode mode) => switch (mode) {
    ThemeMode.light => StringManager.themeLight,
    ThemeMode.dark => StringManager.themeDark,
    ThemeMode.system => StringManager.themeSystem,
  };

  String _languageName(Locale locale) =>
      locale.languageCode == 'ar' ? StringManager.languageArabic : StringManager.languageEnglish;

  Future<void> _pickTheme(BuildContext context) async {
    final settings = context.read<SettingsCubit>();
    final mode = await showChoiceSheet<ThemeMode>(
      context,
      title: StringManager.theme,
      options: [for (final mode in ThemeMode.values) (mode, _themeName(mode))],
      selected: settings.state.themeMode,
    );
    if (mode != null) unawaited(settings.setThemeMode(mode));
  }

  Future<void> _pickLanguage(BuildContext context) async {
    final locale = await showChoiceSheet<Locale>(
      context,
      title: StringManager.language,
      options: [for (final locale in _languages) (locale, _languageName(locale))],
      selected: context.locale,
    );
    if (locale != null && context.mounted) await context.setLocale(locale);
  }

  // ── Security ──

  Future<void> _toggleAppLock(BuildContext context, {required bool enable}) async {
    if (enable) {
      await context.push<bool>(RoutePaths.setPin, extra: PinSetupMode.enable);
      return;
    }
    final auth = context.read<AuthCubit>();
    final confirmed = await context.push<bool>(RoutePaths.verifyPin, extra: PinPurpose.disableLock);
    if (confirmed != true || !context.mounted) return;
    (await auth.disable()).match(
      (failure) => _showMessage(context, StringManager.failure(failure)),
      (_) => _showMessage(context, StringManager.appLockTurnedOff),
    );
  }

  Future<void> _toggleBiometric(BuildContext context, {required bool enable}) async {
    final auth = context.read<AuthCubit>();
    if (!enable) {
      await auth.setBiometricEnabled(enabled: false);
      return;
    }
    final turnedOn = await auth.turnOnBiometrics(StringManager.biometricPrompt);
    if (!turnedOn && context.mounted) _showMessage(context, StringManager.biometricFailed);
  }

  Future<void> _changePin(BuildContext context) async {
    final confirmed = await context.push<bool>(RoutePaths.verifyPin, extra: PinPurpose.changePin);
    if (confirmed != true || !context.mounted) return;
    final changed = await context.push<bool>(RoutePaths.setPin, extra: PinSetupMode.change);
    if (changed == true && context.mounted) _showMessage(context, StringManager.pinChanged);
  }

  // ── Data ──

  void _exportCsv(BuildContext context) => unawaited(
    context.read<DataManagementCubit>().exportCsv(
      currency: context.read<SettingsCubit>().state.currency,
      categoryLabel: ({seedKey, name}) => seedKey != null ? StringManager.categoryName(seedKey) : (name ?? ''),
      walletLabel: ({seedKey, name}) => seedKey != null ? StringManager.walletName(seedKey) : (name ?? ''),
    ),
  );

  /// Two steps (Settings PRD → Clear All Data): a red confirmation, then the
  /// PIN when App Lock is on, or a 3-second hold when it is off.
  Future<void> _clearAllData(BuildContext context) async {
    final data = context.read<DataManagementCubit>();
    final appLock = context.read<AuthCubit>().state.isEnabled;
    final confirmed = await showIconConfirmDialog(
      context,
      icon: Symbols.delete_forever_rounded,
      title: StringManager.clearTitle,
      message: StringManager.clearBody,
      confirmLabel: StringManager.continueLabel,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    final sure = appLock
        ? await context.push<bool>(RoutePaths.verifyPin, extra: PinPurpose.clearData) ?? false
        : await _holdToDelete(context);
    if (sure) unawaited(data.clearAll());
  }

  Future<bool> _holdToDelete(BuildContext context) async {
    final held = await showDialog<bool>(
      context: context,
      builder: (context) => IconDialog(
        icon: Symbols.touch_app_rounded,
        title: StringManager.holdTitle,
        message: StringManager.holdBody,
        destructive: true,
        confirm: HoldToDeleteButton(onCompleted: () => Navigator.pop(context, true)),
      ),
    );
    return held ?? false;
  }

  /// The backup was picked and checked; asks before replacing anything.
  /// Runs from a listener, outside `build`, so it formats from `read`, not `DisplayFormat`.
  Future<void> _confirmRestore(BuildContext context, DataManagementState state) async {
    final data = context.read<DataManagementCubit>();
    final preview = state.pendingRestore!.preview;
    final languageCode = context.locale.languageCode;
    final westernDigits = context.read<SettingsCubit>().state.westernDigits;
    String count(int value) {
      final grouped = NumberFormat.decimalPattern('en').format(value);
      return languageCode == 'ar' && !westernDigits ? toEasternArabicNumber(grouped) : grouped;
    }

    final confirmed = await showIconConfirmDialog(
      context,
      icon: Symbols.upload_file_rounded,
      title: StringManager.restoreTitle,
      message: StringManager.restoreBody(
        DateUtilsHelper.formatDate(
          LocalDate.fromDateTime(preview.exportedAt.toLocal()),
          languageCode: languageCode,
          westernDigits: westernDigits,
        ),
        preview.expenses,
        count(preview.expenses),
        preview.budgets,
        count(preview.budgets),
      ),
      confirmLabel: StringManager.restore,
      destructive: true,
    );
    if (confirmed) {
      unawaited(data.confirmRestore());
    } else {
      data.cancelRestore();
    }
  }

  void _onDataState(BuildContext context, DataManagementState state) {
    if (state.pendingRestore != null) {
      unawaited(_confirmRestore(context, state));
    } else if (state.failure != null) {
      _showMessage(
        context,
        state.failedAction == DataAction.exportBackup
            ? StringManager.backupFailed
            : StringManager.failure(state.failure!),
      );
    } else if (state.completed case final action?) {
      switch (action) {
        case DataAction.restore:
          // The restore replaced the stored preferences too.
          context.read<SettingsCubit>().reload();
          _showMessage(context, StringManager.restored);
        case DataAction.clearAll:
          // The default and viewed wallet are "Me" again.
          context.read<SettingsCubit>().reload();
          _showMessage(context, StringManager.cleared);
        case DataAction.exportCsv || DataAction.exportBackup:
          break;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final settings = context.select<SettingsCubit, SettingsState>((cubit) => cubit.state);
    final auth = context.select<AuthCubit, AuthState>((cubit) => cubit.state);
    final busy = context.select<DataManagementCubit, bool>((cubit) => cubit.state.busy != null);
    final walletCount = context.select<WalletCountCubit, int?>((cubit) => cubit.state);
    final arabic = context.locale.languageCode == 'ar';

    return BlocListener<DataManagementCubit, DataManagementState>(
      listenWhen: (previous, current) =>
          (current.pendingRestore != null && previous.pendingRestore == null) ||
          (current.failure != null && previous.failure == null) ||
          (current.completed != null && previous.completed == null),
      listener: _onDataState,
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(title: Text(StringManager.settingsTitle)),
          body: ListView(
            padding: EdgeInsets.fromLTRB(
              AppSpacing.screen,
              MediaQuery.paddingOf(context).top + kToolbarHeight,
              AppSpacing.screen,
              AppShell.bottomInset,
            ),
            children: [
              SectionHeader(title: StringManager.sectionGeneral),
              GroupedCard(
                children: [
                  SettingsTile(
                    icon: Symbols.account_balance_wallet_rounded,
                    title: StringManager.walletsTitle,
                    value: walletCount == null ? null : context.count(walletCount),
                    onTap: () => context.push(RoutePaths.wallets),
                  ),
                  SettingsTile(
                    icon: Symbols.payments_rounded,
                    title: StringManager.currency,
                    value: context.currencyLabel,
                    onTap: () => context.push(RoutePaths.currency),
                  ),
                  SettingsTile(
                    icon: Symbols.translate_rounded,
                    title: StringManager.language,
                    value: _languageName(context.locale),
                    onTap: () => _pickLanguage(context),
                  ),
                  if (arabic)
                    SettingsTile(
                      icon: Symbols.pin_rounded,
                      title: StringManager.westernDigits,
                      trailing: Switch(
                        value: settings.westernDigits,
                        onChanged: (enabled) =>
                            unawaited(context.read<SettingsCubit>().setWesternDigits(enabled: enabled)),
                      ),
                    ),
                  SettingsTile(
                    icon: Symbols.contrast_rounded,
                    title: StringManager.theme,
                    value: _themeName(settings.themeMode),
                    onTap: () => _pickTheme(context),
                  ),
                ],
              ),
              SectionHeader(title: StringManager.sectionSecurity),
              GroupedCard(
                children: [
                  SettingsTile(
                    icon: Symbols.lock_rounded,
                    title: StringManager.appLock,
                    subtitle: !auth.isEnabled
                        ? StringManager.appLockOff
                        : auth.biometricEnabled
                        ? StringManager.appLockPinAndFingerprint
                        : StringManager.appLockPin,
                    trailing: Switch(
                      value: auth.isEnabled,
                      onChanged: (enabled) => unawaited(_toggleAppLock(context, enable: enabled)),
                    ),
                  ),
                  if (auth.isEnabled && auth.biometricAvailable)
                    SettingsTile(
                      icon: Symbols.fingerprint_rounded,
                      title: StringManager.unlockWithFingerprint,
                      trailing: Switch(
                        value: auth.biometricEnabled,
                        onChanged: (enabled) => unawaited(_toggleBiometric(context, enable: enabled)),
                      ),
                    ),
                  if (auth.isEnabled)
                    SettingsTile(
                      icon: Symbols.password_rounded,
                      title: StringManager.changePin,
                      onTap: () => _changePin(context),
                    ),
                ],
              ),
              SectionHeader(title: StringManager.sectionData),
              GroupedCard(
                children: [
                  SettingsTile(
                    icon: Symbols.category_rounded,
                    title: StringManager.manageCategories,
                    onTap: () => context.push(RoutePaths.categories),
                  ),
                  SettingsTile(
                    icon: Symbols.savings_rounded,
                    title: StringManager.manageBudgets,
                    onTap: () => context.push(RoutePaths.budgets),
                  ),
                  if (smsAvailable ?? Platform.isAndroid)
                    SettingsTile(
                      icon: Symbols.sms_rounded,
                      title: StringManager.smsTitle,
                      value: settings.smsEnabled ? StringManager.smsOn : StringManager.smsOff,
                      onTap: () => context.push(RoutePaths.smsImport),
                    ),
                  SettingsTile(
                    icon: Symbols.table_view_rounded,
                    title: StringManager.exportCsv,
                    onTap: busy ? null : () => _exportCsv(context),
                  ),
                  SettingsTile(
                    icon: Symbols.archive_rounded,
                    title: StringManager.exportBackup,
                    onTap: busy ? null : () => unawaited(context.read<DataManagementCubit>().exportBackup()),
                  ),
                  SettingsTile(
                    icon: Symbols.unarchive_rounded,
                    title: StringManager.restoreBackup,
                    onTap: busy ? null : () => unawaited(context.read<DataManagementCubit>().pickBackup()),
                  ),
                  SettingsTile(
                    icon: Symbols.delete_forever_rounded,
                    title: StringManager.clearData,
                    destructive: true,
                    onTap: busy ? null : () => _clearAllData(context),
                  ),
                ],
              ),
              SectionHeader(title: StringManager.sectionAbout),
              GroupedCard(
                children: [
                  SettingsTile(icon: Symbols.info_rounded, title: StringManager.appVersion, subtitle: appInfo.label),
                  SettingsTile(
                    icon: Symbols.description_rounded,
                    title: StringManager.licenses,
                    onTap: () => showLicensePage(
                      context: context,
                      applicationName: AppConstants.appName,
                      applicationVersion: appInfo.label,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}
