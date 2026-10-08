import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';

/// Read-only aggregates over expenses (Analytics PRD → Data Queries). All
/// streams re-emit when an expense is added, edited or deleted.
abstract interface class IAnalyticsRepository {
  Stream<Either<Failure, Money>> watchTotal(DateRange range);

  /// Sum per category id; categories without spending are absent.
  Stream<Either<Failure, Map<int, Money>>> watchTotalsByCategory(DateRange range);

  /// Sum per day; days without spending are absent.
  Stream<Either<Failure, Map<LocalDate, Money>>> watchDailyTotals(DateRange range);
}
