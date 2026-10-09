import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';

part 'transfer.freezed.dart';

/// Money moved between two wallets. Stored as two linked rows (the out leg in
/// [fromWalletId], the in leg in [toWalletId]); never counted as spending or
/// income.
@freezed
abstract class Transfer with _$Transfer {
  const factory Transfer({
    required int id,
    required int fromWalletId,
    required int toWalletId,
    required Money amount,
    required LocalDate date,
    required DateTime createdAt,
    required DateTime updatedAt,
    String? note,
  }) = _Transfer;
}
