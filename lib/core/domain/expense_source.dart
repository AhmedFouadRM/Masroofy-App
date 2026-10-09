/// How an `expenses` row came to be. Stored as its [name] in `expenses.source`.
enum ExpenseSource {
  /// Typed in by the user.
  manual,

  /// Added from a bank SMS (SMS Import).
  sms,

  /// Generated from a recurring template.
  recurring;

  /// Parses a stored value; [manual] for anything unknown.
  static ExpenseSource parse(String? name) => values.asNameMap()[name] ?? manual;
}
