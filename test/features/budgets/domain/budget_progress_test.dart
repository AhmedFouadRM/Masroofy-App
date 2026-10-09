import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';

void main() {
  final created = DateTime.utc(2026, 10);
  final budget = Budget(
    id: 1,
    categoryId: 1,
    limit: const Money(100000),
    period: BudgetPeriod.monthly,
    createdAt: created,
    updatedAt: created,
  );

  BudgetProgress progress(int spentMinor) => BudgetProgress(
    budget: budget,
    periodStart: LocalDate(2026, 10, 1),
    periodEnd: LocalDate(2026, 10, 31),
    spent: Money(spentMinor),
  );

  test('safe below 80%, warning from 80% up to and including 100%', () {
    expect(progress(79999).status, BudgetStatus.safe);
    expect(progress(80000).status, BudgetStatus.warning);
    expect(progress(100000).status, BudgetStatus.warning);
  });

  test('exceeded only when spent is strictly over the limit', () {
    final over = progress(100001);
    expect(over.status, BudgetStatus.exceeded);
    expect(over.remaining, const Money(-1));
  });

  test('ratio and remaining', () {
    final half = progress(50000);
    expect(half.ratio, 0.5);
    expect(half.remaining, const Money(50000));
  });
}
