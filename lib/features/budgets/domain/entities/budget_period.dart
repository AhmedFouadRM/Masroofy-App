import 'package:masroofy/core/domain/date_range.dart';
import 'package:masroofy/core/domain/local_date.dart';

/// How long a budget's window is. Stored by [name] (`weekly`, `monthly`).
enum BudgetPeriod {
  weekly,
  monthly;

  /// The **current** window containing [today] (Budgets PRD → Period Window
  /// Calculation): the calendar week from the region's [firstWeekday]
  /// (`DateTime.weekday` numbering), or the calendar month.
  DateRange windowFor(LocalDate today, {required int firstWeekday}) => switch (this) {
    weekly => DateRange(today.startOfWeek(firstWeekday), today.startOfWeek(firstWeekday).addDays(6)),
    monthly => DateRange(today.startOfMonth, today.endOfMonth),
  };
}
