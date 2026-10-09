import 'package:easy_localization/easy_localization.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
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
  static String get close => 'general.close'.tr();
  static String get continueLabel => 'general.continue'.tr();

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

  // ── Income ──
  static String get addIncome => 'income.add'.tr();
  static String get editIncome => 'income.edit'.tr();
  static String get saveIncome => 'income.save'.tr();

  /// The Expense | Income switch on the forms.
  static String kindLabel(TransactionKind kind) => 'income.kind_${kind.name}'.tr();
  static String get filterIncome => 'income.filter_income'.tr();
  static String get filterExpenses => 'income.filter_expenses'.tr();
  static String get emptyIncome => 'income.empty_title'.tr();
  static String get emptyIncomeHint => 'income.empty_body'.tr();
  static String get leftThisWeek => 'income.left_week'.tr();
  static String get leftThisMonth => 'income.left_month'.tr();
  static String leftInRange(String range) => 'income.left_range'.tr(args: [range]);
  static String get incomeIn => 'income.in'.tr();
  static String get incomeOut => 'income.out'.tr();
  static String get earnedThisWeek => 'income.earned_week'.tr();
  static String get earnedThisMonth => 'income.earned_month'.tr();
  static String earnedInRange(String range) => 'income.earned_range'.tr(args: [range]);

  /// Screen-reader label of an income row: "Income, Salary, plus EGP 5,000".
  static String incomeRowSemantics(String name, String amount) => 'income.row_semantics'.tr(args: [name, amount]);

  /// "Pick an income category" / "Pick an expense category".
  static String wrongKind(TransactionKind kind) => 'validation.category_wrong_kind.${kind.name}'.tr();

  // ── Categories ──
  static String get categoriesTitle => 'categories.title'.tr();
  static String get addCategory => 'categories.add'.tr();

  /// Display name of a pre-seeded category, by its `seed_key` (e.g. `food`).
  static String categoryName(String seedKey) => 'categories.$seedKey'.tr();
  static String get categoriesDefaultSection => 'categories.section_default'.tr();
  static String get categoriesCustomSection => 'categories.section_custom'.tr();
  static String get categoriesExpenseSection => 'categories.section_expense'.tr();
  static String get categoriesIncomeSection => 'categories.section_income'.tr();
  static String get categoryKindLabel => 'categories.kind_label'.tr();
  static String get categoryKindInUse => 'categories.kind_in_use'.tr();
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
  static String categoryIncomeCount(int count, String number) =>
      count == 0 ? 'categories.income_count.zero'.tr() : 'categories.income_count'.plural(count, args: [number]);
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
    TransactionKind kind = TransactionKind.expense,
  }) {
    final income = kind == TransactionKind.income;
    final moving = [
      if (expenses > 0)
        (income ? 'categories.income_to_move' : 'categories.expenses_to_move').plural(expenses, args: [expensesNumber]),
      if (templates > 0) 'categories.templates_to_move'.plural(templates, args: [templatesNumber]),
    ];
    return [
      if (moving.isNotEmpty)
        (income ? 'categories.delete_moves_income' : 'categories.delete_moves').tr(
          args: [moving.join('categories.and'.tr())],
        ),
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
  static String get incomeVsSpending => 'analytics.income_vs_spending'.tr();
  static String get analyticsIncome => 'analytics.income'.tr();
  static String get analyticsSpent => 'analytics.spent'.tr();
  static String get analyticsBalance => 'analytics.balance'.tr();
  static String get savingsRate => 'analytics.savings_rate'.tr();
  static String get analyticsSpending => 'analytics.spending'.tr();
  static String get noIncomeData => 'analytics.no_income'.tr();

  /// Bar tooltip; both amounts are already formatted.
  static String incomeAndSpent(String income, String spent) => 'analytics.tooltip'.tr(args: [income, spent]);
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
  static String get sectionGeneral => 'settings.section_general'.tr();
  static String get sectionSecurity => 'settings.section_security'.tr();
  static String get sectionData => 'settings.section_data'.tr();
  static String get sectionAbout => 'settings.section_about'.tr();
  static String get currency => 'settings.currency'.tr();
  static String get language => 'settings.language'.tr();

  /// Language names are shown in their own language, in both locales.
  static String get languageEnglish => 'settings.language_en'.tr();
  static String get languageArabic => 'settings.language_ar'.tr();
  static String get theme => 'settings.theme'.tr();
  static String get themeLight => 'settings.theme_light'.tr();
  static String get themeDark => 'settings.theme_dark'.tr();
  static String get themeSystem => 'settings.theme_system'.tr();
  static String get westernDigits => 'settings.western_digits'.tr();
  static String get appLock => 'settings.app_lock'.tr();
  static String get appLockOff => 'settings.app_lock_off'.tr();
  static String get appLockTurnedOff => 'settings.app_lock_turned_off'.tr();
  static String get appLockPin => 'settings.app_lock_pin'.tr();
  static String get appLockPinAndFingerprint => 'settings.app_lock_pin_fingerprint'.tr();
  static String get unlockWithFingerprint => 'settings.fingerprint'.tr();
  static String get changePin => 'settings.change_pin'.tr();
  static String get pinChanged => 'settings.pin_changed'.tr();
  static String get biometricFailed => 'settings.biometric_failed'.tr();
  static String get manageCategories => 'settings.categories'.tr();
  static String get manageBudgets => 'settings.budgets'.tr();
  static String get exportCsv => 'settings.export_csv'.tr();
  static String get exportBackup => 'settings.export_backup'.tr();
  static String get restoreBackup => 'settings.restore_backup'.tr();
  static String get clearData => 'settings.clear_data'.tr();
  static String get clearTitle => 'settings.clear_title'.tr();
  static String get clearBody => 'settings.clear_body'.tr();
  static String get holdTitle => 'settings.hold_title'.tr();
  static String get holdBody => 'settings.hold_body'.tr();
  static String get holdToDelete => 'settings.hold_button'.tr();
  static String get cleared => 'settings.cleared'.tr();
  static String get restoreTitle => 'settings.restore_title'.tr();
  static String get restore => 'settings.restore'.tr();
  static String get restored => 'settings.restored'.tr();
  static String get backupFailed => 'settings.backup_failed'.tr();
  static String get appVersion => 'settings.version'.tr();
  static String get licenses => 'settings.licenses'.tr();
  static String get searchCurrencies => 'settings.search_currencies'.tr();
  static String get clearSearch => 'settings.clear_search'.tr();

  /// `3 decimals`; [number] is already shaped for the locale.
  static String decimals(String number) => 'settings.decimals'.tr(args: [number]);
  static String changeCurrencyTitle(String name) => 'settings.change_currency_title'.tr(args: [name]);

  /// [from] and [to] are the same face value in each currency, e.g. `EGP 12.50`.
  static String changeCurrencyBody(String from, String to) => 'settings.change_currency_body'.tr(args: [from, to]);
  static String get change => 'settings.change'.tr();
  static String get firstLaunchTitle => 'settings.first_launch_title'.tr();
  static String get firstLaunchHint => 'settings.first_launch_hint'.tr();

  /// Body of the restore confirmation: `…backup from Oct 9, 2026 (1,284 expenses, 6 budgets).`
  /// The counts take their number already shaped for the locale.
  static String restoreBody(String date, int expenses, String expensesNumber, int budgets, String budgetsNumber) =>
      'settings.restore_body'.tr(
        args: [
          date,
          'settings.backup_expenses'.plural(expenses, args: [expensesNumber]),
          'settings.backup_budgets'.plural(budgets, args: [budgetsNumber]),
        ],
      );

  /// Localized currency name by ISO 4217 code (e.g. `EGP`).
  static String currencyName(String code) => 'currencies.$code'.tr();

  // ── Auth ──
  static String get enterPin => 'auth.enter_pin'.tr();
  static String get wrongPin => 'auth.wrong_pin'.tr();
  static String get biometricPrompt => 'auth.biometric_prompt'.tr();
  static String get useBiometric => 'auth.use_biometric'.tr();
  static String get createPin => 'auth.create_pin'.tr();
  static String get createNewPin => 'auth.create_new_pin'.tr();
  static String get createPinHint => 'auth.create_pin_hint'.tr();
  static String get confirmPin => 'auth.confirm_pin'.tr();
  static String get confirmPinHint => 'auth.confirm_pin_hint'.tr();
  static String get pinMismatch => 'auth.pin_mismatch'.tr();
  static String get forgotPinNote => 'auth.forgot_note'.tr();
  static String get unlockHint => 'auth.unlock_hint'.tr();
  static String get lockedOutTitle => 'auth.locked_title'.tr();

  /// [time] is the remaining delay as `m:ss`, already shaped for the locale.
  static String lockedOutBody(String time) => 'auth.locked_body'.tr(args: [time]);
  static String get confirmWithPin => 'auth.confirm_with_pin'.tr();
  static String get verifyForChange => 'auth.verify_change'.tr();
  static String get verifyForDisable => 'auth.verify_disable'.tr();
  static String get verifyForClear => 'auth.verify_clear'.tr();
  static String get biometricOptInTitle => 'auth.biometric_opt_in_title'.tr();
  static String get biometricOptInBody => 'auth.biometric_opt_in_body'.tr();
  static String get turnOn => 'auth.turn_on'.tr();
  static String get notNow => 'auth.not_now'.tr();

  // ── Errors ──
  /// Localized message for any [Failure]. Raw exception text never reaches the UI.
  static String failure(Failure failure) => switch (failure) {
    // A backup file that can't be restored (Settings → Restore backup).
    ValidationFailure(field: 'backup') => 'errors.invalid_backup'.tr(),
    ValidationFailure(:final reason) => validation(reason),
    NotFoundFailure() => 'errors.not_found'.tr(),
    ConstraintFailure() => 'errors.constraint'.tr(),
    StorageFailure() => 'errors.storage'.tr(),
    SecureStorageFailure() => failureSecureStorage,
    ExportFailure() => 'errors.export'.tr(),
    UnexpectedFailure() => 'errors.unexpected'.tr(),
  };

  static String get failureSecureStorage => 'errors.secure_storage'.tr();

  static String validation(ValidationReason reason) => switch (reason) {
    ValidationReason.required => 'validation.required'.tr(),
    ValidationReason.tooLong => 'validation.too_long'.tr(),
    ValidationReason.mustBePositive => 'validation.must_be_positive'.tr(),
    ValidationReason.inFuture => 'validation.in_future'.tr(),
    ValidationReason.invalidFormat => 'validation.invalid_format'.tr(),
    ValidationReason.duplicate => 'validation.duplicate'.tr(),
    // Forms pick the wording for their kind with [wrongKind].
    ValidationReason.wrongKind => 'validation.invalid_format'.tr(),
    ValidationReason.inUse => 'categories.kind_in_use'.tr(),
  };
}
