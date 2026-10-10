import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/utils/date_utils.dart';

void main() {
  group('AppDateUtils Tests', () {
    test('formatIsoDate formats DateTime correctly', () {
      final date = DateTime(2026, 10, 10);
      expect(AppDateUtils.formatIsoDate(date), '2026-10-10');

      final dateWithSingleDigit = DateTime(2026, 3, 5);
      expect(AppDateUtils.formatIsoDate(dateWithSingleDigit), '2026-03-05');
    });

    test('todayIsoDate returns formatted date of today or given date', () {
      final mockNow = DateTime(2026, 10, 10, 15, 30);
      expect(AppDateUtils.todayIsoDate(mockNow), '2026-10-10');
    });

    test('parseIsoDate parses valid and invalid strings safely', () {
      final parsed = AppDateUtils.parseIsoDate('2026-10-10');
      expect(parsed, isNotNull);
      expect(parsed!.year, 2026);
      expect(parsed.month, 10);
      expect(parsed.day, 10);

      expect(AppDateUtils.parseIsoDate(null), isNull);
      expect(AppDateUtils.parseIsoDate(''), isNull);
      expect(AppDateUtils.parseIsoDate('invalid-date'), isNull);
    });

    test('daysBetween and daysBetweenIso calculate calendar day difference', () {
      final d1 = DateTime(2026, 10, 10);
      final d2 = DateTime(2026, 10, 15);
      expect(AppDateUtils.daysBetween(d1, d2), 5);
      expect(AppDateUtils.daysBetween(d2, d1), -5);

      expect(AppDateUtils.daysBetweenIso('2026-10-10', '2026-10-15'), 5);
      expect(AppDateUtils.daysBetweenIso('2026-10-15', '2026-10-10'), -5);
      expect(AppDateUtils.daysBetweenIso('bad', '2026-10-15'), 0);
    });

    test('isSameDay and isToday check calendar days', () {
      final d1 = DateTime(2026, 10, 10, 8, 30);
      final d2 = DateTime(2026, 10, 10, 23, 45);
      final d3 = DateTime(2026, 10, 11, 8, 30);

      expect(AppDateUtils.isSameDay(d1, d2), isTrue);
      expect(AppDateUtils.isSameDay(d1, d3), isFalse);

      expect(AppDateUtils.isToday(d1, d2), isTrue);
      expect(AppDateUtils.isToday(d1, d3), isFalse);
    });

    test('getVietnameseWeekday and formatVietnameseDate format correctly', () {
      // 2026-10-10 is a Saturday (DateTime.saturday)
      final sat = DateTime(2026, 10, 10);
      expect(AppDateUtils.getVietnameseWeekday(sat.weekday), 'Thứ Bảy');
      expect(AppDateUtils.formatVietnameseDate(sat), 'Thứ Bảy, 10 Th10');

      final mon = DateTime(2026, 10, 12);
      expect(AppDateUtils.getVietnameseWeekday(mon.weekday), 'Thứ Hai');
      expect(AppDateUtils.formatVietnameseDate(mon), 'Thứ Hai, 12 Th10');
    });
  });
}
