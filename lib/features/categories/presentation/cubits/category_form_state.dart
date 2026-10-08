import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category_summary.dart';

part 'category_form_state.freezed.dart';

enum CategoryFormStatus { loading, ready, saving, saved, deleting, deleted, loadFailure }

@freezed
abstract class CategoryFormState with _$CategoryFormState {
  const factory CategoryFormState({
    required String icon,
    required int color,
    @Default(CategoryFormStatus.loading) CategoryFormStatus status,

    /// Null for a new category.
    int? id,
    @Default('') String name,

    /// Shown under the name field; cleared as soon as the user types.
    ValidationReason? nameError,

    /// A load, save or delete failure other than a name error.
    Failure? failure,

    /// Usage of the category being edited, for the delete confirmation.
    CategorySummary? usage,
  }) = _CategoryFormState;

  const CategoryFormState._();

  bool get isEditing => id != null;

  bool get canSave => status == CategoryFormStatus.ready && name.trim().isNotEmpty;
}
