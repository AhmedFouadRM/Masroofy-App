import 'package:crypto/crypto.dart';
import 'package:meta/meta.dart';

/// A message as the phone delivers it.
@immutable
final class RawSms {
  const RawSms({required this.sender, required this.body, required this.receivedAt});

  final String sender;
  final String body;
  final DateTime receivedAt;

  /// Identifies this message, so it is never imported twice: a SHA-256 of the
  /// sender, the SMS time and the body. The body itself is not kept.
  String get key => sha256.convert('$sender\u0000${receivedAt.millisecondsSinceEpoch}\u0000$body'.codeUnits).toString();
}
