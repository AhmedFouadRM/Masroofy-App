import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/settings/presentation/widgets/settings_tile.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_sender_entry.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/presentation/cubits/sms_import_cubit.dart';
import 'package:masroofy/features/sms_import/presentation/widgets/catch_up_sheet.dart';
import 'package:masroofy/features/sms_import/presentation/widgets/sms_import_row.dart';
import 'package:masroofy/features/sms_import/presentation/widgets/sms_permission_card.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/empty_state_widget.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/grouped_list.dart';
import 'package:masroofy/shared/widgets/icon_dialog.dart';
import 'package:masroofy/shared/widgets/segmented_pills.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Settings → Add from SMS (Android only). Expects an [SmsImportCubit] and the
/// app-wide [SettingsCubit] above it.
class SmsImportScreen extends StatefulWidget {
  const SmsImportScreen({super.key});

  @override
  State<SmsImportScreen> createState() => _SmsImportScreenState();
}

class _SmsImportScreenState extends State<SmsImportScreen> with WidgetsBindingObserver {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  /// Back from the system settings: the permissions may have changed.
  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) unawaited(context.read<SmsImportCubit>().refreshPermissions());
  }

  /// The switch. Turning it on shows the disclosure page first (Google Play
  /// requires it before the permission prompt); only Continue goes on to ask.
  Future<void> _toggle(BuildContext context, {required bool enable}) async {
    final cubit = context.read<SmsImportCubit>();
    if (!enable) {
      await cubit.disable();
      return;
    }
    final accepted = await context.push<bool>(RoutePaths.smsDisclosure);
    if (accepted != true || !context.mounted) return;
    final enabled = await cubit.enable();
    if (!enabled || !context.mounted) return;
    if (await cubit.catchUpDue() && context.mounted) {
      await cubit.markCatchUpOffered();
      if (context.mounted) await _catchUp(context);
    }
  }

  Future<void> _catchUp(BuildContext context) async {
    final cubit = context.read<SmsImportCubit>();
    unawaited(cubit.startCatchUp());
    final added = await showCatchUpSheet(context, cubit);
    cubit.closeCatchUp();
    if (added != null && added > 0 && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(StringManager.smsCatchUpAdded(added, context.count(added)))));
    }
  }

  Future<void> _deleteHistory(BuildContext context) async {
    final cubit = context.read<SmsImportCubit>();
    final confirmed = await showIconConfirmDialog(
      context,
      icon: Symbols.delete_rounded,
      title: StringManager.smsDeleteHistoryTitle,
      message: StringManager.smsDeleteHistoryBody,
      confirmLabel: StringManager.delete,
      destructive: true,
    );
    if (!confirmed || !context.mounted) return;
    if (await cubit.deleteHistory() && context.mounted) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(StringManager.smsHistoryDeleted)));
    }
  }

  void _open(BuildContext context, SmsImport import) {
    switch (import.status) {
      case SmsImportStatus.added when import.expenseId != null:
        unawaited(context.push(RoutePaths.editExpense(import.expenseId!)));
      // Never added (or deleted since): the pre-filled form.
      case SmsImportStatus.added || SmsImportStatus.pending || SmsImportStatus.ignored:
        unawaited(context.push(RoutePaths.newExpenseFromSms(import.id)));
      case SmsImportStatus.cancelled:
        break;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SmsImportCubit, SmsImportState>(
      // Settings shows On / Off from the app-wide settings; keep them in step.
      listenWhen: (previous, current) => previous.enabled != current.enabled,
      listener: (context, _) => context.read<SettingsCubit>().reload(),
      child: AuraBackground(
        child: Scaffold(
          backgroundColor: Colors.transparent,
          extendBodyBehindAppBar: true,
          appBar: GlassAppBar(title: Text(StringManager.smsTitle)),
          body: BlocBuilder<SmsImportCubit, SmsImportState>(
            builder: (context, state) {
              if (state.loading) return const Center(child: CircularProgressIndicator.adaptive());
              return ListView(
                padding: EdgeInsets.fromLTRB(
                  AppSpacing.screen,
                  MediaQuery.paddingOf(context).top + AppSpacing.sm,
                  AppSpacing.screen,
                  MediaQuery.paddingOf(context).bottom + AppSpacing.xl,
                ),
                children: [
                  if (!state.enabled) ...[
                    Text(
                      StringManager.smsIntro,
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.copyWith(color: MasroofyColors.of(context).textSecondary),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                  ],
                  GroupedCard(
                    children: [
                      SettingsTile(
                        icon: Symbols.sms_rounded,
                        title: StringManager.smsSwitch,
                        // The whole row toggles, like a switch list tile.
                        onTap: state.enabling
                            ? null
                            : () => unawaited(_toggle(context, enable: !(state.enabled || state.enabling))),
                        trailing: Switch(
                          value: state.enabled || state.enabling,
                          onChanged: state.enabling ? null : (value) => unawaited(_toggle(context, enable: value)),
                        ),
                      ),
                    ],
                  ),
                  if (state.permissionDenied) ...[
                    const SizedBox(height: AppSpacing.sm),
                    SmsPermissionCard(
                      message: StringManager.smsPermissionDenied,
                      onOpenSettings: () => unawaited(context.read<SmsImportCubit>().openSystemSettings()),
                    ),
                  ],
                  if (!state.enabled)
                    const _PrivacyCaption()
                  else ...[
                    if (state.notificationsBlocked) ...[
                      const SizedBox(height: AppSpacing.sm),
                      SmsPermissionCard(
                        message: StringManager.smsNotificationsDenied,
                        onOpenSettings: () => unawaited(context.read<SmsImportCubit>().openSystemSettings()),
                      ),
                    ],
                    SectionHeader(title: StringManager.smsMode),
                    SegmentedPills(
                      labels: [StringManager.smsModeAsk, StringManager.smsModeAuto],
                      selected: state.mode.index,
                      onSelected: (i) => unawaited(context.read<SmsImportCubit>().setMode(SmsMode.values[i])),
                    ),
                    Padding(
                      padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.sm, AppSpacing.xs, 0),
                      child: Text(
                        state.mode == SmsMode.ask ? StringManager.smsModeAskHelper : StringManager.smsModeAutoHelper,
                        style: Theme.of(
                          context,
                        ).textTheme.bodyMedium!.copyWith(color: MasroofyColors.of(context).textSecondary),
                      ),
                    ),
                    if (state.senders.isNotEmpty) ...[
                      SectionHeader(title: StringManager.smsSenders),
                      GroupedCard(children: [for (final sender in state.senders) _SenderTile(sender: sender)]),
                    ],
                    SectionHeader(title: StringManager.smsRecent),
                    if (state.recent.isEmpty)
                      Card(
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
                          child: EmptyStateWidget(icon: Symbols.sms_rounded, title: StringManager.smsRecentEmpty),
                        ),
                      )
                    else
                      GroupedCard(
                        children: [
                          for (final import in state.recent.take(30))
                            SmsImportRow(
                              import: import,
                              category: state.category(import.categoryId),
                              onTap: import.status == SmsImportStatus.cancelled ? null : () => _open(context, import),
                            ),
                        ],
                      ),
                    const SizedBox(height: AppSpacing.lg),
                    OutlinedButton(
                      onPressed: () => unawaited(_catchUp(context)),
                      child: Text(StringManager.smsScan),
                    ),
                    const SizedBox(height: AppSpacing.sm),
                    TextButton(
                      style: TextButton.styleFrom(foregroundColor: MasroofyColors.of(context).textNegative),
                      onPressed: () => unawaited(_deleteHistory(context)),
                      child: Text(StringManager.smsDeleteHistory),
                    ),
                  ],
                ],
              );
            },
          ),
        ),
      ),
    );
  }
}

