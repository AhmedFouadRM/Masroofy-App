import 'package:drift/drift.dart';
import 'package:masroofy/core/domain/local_date.dart';

/// Stores a [LocalDate] as `YYYY-MM-DD` text: sortable, readable in a DB
/// browser, and free of timezone conversion.
class LocalDateConverter extends TypeConverter<LocalDate, String> {
  const LocalDateConverter();

  @override
  LocalDate fromSql(String fromDb) => LocalDate.parse(fromDb);

  @override
  String toSql(LocalDate value) => value.toIso();
}
