/// Whether a category (and so every transaction in it) is money going out or
/// coming in. Stored as its [name] in `categories.kind`.
enum TransactionKind {
  expense,
  income;

  /// The other kind.
  TransactionKind get other => this == expense ? income : expense;

  /// Parses a stored value; `null` for anything but `expense` or `income`.
  static TransactionKind? tryParse(String? name) => values.asNameMap()[name];
}
