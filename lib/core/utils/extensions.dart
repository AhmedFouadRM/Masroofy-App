extension StringExtension on String {
  String capitalize() {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }

  bool get isNotBlank => trim().isNotEmpty;
}

extension DateTimeExtension on DateTime {
  DateTime startOfDay() => DateTime(year, month, day);
  
  DateTime endOfDay() => DateTime(year, month, day, 23, 59, 59, 999);
  
  bool isSameDay(DateTime other) =>
      year == other.year && month == other.month && day == other.day;
}
