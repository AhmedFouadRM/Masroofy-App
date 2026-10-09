import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:meta/meta.dart';

/// One transaction (expense, income or transfer) as the CSV export needs it,
/// with its category's and wallet's name parts (a default category or wallet is
/// named from the translation files by its seed key; a custom one has its own
/// name). A transfer is one row, listed by its out leg.
@immutable
final class ExpenseExportRow {
  const ExpenseExportRow({
    required this.date,
    required this.amount,
    required this.isRecurring,
    this.kind = TransactionKind.expense,
    this.isTransfer = false,
    this.title,
    this.categorySeedKey,
    this.categoryName,
    this.walletSeedKey,
    this.walletName,
    this.toWalletSeedKey,
    this.toWalletName,
    this.note,
  });

  final LocalDate date;
  final Money amount;

  /// `expense` or `income`: the kind of its category. The amount stays positive.
  /// Ignored for a transfer.
  final TransactionKind kind;

  /// Money moved between two wallets: no category, and a [toWalletName].
  final bool isTransfer;
  final String? title;
  final String? categorySeedKey;
  final String? categoryName;

  /// The row's wallet; a transfer's source wallet.
  final String? walletSeedKey;
  final String? walletName;

  /// A transfer's target wallet.
  final String? toWalletSeedKey;
  final String? toWalletName;
  final String? note;

  /// Generated from a recurring template.
  final bool isRecurring;
}
