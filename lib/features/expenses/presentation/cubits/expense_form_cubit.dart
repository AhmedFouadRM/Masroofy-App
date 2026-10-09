import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/repositories/i_category_repository.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/entities/list_entry.dart';
import 'package:masroofy/features/expenses/domain/repositories/i_expense_repository.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';
import 'package:masroofy/features/expenses/presentation/cubits/expense_form_state.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/usecases/sms_import_actions.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer_draft.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';
import 'package:masroofy/features/wallets/domain/repositories/i_wallet_repository.dart';
import 'package:masroofy/features/wallets/domain/usecases/save_transfer.dart';
import 'package:masroofy/features/wallets/domain/wallet_preselect.dart';

export 'package:masroofy/features/expenses/presentation/cubits/expense_form_state.dart';

/// Add / Edit Expense, Income or Transfer. Pass `expenseId` to edit. A new row
/// starts in the wallet given to [walletSelected] before [load] (the one being
/// viewed, or the default wallet when viewing All wallets), or in the first
/// wallet. [fromSms] before [load] pre-fills a new row from an SMS import.
class ExpenseFormCubit extends Cubit<ExpenseFormState> {
  ExpenseFormCubit(
    this._expenses,
    this._categories,
    this._wallets,
    this._saveExpense,
    this._saveTransfer, {
    required int fractionDigits,
    int? expenseId,
    LocalDate Function()? today,
    this._smsImports,
    this._smsActions,
  }) : _today = today ?? LocalDate.today,
       super(
         ExpenseFormState(
           id: expenseId,
           date: (today ?? LocalDate.today)(),
           fractionDigits: fractionDigits,
         ),
       );

  final IExpenseRepository _expenses;
  final ICategoryRepository _categories;
  final IWalletRepository _wallets;
  final SaveExpense _saveExpense;
  final SaveTransfer _saveTransfer;
  final LocalDate Function() _today;
  final ISmsImportRepository? _smsImports;
  final SmsImportActions? _smsActions;
  StreamSubscription<void>? _categoriesSub;
  StreamSubscription<void>? _walletsSub;

  /// Makes this a new row pre-filled from the SMS import [importId]; call
  /// before [load]. Saving it completes the import and teaches the merchant's
  /// category.
  void fromSms(int importId) => emit(state.copyWith(smsImportId: importId));

  Future<void> load() async {
    _categoriesSub = _categories.watchAll().listen(
      (result) => result.match(
        (failure) => emit(state.copyWith(status: ExpenseFormStatus.loadFailure, failure: failure)),
        (categories) => emit(state.copyWith(categories: categories)),
      ),
    );
    _walletsSub = _wallets
        .watchSummaries(DateRange.monthToDate(_today()))
        .listen(
          (result) => result.match(
            (failure) => emit(state.copyWith(status: ExpenseFormStatus.loadFailure, failure: failure)),
            _onWallets,
          ),
        );
    final id = state.id;
    if (id == null) {
      await _prefillFromSms();
      if (isClosed) return;
      emit(state.copyWith(status: ExpenseFormStatus.ready));
      return;
    }
    final result = await _expenses.getEntry(id);
    if (isClosed) return;
    result.match(
      (failure) => emit(state.copyWith(status: ExpenseFormStatus.loadFailure, failure: failure)),
      (entry) => emit(switch (entry) {
        TransactionEntry(:final expense) => state.copyWith(
          status: ExpenseFormStatus.ready,
          kind: expense.kind,
          amountText: expense.amount.toDecimalString(state.fractionDigits),
          walletId: expense.walletId,
          categoryId: expense.categoryId,
          date: expense.date,
          title: expense.title ?? '',
          note: expense.note ?? '',
        ),
        TransferEntry(:final transfer) => state.copyWith(
          status: ExpenseFormStatus.ready,
          isTransfer: true,
          transferId: transfer.id,
          amountText: transfer.amount.toDecimalString(state.fractionDigits),
          walletId: transfer.fromWalletId,
          toWalletId: transfer.toWalletId,
          date: transfer.date,
          note: transfer.note ?? '',
        ),
      }),
    );
  }

  /// Fills type, amount, category, title, date and note from the SMS import,
  /// if there is one. A missing import leaves the form blank.
  String _amountText(Money amount) {
    final text = amount.toDecimalString(state.fractionDigits);
    return RegExp(r'\.0+$').hasMatch(text) ? text.substring(0, text.indexOf('.')) : text;
  }

  Future<void> _prefillFromSms() async {
    final importId = state.smsImportId;
    final imports = _smsImports;
    if (importId == null || imports == null) return;
    final import = (await imports.getById(importId)).toNullable();
    if (import == null || isClosed) return;
    emit(
      state.copyWith(
        kind: import.kind,
        // Whole amounts as typed ("200", not "200.00"), as in the SMS.
        amountText: _amountText(import.amount),
        categoryId: import.categoryId,
        title: import.merchant ?? '',
        note: import.note ?? '',
        date: import.date.isAfter(_today()) ? _today() : import.date,
        smsImportId: importId,
        smsBank: SenderCatalog.displayName(import.sender),
      ),
    );
  }

