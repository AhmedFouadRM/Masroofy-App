import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';

part 'expense_form_state.freezed.dart';

enum ExpenseFormStatus { loading, ready, saving, saved, loadFailure }

@freezed
abstract class ExpenseFormState with _$ExpenseFormState {
  const factory ExpenseFormState({
    required LocalDate date,

    /// Fraction digits of the app currency (2 for EGP, 3 for KWD).
    required int fractionDigits,
    @Default(ExpenseFormStatus.loading) ExpenseFormStatus status,

    /// Null for a new expense.
    int? id,

    /// As typed: Western or Arabic-Indic digits, `.` or `٫`.
    @Default('') String amountText,
    int? categoryId,
    @Default('') String title,
    @Default('') String note,

    /// Categories offered by the picker (hidden ones left out).
    @Default(<Category>[]) List<Category> categories,

    /// Field errors, keyed by `amount`, `categoryId`, `title`, `date`, `note`.
    @Default(<String, ValidationReason>{}) Map<String, ValidationReason> errors,

    /// A load or save failure other than a field error.
    Failure? failure,
  }) = _ExpenseFormState;

  const ExpenseFormState._();

  bool get isEditing => id != null;

  Category? get category => categories.where((c) => c.id == categoryId).firstOrNull;

  bool get canSave => status == ExpenseFormStatus.ready;
}
