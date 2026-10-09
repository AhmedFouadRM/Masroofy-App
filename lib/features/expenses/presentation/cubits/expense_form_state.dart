import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/domain/entities/category.dart';
import 'package:masroofy/features/wallets/domain/entities/wallet_summary.dart';

part 'expense_form_state.freezed.dart';

enum ExpenseFormStatus { loading, ready, saving, saved, loadFailure }

@freezed
abstract class ExpenseFormState with _$ExpenseFormState {
  const factory ExpenseFormState({
    required LocalDate date,

    /// Fraction digits of the app currency (2 for EGP, 3 for KWD).
    required int fractionDigits,
    @Default(ExpenseFormStatus.loading) ExpenseFormStatus status,

    /// The Expense | Income switch; the category must be of this kind. Kept
    /// while [isTransfer], so switching back finds it as it was.
    @Default(TransactionKind.expense) TransactionKind kind,

    /// The third option of the type control: money moved between two wallets,
    /// with no category and no title.
    @Default(false) bool isTransfer,

    /// Null for a new expense or transfer; otherwise the `expenses` row
    /// being edited (for a transfer, the leg that was opened).
    int? id,

    /// The transfer being edited.
    int? transferId,

    /// The wallet the row belongs to; a transfer's From wallet.
    int? walletId,

    /// A transfer's To wallet.
    int? toWalletId,

    /// As typed: Western or Arabic-Indic digits, `.` or `٫`.
    @Default('') String amountText,
    int? categoryId,
    @Default('') String title,
    @Default('') String note,

    /// Every visible category; the picker offers those of [kind].
    @Default(<Category>[]) List<Category> categories,

    /// Every wallet, for the Wallet, From and To fields.
    @Default(<WalletSummary>[]) List<WalletSummary> wallets,

    /// Field errors, keyed by `amount`, `walletId`, `fromWallet`, `toWallet`,
    /// `categoryId`, `title`, `date`, `note`.
    @Default(<String, ValidationReason>{}) Map<String, ValidationReason> errors,

    /// A load or save failure other than a field error.
    Failure? failure,
  }) = _ExpenseFormState;

  const ExpenseFormState._();

  bool get isEditing => id != null;

  /// What the picker offers: the categories of the selected [kind].
  List<Category> get pickerCategories => [
    for (final c in categories)
      if (c.kind == kind) c,
  ];

  Category? get category => categories.where((c) => c.id == categoryId).firstOrNull;

  WalletSummary? walletById(int? id) => wallets.where((w) => w.wallet.id == id).firstOrNull;

  /// A transfer needs two wallets to move money between.
  bool get needsSecondWallet => isTransfer && wallets.length < 2;

  bool get canSave => status == ExpenseFormStatus.ready && !needsSecondWallet;
}
