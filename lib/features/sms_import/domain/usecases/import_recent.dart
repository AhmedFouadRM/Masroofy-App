import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/catch_up_candidate.dart';
import 'package:masroofy/features/sms_import/domain/entities/parsed_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_inbox.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/sms_parser.dart';
import 'package:masroofy/features/sms_import/domain/usecases/handle_incoming_sms.dart';
import 'package:masroofy/features/sms_import/domain/usecases/resolve_category.dart';

/// The catch-up scan: reads the inbox for the last [defaultDays] days and
/// returns the transactions in it as review candidates. It writes nothing; the
/// user picks which to add (see `AddCatchUpSelection`).
///
/// Only built-in and trusted senders are read, and only messages in the app
/// currency are offered. Messages that were already imported are left out, and
/// a purchase whose cancellation is also in the inbox is left out with it. A
/// candidate is flagged as a likely duplicate when the app already has a
/// transaction with its amount and kind within a day of its date.
class ImportRecent {
  ImportRecent({
    required this._inbox,
    required this._imports,
    required this._settings,
    required this._resolveCategory,
    DateTime Function()? now,
  }) : _now = now ?? DateTime.now;

  final ISmsInbox _inbox;
  final ISmsImportRepository _imports;
  final ISmsSettings _settings;
  final ResolveCategory _resolveCategory;
  final DateTime Function() _now;

  static const defaultDays = 30;

  Future<Either<Failure, List<CatchUpCandidate>>> call({int days = defaultDays}) async {
    final settings = await _settings.load();
    final since = _now().subtract(Duration(days: days));
    final inbox = await _inbox.read(since: since);
    if (inbox case Left(:final value)) return Left(value);
    final messages = inbox.getOrElse((_) => const []);

    // The user's answers decide which unknown senders count.
    final trust = (await _imports.trusted()).getOrElse((_) => const {});

    final parsedMessages = <(RawSms, ParsedSms)>[];
    for (final sms in messages) {
      if (sms.receivedAt.isBefore(since)) continue;
      final trusted = trust[SenderCatalog.keyOf(sms.sender)] ?? SenderCatalog.isKnown(sms.sender);
      if (!trusted) continue;
      final parsed = SmsParser.parse(sms.sender, sms.body, sms.receivedAt);
      if (parsed != null) parsedMessages.add((sms, parsed));
    }

    final cancellations = [
      for (final (sms, parsed) in parsedMessages)
        if (parsed.kind == SmsKind.cancellation) (sms, parsed),
    ];
    final purchases = [
      for (final (sms, parsed) in parsedMessages)
        if (parsed.kind != SmsKind.cancellation && parsed.currency == settings.currencyCode) (sms, parsed),
    ];

    final undone = <RawSms>{};
    for (final (cancel, cancelParsed) in cancellations) {
      // The latest earlier purchase of the same card, amount and merchant.
      final matches = [
        for (final (sms, parsed) in purchases)
          if (!undone.contains(sms) &&
              parsed.kind == SmsKind.expense &&
              SenderCatalog.keyOf(sms.sender) == SenderCatalog.keyOf(cancel.sender) &&
              parsed.amount == cancelParsed.amount &&
              parsed.cardLast4 == cancelParsed.cardLast4 &&
              parsed.merchantKey == cancelParsed.merchantKey &&
              !sms.receivedAt.isAfter(cancel.receivedAt) &&
              cancel.receivedAt.difference(sms.receivedAt) <= HandleIncomingSms.cancellationWindow)
            sms,
      ]..sort((a, b) => b.receivedAt.compareTo(a.receivedAt));
      if (matches.isNotEmpty) undone.add(matches.first);
    }

    final known = (await _imports.existingKeys([for (final (sms, _) in purchases) sms.key])).getOrElse(
      (_) => const {},
    );

    final candidates = <CatchUpCandidate>[];
    for (final (sms, parsed) in purchases) {
      if (undone.contains(sms) || known.contains(sms.key)) continue;
      final categoryId = (await _resolveCategory(parsed.merchant, parsed.kind.transactionKind)).toNullable();
      if (categoryId == null) continue;
      final lookalike = await _imports.hasLookalike(
        amount: parsed.amount,
        kind: parsed.kind.transactionKind,
        from: parsed.date.addDays(-1),
        to: parsed.date.addDays(1),
      );
      candidates.add(
        CatchUpCandidate(
          smsKey: sms.key,
          sender: sms.sender,
          receivedAt: sms.receivedAt,
          parsed: parsed,
          categoryId: categoryId,
          likelyDuplicate: lookalike.getOrElse((_) => false),
        ),
      );
    }
    candidates.sort((a, b) => b.parsed.occurredAt.compareTo(a.parsed.occurredAt));
    return Right(candidates);
  }
}
