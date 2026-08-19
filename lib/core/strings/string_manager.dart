import 'package:easy_localization/easy_localization.dart';

class StringManager {
  StringManager._();

  // â”€â”€ General â”€â”€
  static String get save => 'general.save'.tr();
  static String get cancel => 'general.cancel'.tr();
  static String get delete => 'general.delete'.tr();
  static String get confirm => 'general.confirm'.tr();
  static String get undo => 'general.undo'.tr();
  static String get search => 'general.search'.tr();
  static String get noResults => 'general.no_results'.tr();
  static String get loading => 'general.loading'.tr();

  // â”€â”€ Expenses â”€â”€
  static String get expensesTitle => 'expenses.title'.tr();
  static String get addExpense => 'expenses.add'.tr();
  static String get editExpense => 'expenses.edit'.tr();
  static String expenseDeleted(String title) => 'expenses.deleted'.tr(args: [title]);
  static String get emptyExpenses => 'expenses.empty'.tr();
  static String get emptyExpensesHint => 'expenses.empty_hint'.tr();
  static String get total => 'expenses.total'.tr();
  static String get filter => 'expenses.filter'.tr();

  // â”€â”€ Categories â”€â”€
  static String get categoriesTitle => 'categories.title'.tr();
  static String get addCategory => 'categories.add'.tr();

  // â”€â”€ Recurring â”€â”€
  static String get recurringTitle => 'recurring.title'.tr();
  static String get addRecurring => 'recurring.add'.tr();
  static String nextDue(String date) => 'recurring.next_due'.tr(args: [date]);
  static String get daily => 'recurring.daily'.tr();
  static String get weekly => 'recurring.weekly'.tr();
  static String get monthly => 'recurring.monthly'.tr();
  static String get yearly => 'recurring.yearly'.tr();

  // â”€â”€ Analytics â”€â”€
  static String get analyticsTitle => 'analytics.title'.tr();
  static String get thisWeek => 'analytics.this_week'.tr();
  static String get thisMonth => 'analytics.this_month'.tr();
  static String get lastMonth => 'analytics.last_month'.tr();
  static String get customRange => 'analytics.custom'.tr();
  static String get vsLast => 'analytics.vs_last'.tr();
  static String get noAnalyticsData => 'analytics.no_data'.tr();

  // â”€â”€ Budgets â”€â”€
  static String get budgetsTitle => 'budgets.title'.tr();
  static String get addBudget => 'budgets.add'.tr();
  static String overBudget(String amount) => 'budgets.over_budget'.tr(args: [amount]);
  static String budgetRemaining(String amount) => 'budgets.remaining'.tr(args: [amount]);
  static String budgetExceeded(String category) => 'budgets.exceeded_alert'.tr(args: [category]);

  // â”€â”€ Settings â”€â”€
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
  static String get appVersion => 'settings.version'.tr();

  // â”€â”€ Auth â”€â”€
  static String get enterPin => 'auth.enter_pin'.tr();
  static String get setPin => 'auth.set_pin'.tr();
  static String get confirmPin => 'auth.confirm_pin'.tr();
  static String get wrongPin => 'auth.wrong_pin'.tr();
  static String get biometricPrompt => 'auth.biometric_prompt'.tr();
  static String get enableBiometric => 'auth.enable_biometric'.tr();
}
