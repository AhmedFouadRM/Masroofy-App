import 'package:masroofy/core/domain/money.dart';
import 'package:meta/meta.dart';

/// Money in and out over some period. Both amounts are positive: the kind
/// decides the sign only in [balance].
@immutable
final class PeriodTotals {
  const PeriodTotals({required this.income, required this.spent});

  static const zero = PeriodTotals(income: Money.zero, spent: Money.zero);

  final Money income;
  final Money spent;

  Money get balance => income - spent;

  /// Balance ÷ income as a fraction (0.25 = saved a quarter); null when
  /// there was no income to save from.
  double? get savingsRate => income.isPositive ? balance.minor / income.minor : null;

  @override
  bool operator ==(Object other) => other is PeriodTotals && other.income == income && other.spent == spent;

  @override
  int get hashCode => Object.hash(income, spent);

  @override
  String toString() => 'PeriodTotals(income: $income, spent: $spent)';
}
