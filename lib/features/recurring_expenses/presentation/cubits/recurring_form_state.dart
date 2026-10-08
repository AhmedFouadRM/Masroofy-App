import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';

part 'recurring_form_state.freezed.dart';

enum RecurringFormStatus { loading, ready, saving, saved, loadFailure }

@freezed
abstract class RecurringFormState with _$RecurringFormState {
  const factory RecurringFormState({
    required LocalDate startDate,

    /// Fraction digits of the app currency (2 for EGP, 3 for KWD).
    required int fractionDigits,
    @Default(RecurringFormStatus.loading) RecurringFormStatus status,

    /// Null for a new template.
    int? id,

    /// As typed: Western or Arabic-Indic digits, `.` or `٫`.
    @Default('') String amountText,
    int? categoryId,
    @Default('') String title,
    @Default(RecurringFrequency.monthly) RecurringFrequency frequency,
    @Default(true) bool isActive,

    /// Categories offered by the picker (hidden ones left out).
    @Default(<Category>[]) List<Category> categories,

    /// Field errors, keyed by `amount`, `categoryId`, `title`.
    @Default(<String, ValidationReason>{}) Map<String, ValidationReason> errors,

    /// A load or save failure other than a field error.
    Failure? failure,
  }) = _RecurringFormState;

  const RecurringFormState._();

  bool get isEditing => id != null;

  Category? get category => categories.where((c) => c.id == categoryId).firstOrNull;

  bool get canSave => status == RecurringFormStatus.ready;
}
