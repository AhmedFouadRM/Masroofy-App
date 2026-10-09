import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_draft.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_progress.dart';

abstract interface class IBudgetRepository {
  /// Every budget with its spend in its **own** current window (the week or
  /// month containing [today]; weeks start on [firstWeekday]). Re-emits when
  /// expenses or budgets change.
  Stream<Either<Failure, List<BudgetProgress>>> watchProgress(LocalDate today, {required int firstWeekday});

  Future<Either<Failure, Budget>> getById(int id);

  /// Returns the new id. Fails with a constraint failure if the category
  /// already has a budget.
  Future<Either<Failure, int>> create(BudgetDraft draft);

  /// Changes the limit and period (never the category).
  Future<Either<Failure, Unit>> update(int id, BudgetDraft draft);

  Future<Either<Failure, Unit>> delete(int id);

  /// Records that the exceed alert for the window starting [periodStart] was
  /// shown, so it never shows again for that window.
  Future<Either<Failure, Unit>> markAlerted(int id, LocalDate periodStart);
}
