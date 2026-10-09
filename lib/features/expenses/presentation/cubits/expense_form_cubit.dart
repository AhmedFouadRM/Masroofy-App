import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_state.dart';

export 'package:masroofy/features/expenses/presentation/cubits/expense_form_state.dart';

/// Add / Edit Expense. Pass `expenseId` to edit.
class ExpenseFormCubit extends Cubit<ExpenseFormState> {
  ExpenseFormCubit(
    this._expenses,
    this._categories,
    this._saveExpense, {
    required int fractionDigits,
    int? expenseId,
    LocalDate Function()? today,
  }) : super(
         ExpenseFormState(
           id: expenseId,
           date: (today ?? LocalDate.today)(),
           fractionDigits: fractionDigits,
         ),
       );

  final IExpenseRepository _expenses;
  final ICategoryRepository _categories;
  final SaveExpense _saveExpense;
  StreamSubscription<void>? _categoriesSub;

  Future<void> load() async {
    _categoriesSub = _categories.watchAll().listen(
      (result) => result.match(
        (failure) => emit(state.copyWith(status: ExpenseFormStatus.loadFailure, failure: failure)),
        (categories) => emit(state.copyWith(categories: categories)),
      ),
    );
    final id = state.id;
    if (id == null) {
      emit(state.copyWith(status: ExpenseFormStatus.ready));
      return;
    }
    final result = await _expenses.getById(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(status: ExpenseFormStatus.loadFailure, failure: failure)),
      (expense) => emit(
        state.copyWith(
          status: ExpenseFormStatus.ready,
          kind: expense.kind,
          amountText: expense.amount.toDecimalString(state.fractionDigits),
          categoryId: expense.categoryId,
          date: expense.date,
          title: expense.title ?? '',
          note: expense.note ?? '',
        ),
      ),
    );
  }

  /// Switches Expense | Income. A category of the other kind is cleared, so
  /// Save asks for a new one.
  void kindSelected(TransactionKind kind) {
    if (kind == state.kind) return;
    final keep = state.category?.kind == kind;
    emit(state.copyWith(kind: kind, categoryId: keep ? state.categoryId : null, errors: _without('categoryId')));
  }

  void amountChanged(String text) => emit(state.copyWith(amountText: text, errors: _without('amount')));

  void categorySelected(int id) => emit(state.copyWith(categoryId: id, errors: _without('categoryId')));

  void titleChanged(String text) => emit(state.copyWith(title: text, errors: _without('title')));

  void dateSelected(LocalDate date) => emit(state.copyWith(date: date, errors: _without('date')));

  void noteChanged(String text) => emit(state.copyWith(note: text, errors: _without('note')));

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
    if (categoryId == null) {
      errors['categoryId'] = ValidationReason.required;
    } else if (state.category case final category? when category.kind != state.kind) {
      errors['categoryId'] = ValidationReason.wrongKind;
    }
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return;
    }

    emit(state.copyWith(status: ExpenseFormStatus.saving, errors: const {}, failure: null));
    final result = await _saveExpense(
      ExpenseDraft(
        amount: amount!,
        categoryId: categoryId!,
        date: state.date,
        title: state.title,
        note: state.note,
        kind: state.kind,
      ),
      id: state.id,
    );
    if (isClosed) return;
    result.match(
      (failure) => emit(switch (failure) {
        ValidationFailure(:final field, :final reason) => state.copyWith(
          status: ExpenseFormStatus.ready,
          errors: {field: reason},
        ),
        _ => state.copyWith(status: ExpenseFormStatus.ready, failure: failure),
      }),
      (id) => emit(state.copyWith(status: ExpenseFormStatus.saved, id: id)),
    );
  }

  @override
  Future<void> close() async {
    await _categoriesSub?.cancel();
    return super.close();
  }
}
