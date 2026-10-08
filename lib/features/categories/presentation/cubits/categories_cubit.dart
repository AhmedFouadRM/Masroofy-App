import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/categories/domain/usecases/delete_category.dart';
import 'package:masroofy/features/categories/presentation/cubits/categories_state.dart';

export 'package:masroofy/features/categories/presentation/cubits/categories_state.dart';

/// Manage Categories: a live list split into defaults and custom.
class CategoriesCubit extends Cubit<CategoriesState> {
  CategoriesCubit(this._repository, this._deleteCategory) : super(const CategoriesState());

  final ICategoryRepository _repository;
  final DeleteCategory _deleteCategory;
  StreamSubscription<void>? _subscription;

  /// Starts watching; the list updates after any add, edit or delete.
  void load() {
    unawaited(_subscription?.cancel());
    _subscription = _repository.watchSummaries().listen(
      (result) => result.match(
        (failure) => emit(state.copyWith(status: CategoriesStatus.failure, loadFailure: failure)),
        (summaries) => emit(
          state.copyWith(
            status: CategoriesStatus.loaded,
            defaults: [for (final s in summaries) if (s.category.isDefault) s],
            custom: [for (final s in summaries) if (!s.category.isDefault) s],
            loadFailure: null,
          ),
        ),
      ),
    );
  }

  /// Deletes a custom category after the user confirmed. The watched list
  /// drops it on success; a failure is surfaced through `actionFailure`.
  Future<void> delete(int id) async {
    // Reset first so the same failure twice still reaches the listener.
    if (state.actionFailure != null) emit(state.copyWith(actionFailure: null));
    final result = await _deleteCategory(id);
    if (isClosed) return;
    result.match((failure) => emit(state.copyWith(actionFailure: failure)), (_) {});
  }

  @override
  Future<void> close() async {
    await _subscription?.cancel();
    return super.close();
  }
}
