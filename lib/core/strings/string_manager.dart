import 'package:easy_localization/easy_localization.dart';
import 'package:masroofy/core/error/failures.dart';

/// Single access point for every user-facing string.
///
/// Getters read the *current* locale when called, so call them inside `build`
/// and never cache the result in a field, constant, or long-lived provider.
class StringManager {
  StringManager._();

  // ── General ──
  static String get save => 'general.save'.tr();
  static String get cancel => 'general.cancel'.tr();
  static String get delete => 'general.delete'.tr();
  static String get confirm => 'general.confirm'.tr();
  static String get undo => 'general.undo'.tr();
  static String get search => 'general.search'.tr();
  static String get noResults => 'general.no_results'.tr();
  static String get loading => 'general.loading'.tr();

  // ── Dates ──
  static String get today => 'date.today'.tr();
  static String get yesterday => 'date.yesterday'.tr();

  // ── Expenses ──
  static String get expensesTitle => 'expenses.title'.tr();
  static String get addExpense => 'expenses.add'.tr();
  static String get editExpense => 'expenses.edit'.tr();
  static String expenseDeleted(String title) => 'expenses.deleted'.tr(args: [title]);
  static String get emptyExpenses => 'expenses.empty'.tr();
  static String get emptyExpensesHint => 'expenses.empty_hint'.tr();
  static String get total => 'expenses.total'.tr();
  static String get filter => 'expenses.filter'.tr();

  // ── Categories ──
  static String get categoriesTitle => 'categories.title'.tr();
  static String get addCategory => 'categories.add'.tr();

  /// Display name of a pre-seeded category, by its `seed_key` (e.g. `food`).
  static String categoryName(String seedKey) => 'categories.$seedKey'.tr();

  // ── Recurring ──
  static String get recurringTitle => 'recurring.title'.tr();
  static String get addRecurring => 'recurring.add'.tr();
  static String nextDue(String date) => 'recurring.next_due'.tr(args: [date]);
  static String get daily => 'recurring.daily'.tr();
  static String get weekly => 'recurring.weekly'.tr();
  static String get monthly => 'recurring.monthly'.tr();
  static String get yearly => 'recurring.yearly'.tr();

  // ── Analytics ──
  static String get analyticsTitle => 'analytics.title'.tr();
  static String get thisWeek => 'analytics.this_week'.tr();
  static String get thisMonth => 'analytics.this_month'.tr();
  static String get lastMonth => 'analytics.last_month'.tr();
  static String get customRange => 'analytics.custom'.tr();
  static String get vsLast => 'analytics.vs_last'.tr();
  static String get noAnalyticsData => 'analytics.no_data'.tr();

  // ── Budgets ──
  static String get budgetsTitle => 'budgets.title'.tr();
  static String get addBudget => 'budgets.add'.tr();
  static String overBudget(String amount) => 'budgets.over_budget'.tr(args: [amount]);
  static String budgetRemaining(String amount) => 'budgets.remaining'.tr(args: [amount]);
  static String budgetExceeded(String category) => 'budgets.exceeded_alert'.tr(args: [category]);

  // ── Settings ──
  static String get settingsTitle => 'settings.title'.tr();
  static String get currency => 'settings.currency'.tr();
  static String get language => 'settings.language'.tr();
  static String get theme => 'settings.theme'.tr();
  static String get appLock => 'settings.app_lock'.tr();
  static String get manageCategories => 'settings.categories'.tr();
  static String get manageBudgets => 'settings.budgets'.tr();
  static String get exportData => 'settings.export'.tr();
  static String get clearData => 'settings.clear_data'.tr();
  static String get clearDataConfirm => 'settings.clear_confirm'.tr();
  static String get currencyWarning => 'settings.currency_warning'.tr();
  static String get westernDigits => 'settings.western_digits'.tr();

  /// Localized currency name by ISO 4217 code (e.g. `EGP`).
  static String currencyName(String code) => 'currencies.$code'.tr();
  static String get appVersion => 'settings.version'.tr();

  // ── Auth ──
  static String get enterPin => 'auth.enter_pin'.tr();
  static String get setPin => 'auth.set_pin'.tr();
  static String get confirmPin => 'auth.confirm_pin'.tr();
  static String get wrongPin => 'auth.wrong_pin'.tr();
  static String get biometricPrompt => 'auth.biometric_prompt'.tr();
  static String get enableBiometric => 'auth.enable_biometric'.tr();

  // ── Errors ──
  /// Localized message for any [Failure]. Raw exception text never reaches the UI.
  static String failure(Failure failure) => switch (failure) {
        ValidationFailure(:final reason) => validation(reason),
        NotFoundFailure() => 'errors.not_found'.tr(),
        ConstraintFailure() => 'errors.constraint'.tr(),
        StorageFailure() => 'errors.storage'.tr(),
        SecureStorageFailure() => 'errors.secure_storage'.tr(),
        ExportFailure() => 'errors.export'.tr(),
        UnexpectedFailure() => 'errors.unexpected'.tr(),
      };

  static String validation(ValidationReason reason) => switch (reason) {
        ValidationReason.required => 'validation.required'.tr(),
        ValidationReason.tooLong => 'validation.too_long'.tr(),
        ValidationReason.mustBePositive => 'validation.must_be_positive'.tr(),
        ValidationReason.inFuture => 'validation.in_future'.tr(),
        ValidationReason.invalidFormat => 'validation.invalid_format'.tr(),
        ValidationReason.duplicate => 'validation.duplicate'.tr(),
      };
}
