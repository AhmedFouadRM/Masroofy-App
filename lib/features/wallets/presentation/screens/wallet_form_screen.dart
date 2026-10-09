import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_colors.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/wallets/domain/wallet_icons.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallet_form_cubit.dart';
import 'package:masroofy/features/wallets/presentation/widgets/delete_wallet_dialog.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/wallets/wallet_avatar.dart';
import 'package:masroofy/shared/wallets/wallet_display.dart';
import 'package:masroofy/shared/wallets/wallet_icon_registry.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/color_option.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/icon_option.dart';
import 'package:material_symbols_icons/symbols.dart';

/// New / Edit Wallet. Expects a [WalletFormCubit] and the app-wide
/// [SettingsCubit] above it.
class WalletFormScreen extends StatefulWidget {
  const WalletFormScreen({super.key});

  @override
  State<WalletFormScreen> createState() => _WalletFormScreenState();
}

class _WalletFormScreenState extends State<WalletFormScreen> {
  final _name = TextEditingController();

  @override
  void dispose() {
    _name.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WalletFormCubit>();
    return MultiBlocListener(
      listeners: [
        BlocListener<WalletFormCubit, WalletFormState>(
          listenWhen: (previous, current) =>
              previous.status != current.status &&
              (current.status == WalletFormStatus.saved || current.status == WalletFormStatus.deleted),
          listener: (context, state) {
            final settings = context.read<SettingsCubit>();
            final id = state.id;
            if (state.status == WalletFormStatus.saved && id != null && state.makeDefault && !state.wasDefault) {
              unawaited(settings.setDefaultWallet(id));
            }
            // A wallet that no longer exists can't stay the one viewed.
            if (state.status == WalletFormStatus.deleted && settings.state.viewedWalletId == id) {
              unawaited(settings.setViewedWallet(null));
            }
            context.pop();
          },
        ),
        // Fill the field once the edited wallet has loaded: the seeded wallet
        // shows its translated name.
        BlocListener<WalletFormCubit, WalletFormState>(
          listenWhen: (previous, current) =>
              previous.status == WalletFormStatus.loading && current.status == WalletFormStatus.ready,
          listener: (context, state) => _name.text = state.wallet?.displayName ?? state.name,
        ),
        BlocListener<WalletFormCubit, WalletFormState>(
          listenWhen: (previous, current) =>
              current.status != WalletFormStatus.loadFailure &&
              current.failure != null &&
              current.failure != previous.failure,
          listener: (context, state) => ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(StringManager.failure(state.failure!)))),
        ),
      ],
      child: BlocBuilder<WalletFormCubit, WalletFormState>(
        builder: (context, state) => AuraBackground(
          child: Scaffold(
            backgroundColor: Colors.transparent,
            extendBodyBehindAppBar: true,
            appBar: GlassAppBar(
              leading: IconButton(
                icon: const Icon(Symbols.close_rounded),
                tooltip: MaterialLocalizations.of(context).closeButtonTooltip,
                onPressed: () => context.pop(),
              ),
              title: Text(state.isEditing ? StringManager.editWallet : StringManager.newWallet),
              actions: [
                TextButton(onPressed: state.canSave ? cubit.save : null, child: Text(StringManager.save)),
                const SizedBox(width: AppSpacing.sm),
              ],
            ),
            body: switch (state.status) {
              WalletFormStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
              WalletFormStatus.loadFailure => Center(child: Text(StringManager.failure(state.failure!))),
              _ => _Form(state: state, nameController: _name),
            },
          ),
        ),
      ),
    );
  }
}

class _Form extends StatelessWidget {
  const _Form({required this.state, required this.nameController});

  final WalletFormState state;
  final TextEditingController nameController;

  Future<void> _delete(BuildContext context) async {
    final cubit = context.read<WalletFormCubit>();
    final settings = context.read<SettingsCubit>();
    final usage = state.usage;
    if (usage == null) return;
    final choice = await showDeleteWalletDialog(
      context,
      summary: usage,
      others: state.others,
      defaultWalletId: settings.state.defaultWalletId,
    );
    if (choice == null) return;
    // The default moves first, so it never points at a deleted wallet.
    if (choice.newDefault case final id?) await settings.setDefaultWallet(id);
    await cubit.delete(moveTo: choice.moveTo);
  }

