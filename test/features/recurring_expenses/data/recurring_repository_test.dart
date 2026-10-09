import 'package:drift/drift.dart' hide isNotNull, isNull;
import 'package:drift/native.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/categories/data/datasources/category_local_datasource.dart';
import 'package:masroofy/features/recurring_expenses/data/datasources/recurring_expense_local_datasource.dart';
import 'package:masroofy/features/recurring_expenses/data/repositories/recurring_expense_repository_impl.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_draft.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/delete_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/process_due_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/save_recurring.dart';
import 'package:masroofy/features/recurring_expenses/domain/usecases/set_recurring_active.dart';

void main() {
  late AppDatabase db;
  late RecurringExpenseRepositoryImpl repository;
  late LocalDate today;
  late ProcessDueRecurring process;
  late SaveRecurring save;
  late SetRecurringActive setActive;
  late int bills;

  setUp(() async {
    driftRuntimeOptions.dontWarnAboutMultipleDatabases = true;
    db = AppDatabase(NativeDatabase.memory());
    repository = RecurringExpenseRepositoryImpl(RecurringExpenseLocalDatasource(db));
    today = LocalDate(2026, 10, 9);
    process = ProcessDueRecurring(repository, today: () => today);
    save = SaveRecurring(repository, process, today: () => today);
    setActive = SetRecurringActive(repository, process, today: () => today);
    bills = (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals('bills'))).getSingle()).id;
  });
  tearDown(() => db.close());

  T right<T>(Either<Failure, T> result) => result.getOrElse((f) => fail('expected Right, got $f'));

  Future<int> add(
    LocalDate start, {
    RecurringFrequency frequency = RecurringFrequency.monthly,
    String title = 'Rent',
  }) async => right(
    await save(
      RecurringDraft(
        title: title,
        amount: const Money(500000),
        categoryId: bills,
        frequency: frequency,
        startDate: start,
      ),
    ),
  );

  Future<List<LocalDate>> generatedDates(int templateId) async {
    final rows =
        await (db.select(db.expensesTable)
              ..where((e) => e.recurringExpenseId.equals(templateId))
              ..orderBy([(e) => OrderingTerm.asc(e.date)]))
            .get();
    return [for (final row in rows) row.date];
  }

  test('saving with a past start back-fills, and a future start waits', () async {
    final past = await add(LocalDate(2026, 8, 9));
    final future = await add(LocalDate(2026, 11, 1), title: 'Gym');

    expect(await generatedDates(past), [LocalDate(2026, 8, 9), LocalDate(2026, 9, 9), today]);
    expect(right(await repository.getById(past)).nextDueDate, LocalDate(2026, 11, 9));
    expect(await generatedDates(future), isEmpty);
    expect(right(await repository.getById(future)).nextDueDate, LocalDate(2026, 11, 1));
  });

  test('generated expenses copy the template and carry the occurrence', () async {
    final id = await add(today);
    final row = await (db.select(db.expensesTable)..where((e) => e.recurringExpenseId.equals(id))).getSingle();
    expect(
      (row.title, row.amountMinor, row.categoryId, row.date, row.occurrenceDate),
      (
        'Rent',
        500000,
        bills,
        today,
        today,
      ),
    );
  });

  test('running generation twice, or concurrently, creates no duplicates', () async {
    final id = await add(LocalDate(2026, 9, 9));
    // Force the template due again, as if the due-date update had been lost.
    await (db.update(
      db.recurringExpensesTable,
    )..where((r) => r.id.equals(id))).write(RecurringExpensesTableCompanion(nextDueDate: Value(LocalDate(2026, 9, 9))));

    final results = await Future.wait([process(), process()]);
    expect(results.map(right), [0, 0]);
    expect(right(await process()), 0);
    expect(await generatedDates(id), [LocalDate(2026, 9, 9), today]);
  });

  test('generation picks up new due dates as days pass', () async {
    final id = await add(today, frequency: RecurringFrequency.daily);
    today = today.addDays(3);
    expect(right(await process()), 3);
    expect(await generatedDates(id), hasLength(4));
  });

  test('a paused template generates nothing, and resuming skips the pause', () async {
    final id = await add(LocalDate(2026, 9, 1));
    expect(await generatedDates(id), [LocalDate(2026, 9, 1), LocalDate(2026, 10, 1)]);

    right(await setActive(id, active: false));
    today = LocalDate(2027, 1, 10);
    expect(right(await process()), 0);

    right(await setActive(id, active: true));
    expect(await generatedDates(id), [LocalDate(2026, 9, 1), LocalDate(2026, 10, 1)]);
    expect(right(await repository.getById(id)).nextDueDate, LocalDate(2027, 2, 1));
  });

  test('editing the amount keeps the schedule; editing the frequency re-anchors it', () async {
    final id = await add(LocalDate(2026, 9, 9));
    final template = right(await repository.getById(id));
    final draft = RecurringDraft(
      title: template.title,
      amount: const Money(600000),
      categoryId: bills,
      frequency: RecurringFrequency.monthly,
      startDate: template.startDate,
    );

    right(await save(draft, id: id));
    expect(right(await repository.getById(id)).nextDueDate, LocalDate(2026, 11, 9));

    right(await save(draft.copyWith(frequency: RecurringFrequency.weekly), id: id));
    // First weekly occurrence after the last generated one (today).
    expect(right(await repository.getById(id)).nextDueDate, LocalDate(2026, 10, 14));
    expect(await generatedDates(id), [LocalDate(2026, 9, 9), today]);
  });

  group('income templates', () {
    late int salary;

    setUp(() async {
      salary = (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals('salary'))).getSingle()).id;
    });

    Future<Either<Failure, int>> addSalary({TransactionKind kind = TransactionKind.income, int? category}) => save(
      RecurringDraft(
        title: 'Salary',
        amount: const Money(1500000),
        categoryId: category ?? salary,
        frequency: RecurringFrequency.monthly,
        startDate: LocalDate(2026, 8, 25),
        kind: kind,
      ),
    );

    test('a monthly Salary template generates income rows on its due dates', () async {
      final id = right(await addSalary());

      expect(right(await repository.getById(id)).kind, TransactionKind.income);
      expect(await generatedDates(id), [LocalDate(2026, 8, 25), LocalDate(2026, 9, 25)]);
      final rows = await db.select(db.expensesTable).get();
      expect(rows.map((r) => (r.categoryId, r.amountMinor)), [(salary, 1500000), (salary, 1500000)]);
      // The rows are income: their category says so.
      final incomeRows = await (db.select(db.expensesTable).join([
        innerJoin(db.categoriesTable, db.categoriesTable.id.equalsExp(db.expensesTable.categoryId)),
      ])..where(db.categoriesTable.kind.equals('income'))).get();
      expect(incomeRows, hasLength(2));
    });

    test('a template must match its category kind', () async {
      expect(
        (await addSalary(kind: TransactionKind.expense)).getLeft().toNullable(),
        const Failure.validation(field: 'categoryId', reason: ValidationReason.wrongKind),
      );
      expect(
        (await addSalary(category: bills)).getLeft().toNullable(),
        const Failure.validation(field: 'categoryId', reason: ValidationReason.wrongKind),
      );
    });
  });

  test('deleting a template keeps its expenses and their badge', () async {
    final id = await add(today);
    right(await DeleteRecurring(repository)(id));

    final rows = await db.select(db.expensesTable).get();
    expect(rows, hasLength(1));
    expect((rows.single.recurringExpenseId, rows.single.occurrenceDate), (null, today));
  });

  test('deleting a category moves its templates to Other', () async {
    final categories = CategoryLocalDatasource(db);
    final custom = await categories.insertCategory(
      name: 'Gym',
      icon: 'fitness_center',
      color: 0xFF000000,
      kind: 'expense',
    );
    final id = right(
      await save(
        RecurringDraft(
          title: 'Gym',
          amount: const Money(1),
          categoryId: custom,
          frequency: RecurringFrequency.monthly,
          startDate: LocalDate(2026, 12, 1),
        ),
      ),
    );
    await categories.deleteCategory(custom);
    final other = (await (db.select(db.categoriesTable)..where((c) => c.seedKey.equals('other'))).getSingle()).id;
    expect(right(await repository.getById(id)).categoryId, other);
  });

  test('rejects an empty title', () async {
    final result = await save(
      RecurringDraft(
        title: '  ',
        amount: const Money(1),
        categoryId: bills,
        frequency: RecurringFrequency.monthly,
        startDate: today,
      ),
    );
    expect(result.getLeft().toNullable(), const Failure.validation(field: 'title', reason: ValidationReason.required));
  });
}
