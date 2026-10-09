import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/expense_source.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense_draft.dart';
import 'package:masroofy/features/expenses/domain/usecases/delete_expense.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/parsed_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_import.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_outcome.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/merchant_key.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/sms_parser.dart';
import 'package:masroofy/features/sms_import/domain/usecases/resolve_category.dart';

/// Decides what happens to one incoming SMS: drop it, ask the user, or record
/// it in the default wallet. It writes (imports, transactions) but shows
/// nothing; the caller turns the [SmsOutcome] into a notification.
///
/// Idempotent: a message is keyed by a hash of sender, time and body, so a
/// duplicate broadcast or a re-scan changes nothing.
class HandleIncomingSms {
  HandleIncomingSms({
    required this._settings,
    required this._imports,
    required this._resolveCategory,
    required this._saveExpense,
    required this._deleteExpense,
  });

  final ISmsSettings _settings;
  final ISmsImportRepository _imports;
  final ResolveCategory _resolveCategory;
  final SaveExpense _saveExpense;
  final DeleteExpense _deleteExpense;

  /// How long after a purchase its cancellation can still undo it.
  static const cancellationWindow = Duration(days: 7);

  /// A cancellation may come a little before the clocks agree.
  static const _clockSkew = Duration(minutes: 5);

  static const _ignored = Right<Failure, SmsOutcome>(SmsIgnored(SmsIgnoreReason.notTransaction));

  Future<Either<Failure, SmsOutcome>> call(RawSms sms) async {
    try {
      return await _handle(sms);
    } on _Abort catch (abort) {
      return Left(abort.failure);
    }
  }

  Future<Either<Failure, SmsOutcome>> _handle(RawSms sms) async {
    final settings = await _settings.load();
    if (!settings.enabled) return const Right(SmsIgnored(SmsIgnoreReason.disabled));

    final key = sms.key;
    if ((await _imports.findByKey(key)).unwrap() != null) return const Right(SmsIgnored(SmsIgnoreReason.duplicate));

    final parsed = SmsParser.parse(sms.sender, sms.body, sms.receivedAt);
    if (parsed == null) return _ignored;

    final senderKey = SenderCatalog.keyOf(sms.sender);
    final answer = (await _imports.trustOf(senderKey)).unwrap();
    if (answer == false) return const Right(SmsIgnored(SmsIgnoreReason.untrusted));
    final trusted = answer ?? SenderCatalog.isKnown(sms.sender);

    if (!trusted) {
      // A phone number is a person. A name or short code that texts a
      // transaction is asked about, once.
      if (SenderCatalog.looksPersonal(sms.sender) || parsed.kind == SmsKind.cancellation) return _ignored;
      return _trustPrompt(sms, key, parsed);
    }
    if (parsed.kind == SmsKind.cancellation) return _cancel(sms, parsed, settings);
    return _record(sms, key, parsed, settings);
  }

  Future<Either<Failure, SmsOutcome>> _trustPrompt(RawSms sms, String key, ParsedSms parsed) async {
    final categoryId = await _categoryFor(parsed);
    final inserted = await _imports.insert(_draft(sms, key, parsed, categoryId));
    return inserted.match(
      (failure) => failure is ConstraintFailure ? const Right(SmsIgnored(SmsIgnoreReason.duplicate)) : Left(failure),
      (import) => Right(SmsTrustPrompt(sms.sender, import)),
    );
  }

  Future<Either<Failure, SmsOutcome>> _record(RawSms sms, String key, ParsedSms parsed, SmsSettings settings) async {
    final categoryId = await _categoryFor(parsed);
    final inserted = await _imports.insert(_draft(sms, key, parsed, categoryId));
    // Another delivery of this message got here first.
    if (inserted case Left(:final value) when value is ConstraintFailure) {
      return const Right(SmsIgnored(SmsIgnoreReason.duplicate));
    }
    final import = inserted.unwrap();

    final sameCurrency = parsed.currency == settings.currencyCode;
    final walletId = settings.defaultWalletId;
    final canRecord =
        settings.mode == SmsMode.auto &&
        sameCurrency &&
        parsed.isConfident &&
        parsed.amount.isPositive &&
        walletId != null &&
        categoryId != null;
    if (!canRecord) return Right(SmsNeedsReview(import, otherCurrency: !sameCurrency));

    final saved = await _saveExpense(
      ExpenseDraft(
        amount: parsed.amount,
        walletId: walletId,
        categoryId: categoryId,
        date: _clampedDate(parsed, sms),
        title: parsed.merchant,
        note: parsed.note,
        kind: parsed.kind.transactionKind,
        source: ExpenseSource.sms,
      ),
    );
    return switch (saved) {
      // It could not be saved (e.g. the wallet is gone): ask instead.
      Left() => Right(SmsNeedsReview(import, otherCurrency: false)),
      Right(:final value) => (await _imports.setStatus(
        import.id,
        SmsImportStatus.added,
        expenseId: value,
      )).map((_) => SmsRecorded(import.copyWith(status: SmsImportStatus.added, expenseId: value))),
    };
  }

