import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/core/theme/app_colors.dart';
import 'package:masroofy/features/categories/domain/category_icons.dart';
import 'package:masroofy/features/categories/domain/entities/category_draft.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/categories/domain/usecases/delete_category.dart';
import 'package:masroofy/features/categories/domain/usecases/save_category.dart';
import 'package:masroofy/features/categories/presentation/cubits/category_form_state.dart';

export 'package:masroofy/features/categories/presentation/cubits/category_form_state.dart';

/// New / Edit Category. Pass `categoryId` to edit an existing custom category.
class CategoryFormCubit extends Cubit<CategoryFormState> {
  CategoryFormCubit(
    this._repository,
    this._saveCategory,
    this._deleteCategory, {
    int? categoryId,
  }) : super(
         CategoryFormState(
           id: categoryId,
           icon: CategoryIcons.keys.first,
           color: AppColors.categoryPalette.first.toARGB32(),
         ),
       );

  final ICategoryRepository _repository;
  final SaveCategory _saveCategory;
  final DeleteCategory _deleteCategory;

  Future<void> load() async {
    final id = state.id;
    if (id == null) {
      emit(state.copyWith(status: CategoryFormStatus.ready));
      return;
    }
    final result = await _repository.getSummary(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(status: CategoryFormStatus.loadFailure, failure: failure)),
      (summary) {
        final category = summary.category;
        if (category.isDefault) {
          // Default categories are not editable in V1; the UI never routes here.
          emit(
            state.copyWith(
              status: CategoryFormStatus.loadFailure,
              failure: const Failure.constraint(message: 'Default categories are not editable'),
            ),
          );
          return;
        }
        emit(
          state.copyWith(
            status: CategoryFormStatus.ready,
            name: category.name!,
            icon: category.icon,
            color: category.color,
            usage: summary,
          ),
        );
      },
    );
  }

  void nameChanged(String name) => emit(state.copyWith(name: name, nameError: null));

  void iconSelected(String icon) => emit(state.copyWith(icon: icon));

  void colorSelected(int color) => emit(state.copyWith(color: color));

  Future<void> save() async {
    if (!state.canSave) return;
    emit(state.copyWith(status: CategoryFormStatus.saving, nameError: null, failure: null));
    final result = await _saveCategory(
      CategoryDraft(name: state.name, icon: state.icon, color: state.color),
      id: state.id,
    );
    if (isClosed) return;
    result.match(
      (failure) => emit(switch (failure) {
        ValidationFailure(field: 'name', :final reason) => state.copyWith(
          status: CategoryFormStatus.ready,
          nameError: reason,
        ),
        _ => state.copyWith(status: CategoryFormStatus.ready, failure: failure),
      }),
      (id) => emit(state.copyWith(status: CategoryFormStatus.saved, id: id)),
    );
  }

  /// Deletes the category being edited, after the user confirmed.
  Future<void> delete() async {
    final id = state.id;
    if (id == null || state.status != CategoryFormStatus.ready) return;
    emit(state.copyWith(status: CategoryFormStatus.deleting, failure: null));
    final result = await _deleteCategory(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(status: CategoryFormStatus.ready, failure: failure)),
      (_) => emit(state.copyWith(status: CategoryFormStatus.deleted)),
    );
  }
}
