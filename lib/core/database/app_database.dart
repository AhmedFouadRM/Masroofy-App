import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'package:masroofy/core/database/converters.dart';
import 'package:masroofy/core/database/tables/budgets_table.dart';
import 'package:masroofy/core/database/tables/categories_table.dart';
import 'package:masroofy/core/database/tables/expenses_table.dart';
import 'package:masroofy/core/database/tables/recurring_expenses_table.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/theme/app_colors.dart';

part 'app_database.g.dart';

/// A pre-seeded category. Its display name comes from `categories.<seedKey>`
/// in the translation files.
typedef DefaultCategorySeed = ({String seedKey, String icon, int color});

abstract final class DefaultCategories {
  /// Reassignment target when a custom category is deleted; never deletable.
  static const otherSeedKey = 'other';

  static final List<DefaultCategorySeed> seeds = [
    (seedKey: 'food', icon: 'restaurant', color: AppColors.categoryFood.toARGB32()),
    (seedKey: 'transport', icon: 'directions_car', color: AppColors.categoryTransport.toARGB32()),
    (seedKey: 'shopping', icon: 'shopping_bag', color: AppColors.categoryShopping.toARGB32()),
    (seedKey: 'bills', icon: 'receipt_long', color: AppColors.categoryBills.toARGB32()),
    (seedKey: 'health', icon: 'medical_services', color: AppColors.categoryHealth.toARGB32()),
    (seedKey: 'entertainment', icon: 'movie', color: AppColors.categoryEntertainment.toARGB32()),
    (seedKey: 'education', icon: 'school', color: AppColors.categoryEducation.toARGB32()),
    (seedKey: otherSeedKey, icon: 'more_horiz', color: AppColors.categoryOther.toARGB32()),
  ];
}

@DriftDatabase(
  tables: [
    CategoriesTable,
    ExpensesTable,
    BudgetsTable,
    RecurringExpensesTable,
  ],
)
class AppDatabase extends _$AppDatabase {
  /// Pass an [executor] in tests (e.g. `NativeDatabase.memory()`).
  AppDatabase([QueryExecutor? executor]) : super(executor ?? driftDatabase(name: 'masroofy_db'));

  /// Bump on every schema change and add a step in [migration]. Run
  /// `dart run drift_dev make-migrations` to snapshot the new version and
  /// generate its migration test. Never destructive after the first release.
  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (m) async {
          await m.createAll();
          await seedDefaultCategories();
        },
        beforeOpen: (details) async {
          // SQLite ignores FOREIGN KEY clauses (incl. ON DELETE) unless enabled per connection.
          await customStatement('PRAGMA foreign_keys = ON');
        },
      );

  /// Inserts the default categories that are missing. Safe to call again,
  /// e.g. after "Clear All Data".
  Future<void> seedDefaultCategories() async {
    await batch((batch) {
      for (final (index, seed) in DefaultCategories.seeds.indexed) {
        batch.insert(
          categoriesTable,
          CategoriesTableCompanion.insert(
            seedKey: Value(seed.seedKey),
            icon: seed.icon,
            color: seed.color,
            sortOrder: index,
          ),
          mode: InsertMode.insertOrIgnore,
        );
      }
    });
  }

  /// Rescales every stored amount when the user switches between currencies
  /// with different fraction digits (e.g. EGP 2 → KWD 3), keeping face value.
  /// Runs in one transaction. Dropping digits rounds half away from zero, and
  /// an amount never drops below one minor unit (the columns require > 0).
  Future<void> rescaleAmounts({required int fromDigits, required int toDigits}) async {
    if (fromDigits == toDigits) return;
    int scale(int minor) =>
        Money(minor).rescale(fromDigits: fromDigits, toDigits: toDigits).minor.clamp(1, 1 << 62);

    await transaction(() async {
      for (final row in await select(expensesTable).get()) {
        await (update(expensesTable)..where((t) => t.id.equals(row.id)))
            .write(ExpensesTableCompanion(amountMinor: Value(scale(row.amountMinor))));
      }
      for (final row in await select(recurringExpensesTable).get()) {
        await (update(recurringExpensesTable)..where((t) => t.id.equals(row.id)))
            .write(RecurringExpensesTableCompanion(amountMinor: Value(scale(row.amountMinor))));
      }
      for (final row in await select(budgetsTable).get()) {
        await (update(budgetsTable)..where((t) => t.id.equals(row.id)))
            .write(BudgetsTableCompanion(limitMinor: Value(scale(row.limitMinor))));
      }
    });
  }
}
