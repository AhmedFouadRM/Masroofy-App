import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_draft.dart';
import 'package:masroofy/features/budgets/domain/entities/budget_period.dart';
import 'package:masroofy/features/budgets/domain/repositories/i_budget_repository.dart';
import 'package:masroofy/features/budgets/domain/usecases/save_budget.dart';
import 'package:masroofy/features/budgets/presentation/cubits/budget_form_state.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';

export 'package:masroofy/features/budgets/presentation/cubits/budget_form_state.dart';

/// Add / Edit Budget. Pass `budgetId` to edit (the category is then fixed).
class BudgetFormCubit extends Cubit<BudgetFormState> {
  BudgetFormCubit(this._budgets, this._categories, this._saveBudget, {required int fractionDigits, int? budgetId})
    : super(BudgetFormState(id: budgetId, fractionDigits: fractionDigits));

  final IBudgetRepository _budgets;
  final ICategoryRepository _categories;
  final SaveBudget _saveBudget;
  final _subscriptions = <StreamSubscription<void>>[];

  Future<void> load() async {
    _subscriptions
      ..add(
        _categories.watchAll().listen(
          (result) => result.match(
            _onLoadFailure,
            // Budgets limit spending, so income categories are never offered.
            (categories) => emit(
              state.copyWith(
                categories: [
                  for (final c in categories)
                    if (c.kind == TransactionKind.expense) c,
                ],
              ),
            ),
          ),
        ),
      )
      ..add(
        // Only the ids matter, so any week start will do.
        _budgets
            .watchProgress(LocalDate.today(), firstWeekday: DateTime.monday)
            .listen(
              (result) => result.match(
                _onLoadFailure,
                (budgets) => emit(state.copyWith(budgeted: {for (final b in budgets) b.budget.categoryId})),
              ),
            ),
      );
    final id = state.id;
    if (id == null) {
      emit(state.copyWith(status: BudgetFormStatus.ready));
      return;
    }
    final result = await _budgets.getById(id);
    if (isClosed) return;
    result.match(
      _onLoadFailure,
      (budget) => emit(
        state.copyWith(
          status: BudgetFormStatus.ready,
          categoryId: budget.categoryId,
          limitText: budget.limit.toDecimalString(state.fractionDigits),
          period: budget.period,
        ),
      ),
    );
  }

  void _onLoadFailure(Failure failure) => emit(state.copyWith(status: BudgetFormStatus.loadFailure, failure: failure));

  void categorySelected(int id) => emit(state.copyWith(categoryId: id, errors: _without('categoryId')));

  void limitChanged(String text) => emit(state.copyWith(limitText: text, errors: _without('limit')));

  void periodSelected(BudgetPeriod period) => emit(state.copyWith(period: period));

  Map<String, ValidationReason> _without(String field) => {...state.errors}..remove(field);

  Future<void> save() async {
    if (!state.canSave) return;
    final errors = <String, ValidationReason>{};
    final limit = Money.tryParse(state.limitText, fractionDigits: state.fractionDigits);
    if (state.limitText.trim().isEmpty) {
      errors['limit'] = ValidationReason.required;
    } else if (limit == null) {
      errors['limit'] = ValidationReason.invalidFormat;
    }
    final categoryId = state.categoryId;
    if (categoryId == null) errors['categoryId'] = ValidationReason.required;
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return;
    }

    emit(state.copyWith(status: BudgetFormStatus.saving, errors: const {}, failure: null));
    final result = await _saveBudget(
      BudgetDraft(categoryId: categoryId!, limit: limit!, period: state.period),
      id: state.id,
    );
    if (isClosed) return;
    result.match(
      (failure) => emit(switch (failure) {
        ValidationFailure(:final field, :final reason) => state.copyWith(
          status: BudgetFormStatus.ready,
          errors: {field: reason},
        ),
        _ => state.copyWith(status: BudgetFormStatus.ready, failure: failure),
      }),
      (id) => emit(state.copyWith(status: BudgetFormStatus.saved, id: id)),
    );
  }

  @override
  Future<void> close() async {
    await Future.wait(_subscriptions.map((s) => s.cancel()));
    return super.close();
  }
}
