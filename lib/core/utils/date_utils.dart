import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DateUtilsHelper {
  DateUtilsHelper._();

  static String formatDate(DateTime date, String locale) {
    return DateFormat.yMMMd(locale).format(date);
  }

  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return date.year == now.year && date.month == now.month && date.day == now.day;
  }

  static bool isYesterday(DateTime date) {
    final yesterday = DateTime.now().subtract(const Duration(days: 1));
    return date.year == yesterday.year && date.month == yesterday.month && date.day == yesterday.day;
  }

  static bool isThisWeek(DateTime date) {
    final now = DateTime.now();
    final startOfWeek = now.subtract(Duration(days: now.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6));
    return date.isAfter(startOfWeek.subtract(const Duration(days: 1))) && 
           date.isBefore(endOfWeek.add(const Duration(days: 1)));
  }

  static DateTimeRange getWeekRange(DateTime date) {
    final startOfWeek = date.subtract(Duration(days: date.weekday - 1));
    final endOfWeek = startOfWeek.add(const Duration(days: 6, hours: 23, minutes: 59, seconds: 59));
    return DateTimeRange(start: startOfWeek, end: endOfWeek);
  }

  static DateTimeRange getMonthRange(DateTime date) {
    final startOfMonth = DateTime(date.year, date.month, 1);
    final endOfMonth = DateTime(date.year, date.month + 1, 0, 23, 59, 59);
    return DateTimeRange(start: startOfMonth, end: endOfMonth);
  }

  static String getDateGroupLabel(DateTime date, String locale) {
    if (isToday(date)) {
      return locale == 'ar' ? 'Ø§Ù„ÙŠÙˆÙ…' : 'Today';
    } else if (isYesterday(date)) {
      return locale == 'ar' ? 'Ø£Ù…Ø³' : 'Yesterday';
    }
    return DateFormat.MMMd(locale).format(date);
  }
}