  /// Settles a new row's wallet once the wallets are known (the preset one if
  /// it exists, else the first); with exactly two wallets a transfer's To
  /// wallet is the other one.
  void _onWallets(List<WalletSummary> wallets) {
    final ids = [for (final w in wallets) w.wallet.id];
    final walletId = state.isEditing ? state.walletId : WalletPreselect.validated(state.walletId, ids);
    final toWalletId = state.toWalletId ?? (ids.length == 2 ? ids.where((id) => id != walletId).first : null);
    emit(state.copyWith(wallets: wallets, walletId: walletId, toWalletId: toWalletId));
  }

  /// Switches Expense | Income (and back from Transfer). A category of the
  /// other kind is cleared, so Save asks for a new one.
  void kindSelected(TransactionKind kind) {
    if (kind == state.kind && !state.isTransfer) return;
    final keep = state.category?.kind == kind;
    emit(
      state.copyWith(
        kind: kind,
        isTransfer: false,
        categoryId: keep ? state.categoryId : null,
        errors: _without('categoryId'),
      ),
    );
  }

  /// The third option of the type control. Only a new row can become a transfer.
  void transferSelected() {
    if (state.isTransfer || state.isEditing) return;
    emit(state.copyWith(isTransfer: true, errors: const {}));
  }

  void amountChanged(String text) => emit(state.copyWith(amountText: text, errors: _without('amount')));

  /// The wallet of an expense or income, or a transfer's From wallet. Picking
  /// the To wallet as From swaps the two.
  void walletSelected(int id) {
    final swap = state.isTransfer && id == state.toWalletId;
    emit(
      state.copyWith(
        walletId: id,
        toWalletId: swap ? state.walletId : state.toWalletId,
        errors: _without('walletId')
          ..remove('fromWallet')
          ..remove('toWallet'),
      ),
    );
  }

  /// A transfer's To wallet. Picking the From wallet as To swaps the two.
  void toWalletSelected(int id) {
    final swap = id == state.walletId;
    emit(
      state.copyWith(
        toWalletId: id,
        walletId: swap ? state.toWalletId : state.walletId,
        errors: _without('toWallet')..remove('fromWallet'),
      ),
    );
  }

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
    final walletId = state.walletId;
    final toWalletId = state.toWalletId;
    final categoryId = state.categoryId;
    if (state.isTransfer) {
      if (walletId == null) errors['fromWallet'] = ValidationReason.required;
      if (toWalletId == null) errors['toWallet'] = ValidationReason.required;
    } else {
      if (walletId == null) errors['walletId'] = ValidationReason.required;
      if (categoryId == null) {
        errors['categoryId'] = ValidationReason.required;
      } else if (state.category case final category? when category.kind != state.kind) {
        errors['categoryId'] = ValidationReason.wrongKind;
      }
    }
    if (errors.isNotEmpty) {
      emit(state.copyWith(errors: errors));
      return;
    }

    emit(state.copyWith(status: ExpenseFormStatus.saving, errors: const {}, failure: null));
    final result = state.isTransfer
        ? await _saveTransfer(
            TransferDraft(
              fromWalletId: walletId!,
              toWalletId: toWalletId!,
              amount: amount!,
              date: state.date,
              note: state.note,
            ),
            id: state.transferId,
          )
        : await _saveExpense(
            ExpenseDraft(
              amount: amount!,
              walletId: walletId!,
              categoryId: categoryId!,
              date: state.date,
              title: state.title,
              note: state.note,
              kind: state.kind,
              source: state.smsImportId != null ? ExpenseSource.sms : ExpenseSource.manual,
            ),
            id: state.id,
          );
    if (isClosed) return;
    // The transaction of an SMS is saved: the import is done, and the merchant
    // keeps the category the user ended up with.
    if (!state.isTransfer && !state.isEditing && state.smsImportId != null) {
      if (result case Right(:final value)) {
        await _smsActions?.complete(state.smsImportId!, expenseId: value, categoryId: categoryId!);
      }
    }
    result.match(
      (failure) => emit(switch (failure) {
        ValidationFailure(:final field, :final reason) => state.copyWith(
          status: ExpenseFormStatus.ready,
          errors: {field: reason},
        ),
        _ => state.copyWith(status: ExpenseFormStatus.ready, failure: failure),
      }),
      (id) => emit(state.copyWith(status: ExpenseFormStatus.saved, id: state.id ?? id)),
    );
  }

  @override
  Future<void> close() async {
    await _categoriesSub?.cancel();
    await _walletsSub?.cancel();
    return super.close();
  }
}
