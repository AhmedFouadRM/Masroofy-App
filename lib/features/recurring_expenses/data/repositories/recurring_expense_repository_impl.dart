import 'package:drift/drift.dart' show Value;
import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/app_database.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/recurring_expenses/data/datasources/recurring_expense_local_datasource.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_draft.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_expense.dart';
import 'package:masroofy/features/recurring_expenses/domain/entities/recurring_frequency.dart';
import 'package:masroofy/features/recurring_expenses/domain/recurring_schedule.dart';
import 'package:masroofy/features/recurring_expenses/domain/repositories/i_recurring_expense_repository.dart';

class RecurringExpenseRepositoryImpl implements IRecurringExpenseRepository {
  RecurringExpenseRepositoryImpl(this._datasource);

  final RecurringExpenseLocalDatasource _datasource;

  @override
  Stream<Either<Failure, List<RecurringExpense>>> watchAll() =>
      _datasource.watchAll().map((rows) => rows.map(_toTemplate).toList()).guarded();

  @override
  Future<Either<Failure, RecurringExpense>> getById(int id) async => (await guardDb(
    () => _datasource.getById(id),
  )).flatMap((row) => row == null ? const Left(Failure.notFound()) : Right(_toTemplate(row)));

  @override
  Future<Either<Failure, LocalDate?>> lastOccurrence(int id) => guardDb(() => _datasource.lastOccurrence(id));

  @override
  Future<Either<Failure, int>> create(RecurringDraft draft, {required LocalDate nextDue}) async {
    final wrongKind = await _wrongKind(draft);
    if (wrongKind != null) return Left(wrongKind);
    return guardDb(
      () => _datasource.insertTemplate(
        RecurringExpensesTableCompanion.insert(
          title: draft.title,
          amountMinor: draft.amount.minor,
          walletId: draft.walletId,
          categoryId: draft.categoryId,
          frequency: draft.frequency.name,
          startDate: draft.startDate,
          nextDueDate: nextDue,
          isActive: Value(draft.isActive),
        ),
      ),
    );
  }

  @override
  Future<Either<Failure, Unit>> update(int id, RecurringDraft draft, {required LocalDate nextDue}) async {
    final wrongKind = await _wrongKind(draft);
    if (wrongKind != null) return Left(wrongKind);
    return (await guardDb(
      () => _datasource.updateTemplate(
        id,
        RecurringExpensesTableCompanion(
          title: Value(draft.title),
          amountMinor: Value(draft.amount.minor),
          walletId: Value(draft.walletId),
          categoryId: Value(draft.categoryId),
          frequency: Value(draft.frequency.name),
          startDate: Value(draft.startDate),
          nextDueDate: Value(nextDue),
          isActive: Value(draft.isActive),
          updatedAt: Value(DateTime.now().toUtc()),
        ),
      ),
    )).flatMap(_oneRowChanged);
  }

  /// The category must be of the draft's kind. A missing category is left to
  /// the foreign key.
  Future<Failure?> _wrongKind(RecurringDraft draft) async {
    final kind = (await guardDb(() => _datasource.categoryKind(draft.categoryId))).getOrElse((_) => null);
    return kind == null || kind == draft.kind.name
        ? null
        : const ValidationFailure(field: 'categoryId', reason: ValidationReason.wrongKind);
  }

  @override
  Future<Either<Failure, Unit>> setActive(int id, {required bool active, required LocalDate nextDue}) async =>
      (await guardDb(
        () => _datasource.updateTemplate(
          id,
          RecurringExpensesTableCompanion(
            isActive: Value(active),
            nextDueDate: Value(nextDue),
            updatedAt: Value(DateTime.now().toUtc()),
          ),
        ),
      )).flatMap(_oneRowChanged);

  @override
  Future<Either<Failure, Unit>> delete(int id) async =>
      (await guardDb(() => _datasource.deleteTemplate(id))).flatMap(_oneRowChanged);

  @override
  Future<Either<Failure, int>> generateDue(
    LocalDate today,
    RecurringPlan Function(RecurringExpense template) plan,
  ) => guardDb(
    () => _datasource.transaction(() async {
      var inserted = 0;
      for (final row in await _datasource.getDue(today)) {
        final template = _toTemplate(row);
        final (:occurrences, :nextDue) = plan(template);
        for (final date in occurrences) {
          final added = await _datasource.insertOccurrence(
            ExpensesTableCompanion.insert(
              title: Value(template.title),
              amountMinor: template.amount.minor,
              walletId: template.walletId,
              categoryId: Value(template.categoryId),
              date: date,
              recurringExpenseId: Value(template.id),
              occurrenceDate: Value(date),
            ),
          );
          if (added) inserted++;
        }
        await _datasource.updateTemplate(template.id, RecurringExpensesTableCompanion(nextDueDate: Value(nextDue)));
      }
      return inserted;
    }),
  );

  static Either<Failure, Unit> _oneRowChanged(int rows) =>
      rows == 1 ? const Right(unit) : const Left(Failure.notFound());

  static RecurringExpense _toTemplate(TemplateRow result) {
    final row = result.template;
    return RecurringExpense(
      id: row.id,
      title: row.title,
      amount: Money(row.amountMinor),
      walletId: row.walletId,
      categoryId: row.categoryId,
      frequency: RecurringFrequency.values.byName(row.frequency),
      startDate: row.startDate,
      nextDueDate: row.nextDueDate,
      isActive: row.isActive,
      createdAt: row.createdAt,
      updatedAt: row.updatedAt,
      kind: TransactionKind.values.byName(result.kind),
    );
  }
}
