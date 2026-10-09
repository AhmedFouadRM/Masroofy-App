import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';

/// The one-shot exceed alert (Budgets PRD → Exceed alert): from a progress
/// snapshot, returns the budgets that are over their limit and haven't been
/// alerted for their current window, and marks them alerted first, so a
/// restart (or a second snapshot) never repeats the alert.
class TakeNewBudgetAlerts {
  TakeNewBudgetAlerts(this._repository);

  final IBudgetRepository _repository;

  /// The budgets to announce, together in one dialog. A budget whose
  /// marker can't be saved is still announced; it may repeat next launch.
  Future<List<BudgetProgress>> call(List<BudgetProgress> snapshot) async {
    final fresh = [
      for (final progress in snapshot)
        if (progress.status == BudgetStatus.exceeded && progress.budget.lastAlertedPeriodStart != progress.periodStart)
          progress,
    ];
    for (final progress in fresh) {
      await _repository.markAlerted(progress.budget.id, progress.periodStart);
    }
    return fresh;
  }
}
