import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/features/sms_import/domain/merchant_key.dart';

part 'sms_import.freezed.dart';

/// Where an imported SMS stands.
enum SmsImportStatus {
  /// It became a transaction.
  added,

  /// Waiting for the user (an Ask notification, or a sender to trust).
  pending,

  /// The user said no.
  ignored,

  /// The bank cancelled the purchase.
  cancelled;

  static SmsImportStatus parse(String? name) => values.asNameMap()[name] ?? pending;
}

/// One SMS that SMS Import has handled: its parsed fields and its status.
/// The message body is never kept; [smsKey] is a hash of it.
@freezed
abstract class SmsImport with _$SmsImport {
  const factory SmsImport({
    required int id,
    required String smsKey,

    /// The address the message came from, as received.
    required String sender,
    required DateTime receivedAt,
    required TransactionKind kind,
    required Money amount,
    required String currency,
    required LocalDate date,
    required SmsImportStatus status,
    String? merchant,
    int? categoryId,
    String? cardLast4,
    String? note,

    /// The transaction this import became.
    int? expenseId,
  }) = _SmsImport;

  const SmsImport._();

  bool get isPending => status == SmsImportStatus.pending;

  /// The normalised merchant name the learned category is keyed by.
  String? get merchantKey => MerchantKey.of(merchant);
}

/// A new import row.
@freezed
abstract class SmsImportDraft with _$SmsImportDraft {
  const factory SmsImportDraft({
    required String smsKey,
    required String sender,
    required DateTime receivedAt,
    required TransactionKind kind,
    required Money amount,
    required String currency,
    required LocalDate date,
    @Default(SmsImportStatus.pending) SmsImportStatus status,
    String? merchant,
    int? categoryId,
    String? cardLast4,
    String? note,
    int? expenseId,
  }) = _SmsImportDraft;
}
