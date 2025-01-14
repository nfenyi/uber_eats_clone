import 'package:flutter/material.dart';

class AppFunctions {
  static String formatTime(TimeOfDay time) {
    // final formattedHour = time.hourOfPeriod.toString().padLeft(2, '0');
    final formattedMinute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${time.hourOfPeriod}:$formattedMinute $period';
  }
}
