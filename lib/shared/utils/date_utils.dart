import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class WeddingDateUtils {
  static final DateFormat _fullFormat = DateFormat('EEEE, d MMMM yyyy', 'id_ID');
  static final DateFormat _monthYearFormat = DateFormat('MMMM yyyy', 'id_ID');
  static final DateFormat _shortFormat = DateFormat('d MMM yyyy', 'id_ID');
  static final DateFormat _timeFormat = DateFormat('HH:mm', 'id_ID');

  /// Formats epoch millis into "Sabtu, 3 Oktober 2026"
  static String formatFull(int epochMillis) {
    if (epochMillis <= 0) return '-';
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMillis);
    try {
      return _fullFormat.format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  /// Formats epoch millis into "Oktober 2026"
  static String formatMonthYear(int epochMillis) {
    if (epochMillis <= 0) return '-';
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMillis);
    try {
      return _monthYearFormat.format(dt);
    } catch (_) {
      return '${dt.month}/${dt.year}';
    }
  }

  /// Formats epoch millis into "3 Okt 2026"
  static String formatShort(int epochMillis) {
    if (epochMillis <= 0) return '-';
    final dt = DateTime.fromMillisecondsSinceEpoch(epochMillis);
    try {
      return _shortFormat.format(dt);
    } catch (_) {
      return '${dt.day}/${dt.month}/${dt.year}';
    }
  }

  /// Formats DateTime or epoch into "08:00"
  static String formatTime(DateTime dt) {
    return _timeFormat.format(dt);
  }

  /// Parses "08:00" into TimeOfDay
  static TimeOfDay parseTime(String hhmm) {
    try {
      final parts = hhmm.split(':');
      if (parts.length >= 2) {
        return TimeOfDay(
          hour: int.tryParse(parts[0]) ?? 8,
          minute: int.tryParse(parts[1]) ?? 0,
        );
      }
    } catch (_) {}
    return const TimeOfDay(hour: 8, minute: 0);
  }

  /// Formats TimeOfDay to "08:00"
  static String formatTimeOfDay(TimeOfDay time) {
    final h = time.hour.toString().padLeft(2, '0');
    final m = time.minute.toString().padLeft(2, '0');
    return '$h:$m';
  }

  /// Epoch millis at start of today (midnight)
  static int todayMillis() {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day).millisecondsSinceEpoch;
  }

  /// Days until event from today (negative if past)
  static int daysUntil(int targetEpochMillis) {
    if (targetEpochMillis <= 0) return 0;
    final target = DateTime.fromMillisecondsSinceEpoch(targetEpochMillis);
    final targetMidnight = DateTime(target.year, target.month, target.day);
    
    final now = DateTime.now();
    final todayMidnight = DateTime(now.year, now.month, now.day);
    
    return targetMidnight.difference(todayMidnight).inDays;
  }
}
