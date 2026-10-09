import 'package:flutter/material.dart';
import 'package:masroofy/core/strings/string_manager.dart';
import 'package:masroofy/core/theme/app_dimensions.dart';
import 'package:masroofy/core/theme/masroofy_colors.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/shared/formatting/display_format.dart';
import 'package:masroofy/shared/wallets/wallet_avatar.dart';
import 'package:masroofy/shared/wallets/wallet_display.dart';
import 'package:masroofy/shared/wallets/wallet_sheet.dart';
import 'package:masroofy/shared/widgets/select_field.dart';

/// What the user chose in the delete dialog: where the wallet's transactions
/// and templates move to (null when it has none), and which wallet becomes
/// the default when the default one is deleted (null otherwise).
typedef DeleteWalletChoice = ({int? moveTo, int? newDefault});

/// Asks before deleting a wallet: where its transactions move to, and, for
/// the default wallet, which wallet becomes the default. [others] are the
/// wallets that stay. Resolves to the choice, or null when cancelled.
Future<DeleteWalletChoice?> showDeleteWalletDialog(
  BuildContext context, {
  required WalletSummary summary,
  required List<WalletSummary> others,
  required int? defaultWalletId,
}) => showDialog<DeleteWalletChoice>(
  context: context,
  builder: (context) => _DeleteWalletDialog(summary: summary, others: others, defaultWalletId: defaultWalletId),
);

class _DeleteWalletDialog extends StatefulWidget {
  const _DeleteWalletDialog({required this.summary, required this.others, required this.defaultWalletId});

  final WalletSummary summary;
  final List<WalletSummary> others;
  final int? defaultWalletId;

  @override
  State<_DeleteWalletDialog> createState() => _DeleteWalletDialogState();
}

class _DeleteWalletDialogState extends State<_DeleteWalletDialog> {
  late int _moveTo;
  late int _newDefault;

  bool get _isDefault => widget.summary.wallet.id == widget.defaultWalletId;

  @override
  void initState() {
    super.initState();
    // Move to the default wallet when it stays, else to the first one.
    final stays = widget.others.where((w) => w.wallet.id == widget.defaultWalletId).firstOrNull;
    _moveTo = (stays ?? widget.others.first).wallet.id;
    _newDefault = _moveTo;
  }

  Future<void> _pick({required int selectedId, required ValueChanged<int> onChosen}) async {
    final choice = await showWalletSheet(
      context,
      title: StringManager.chooseWallet,
      wallets: widget.others,
      selectedId: selectedId,
      defaultId: widget.defaultWalletId,
    );
    if (choice?.walletId case final id?) onChosen(id);
  }

  Widget _field({required String label, required int walletId, required ValueChanged<int> onChosen}) {
    final wallet = widget.others.firstWhere((w) => w.wallet.id == walletId).wallet;
    return SelectField(
      label: label,
      value: wallet.displayName,
      leading: WalletAvatar(icon: wallet.icon, color: wallet.color, size: 28),
      onTap: () => _pick(selectedId: walletId, onChosen: (id) => setState(() => onChosen(id))),
    );
  }

  @override
  Widget build(BuildContext context) {
    final colors = MasroofyColors.of(context);
    final summary = widget.summary;
    return AlertDialog(
      title: Text(StringManager.deleteWalletTitle(summary.wallet.displayName)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              StringManager.deleteWalletBody(
                transactions: summary.transactionCount,
                transactionsNumber: context.count(summary.transactionCount),
                templates: summary.templateCount,
                templatesNumber: context.count(summary.templateCount),
                hasTransfers: summary.transferCount > 0,
              ),
            ),
            if (summary.isInUse) ...[
              const SizedBox(height: AppSpacing.lg),
              _field(
                label: StringManager.walletMoveTo,
                walletId: _moveTo,
                onChosen: (id) => _moveTo = id,
              ),
            ],
            if (_isDefault) ...[
              const SizedBox(height: AppSpacing.lg),
              Text(StringManager.walletDeleteDefault, style: Theme.of(context).textTheme.bodyMedium),
              const SizedBox(height: AppSpacing.md),
              _field(
                label: StringManager.walletNewDefault,
                walletId: _newDefault,
                onChosen: (id) => _newDefault = id,
              ),
            ],
          ],
        ),
      ),
      actions: [
        TextButton(onPressed: () => Navigator.pop(context), child: Text(StringManager.cancel)),
        FilledButton(
          style: FilledButton.styleFrom(backgroundColor: colors.negative, foregroundColor: colors.onPrimary),
          onPressed: () => Navigator.pop(
            context,
            (moveTo: summary.isInUse ? _moveTo : null, newDefault: _isDefault ? _newDefault : null),
          ),
          child: Text(StringManager.delete),
        ),
      ],
    );
  }
}
