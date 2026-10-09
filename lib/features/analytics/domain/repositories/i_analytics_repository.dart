import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';

/// Read-only aggregates over transactions (Analytics PRD → Data Queries). All
/// streams re-emit when a transaction is added, edited or deleted. Spending
/// is the sum over expense categories only, so income never changes it.
abstract interface class IAnalyticsRepository {
  Stream<Either<Failure, PeriodTotals>> watchTotals(DateRange range);

  /// Sum per category id for categories of [kind]; categories without
  /// transactions are absent.
  Stream<Either<Failure, Map<int, Money>>> watchTotalsByCategory(DateRange range, TransactionKind kind);

  /// Income and spending per day; days without transactions are absent.
  Stream<Either<Failure, Map<LocalDate, PeriodTotals>>> watchDailyTotals(DateRange range);
}
