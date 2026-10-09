import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:meta/meta.dart';

/// A row of the Trusted senders list.
@immutable
final class SmsSenderEntry {
  const SmsSenderEntry({
    required this.key,
    required this.name,
    required this.type,
    required this.trusted,
    required this.addedByUser,
  });

  /// What the answer is stored under (see `SenderCatalog.keyOf`).
  final String key;
  final String name;
  final SmsSenderType type;
  final bool trusted;

  /// A sender the user trusted, rather than a built-in one.
  final bool addedByUser;
}