  /// Matches a cancellation to the import it undoes: same sender, card,
  /// amount and merchant, within 7 days before it.
  Future<Either<Failure, SmsOutcome>> _cancel(RawSms sms, ParsedSms parsed, SmsSettings settings) async {
    final candidates = await _imports.findCancellable(
      amount: parsed.amount,
      since: sms.receivedAt.subtract(cancellationWindow),
    );
    final list = candidates.unwrap();
    final senderKey = SenderCatalog.keyOf(sms.sender);
    final latest = sms.receivedAt.add(_clockSkew);
    final match = list.where(
      (c) =>
          SenderCatalog.keyOf(c.sender) == senderKey &&
          c.currency == parsed.currency &&
          c.cardLast4 == parsed.cardLast4 &&
          MerchantKey.of(c.merchant) == parsed.merchantKey &&
          !c.receivedAt.isAfter(latest),
    );
    if (match.isEmpty) return const Right(SmsIgnored(SmsIgnoreReason.noMatch));
    final import = match.first;

    final added = import.status == SmsImportStatus.added;
    if (added && settings.mode == SmsMode.ask) return Right(SmsCancellationAsk(import));
    return (await _cancelImport(import)).map((removed) => SmsImportCancelled(import, removedExpense: removed));
  }

  /// Marks `import` cancelled and deletes the transaction it made, if any.
  /// Returns whether a transaction was deleted. Also the "Remove" action of
  /// the cancellation notification.
  Future<Either<Failure, bool>> cancelImport(int importId) async => switch (await _imports.getById(importId)) {
    Left(:final value) => Left(value),
    Right(:final value) => await _cancelImport(value),
  };

  Future<Either<Failure, bool>> _cancelImport(SmsImport import) async {
    var removed = false;
    final expenseId = import.expenseId;
    if (import.status == SmsImportStatus.added && expenseId != null) {
      final deleted = await _deleteExpense(expenseId);
      // Already gone is fine.
      if (deleted case Left(:final value) when value is! NotFoundFailure) return Left(value);
      removed = deleted.isRight();
    }
    return (await _imports.setStatus(import.id, SmsImportStatus.cancelled)).map((_) => removed);
  }

  Future<int?> _categoryFor(ParsedSms parsed) async =>
      (await _resolveCategory(parsed.merchant, parsed.kind.transactionKind)).toNullable();

  /// A date in the future is clamped to the SMS time.
  static LocalDate _clampedDate(ParsedSms parsed, RawSms sms) {
    final received = LocalDate.fromDateTime(sms.receivedAt);
    return parsed.date.isAfter(received) ? received : parsed.date;
  }

  static SmsImportDraft _draft(RawSms sms, String key, ParsedSms parsed, int? categoryId) => SmsImportDraft(
    smsKey: key,
    sender: sms.sender,
    receivedAt: sms.receivedAt,
    kind: parsed.kind.transactionKind,
    amount: parsed.amount,
    currency: parsed.currency,
    date: _clampedDate(parsed, sms),
    merchant: parsed.merchant,
    categoryId: categoryId,
    cardLast4: parsed.cardLast4,
    note: parsed.note.isEmpty ? null : parsed.note,
  );
}

class _Abort implements Exception {
  const _Abort(this.failure);

  final Failure failure;
}

extension _Unwrap<T> on Either<Failure, T> {
  /// The value, or abandons the whole message with the failure.
  T unwrap() => switch (this) {
    Left(:final value) => throw _Abort(value),
    Right(:final value) => value,
  };
}
