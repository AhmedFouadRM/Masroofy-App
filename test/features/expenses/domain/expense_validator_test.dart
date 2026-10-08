import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/expenses/domain/entities/expense.dart';
import 'package:masroofy/features/expenses/domain/validation/expense_validator.dart';

void main() {
  final today = LocalDate(2026, 10, 8);
  final valid = Expense(
    id: 0,
    amount: const Money(1250),
    categoryId: 1,
    date: today,
    createdAt: DateTime.utc(2026, 10, 8),
    updatedAt: DateTime.utc(2026, 10, 8),
  );

  ValidationFailure? validate(Expense expense) => ExpenseValidator.validate(expense, today: today);

  void expectFailure(Expense expense, String field, ValidationReason reason) {
    final failure = validate(expense);
    expect(failure?.field, field);
    expect(failure?.reason, reason);
  }

  test('a minimal expense is valid: title is optional', () {
    expect(validate(valid), isNull);
    expect(validate(valid.copyWith(title: 'Lunch', note: 'with team')), isNull);
  });

  test('title, when given, must be 1–100 characters after trimming', () {
    expectFailure(valid.copyWith(title: '   '), 'title', ValidationReason.required);
    expectFailure(valid.copyWith(title: 'x' * 101), 'title', ValidationReason.tooLong);
    expect(validate(valid.copyWith(title: ' ${'x' * 100} ')), isNull);
  });

  test('amount must be positive', () {
    expectFailure(valid.copyWith(amount: Money.zero), 'amount', ValidationReason.mustBePositive);
    expectFailure(valid.copyWith(amount: const Money(-1)), 'amount', ValidationReason.mustBePositive);
  });

  test('date may be today or earlier, never later', () {
    expect(validate(valid.copyWith(date: today.addDays(-400))), isNull);
    expectFailure(valid.copyWith(date: today.addDays(1)), 'date', ValidationReason.inFuture);
  });

  test('note is capped at 500 characters', () {
    expect(validate(valid.copyWith(note: 'x' * 500)), isNull);
    expectFailure(valid.copyWith(note: 'x' * 501), 'note', ValidationReason.tooLong);
  });
}
