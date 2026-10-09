import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:masroofy/app/routes.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/presentation/cubits/wallets_cubit.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/settings/settings_cubit.dart';
import 'package:masroofy/shared/wallets/default_badge.dart';
import 'package:masroofy/shared/wallets/wallet_avatar.dart';
import 'package:masroofy/shared/wallets/wallet_display.dart';
import 'package:masroofy/shared/widgets/aura_background.dart';
import 'package:masroofy/shared/widgets/glass_app_bar.dart';
import 'package:masroofy/shared/widgets/glowing_fab.dart';
import 'package:masroofy/shared/widgets/grouped_list.dart';
import 'package:material_symbols_icons/symbols.dart';

/// Settings → Wallets. Expects a [WalletsCubit] and the app-wide
/// [SettingsCubit] above it.
class WalletsScreen extends StatelessWidget {
  const WalletsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AuraBackground(
      child: Scaffold(
        backgroundColor: Colors.transparent,
        extendBodyBehindAppBar: true,
        appBar: GlassAppBar(title: Text(StringManager.walletsTitle)),
        floatingActionButton: GlowingFab(
          tooltip: StringManager.addWallet,
          onPressed: () => context.push(RoutePaths.newWallet),
        ),
        body: BlocBuilder<WalletsCubit, WalletsState>(
          builder: (context, state) => switch (state.status) {
            WalletsStatus.loading => const Center(child: CircularProgressIndicator.adaptive()),
            WalletsStatus.failure => Center(child: Text(StringManager.failure(state.loadFailure!))),
            WalletsStatus.loaded => _WalletList(wallets: state.wallets),
          },
        ),
      ),
    );
  }
}

class _WalletList extends StatelessWidget {
  const _WalletList({required this.wallets});

  final List<WalletSummary> wallets;

  @override
  Widget build(BuildContext context) {
    final defaultId = context.select<SettingsCubit, int?>((cubit) => cubit.state.defaultWalletId);
    return ListView(
      // Bottom space keeps the last row clear of the FAB.
      padding: EdgeInsets.fromLTRB(AppSpacing.screen, MediaQuery.paddingOf(context).top, AppSpacing.screen, 96),
      children: [
        SectionHeader(title: StringManager.walletsTitle, trailing: context.count(wallets.length)),
        GroupedCard(
          children: [
            for (final summary in wallets) _WalletRow(summary: summary, isDefault: summary.wallet.id == defaultId),
          ],
        ),
      ],
    );
  }
}

class _WalletRow extends StatelessWidget {
  const _WalletRow({required this.summary, required this.isDefault});

  final WalletSummary summary;
  final bool isDefault;

  @override
  Widget build(BuildContext context) {
    final wallet = summary.wallet;
    return ListTile(
      leading: WalletAvatar(icon: wallet.icon, color: wallet.color),
      title: Row(
        children: [
          Flexible(
            child: Text(
              wallet.displayName,
              textDirection: wallet.nameDirection,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
          if (isDefault) ...[const SizedBox(width: AppSpacing.sm), const DefaultBadge()],
        ],
      ),
      subtitle: Text(StringManager.walletBalanceThisMonth(context.signedMoney(summary.balance, plus: false))),
      trailing: Icon(Symbols.chevron_forward_rounded, color: MasroofyColors.of(context).textSecondary),
      onTap: () => context.push(RoutePaths.editWallet(wallet.id)),
    );
  }
}
