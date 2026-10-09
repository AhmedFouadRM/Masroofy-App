import 'package:easy_localization/easy_localization.dart';
import 'package:masroofy/core/error/failures.dart';

/// Single access point for every user-facing string.
///
/// Getters read the *current* locale when called, so call them inside `build`
/// and never cache the result in a field, constant, or long-lived cubit state.
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
  static String get spentThisWeek => 'expenses.spent_week'.tr();
  static String get spentThisMonth => 'expenses.spent_month'.tr();
  static String spentInRange(String range) => 'expenses.spent_range'.tr(args: [range]);
  static String get vsLastWeek => 'expenses.vs_last_week'.tr();
  static String get vsLastMonth => 'expenses.vs_last_month'.tr();
  static String get vsPreviousPeriod => 'expenses.vs_previous'.tr();
  static String get allCategories => 'expenses.all'.tr();
  static String get recurringBadge => 'expenses.recurring'.tr();
  static String get searchExpensesHint => 'expenses.search_hint'.tr();
  static String get closeSearch => 'expenses.close_search'.tr();
  static String get noMatchingExpenses => 'expenses.no_match'.tr();
  static String get clearFilters => 'expenses.clear_filters'.tr();
  static String get addFirstExpense => 'expenses.add_first'.tr();
  static String get amountLabel => 'expenses.amount'.tr();
  static String amountHelper(String digits, String currency) => 'expenses.amount_helper'.tr(args: [digits, currency]);
  static String get categoryLabel => 'expenses.category'.tr();
  static String get chooseCategory => 'expenses.choose_category'.tr();
  static String get titleLabel => 'expenses.title_label'.tr();
  static String get titleHelper => 'expenses.title_helper'.tr();
  static String get dateLabel => 'expenses.date'.tr();
  static String todayWithDate(String date) => 'expenses.today_date'.tr(args: [date]);
  static String yesterdayWithDate(String date) => 'expenses.yesterday_date'.tr(args: [date]);
  static String get noteLabel => 'expenses.note'.tr();
  static String get noteHint => 'expenses.note_hint'.tr();
  static String get saveExpense => 'expenses.save'.tr();

  // ── Categories ──
  static String get categoriesTitle => 'categories.title'.tr();
  static String get addCategory => 'categories.add'.tr();

  /// Display name of a pre-seeded category, by its `seed_key` (e.g. `food`).
  static String categoryName(String seedKey) => 'categories.$seedKey'.tr();
  static String get categoriesDefaultSection => 'categories.section_default'.tr();
  static String get categoriesCustomSection => 'categories.section_custom'.tr();
  static String get newCategory => 'categories.new'.tr();
  static String get editCategory => 'categories.edit'.tr();
  static String get categoryNameLabel => 'categories.name'.tr();
  static String categoryNameHelper(String max) => 'categories.name_helper'.tr(args: [max]);
  static String get categoryIcon => 'categories.icon'.tr();
  static String get categoryColour => 'categories.colour'.tr();
  static String get deleteCategory => 'categories.delete'.tr();
  static String deleteCategoryTitle(String name) => 'categories.delete_title'.tr(args: [name]);
  static String categoryBudget(String amount) => 'categories.budget'.tr(args: [amount]);

  /// Counts take the number already shaped for the locale ([number]); `0`
  /// is handled here because English plural rules have no zero form.
  static String categoryExpenseCount(int count, String number) =>
      count == 0 ? 'categories.expense_count.zero'.tr() : 'categories.expense_count'.plural(count, args: [number]);
  static String categoryRecurringCount(int count, String number) =>
      count == 0 ? '' : 'categories.recurring_count'.plural(count, args: [number]);

  /// Body of the delete confirmation, e.g. "12 expenses and 1 recurring
  /// template will move to Other. Its budget will be removed."
  static String deleteCategoryBody({
    required int expenses,
    required String expensesNumber,
    required int templates,
    required String templatesNumber,
    required bool hasBudget,
  }) {
    final moving = [
      if (expenses > 0) 'categories.expenses_to_move'.plural(expenses, args: [expensesNumber]),
      if (templates > 0) 'categories.templates_to_move'.plural(templates, args: [templatesNumber]),
    ];
    return [
      if (moving.isNotEmpty) 'categories.delete_moves'.tr(args: [moving.join('categories.and'.tr())]),
      if (hasBudget) 'categories.delete_budget'.tr(),
      if (moving.isEmpty && !hasBudget) 'categories.delete_unused'.tr(),
    ].join(' ');
  }

  // ── Recurring ──
  static String get recurringTitle => 'recurring.title'.tr();
  static String get addRecurring => 'recurring.add'.tr();
  static String get editRecurring => 'recurring.edit'.tr();
  static String nextDue(String date) => 'recurring.next_due'.tr(args: [date]);

  /// `Daily`, `Weekly`, ... by frequency name (`daily`, `weekly`, ...).
  static String frequency(String name) => 'recurring.$name'.tr();
  static String get recurringActiveSection => 'recurring.section_active'.tr();
  static String get recurringPausedSection => 'recurring.section_paused'.tr();
  static String get recurringPaused => 'recurring.paused'.tr();
  static String get emptyRecurring => 'recurring.empty'.tr();
  static String get emptyRecurringHint => 'recurring.empty_hint'.tr();
  static String get addFirstRecurring => 'recurring.add_first'.tr();
  static String get recurringTitleLabel => 'recurring.title_label'.tr();
  static String get recurringTitleHint => 'recurring.title_hint'.tr();
  static String get repeats => 'recurring.repeats'.tr();
  static String get startDate => 'recurring.start_date'.tr();
  static String get startDateHelper => 'recurring.start_helper'.tr();
  static String get recurringActive => 'recurring.active'.tr();
  static String get recurringActiveHelper => 'recurring.active_helper'.tr();
  static String get saveRecurring => 'recurring.save'.tr();
  static String deleteRecurringTitle(String title) => 'recurring.delete_title'.tr(args: [title]);
  static String get deleteRecurringBody => 'recurring.delete_body'.tr();

  /// Switch label for screen readers, e.g. "Active: Rent".
  static String recurringActiveToggle(String title) => 'recurring.active_toggle'.tr(args: [title]);

  // ── Analytics ──
  static String get analyticsTitle => 'analytics.title'.tr();
  static String get thisWeek => 'analytics.this_week'.tr();
  static String get thisMonth => 'analytics.this_month'.tr();
  static String get lastMonth => 'analytics.last_month'.tr();
  static String get customRange => 'analytics.custom'.tr();
  static String get spentLastMonth => 'analytics.spent_last_month'.tr();
  static String get vsMonthBefore => 'analytics.vs_month_before'.tr();
  static String get byCategory => 'analytics.by_category'.tr();
  static String get spendingOverTime => 'analytics.over_time'.tr();
  static String get smallerCategories => 'analytics.smaller_categories'.tr();
  static String get noAnalyticsData => 'analytics.no_data'.tr();
  static String get noAnalyticsDataHint => 'analytics.no_data_hint'.tr();

  /// [percent] is already shaped for the locale.
  static String percentOfTotal(String percent) => 'analytics.of_total'.tr(args: [percent]);

  // ── Budgets ──
  static String get budgetsTitle => 'budgets.title'.tr();
  static String get addBudget => 'budgets.add'.tr();
  static String get editBudget => 'budgets.edit'.tr();
  static String overBudget(String amount) => 'budgets.over_budget'.tr(args: [amount]);
  static String budgetRemaining(String amount) => 'budgets.remaining'.tr(args: [amount]);

  /// "EGP 1,200 of EGP 2,000".
  static String budgetOfLimit(String spent, String limit) => 'budgets.of_limit'.tr(args: [spent, limit]);

  /// `Weekly` / `Monthly` by period name.
  static String budgetPeriod(String name) => 'budgets.$name'.tr();
  static String get budgetPeriodLabel => 'budgets.period'.tr();
  static String get budgetLimitLabel => 'budgets.limit'.tr();
  static String get emptyBudgets => 'budgets.empty'.tr();
  static String get emptyBudgetsHint => 'budgets.empty_hint'.tr();
  static String get addFirstBudget => 'budgets.add_first'.tr();
  static String get allCategoriesBudgeted => 'budgets.all_budgeted'.tr();
  static String get budgetCategoryLocked => 'budgets.category_locked'.tr();
  static String deleteBudgetTitle(String category) => 'budgets.delete_title'.tr(args: [category]);
  static String get deleteBudgetBody => 'budgets.delete_body'.tr();
  static String get saveBudget => 'budgets.save'.tr();
  static String get budgetExceededTitle => 'budgets.exceeded_title'.tr();
  static String get budgetExceededBody => 'budgets.exceeded_body'.tr();
  static String get gotIt => 'budgets.got_it'.tr();

  /// Screen-reader status: `safe`, `warning` or `exceeded`.
  static String budgetStatus(String name) => 'budgets.status_$name'.tr();

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
