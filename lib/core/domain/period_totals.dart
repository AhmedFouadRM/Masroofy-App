import 'package:masroofy/core/domain/money.dart';
import 'package:meta/meta.dart';

/// Money in and out over some period. Both amounts are positive: the kind
/// decides the sign only in [balance]. Transfers between wallets are never
/// part of [income] or [spent]; they are counted apart, as [transfersIn] and
/// [transfersOut], and their net effect on a wallet is [transfersNet].
@immutable
final class PeriodTotals {
  const PeriodTotals({
    required this.income,
    required this.spent,
    this.transfersIn = Money.zero,
    this.transfersOut = Money.zero,
  });

  /// For callers that only know the net of the transfers: a positive net is
  /// all [transfersIn], a negative one all [transfersOut].
  factory PeriodTotals.withTransfersNet({required Money income, required Money spent, required Money transfersNet}) =>
      PeriodTotals(
        income: income,
        spent: spent,
        transfersIn: transfersNet.isPositive ? transfersNet : Money.zero,
        transfersOut: transfersNet.isNegative ? -transfersNet : Money.zero,
      );

  static const zero = PeriodTotals(income: Money.zero, spent: Money.zero);

  final Money income;
  final Money spent;

  /// Money moved into the wallet from other wallets (positive).
  final Money transfersIn;

  /// Money moved out of the wallet to other wallets (positive).
  final Money transfersOut;

  /// Transfers in minus transfers out. Zero over all wallets, where every
  /// transfer cancels out; also zero where transfers aren't counted at all.
  Money get transfersNet => transfersIn - transfersOut;

  /// Any transfer touched the period.
  bool get hasTransfers => transfersIn.isPositive || transfersOut.isPositive;

  /// What is left: income and transfers in, minus spending and transfers out.
  Money get balance => income - spent + transfersNet;

  /// Savings ÷ income as a fraction (0.25 = saved a quarter); null when
  /// there was no income to save from. Transfers never count.
  double? get savingsRate => income.isPositive ? (income - spent).minor / income.minor : null;

  @override
  bool operator ==(Object other) =>
      other is PeriodTotals &&
      other.income == income &&
      other.spent == spent &&
      other.transfersIn == transfersIn &&
      other.transfersOut == transfersOut;

  @override
  int get hashCode => Object.hash(income, spent, transfersIn, transfersOut);

  @override
  String toString() =>
      'PeriodTotals(income: $income, spent: $spent, transfersIn: $transfersIn, transfersOut: $transfersOut)';
}
