import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/domain/validation/expense_validator.dart';

/// Validates and creates (no `id`) or updates an expense. Title and note are
/// trimmed, and an empty one is stored as null.
class SaveExpense {
  SaveExpense(this._repository, {LocalDate Function()? today}) : _today = today ?? LocalDate.today;

  final IExpenseRepository _repository;
  final LocalDate Function() _today;

  /// Returns the expense id.
  Future<Either<Failure, int>> call(ExpenseDraft draft, {int? id}) async {
    final cleaned = draft.copyWith(title: _clean(draft.title), note: _clean(draft.note));
    final failure = ExpenseValidator.validate(cleaned, today: _today());
    if (failure != null) return Left(failure);
    if (id == null) return _repository.create(cleaned);
    return (await _repository.update(id, cleaned)).map((_) => id);
  }

  static String? _clean(String? text) {
    final trimmed = text?.trim();
    return trimmed == null || trimmed.isEmpty ? null : trimmed;
  }
}