  @override
  Widget build(BuildContext context) {
    final cubit = context.read<WalletFormCubit>();
    final text = Theme.of(context).textTheme;
    final colors = MasroofyColors.of(context);
    final busy = state.status == WalletFormStatus.saving || state.status == WalletFormStatus.deleting;
    final typed = state.name.trim();

    return ListView(
      padding: EdgeInsets.fromLTRB(
        AppSpacing.screen,
        MediaQuery.paddingOf(context).top + AppSpacing.sm,
        AppSpacing.screen,
        AppSpacing.xxl,
      ),
      children: [
        // Live preview.
        Card(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.xl),
            child: Column(
              children: [
                WalletAvatar(icon: state.icon, color: state.color, size: 56),
                const SizedBox(height: AppSpacing.md),
                Text(
                  typed.isEmpty ? StringManager.newWallet : typed,
                  style: text.titleMedium,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        TextField(
          controller: nameController,
          enabled: !busy,
          textCapitalization: TextCapitalization.words,
          textInputAction: TextInputAction.done,
          inputFormatters: [LengthLimitingTextInputFormatter(AppConstants.maxWalletNameLength)],
          onChanged: cubit.nameChanged,
          onSubmitted: (_) => cubit.save(),
          decoration: InputDecoration(
            labelText: StringManager.walletNameLabel,
            helperText: StringManager.walletNameHelper(context.count(AppConstants.maxWalletNameLength)),
            errorText: state.nameError == null ? null : StringManager.validation(state.nameError!),
          ),
        ),
        _Heading(StringManager.walletIcon),
        GridView.count(
          // Without it, the grid inherits the top inset meant for the page.
          padding: EdgeInsets.zero,
          crossAxisCount: 4,
          mainAxisSpacing: AppSpacing.sm,
          crossAxisSpacing: AppSpacing.sm,
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          children: [
            for (final key in WalletIcons.keys)
              IconOption(
                icon: WalletIconRegistry.of(key),
                selected: key == state.icon,
                accent: Color(state.color),
                onTap: () => cubit.iconSelected(key),
              ),
          ],
        ),
        _Heading(StringManager.walletColour),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final color in AppColors.walletPalette)
              ColorOption(
                color: color,
                selected: color.toARGB32() == state.color,
                onTap: () => cubit.colorSelected(color.toARGB32()),
              ),
          ],
        ),
        if (state.isEditing) ...[
          const SizedBox(height: AppSpacing.xl),
          Card(
            child: SwitchListTile(
              title: Text(StringManager.walletSetDefault),
              subtitle: Text(
                state.wasDefault ? StringManager.walletDefaultLocked : StringManager.walletSetDefaultHelper,
              ),
              // The default can only change by making another wallet the default.
              value: state.makeDefault,
              onChanged: busy || state.wasDefault ? null : (value) => cubit.defaultChanged(value: value),
            ),
          ),
          const SizedBox(height: AppSpacing.xxl),
          OutlinedButton.icon(
            style: OutlinedButton.styleFrom(
              foregroundColor: colors.textNegative,
              side: BorderSide(color: colors.borderError),
            ),
            icon: const Icon(Symbols.delete_rounded),
            label: Text(StringManager.deleteWallet),
            onPressed: busy || !state.canDelete ? null : () => _delete(context),
          ),
          if (!state.canDelete && state.wallets.isNotEmpty)
            Padding(
              padding: const EdgeInsetsDirectional.only(start: AppSpacing.xs, top: AppSpacing.sm),
              child: Text(StringManager.walletLast, style: text.bodySmall!.copyWith(color: colors.textSecondary)),
            ),
        ],
      ],
    );
  }
}

class _Heading extends StatelessWidget {
  const _Heading(this.title);

  final String title;

  @override
  Widget build(BuildContext context) => Padding(
    padding: const EdgeInsetsDirectional.only(top: AppSpacing.xl, bottom: AppSpacing.md),
    child: Text(title, style: Theme.of(context).textTheme.titleMedium),
  );
}
