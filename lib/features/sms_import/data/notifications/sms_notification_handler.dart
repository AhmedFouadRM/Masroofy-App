import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_payload.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notifier.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_import_repository.dart';
import 'package:masroofy/features/sms_import/domain/repositories/i_sms_settings.dart';
import 'package:masroofy/features/sms_import/domain/usecases/handle_incoming_sms.dart';
import 'package:masroofy/features/sms_import/domain/usecases/sms_import_actions.dart';

/// What the user did with an SMS notification: a tap, or one of its buttons.
///
/// The same code runs in the app and in the background isolate Android starts
/// for a button that does not open the app (Ignore, Remove, Keep, Trust). The
/// two callbacks open the app, so only the app's own handler passes them; a
/// background isolate has no UI.
class SmsNotificationHandler {
  SmsNotificationHandler({
    required this._actions,
    required this._handleIncoming,
    required this._imports,
    required this._settings,
    required this._notifier,
    this.onOpenReview,
    this.onOpenExpense,
  });

  final SmsImportActions _actions;
  final HandleIncomingSms _handleIncoming;
  final ISmsImportRepository _imports;
  final ISmsSettings _settings;
  final SmsNotifier _notifier;

  /// Opens the Add form, pre-filled from the import with this id.
  final void Function(int importId)? onOpenReview;

  /// Opens the transaction with this id.
  final void Function(int expenseId)? onOpenExpense;

  Future<void> handle(NotificationResponse response) async {
    final payload = SmsNotificationPayload.tryParse(response.payload);
    if (payload == null) return;
    final action = response.actionId;
    final tapped = action == null || action.isEmpty;
    final id = payload.importId;

    switch (payload.kind) {
      case SmsNotificationKind.review:
        if (action == SmsNotificationActions.ignore) {
          await _actions.ignore(id);
          await _notifier.dismissImport(id);
        } else {
          onOpenReview?.call(id);
          await _notifier.dismissImport(id);
        }
      case SmsNotificationKind.cancellation:
        if (action == SmsNotificationActions.remove) {
          await _handleIncoming.cancelImport(id);
        } else if (tapped) {
          final import = (await _imports.getById(id)).toNullable();
          if (import?.expenseId case final expenseId?) onOpenExpense?.call(expenseId);
        }
        await _notifier.dismissImport(id);
      case SmsNotificationKind.trust:
        final import = (await _imports.getById(id)).toNullable();
        if (import != null && action == SmsNotificationActions.trust) {
          await _actions.setSenderTrusted(import.sender, trusted: true);
          // The message that prompted this is now imported: ask about it.
          final settings = await _settings.load();
          await _notifier.showReview(import, otherCurrency: import.currency != settings.currencyCode);
        } else if (import != null && action == SmsNotificationActions.distrust) {
          await _actions.setSenderTrusted(import.sender, trusted: false);
          await _actions.ignore(id);
        }
        if (!tapped) await _notifier.dismiss(payload.notificationId);
    }
  }
}
