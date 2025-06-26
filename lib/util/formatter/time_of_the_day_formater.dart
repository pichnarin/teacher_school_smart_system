import 'package:flutter/material.dart';

class TimeFormatter {
  /// Converts [TimeOfDay] to a readable 12-hour format like "03:45 PM"
  static String format(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }
}
