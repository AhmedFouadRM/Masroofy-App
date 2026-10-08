import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_draft.dart';
import 'package:masroofy/features/recurring_expenses/domain/recurring_schedule.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/process_due_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/validation/recurring_validator.dart';

/// Validates and creates (no `id`) or updates a template, then generates
/// whatever is due right away (PRD → flow step 5).
///
/// Editing the title, amount or category only affects future occurrences.
/// Editing the frequency or start date re-anchors the schedule after the
/// last generated occurrence. Resuming skips the paused period.
class SaveRecurring {
  SaveRecurring(this._repository, this._processDue, {LocalDate Function()? today}) : _today = today ?? LocalDate.today;

  final IRecurringExpenseRepository _repository;
  final ProcessDueRecurring _processDue;
  final LocalDate Function() _today;

  /// Returns the template id.
  Future<Either<Failure, int>> call(RecurringDraft draft, {int? id}) async {
    final cleaned = draft.copyWith(title: draft.title.trim());
    final failure = RecurringValidator.validate(cleaned);
    if (failure != null) return Left(failure);

    final saved = id == null
        ? await _repository.create(cleaned, nextDue: cleaned.startDate)
        : await _update(id, cleaned);
    // A failed generation is retried on the next resume; the save stands.
    if (saved.isRight()) await _processDue();
    return saved;
  }

  Future<Either<Failure, int>> _update(int id, RecurringDraft draft) async {
    final existing = await _repository.getById(id);
    return existing.match(Left.new, (template) async {
      var nextDue = template.nextDueDate;
      if (draft.frequency != template.frequency || draft.startDate != template.startDate) {
        final last = await _repository.lastOccurrence(id);
        if (last case Left(:final value)) return Left(value);
        nextDue = switch (last.getOrElse((_) => null)) {
          final date? => RecurringSchedule.firstAfter(draft.startDate, draft.frequency, date),
          null => draft.startDate,
        };
      }
      if (draft.isActive && !template.isActive) {
        nextDue = RecurringSchedule.resumedDue(draft.startDate, draft.frequency, nextDue, today: _today());
      }
      return (await _repository.update(id, draft, nextDue: nextDue)).map((_) => id);
    });
  }
}
