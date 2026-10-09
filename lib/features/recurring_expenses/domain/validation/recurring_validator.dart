import 'package:masroofy/core/constants/app_constants.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_draft.dart';

/// Field rules from the Recurring Expenses PRD → Data Model.
abstract final class RecurringValidator {
  /// Returns the first failing rule, or `null` when [draft] is valid.
  static ValidationFailure? validate(RecurringDraft draft) {
    final title = draft.title.trim();
    if (title.isEmpty) {
      return const ValidationFailure(field: 'title', reason: ValidationReason.required);
    }
    if (title.length > AppConstants.maxTitleLength) {
      return const ValidationFailure(field: 'title', reason: ValidationReason.tooLong);
    }
    if (!draft.amount.isPositive) {
      return const ValidationFailure(field: 'amount', reason: ValidationReason.mustBePositive);
    }
    if (draft.walletId <= 0) {
      return const ValidationFailure(field: 'walletId', reason: ValidationReason.required);
    }
    if (draft.categoryId <= 0) {
      return const ValidationFailure(field: 'categoryId', reason: ValidationReason.required);
    }
    return null;
  }
}
