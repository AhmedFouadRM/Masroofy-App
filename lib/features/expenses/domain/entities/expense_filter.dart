import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:masroofy/core/domain/date_range.dart';

part 'expense_filter.freezed.dart';

/// What the expense list shows: a date range, optionally one category and a
/// search over title and note (case-insensitive).
@freezed
abstract class ExpenseFilter with _$ExpenseFilter {
  const factory ExpenseFilter({
    required DateRange range,
    int? categoryId,
    String? search,
  }) = _ExpenseFilter;

  const ExpenseFilter._();

  /// The search text trimmed, or null when there is nothing to search for.
  String? get searchText {
    final text = search?.trim();
    return text == null || text.isEmpty ? null : text;
  }
}
