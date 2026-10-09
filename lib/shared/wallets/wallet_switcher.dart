import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/wallets/wallet_display.dart';
import 'package:masroofy/shared/wallets/wallet_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';

/// An app bar title that names the viewed wallet (or All wallets) with a
/// caret and opens the wallet sheet. The choice is stored in [SettingsCubit],
/// so every tab that shows wallet data follows it. Falls back to
/// [fallbackTitle] until the wallets load.
class WalletSwitcher extends StatelessWidget {
  const WalletSwitcher({required this.wallets, required this.fallbackTitle, super.key});

  /// Every wallet with its balance this month, for the sheet.
  final List<WalletSummary> wallets;
  final String fallbackTitle;

  Future<void> _switch(BuildContext context, int? viewedId) async {
    final settings = context.read<SettingsCubit>();
    final choice = await showWalletSheet(
      context,
      title: StringManager.walletsTitle,
      wallets: wallets,
      selectedId: viewedId,
      defaultId: settings.state.defaultWalletId,
      includeAll: true,
    );
    if (choice == null) return;
    unawaited(settings.setViewedWallet(choice.walletId));
  }

  @override
  Widget build(BuildContext context) {
    final viewedId = context.select<SettingsCubit, int?>((cubit) => cubit.state.viewedWalletId);
    if (wallets.isEmpty) return Text(fallbackTitle);
    final colors = MasroofyColors.of(context);
    final wallet = wallets.where((summary) => summary.wallet.id == viewedId).firstOrNull?.wallet;
    final name = wallet?.displayName ?? StringManager.allWallets;
    return Semantics(
      button: true,
      label: StringManager.walletSwitcherSemantics(name),
      excludeSemantics: true,
      child: InkWell(
        onTap: () => _switch(context, viewedId),
        borderRadius: BorderRadius.circular(AppRadius.full),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.sm, vertical: AppSpacing.xs),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: Text(name, textDirection: wallet?.nameDirection, maxLines: 1, overflow: TextOverflow.ellipsis),
              ),
              const SizedBox(width: AppSpacing.xs),
              Icon(Symbols.expand_more_rounded, color: colors.textSecondary),
            ],
          ),
        ),
      ),
    );
  }
}
