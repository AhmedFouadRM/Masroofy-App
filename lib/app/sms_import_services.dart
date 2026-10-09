import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart' show rootBundle;
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/features/expenses/data/datasources/expense_local_datasource.dart';
import 'package:masroofy/features/expenses/data/repositories/expense_repository_impl.dart';
import 'package:masroofy/features/expenses/domain/usecases/delete_expense.dart';
import 'package:masroofy/features/expenses/domain/usecases/save_expense.dart';
import 'package:masroofy/features/sms_import/data/datasources/sms_import_local_datasource.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_handler.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notification_texts.dart';
import 'package:masroofy/features/sms_import/data/notifications/sms_notifier.dart';
import 'package:masroofy/features/sms_import/data/platform/sms_channel.dart';
import 'package:masroofy/features/sms_import/data/platform/sms_permission_service.dart';
import 'package:masroofy/features/sms_import/data/repositories/sms_import_repository_impl.dart';
import 'package:masroofy/features/sms_import/data/sms_settings_store.dart';
import 'package:masroofy/features/sms_import/domain/entities/raw_sms.dart';
import 'package:masroofy/features/sms_import/domain/usecases/add_catch_up_selection.dart';
import 'package:masroofy/features/sms_import/domain/usecases/handle_incoming_sms.dart';
import 'package:masroofy/features/sms_import/domain/usecases/import_recent.dart';
import 'package:masroofy/features/sms_import/domain/usecases/list_sms_senders.dart';
import 'package:masroofy/features/sms_import/domain/usecases/resolve_category.dart';
import 'package:masroofy/features/sms_import/domain/usecases/sms_import_actions.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wires SMS Import's pieces over one database and one set of preferences.
///
/// SMS can arrive while the app is closed, in a headless engine that has no
/// `get_it` graph, so this is the second composition root (the first is
/// `configureDependencies`, which builds its SMS Import objects from one of
/// these). Both engines run the same code.
class SmsImportServices {
  SmsImportServices({
    required this.database,
    required this.preferences,
    FlutterLocalNotificationsPlugin? notifications,
    SmsChannel? channel,
  }) : notificationsPlugin = notifications ?? FlutterLocalNotificationsPlugin(),
       channel = channel ?? SmsChannel();

  /// Opens the app's database and preferences, for a headless engine. Call
  /// [dispose] when done.
  static Future<SmsImportServices> open() async =>
      SmsImportServices(database: AppDatabase(), preferences: await SharedPreferences.getInstance());

  final AppDatabase database;
  final SharedPreferences preferences;
  final FlutterLocalNotificationsPlugin notificationsPlugin;
  final SmsChannel channel;

  late final SmsImportRepositoryImpl repository = SmsImportRepositoryImpl(SmsImportLocalDatasource(database));
  late final SmsSettingsStore settings = SmsSettingsStore(preferences);
  late final ExpenseRepositoryImpl _expenses = ExpenseRepositoryImpl(ExpenseLocalDatasource(database));
  late final SaveExpense saveExpense = SaveExpense(_expenses);
  late final DeleteExpense deleteExpense = DeleteExpense(_expenses);
  late final ResolveCategory resolveCategory = ResolveCategory(repository);

  late final HandleIncomingSms handleIncoming = HandleIncomingSms(
    settings: settings,
    imports: repository,
    resolveCategory: resolveCategory,
    saveExpense: saveExpense,
    deleteExpense: deleteExpense,
  );

  late final SmsImportActions actions = SmsImportActions(repository, repository);

  late final ImportRecent importRecent = ImportRecent(
    inbox: channel,
    imports: repository,
    settings: settings,
    resolveCategory: resolveCategory,
  );

  late final AddCatchUpSelection addCatchUpSelection = AddCatchUpSelection(
    settings: settings,
    imports: repository,
    saveExpense: saveExpense,
  );

  late final ListSmsSenders listSenders = ListSmsSenders(imports: repository, inbox: channel);

  late final SmsNotifier notifier = SmsNotifier(
    notificationsPlugin,
    () => SmsNotificationTexts.load(preferences, rootBundle),
  );

  static const permissions = SmsPermissionService();

  /// Handles one message: imports or drops it, then posts its notification.
  Future<void> processIncoming(RawSms sms) async {
    final outcome = await handleIncoming(sms);
    await outcome.match(
      (failure) async => debugPrint('SMS Import: could not handle a message: $failure'),
      notifier.announce,
    );
  }

  /// Handles a tap or button of an SMS notification. [onOpenReview] and
  /// [onOpenExpense] open the app; leave them out in a background isolate.
  SmsNotificationHandler notificationHandler({
    void Function(int importId)? onOpenReview,
    void Function(int expenseId)? onOpenExpense,
  }) => SmsNotificationHandler(
    actions: actions,
    handleIncoming: handleIncoming,
    imports: repository,
    settings: settings,
    notifier: notifier,
    onOpenReview: onOpenReview,
    onOpenExpense: onOpenExpense,
  );

  /// Closes the database a headless engine opened.
  Future<void> dispose() => database.close();
}