/// "Android only · Processed on your phone".
class _PrivacyCaption extends StatelessWidget {
  const _PrivacyCaption();

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Padding(
      padding: const EdgeInsets.fromLTRB(AppSpacing.xs, AppSpacing.md, AppSpacing.xs, 0),
      child: Row(
        children: [
          Icon(Symbols.lock_rounded, size: 16, color: colors.textSecondary),
          const SizedBox(width: 6),
          Expanded(
            child: Text(
              StringManager.smsPrivacy,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(color: colors.textSecondary),
            ),
          ),
        ],
      ),
    );
  }
}

class _SenderTile extends StatelessWidget {
  const _SenderTile({required this.sender});

  final SmsSenderEntry sender;

  static IconData _icon(SmsSenderType type) => switch (type) {
    SmsSenderType.bank => Symbols.account_balance_rounded,
    SmsSenderType.wallet => Symbols.smartphone_rounded,
    SmsSenderType.instant => Symbols.bolt_rounded,
  };

  @override
  Widget build(BuildContext context) {
    return SettingsTile(
      icon: _icon(sender.type),
      title: sender.name,
      subtitle: sender.addedByUser ? StringManager.smsTrustedByYou : null,
      trailing: Switch(
        value: sender.trusted,
        onChanged: (value) => unawaited(context.read<SmsImportCubit>().setSenderTrusted(sender, trusted: value)),
      ),
      // A name from a message, not a translation: keep its own direction.
      key: ValueKey(sender.key),
    );
  }
}
