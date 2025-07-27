import 'package:flutter/material.dart';

class TimeFormatter {
  /// Converts [TimeOfDay] to a readable 12-hour format like "03:45 PM"
  static String format(TimeOfDay time) {
    final hour = time.hourOfPeriod == 0 ? 12 : time.hourOfPeriod;
    final minute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  static int calculateDurationFromTimeOfDay(TimeOfDay? startTime, TimeOfDay? endTime) {
    if (startTime == null || endTime == null) return 0;

    try {
      // Convert TimeOfDay to minutes since midnight
      final startMinutes = startTime.hour * 60 + startTime.minute;
      final endMinutes = endTime.hour * 60 + endTime.minute;

      // Calculate difference
      int difference = endMinutes - startMinutes;

      // Handle case where end time is next day (rare but possible)
      if (difference < 0) {
        difference += 24 * 60; // Add 24 hours in minutes
      }

      return difference;
    } catch (e) {
      debugPrint('Error calculating duration: $e');
      return 0;
    }
  }

  static DateTime? safeParseDate(dynamic input) {
    if (input == null) return null;
    try {
      if (input is DateTime) return input;
      if (input is String && input.trim().isNotEmpty) {
        return DateTime.tryParse(input);
      }
    } catch (_) {}
    return null;
  }



}


