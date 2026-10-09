import 'package:masroofy/features/sms_import/domain/entities/parsed_sms.dart';
import 'package:meta/meta.dart';

/// A transaction found in the inbox, offered in the catch-up review.
@immutable
final class CatchUpCandidate {
  const CatchUpCandidate({
    required this.smsKey,
    required this.sender,
    required this.receivedAt,
    required this.parsed,
    required this.categoryId,
    required this.likelyDuplicate,
  });

  final String smsKey;
  final String sender;
  final DateTime receivedAt;
  final ParsedSms parsed;

  /// The category it would be added under.
  final int categoryId;

  /// A transaction with the same amount, kind and date (±1 day) is already
  /// in the app. Such candidates start unchecked.
  final bool likelyDuplicate;
}
