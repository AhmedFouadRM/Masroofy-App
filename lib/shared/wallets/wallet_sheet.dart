import 'package:flutter/material.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/wallets/default_badge.dart';
import 'package:masroofy/shared/wallets/wallet_avatar.dart';
import 'package:masroofy/shared/wallets/wallet_display.dart';
import 'package:masroofy/shared/widgets/glass_sheet.dart';
import 'package:material_symbols_icons/symbols.dart';

/// What the wallet sheet resolved to. A record, so "All wallets" (a null id)
/// is told apart from a dismissed sheet (a null result).
typedef WalletChoice = ({int? walletId});

/// The glass sheet listing wallets, each with its balance this month, the
/// Default badge and a check mark on the current one. With [includeAll] it
/// starts with **All wallets** (the switcher); without, it is the picker of
/// the forms. Resolves to the choice, or null when dismissed.
Future<WalletChoice?> showWalletSheet(
  BuildContext context, {
  required String title,
  required List<WalletSummary> wallets,
  required int? selectedId,
  required int? defaultId,
  bool includeAll = false,
}) => showGlassSheet<WalletChoice>(
  context,
  title: title,
  builder: (context) => ListView(
    shrinkWrap: true,
    padding: EdgeInsets.zero,
    children: [
      if (includeAll)
        _SheetRow(
          leading: const _AllAvatar(),
          name: StringManager.allWallets,
          balance: Money.sum([for (final w in wallets) w.balance]),
          selected: selectedId == null,
          onTap: () => Navigator.pop(context, (walletId: null)),
        ),
      for (final summary in wallets)
        _SheetRow(
          leading: WalletAvatar(icon: summary.wallet.icon, color: summary.wallet.color),
          name: summary.wallet.displayName,
          nameDirection: summary.wallet.nameDirection,
          balance: summary.balance,
          isDefault: summary.wallet.id == defaultId,
          selected: summary.wallet.id == selectedId,
          onTap: () => Navigator.pop(context, (walletId: summary.wallet.id)),
        ),
    ],
  ),
);

class _AllAvatar extends StatelessWidget {
  const _AllAvatar();

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(shape: BoxShape.circle, color: colors.surfaceVariant),
      child: Icon(Symbols.account_balance_wallet_rounded, color: colors.textPrimary, size: 22),
    );
  }
}

class _SheetRow extends StatelessWidget {
  const _SheetRow({
    required this.leading,
    required this.name,
    required this.balance,
    required this.selected,
    required this.onTap,
    this.nameDirection,
    this.isDefault = false,
  });

  final Widget leading;
  final String name;
  final TextDirection? nameDirection;
  final Money balance;
  final bool isDefault;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    return Semantics(
      selected: selected,
      child: ListTile(
        contentPadding: EdgeInsets.zero,
        leading: leading,
        title: Row(
          children: [
            Flexible(
              child: Text(name, textDirection: nameDirection, maxLines: 1, overflow: TextOverflow.ellipsis),
            ),
            if (isDefault) ...[const SizedBox(width: AppSpacing.sm), const DefaultBadge()],
          ],
        ),
        subtitle: Text(StringManager.walletBalanceThisMonth(context.signedMoney(balance, plus: false))),
        trailing: selected ? Icon(Symbols.check_rounded, color: colors.primary) : null,
        onTap: onTap,
      ),
    );
  }
}
