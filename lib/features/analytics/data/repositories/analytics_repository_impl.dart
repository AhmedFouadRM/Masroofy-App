import 'package:fpdart/fpdart.dart';
import 'package:masroofy/core/database/db_guard.dart';
import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:masroofy/core/domain/period_totals.dart';
import 'package:masroofy/core/domain/transaction_kind.dart';
import 'package:masroofy/core/error/failures.dart';
import 'package:masroofy/features/analytics/data/datasources/analytics_local_datasource.dart';
import 'package:masroofy/features/analytics/domain/repositories/i_analytics_repository.dart';

class AnalyticsRepositoryImpl implements IAnalyticsRepository {
  AnalyticsRepositoryImpl(this._datasource);

  final AnalyticsLocalDatasource _datasource;

  @override
  Stream<Either<Failure, PeriodTotals>> watchTotals(DateRange range, {int? walletId}) =>
      _datasource.watchTotals(range, walletId: walletId).map(_toTotals).guarded();

  @override
  Stream<Either<Failure, Map<int, Money>>> watchTotalsByCategory(
    DateRange range,
    TransactionKind kind, {
    int? walletId,
  }) => _datasource
      .watchTotalsByCategory(range, kind, walletId: walletId)
      .map((totals) => totals.map((id, minor) => MapEntry(id, Money(minor))))
      .guarded();

  @override
  Stream<Either<Failure, Map<int, PeriodTotals>>> watchTotalsByWallet(DateRange range) => _datasource
      .watchTotalsByWallet(range)
      .map((totals) => totals.map((id, minor) => MapEntry(id, _toTotals(minor))))
      .guarded();

  @override
  Stream<Either<Failure, Map<LocalDate, PeriodTotals>>> watchDailyTotals(DateRange range, {int? walletId}) =>
      _datasource
          .watchDailyTotals(range, walletId: walletId)
          .map((totals) => totals.map((date, minor) => MapEntry(date, _toTotals(minor))))
          .guarded();

  static PeriodTotals _toTotals(MinorTotals totals) => PeriodTotals(
    income: Money(totals.income),
    spent: Money(totals.spent),
    transfersIn: Money(totals.transfersIn),
    transfersOut: Money(totals.transfersOut),
  );
}
