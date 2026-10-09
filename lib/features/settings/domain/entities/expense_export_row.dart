import 'package:masroofy/core/domain/local_date.dart';
import 'package:masroofy/core/domain/money.dart';
import 'package:meta/meta.dart';

/// One expense as the CSV export needs it, with its category's name parts
/// (a default category is named from the translation files by [categorySeedKey];
/// a custom one has its own [categoryName]).
@immutable
final class ExpenseExportRow {
  const ExpenseExportRow({
    required this.date,
    required this.amount,
    required this.isRecurring,
    this.title,
    this.categorySeedKey,
    this.categoryName,
    this.note,
  });

  final LocalDate date;
  final Money amount;
  final String? title;
  final String? categorySeedKey;
  final String? categoryName;
  final String? note;

  /// Generated from a recurring template.
  final bool isRecurring;
}
