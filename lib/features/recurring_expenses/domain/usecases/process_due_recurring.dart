import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/recurring_schedule.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';

/// Generates the expenses of every due template (Recurring Expenses PRD →
/// Auto-Generation Algorithm). Runs on launch, on every resume, and after a
/// template is saved. Idempotent: running it twice, or concurrently, never
/// creates a duplicate.
class ProcessDueRecurring {
  ProcessDueRecurring(this._repository, {LocalDate Function()? today}) : _today = today ?? LocalDate.today;

  final IRecurringExpenseRepository _repository;
  final LocalDate Function() _today;

  /// Returns how many expenses were added.
  Future<Either<Failure, int>> call() {
    final today = _today();
    return _repository.generateDue(
      today,
      (template) => RecurringSchedule.plan(
        start: template.startDate,
        frequency: template.frequency,
        nextDue: template.nextDueDate,
        today: today,
      ),
    );
  }
}
