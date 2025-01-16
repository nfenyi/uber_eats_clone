import 'package:date_time_format/date_time_format.dart';
import 'package:flutter/material.dart';

import 'presentation/constants/other_constants.dart';

class AppFunctions {
  static String formatTime(TimeOfDay time) {
    // final formattedHour = time.hourOfPeriod.toString().padLeft(2, '0');
    final formattedMinute = time.minute.toString().padLeft(2, '0');
    final period = time.period == DayPeriod.am ? 'AM' : 'PM';
    return '${time.hourOfPeriod}:$formattedMinute $period';
  }

  static String formatDate(String date, {String format = 'd/m/Y'}) {
    return date == OtherConstants.na || date == 'null' || date.isEmpty
        ? OtherConstants.na
        : date == '--'
            ? '--'
            : DateTimeFormat.format(DateTime.parse(date), format: format);
  }
}
