import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category_summary.dart';

part 'categories_state.freezed.dart';

enum CategoriesStatus { loading, loaded, failure }

@freezed
abstract class CategoriesState with _$CategoriesState {
  const factory CategoriesState({
    @Default(CategoriesStatus.loading) CategoriesStatus status,
    @Default(<CategorySummary>[]) List<CategorySummary> defaults,
    @Default(<CategorySummary>[]) List<CategorySummary> custom,

    /// Why loading failed (`status == failure`).
    Failure? loadFailure,

    /// A failed delete, shown once as a snackbar by a `BlocListener`.
    Failure? actionFailure,
  }) = _CategoriesState;
}
