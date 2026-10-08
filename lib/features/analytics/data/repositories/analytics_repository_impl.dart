import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:masroofy/features/analytics/domain/repositories/i_analytics_repository.dart';

class AnalyticsRepositoryImpl implements IAnalyticsRepository {
  AnalyticsRepositoryImpl(this._datasource);

  final AnalyticsLocalDatasource _datasource;

  @override
  Stream<Either<Failure, Money>> watchTotal(DateRange range) => _datasource.watchTotal(range).map(Money.new).guarded();

  @override
  Stream<Either<Failure, Map<int, Money>>> watchTotalsByCategory(DateRange range) => _datasource
      .watchTotalsByCategory(range)
      .map((totals) => totals.map((id, minor) => MapEntry(id, Money(minor))))
      .guarded();

  @override
  Stream<Either<Failure, Map<LocalDate, Money>>> watchDailyTotals(DateRange range) => _datasource
      .watchDailyTotals(range)
      .map((totals) => totals.map((date, minor) => MapEntry(date, Money(minor))))
      .guarded();
}
