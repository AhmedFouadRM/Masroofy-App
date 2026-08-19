import 'package:drift/drift.dart';
import 'package:drift_flutter/drift_flutter.dart';
import 'tables/categories_table.dart';
import 'tables/expenses_table.dart';
import 'tables/budgets_table.dart';
import 'tables/recurring_expenses_table.dart';

part 'app_database.g.dart';

@DriftDatabase(tables: [
  CategoriesTable,
  ExpensesTable,
  BudgetsTable,
  RecurringExpensesTable,
])
class AppDatabase extends _$AppDatabase {
  AppDatabase() : super(driftDatabase(name: 'masroofy_db'));

  @override
  int get schemaVersion => 1;

  @override
  MigrationStrategy get migration => MigrationStrategy(
        onCreate: (Migrator m) async {
          await m.createAll();
          await _seedDefaultCategories();
        },
      );

  Future<void> _seedDefaultCategories() async {
    final defaultCategories = [
      CategoriesTableCompanion.insert(
        nameEn: 'Food & Dining',
        nameAr: const Value('Ø·Ø¹Ø§Ù… ÙˆÙ…Ø·Ø§Ø¹Ù…'),
        icon: 'restaurant',
        color: 0xFFFF7043,
        isDefault: const Value(true),
      ),
      CategoriesTableCompanion.insert(
        nameEn: 'Transportation',
        nameAr: const Value('Ù…ÙˆØ§ØµÙ„Ø§Øª'),
        icon: 'directions_car',
        color: 0xFF42A5F5,
        isDefault: const Value(true),
      ),
      CategoriesTableCompanion.insert(
        nameEn: 'Shopping',
        nameAr: const Value('ØªØ³ÙˆÙ‚'),
        icon: 'shopping_cart',
        color: 0xFFAB47BC,
        isDefault: const Value(true),
      ),
      CategoriesTableCompanion.insert(
        nameEn: 'Bills & Utilities',
        nameAr: const Value('ÙÙˆØ§ØªÙŠØ± ÙˆØ®Ø¯Ù…Ø§Øª'),
        icon: 'receipt',
        color: 0xFFFFA726,
        isDefault: const Value(true),
      ),
      CategoriesTableCompanion.insert(
        nameEn: 'Health & Fitness',
        nameAr: const Value('ØµØ­Ø© ÙˆÙ„ÙŠØ§Ù‚Ø©'),
        icon: 'fitness_center',
        color: 0xFFEF5350,
        isDefault: const Value(true),
      ),
      CategoriesTableCompanion.insert(
        nameEn: 'Entertainment',
        nameAr: const Value('ØªØ±ÙÙŠÙ‡'),
        icon: 'movie',
        color: 0xFF26C6DA,
        isDefault: const Value(true),
      ),
      CategoriesTableCompanion.insert(
        nameEn: 'Education',
        nameAr: const Value('ØªØ¹Ù„ÙŠÙ…'),
        icon: 'school',
        color: 0xFF5C6BC0,
        isDefault: const Value(true),
      ),
      CategoriesTableCompanion.insert(
        nameEn: 'Other',
        nameAr: const Value('Ø£Ø®Ø±Ù‰'),
        icon: 'category',
        color: 0xFF78909C,
        isDefault: const Value(true),
      ),
    ];

    for (final category in defaultCategories) {
      await into(categoriesTable).insert(category);
    }
  }
}
