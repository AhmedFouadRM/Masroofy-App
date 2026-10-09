import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/wallets/domain/entities/transfer.dart';

part 'list_entry.freezed.dart';

/// One row of the transaction list: an expense or income, or a transfer
/// between wallets.
@freezed
sealed class ListEntry with _$ListEntry {
  const factory ListEntry.transaction(Expense expense) = TransactionEntry;

  /// A transfer is listed by one of its two rows: [rowId], the leg in
  /// [walletId]. In a single wallet's list that is the wallet's own leg; in
  /// All wallets it is the out leg, so the transfer shows once.
  const factory ListEntry.transfer(Transfer transfer, {required int rowId, required int walletId}) = TransferEntry;

  const ListEntry._();

  /// The `expenses` row this entry is listed by; what edit and delete address.
  int get id => switch (this) {
    TransactionEntry(:final expense) => expense.id,
    TransferEntry(:final rowId) => rowId,
  };

  LocalDate get date => switch (this) {
    TransactionEntry(:final expense) => expense.date,
    TransferEntry(:final transfer) => transfer.date,
  };
}
