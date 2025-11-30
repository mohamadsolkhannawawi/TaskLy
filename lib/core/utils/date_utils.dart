// filepath: d:\Code\PBP\Mobile\Flutter\todolist\lib\core\utils\date_utils.dart

/// Custom Date Utilities for Task Management
class DateUtils {
  /// Check if a date is today
  static bool isToday(DateTime date) {
    final now = DateTime.now();
    return isSameDay(date, now);
  }

  /// Check if a date is tomorrow
  static bool isTomorrow(DateTime date) {
    final tomorrow = DateTime.now().add(const Duration(days: 1));
    return isSameDay(date, tomorrow);
  }

  /// Check if two dates are the same day (ignoring time)
  static bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  /// Remove time from DateTime (set to midnight)
  static DateTime dateOnly(DateTime date) {
    return DateTime(date.year, date.month, date.day);
  }

  /// Get start of today
  static DateTime get todayStart {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day);
  }

  /// Get end of today
  static DateTime get todayEnd {
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, 23, 59, 59);
  }

  /// Check if date is in the past
  static bool isPast(DateTime date) {
    return dateOnly(date).isBefore(todayStart);
  }

  /// Check if date is in the future
  static bool isFuture(DateTime date) {
    return dateOnly(date).isAfter(todayStart);
  }
}

