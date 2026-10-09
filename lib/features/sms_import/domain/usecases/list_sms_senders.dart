import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/sms_import/domain/catalog/senders.dart';
import 'package:masroofy/features/sms_import/domain/entities/sms_sender_entry.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_inbox.dart';

/// The Trusted senders list: the built-in senders found on this phone (in the
/// inbox of the last [inboxDays] days, or already imported from), and the
/// senders the user answered for.
class ListSmsSenders {
  ListSmsSenders({required this._imports, required this._inbox, DateTime Function()? now}) : _now = now ?? DateTime.now;

  final ISmsImportRepository _imports;
  final ISmsInbox _inbox;
  final DateTime Function() _now;

  static const inboxDays = 90;

  /// Rebuilds the list from the stored answers [trust] (by sender key).
  Future<Either<Failure, List<SmsSenderEntry>>> call(Map<String, bool> trust) async {
    final addresses = <String>{
      ...(await _imports.importedSenders()).getOrElse((_) => const {}),
      ...(await _inbox.read(since: _now().subtract(const Duration(days: inboxDays))))
          .getOrElse((_) => const [])
          .map(
            (sms) => sms.sender,
          ),
    };

    final entries = <String, SmsSenderEntry>{};
    for (final address in addresses) {
      final known = SenderCatalog.lookup(address);
      final key = SenderCatalog.keyOf(address);
      // From the inbox, only banks and wallets; a stranger appears once the
      // user has been asked about it (it has an answer below).
      if (known == null && !trust.containsKey(key)) continue;
      entries[key] = _entry(key, known, address, trust);
    }
    for (final key in trust.keys) {
      entries.putIfAbsent(key, () {
        final known = SenderCatalog.senders.where((s) => s.id == key).firstOrNull;
        return _entry(key, known, key, trust);
      });
    }

    final list = entries.values.toList()
      ..sort((a, b) {
        // Built-in senders first, then the ones the user added, by name.
        if (a.addedByUser != b.addedByUser) return a.addedByUser ? 1 : -1;
        return a.name.toLowerCase().compareTo(b.name.toLowerCase());
      });
    return Right(list);
  }

  SmsSenderEntry _entry(String key, SmsSender? known, String address, Map<String, bool> trust) => SmsSenderEntry(
    key: key,
    name: known?.name ?? address.trim(),
    type: known?.type ?? SmsSenderType.bank,
    // A built-in sender is on until the user turns it off.
    trusted: trust[key] ?? known != null,
    addedByUser: known == null,
  );
}
