import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_draft.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';
import 'package:masroofy/features/recurring_expenses/domain/recurring_schedule.dart';

abstract interface class IRecurringExpenseRepository {
  /// Every template: active ones first, each group by next due date.
  Stream<Either<Failure, List<RecurringExpense>>> watchAll();

  Future<Either<Failure, RecurringExpense>> getById(int id);

  /// The latest occurrence date generated for template [id], or null.
  Future<Either<Failure, LocalDate?>> lastOccurrence(int id);

  /// Returns the new id.
  Future<Either<Failure, int>> create(RecurringDraft draft, {required LocalDate nextDue});

  Future<Either<Failure, Unit>> update(int id, RecurringDraft draft, {required LocalDate nextDue});

  Future<Either<Failure, Unit>> setActive(int id, {required bool active, required LocalDate nextDue});

  /// Deletes the template. Its generated expenses stay (their template id is
  /// cleared, and `occurrence_date` keeps the recurring badge).
  Future<Either<Failure, Unit>> delete(int id);

  /// In one transaction: for every active template due on or before [today],
  /// inserts the expenses [plan] returns (skipping occurrences that already
  /// exist) and stores its new due date. Returns how many were inserted.
  Future<Either<Failure, int>> generateDue(LocalDate today, RecurringPlan Function(RecurringExpense template) plan);
}
