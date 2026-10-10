/// Pure date and time utility functions for AstroBite.
/// All functions are deterministic pure functions with zero side-effects.
library;

class AppDateUtils {
  const AppDateUtils._();

  /// Formats a [DateTime] into standard ISO-8601 date string (`yyyy-MM-dd`).
  static String formatIsoDate(DateTime date) {
    final y = date.year.toString().padLeft(4, '0');
    final m = date.month.toString().padLeft(2, '0');
    final d = date.day.toString().padLeft(2, '0');
    return '$y-$m-$d';
  }

  /// Returns today's date in `yyyy-MM-dd` format.
  static String todayIsoDate([DateTime? now]) {
    return formatIsoDate(now ?? DateTime.now());
  }

  /// Parses a `yyyy-MM-dd` string safely into a [DateTime].
  /// Returns `null` if the string cannot be parsed.
  static DateTime? parseIsoDate(String? isoString) {
    if (isoString == null || isoString.trim().isEmpty) return null;
    return DateTime.tryParse(isoString);
  }

  /// Calculates calendar day difference between two `yyyy-MM-dd` strings.
  static int daysBetweenIso(String date1, String date2) {
    final d1 = parseIsoDate(date1);
    final d2 = parseIsoDate(date2);
    if (d1 == null || d2 == null) return 0;
    return daysBetween(d1, d2);
  }

  /// Calculates calendar day difference between two [DateTime] objects.
  static int daysBetween(DateTime d1, DateTime d2) {
    final cleanD1 = DateTime(d1.year, d1.month, d1.day);
    final cleanD2 = DateTime(d2.year, d2.month, d2.day);
    return cleanD2.difference(cleanD1).inDays;
  }

  /// Checks if two [DateTime] objects represent the exact same calendar day.
  static bool isSameDay(DateTime a, DateTime b) {
    return a.year == b.year && a.month == b.month && a.day == b.day;
  }

  /// Checks if a [DateTime] represents today.
  static bool isToday(DateTime date, [DateTime? now]) {
    final current = now ?? DateTime.now();
    return isSameDay(date, current);
  }

  /// Returns Vietnamese weekday name (1 = Monday ... 7 = Sunday).
  static String getVietnameseWeekday(int weekday) {
    return switch (weekday) {
      DateTime.monday => 'Thứ Hai',
      DateTime.tuesday => 'Thứ Ba',
      DateTime.wednesday => 'Thứ Tư',
      DateTime.thursday => 'Thứ Năm',
      DateTime.friday => 'Thứ Sáu',
      DateTime.saturday => 'Thứ Bảy',
      DateTime.sunday => 'Chủ Nhật',
      _ => '',
    };
  }

  /// Formats date for Vietnamese display (e.g. `Thứ Hai, 10 Th10`).
  static String formatVietnameseDate(DateTime date) {
    final weekdayStr = getVietnameseWeekday(date.weekday);
    final dayStr = date.day.toString().padLeft(2, '0');
    final monthStr = date.month.toString().padLeft(2, '0');
    return '$weekdayStr, $dayStr Th$monthStr';
  }
}
