import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';

part 'recurring_form_state.freezed.dart';

enum RecurringFormStatus { loading, ready, saving, saved, loadFailure }

@freezed
abstract class RecurringFormState with _$RecurringFormState {
  const factory RecurringFormState({
    required LocalDate startDate,

    /// Fraction digits of the app currency (2 for EGP, 3 for KWD).
    required int fractionDigits,
    @Default(RecurringFormStatus.loading) RecurringFormStatus status,

    /// The Expense | Income switch; the category must be of this kind.
    @Default(TransactionKind.expense) TransactionKind kind,

    /// Null for a new template.
    int? id,

    /// As typed: Western or Arabic-Indic digits, `.` or `٫`.
    @Default('') String amountText,

    /// The wallet the template's rows go to.
    int? walletId,
    int? categoryId,
    @Default('') String title,
    @Default(RecurringFrequency.monthly) RecurringFrequency frequency,
    @Default(true) bool isActive,

    /// Every visible category; the picker offers those of [kind].
    @Default(<Category>[]) List<Category> categories,

    /// Every wallet, for the Wallet field.
    @Default(<WalletSummary>[]) List<WalletSummary> wallets,

    /// Field errors, keyed by `amount`, `walletId`, `categoryId`, `title`.
    @Default(<String, ValidationReason>{}) Map<String, ValidationReason> errors,

    /// A load or save failure other than a field error.
    Failure? failure,
  }) = _RecurringFormState;

  const RecurringFormState._();

  bool get isEditing => id != null;

  /// What the picker offers: the categories of the selected [kind].
  List<Category> get pickerCategories => [
    for (final c in categories)
      if (c.kind == kind) c,
  ];

  Category? get category => categories.where((c) => c.id == categoryId).firstOrNull;

  WalletSummary? get wallet => wallets.where((w) => w.wallet.id == walletId).firstOrNull;

  bool get canSave => status == RecurringFormStatus.ready;
}
