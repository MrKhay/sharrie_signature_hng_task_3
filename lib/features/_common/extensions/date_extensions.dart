import 'dart:math';

import 'package:flutter/material.dart';

/// DateTime Extension
extension DateTimeFormatter on DateTime {
  String formatTime() {
    final int hour = this.hour > 12 ? this.hour - 12 : this.hour;
    final String minute = this.minute.toString().padLeft(2, '0');
    final String period = this.hour < 12 ? 'am' : 'pm';
    return '$hour:$minute $period';
  }

  String formatAttendanceDateTime() {
    final DateTime now = DateTime.now();
    final Duration difference = now.difference(this);

    if (difference.inSeconds < 60) {
      return '${difference.inSeconds} second${difference.inSeconds == 1 ? '' : 's'} ago';
    } else if (difference.inMinutes < 60) {
      return '${difference.inMinutes} minute${difference.inMinutes == 1 ? '' : 's'} ago';
    } else if (difference.inHours < 24) {
      return '${difference.inHours} hour${difference.inHours == 1 ? '' : 's'} ago';
    } else if (difference.inDays == 1) {
      return 'Yesterday at ${formatTime()}';
    } else if (difference.inDays < 7) {
      return '${_formatWeekday(weekday)} at ${formatTime()}';
    } else if (difference.inDays < 30) {
      return '${difference.inDays} days ago';
    } else if (difference.inDays < 365) {
      return '${_formatMonth(month)} $day';
    } else {
      return '${_formatMonth(month)} $day, $year';
    }
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  String formatDateTime() {
    return ' ${_formatMonth(month)} $day';
  }

  String _formatMonth(int month) {
    switch (month) {
      case 1:
        return 'January';
      case 2:
        return 'February';
      case 3:
        return 'March';
      case 4:
        return 'April';
      case 5:
        return 'May';
      case 6:
        return 'June';
      case 7:
        return 'July';
      case 8:
        return 'August';
      case 9:
        return 'September';
      case 10:
        return 'October';
      case 11:
        return 'November';
      case 12:
        return 'December';
      default:
        return '';
    }
  }

  String _formatWeekday(int weekday) {
    switch (weekday) {
      case 1:
        return 'Monday';
      case 2:
        return 'Tuesday';
      case 3:
        return 'Wednesday';
      case 4:
        return 'Thursday';
      case 5:
        return 'Friday';
      case 6:
        return 'Saturday';
      case 7:
        return 'Sunday';
      default:
        return '';
    }
  }
}

int generateRandomColor() {
  final List<MaterialColor> colors = <MaterialColor>[...Colors.primaries];

  final MaterialColor color = colors[Random().nextInt(colors.length)];

  return color.value;
}
