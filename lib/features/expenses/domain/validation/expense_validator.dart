import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';

/// Field rules from the Expenses PRD → Validation Rules.
abstract final class ExpenseValidator {
  /// Returns the first failing rule, or `null` when [expense] is valid.
  /// [today] is the device-local date (injectable for tests).
  static ValidationFailure? validate(Expense expense, {required LocalDate today}) {
    final title = expense.title;
    if (title != null) {
      final trimmed = title.trim();
      if (trimmed.isEmpty) {
        return const ValidationFailure(field: 'title', reason: ValidationReason.required);
      }
      if (trimmed.length > AppConstants.maxTitleLength) {
        return const ValidationFailure(field: 'title', reason: ValidationReason.tooLong);
      }
    }
    if (!expense.amount.isPositive) {
      return const ValidationFailure(field: 'amount', reason: ValidationReason.mustBePositive);
    }
    if (expense.categoryId <= 0) {
      return const ValidationFailure(field: 'categoryId', reason: ValidationReason.required);
    }
    if (expense.date.isAfter(today)) {
      return const ValidationFailure(field: 'date', reason: ValidationReason.inFuture);
    }
    final note = expense.note;
    if (note != null && note.length > AppConstants.maxNoteLength) {
      return const ValidationFailure(field: 'note', reason: ValidationReason.tooLong);
    }
    return null;
  }
}
