import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';

/// Why a message was dropped.
enum SmsIgnoreReason {
  /// SMS Import is off.
  disabled,

  /// An OTP, a declined or promotional message, or not a bank message at all.
  notTransaction,

  /// This exact message was already handled.
  duplicate,

  /// The sender is one the user turned off.
  untrusted,

  /// A cancellation with no purchase to match.
  noMatch,
}

/// What `HandleIncomingSms` decided; the caller shows the matching
/// notification.
sealed class SmsOutcome {
  const SmsOutcome();
}

final class SmsIgnored extends SmsOutcome {
  const SmsIgnored(this.reason);

  final SmsIgnoreReason reason;
}

/// Saved to the default wallet; nothing to show.
final class SmsRecorded extends SmsOutcome {
  const SmsRecorded(this.import);

  final SmsImport import;
}

/// Waiting for the user: post the Add / Ignore notification.
final class SmsNeedsReview extends SmsOutcome {
  const SmsNeedsReview(this.import, {required this.otherCurrency});

  final SmsImport import;

  /// The message is in a currency other than the app's.
  final bool otherCurrency;
}

/// The purchase of [import] was cancelled and it is no longer pending or
/// added: dismiss its notification. [removedExpense] says a transaction was
/// deleted with it.
final class SmsImportCancelled extends SmsOutcome {
  const SmsImportCancelled(this.import, {required this.removedExpense});

  final SmsImport import;
  final bool removedExpense;
}

/// The purchase of [import] was cancelled in Ask mode: post the Remove / Keep
/// notification.
final class SmsCancellationAsk extends SmsOutcome {
  const SmsCancellationAsk(this.import);

  final SmsImport import;
}

/// A bank-like message from a sender we don't know: post the Trust / Ignore
/// notification. [import] is the message, waiting for the answer.
final class SmsTrustPrompt extends SmsOutcome {
  const SmsTrustPrompt(this.sender, this.import);

  final String sender;
  final SmsImport import;
}
