import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_draft.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/save_recurring.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_state.dart';

export 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_state.dart';

/// Add / Edit Recurring Expense. Pass `recurringId` to edit.
class RecurringFormCubit extends Cubit<RecurringFormState> {
  RecurringFormCubit(
    this._recurring,
    this._categories,
    this._saveRecurring, {
    required int fractionDigits,
    int? recurringId,
    LocalDate Function()? today,
  }) : super(
         RecurringFormState(
           id: recurringId,
           startDate: (today ?? LocalDate.today)(),
           fractionDigits: fractionDigits,
         ),
       );

  final IRecurringExpenseRepository _recurring;
  final ICategoryRepository _categories;
  final SaveRecurring _saveRecurring;
  StreamSubscription<void>? _categoriesSub;

  Future<void> load() async {
    _categoriesSub = _categories.watchAll().listen(
      (result) => result.match(
        (failure) => emit(state.copyWith(status: RecurringFormStatus.loadFailure, failure: failure)),
        (categories) => emit(state.copyWith(categories: categories)),
      ),
    );
    final id = state.id;
    if (id == null) {
      emit(state.copyWith(status: RecurringFormStatus.ready));
      return;
    }
    final result = await _recurring.getById(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(status: RecurringFormStatus.loadFailure, failure: failure)),
      (template) => emit(
        state.copyWith(
          status: RecurringFormStatus.ready,
          amountText: template.amount.toDecimalString(state.fractionDigits),
          categoryId: template.categoryId,
          title: template.title,
          frequency: template.frequency,
          startDate: template.startDate,
          isActive: template.isActive,
        ),
      ),
    );
  }

  void amountChanged(String text) => emit(state.copyWith(amountText: text, errors: _without('amount')));

  void categorySelected(int id) => emit(state.copyWith(categoryId: id, errors: _without('categoryId')));

  void titleChanged(String text) => emit(state.copyWith(title: text, errors: _without('title')));

  void frequencySelected(RecurringFrequency frequency) => emit(state.copyWith(frequency: frequency));

  void startDateSelected(LocalDate date) => emit(state.copyWith(startDate: date));

  void activeChanged({required bool active}) => emit(state.copyWith(isActive: active));

  Map<String, ValidationReason> _without(String field) => {...state.errors}..remove(field);

  Future<void> save() async {
    if (!state.canSave) return;
    final errors = <String, ValidationReason>{};
    final amount = Money.tryParse(state.amountText, fractionDigits: state.fractionDigits);
    if (state.amountText.trim().isEmpty) {
      errors['amount'] = ValidationReason.required;
    } else if (amount == null) {
      errors['amount'] = ValidationReason.invalidFormat;
    }
    final categoryId = state.categoryId;
    if (categoryId == null) errors['categoryId'] = ValidationReason.required;
    if (state.title.trim().isEmpty) errors['title'] = ValidationReason.required;
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return;
    }

    emit(state.copyWith(status: RecurringFormStatus.saving, errors: const {}, failure: null));
    final result = await _saveRecurring(
      RecurringDraft(
        title: state.title,
        amount: amount!,
        categoryId: categoryId!,
        frequency: state.frequency,
        startDate: state.startDate,
        isActive: state.isActive,
      ),
      id: state.id,
    );
    if (isClosed) return;
    result.match(
      (failure) => emit(switch (failure) {
        ValidationFailure(:final field, :final reason) => state.copyWith(
          status: RecurringFormStatus.ready,
          errors: {field: reason},
        ),
        _ => state.copyWith(status: RecurringFormStatus.ready, failure: failure),
      }),
      (id) => emit(state.copyWith(status: RecurringFormStatus.saved, id: id)),
    );
  }

  @override
  Future<void> close() async {
    await _categoriesSub?.cancel();
    return super.close();
  }
}
