import 'package:flutter_test/flutter_test.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';

void main() {
  group('PeriodTotals', () {
    test('the balance is income minus spending, and can be negative', () {
      expect(const PeriodTotals(income: Money(500000), spent: Money(120000)).balance, const Money(380000));
      expect(const PeriodTotals(income: Money(1000), spent: Money(3000)).balance, const Money(-2000));
      expect(PeriodTotals.zero.balance, Money.zero);
    });

    test('the savings rate is the balance over income, and absent without income', () {
      expect(const PeriodTotals(income: Money(10000), spent: Money(7500)).savingsRate, 0.25);
      expect(const PeriodTotals(income: Money(10000), spent: Money(15000)).savingsRate, -0.5);
      expect(const PeriodTotals(income: Money.zero, spent: Money(15000)).savingsRate, isNull);
    });

    test('compares by value', () {
      expect(
        const PeriodTotals(income: Money(1), spent: Money(2)),
        const PeriodTotals(income: Money(1), spent: Money(2)),
      );
      expect(
        const PeriodTotals(income: Money(1), spent: Money(2)),
        isNot(const PeriodTotals(income: Money(2), spent: Money(1))),
      );
    });
  });

  group('TransactionKind', () {
    test('parses its stored name', () {
      expect(TransactionKind.tryParse('income'), TransactionKind.income);
      expect(TransactionKind.tryParse('expense'), TransactionKind.expense);
      expect(TransactionKind.tryParse('transfer'), isNull);
      expect(TransactionKind.tryParse(null), isNull);
    });

    test('has an opposite', () {
      expect(TransactionKind.income.other, TransactionKind.expense);
      expect(TransactionKind.expense.other, TransactionKind.income);
    });
  });
}
