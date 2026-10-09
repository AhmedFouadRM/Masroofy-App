import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/utils/currency_utils.dart';
import 'package:masroofy/features/sms_import/domain/merchant_key.dart';

part 'parsed_sms.freezed.dart';

/// What a bank message says happened.
enum SmsKind {
  /// Money out: a purchase, withdrawal, payment or transfer sent.
  expense,

  /// Money in: a credit, deposit, salary, refund or transfer received.
  income,

  /// An earlier purchase was cancelled; it reverses the matching import.
  cancellation;

  /// The kind of transaction this message is about (a cancellation is about
  /// an expense).
  TransactionKind get transactionKind => this == income ? TransactionKind.income : TransactionKind.expense;
}

/// The fields read from one bank SMS. The message body itself is never kept.
@freezed
abstract class ParsedSms with _$ParsedSms {
  const factory ParsedSms({
    required SmsKind kind,
    required Money amount,

    /// ISO 4217 code of the amount, e.g. `EGP`.
    required String currency,

    /// When it happened: the date and time in the text, else the SMS time.
    required DateTime occurredAt,

    /// 0 to 1. At [highConfidence] and above, a real template matched; below
    /// it, a generic pattern did, and the user is always asked.
    required double confidence,

    /// The merchant, or for a transfer the other party; null when the message
    /// has none.
    String? merchant,

    /// Last 4 digits of the card or account.
    String? cardLast4,

    /// The balance after the transaction, in [currency].
    Money? balance,
    String? reference,

    /// The bank's display name, e.g. `EG Bank`.
    String? bankName,

    /// How the money moved when it was not by card, e.g. `InstaPay`.
    String? channel,
  }) = _ParsedSms;

  const ParsedSms._();

  /// Confidence from which an SMS may be recorded without asking.
  static const highConfidence = 0.8;

  LocalDate get date => LocalDate.fromDateTime(occurredAt);

  bool get isConfident => confidence >= highConfidence;

  /// The normalised merchant name the learned category is keyed by.
  String? get merchantKey => MerchantKey.of(merchant);

  /// The transaction note: `EG Bank ••9033`, or `InstaPay · Ref 123`, with
  /// `· Balance EGP 8,320` when the message gives one.
  String get note {
    final parts = <String>[];
    if (channel != null) {
      parts.add(reference == null ? channel! : '$channel · Ref $reference');
    } else {
      final account = cardLast4 == null ? null : '••$cardLast4';
      final bank = [?bankName, ?account].join(' ');
      if (bank.isNotEmpty) parts.add(bank);
      if (reference != null) parts.add('Ref $reference');
    }
    if (balance case final balance?) {
      final unit = CurrencyUtils.byCode(currency);
      final shown = unit == null
          ? '$currency ${balance.toDecimalString(2)}'
          : CurrencyUtils.format(balance, unit, languageCode: 'en');
      parts.add('Balance $shown');
    }
    return parts.join(' · ');
  }
}
