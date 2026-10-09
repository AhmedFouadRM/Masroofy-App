import 'package:masroofy/core/domain/money.dart';
import 'package:meta/meta.dart';

/// Money in and out over some period. Both amounts are positive: the kind
/// decides the sign only in [balance]. Transfers between wallets are never
/// part of [income] or [spent]; their net effect on a wallet is [transfersNet].
@immutable
final class PeriodTotals {
  const PeriodTotals({required this.income, required this.spent, this.transfersNet = Money.zero});

  static const zero = PeriodTotals(income: Money.zero, spent: Money.zero);

  final Money income;
  final Money spent;

  /// Transfers in minus transfers out. Zero over all wallets, where every
  /// transfer cancels out; also zero where transfers aren't counted at all.
  final Money transfersNet;

  /// What is left: income and transfers in, minus spending and transfers out.
  Money get balance => income - spent + transfersNet;

  /// Savings ÷ income as a fraction (0.25 = saved a quarter); null when
  /// there was no income to save from. Transfers never count.
  double? get savingsRate => income.isPositive ? (income - spent).minor / income.minor : null;

  @override
  bool operator ==(Object other) =>
      other is PeriodTotals && other.income == income && other.spent == spent && other.transfersNet == transfersNet;

  @override
  int get hashCode => Object.hash(income, spent, transfersNet);

  @override
  String toString() => 'PeriodTotals(income: $income, spent: $spent, transfersNet: $transfersNet)';
}
