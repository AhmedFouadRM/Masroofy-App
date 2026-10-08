import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/recurring_schedule.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/process_due_recurring.dart';

/// Pauses or resumes a template. A paused template generates nothing, and
/// resuming skips the paused period: "paused" means "I didn't pay this".
class SetRecurringActive {
  SetRecurringActive(this._repository, this._processDue, {LocalDate Function()? today})
    : _today = today ?? LocalDate.today;

  final IRecurringExpenseRepository _repository;
  final ProcessDueRecurring _processDue;
  final LocalDate Function() _today;

  Future<Either<Failure, Unit>> call(int id, {required bool active}) async {
    final existing = await _repository.getById(id);
    return existing.match(Left.new, (template) async {
      if (template.isActive == active) return const Right(unit);
      final nextDue = active
          ? RecurringSchedule.resumedDue(template.startDate, template.frequency, template.nextDueDate, today: _today())
          : template.nextDueDate;
      final result = await _repository.setActive(id, active: active, nextDue: nextDue);
      if (active && result.isRight()) await _processDue();
      return result;
    });
  }
}
