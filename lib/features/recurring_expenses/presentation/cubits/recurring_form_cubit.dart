import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_draft.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/save_recurring.dart';
import 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_state.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/features/wallets/domain/wallet_preselect.dart';

export 'package:masroofy/features/recurring_expenses/presentation/cubits/recurring_form_state.dart';

/// Add / Edit Recurring Expense. Pass `recurringId` to edit. A new template
/// starts in the wallet given to [walletSelected] before [load] (the one being
/// viewed, or the default wallet), or in the first wallet.
class RecurringFormCubit extends Cubit<RecurringFormState> {
  RecurringFormCubit(
    this._recurring,
    this._categories,
    this._wallets,
    this._saveRecurring, {
    required int fractionDigits,
    int? recurringId,
    LocalDate Function()? today,
  }) : _today = today ?? LocalDate.today,
       super(
         RecurringFormState(
           id: recurringId,
           startDate: (today ?? LocalDate.today)(),
           fractionDigits: fractionDigits,
         ),
       );

  final IRecurringExpenseRepository _recurring;
  final ICategoryRepository _categories;
  final IWalletRepository _wallets;
  final SaveRecurring _saveRecurring;
  final LocalDate Function() _today;
  StreamSubscription<void>? _categoriesSub;
  StreamSubscription<void>? _walletsSub;

  Future<void> load() async {
    _categoriesSub = _categories.watchAll().listen(
      (result) => result.match(
        (failure) => emit(state.copyWith(status: RecurringFormStatus.loadFailure, failure: failure)),
        (categories) => emit(state.copyWith(categories: categories)),
      ),
    );
    _walletsSub = _wallets
        .watchSummaries(DateRange.monthToDate(_today()))
        .listen(
          (result) => result.match(
            (failure) => emit(state.copyWith(status: RecurringFormStatus.loadFailure, failure: failure)),
            _onWallets,
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
          kind: template.kind,
          amountText: template.amount.toDecimalString(state.fractionDigits),
          walletId: template.walletId,
          categoryId: template.categoryId,
          title: template.title,
          frequency: template.frequency,
          startDate: template.startDate,
          isActive: template.isActive,
        ),
      ),
    );
  }

  /// Settles a new template's wallet once the wallets are known (the preset
  /// one if it exists, else the first).
  void _onWallets(List<WalletSummary> wallets) {
    final ids = [for (final w in wallets) w.wallet.id];
    emit(
      state.copyWith(
        wallets: wallets,
        walletId: state.isEditing ? state.walletId : WalletPreselect.validated(state.walletId, ids),
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

  void walletSelected(int id) => emit(state.copyWith(walletId: id, errors: _without('walletId')));

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
    final walletId = state.walletId;
    if (walletId == null) errors['walletId'] = ValidationReason.required;
    final categoryId = state.categoryId;
    if (categoryId == null) {
      errors['categoryId'] = ValidationReason.required;
    } else if (state.category case final category? when category.kind != state.kind) {
      errors['categoryId'] = ValidationReason.wrongKind;
    }
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
        walletId: walletId!,
        categoryId: categoryId!,
        frequency: state.frequency,
        startDate: state.startDate,
        isActive: state.isActive,
        kind: state.kind,
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
    await _walletsSub?.cancel();
    return super.close();
  }
}
