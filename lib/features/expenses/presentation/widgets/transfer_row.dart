import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/wallets/wallet_display.dart';
import 'package:material_symbols_icons/symbols.dart';

/// A transfer in the list. In a single wallet's list it reads "To Son" with a
/// minus sign (outgoing) or "From Me" with a plus sign (incoming); in All
/// wallets it shows once, as "Me → Son" with an arrow that mirrors in RTL.
/// Neutral `text/secondary` and a ⇄ icon, never green or red: the sign and
/// the words carry the meaning.
class TransferRow extends StatelessWidget {
  const TransferRow({
    required this.transfer,
    required this.walletId,
    required this.from,
    required this.to,
    this.onTap,
    super.key,
  });

  final Transfer transfer;

  /// The wallet being viewed; null in All wallets.
  final int? walletId;

  /// Null only if the wallet vanished mid-update.
  final Wallet? from;
  final Wallet? to;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final text = Theme.of(context).textTheme;
    final fromName = from?.displayName ?? '';
    final toName = to?.displayName ?? '';
    final amount = context.money(transfer.amount);
    final outgoing = walletId == transfer.fromWalletId;

    // Null in All wallets, where the title is "Me → Son".
    final String? title;
    final String shownAmount;
    final String semantics;
    if (walletId == null) {
      title = null;
      shownAmount = amount;
      semantics = StringManager.transferSemanticsBetween(fromName, toName, amount);
    } else if (outgoing) {
      title = StringManager.transferToName(toName);
      shownAmount = context.signedMoney(-transfer.amount);
      semantics = StringManager.transferSemanticsOut(toName, amount);
    } else {
      title = StringManager.transferFromName(fromName);
      shownAmount = context.signedMoney(transfer.amount);
      semantics = StringManager.transferSemanticsIn(fromName, amount);
    }

    return InkWell(
      onTap: onTap,
      child: Semantics(
        label: semantics,
        excludeSemantics: true,
        button: onTap != null,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.lg, vertical: AppSpacing.md),
          child: Row(
            children: [
              Container(
                width: 40,
                height: 40,
                decoration: BoxDecoration(shape: BoxShape.circle, color: colors.surfaceVariant),
                child: Icon(Symbols.sync_alt_rounded, color: colors.textSecondary, size: 22),
              ),
              const SizedBox(width: AppSpacing.md),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    if (title == null)
                      Row(
                        children: [
                          Flexible(
                            child: Text(
                              fromName,
                              textDirection: from?.nameDirection,
                              style: text.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          const Padding(
                            padding: EdgeInsets.symmetric(horizontal: AppSpacing.sm),
                            // `arrow_forward` mirrors by itself in RTL.
                            child: Icon(Symbols.arrow_forward_rounded, size: 16),
                          ),
                          Flexible(
                            child: Text(
                              toName,
                              textDirection: to?.nameDirection,
                              style: text.bodyLarge,
                              maxLines: 1,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                        ],
                      )
                    else
                      Text(title, style: text.bodyLarge, maxLines: 1, overflow: TextOverflow.ellipsis),
                    if (transfer.note != null)
                      Text(
                        transfer.note!,
                        style: text.bodySmall!.copyWith(color: colors.textSecondary),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                  ],
                ),
              ),
              const SizedBox(width: AppSpacing.md),
              Text(shownAmount, style: text.titleMedium!.copyWith(color: colors.textSecondary)),
            ],
          ),
        ),
      ),
    );
  }
}
