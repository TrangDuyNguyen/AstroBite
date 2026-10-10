import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/utils/format_utils.dart';

void main() {
  group('FormatUtils Tests', () {
    test('formatCompactNumber handles numbers correctly', () {
      expect(FormatUtils.formatCompactNumber(500), '500');
      expect(FormatUtils.formatCompactNumber(999), '999');
      expect(FormatUtils.formatCompactNumber(1000), '1k');
      expect(FormatUtils.formatCompactNumber(1500), '1.5k');
      expect(FormatUtils.formatCompactNumber(12500), '12.5k');
      expect(FormatUtils.formatCompactNumber(20000), '20k');
    });

    test('formatCalories appends unit correctly', () {
      expect(FormatUtils.formatCalories(2000), '2000 kcal');
      expect(FormatUtils.formatCalories(0), '0 kcal');
    });

    test('formatWeight appends gram unit correctly', () {
      expect(FormatUtils.formatWeight(150), '150g');
      expect(FormatUtils.formatWeight(0), '0g');
    });

    test('formatPercentage formats percentage correctly', () {
      expect(FormatUtils.formatPercentage(0.5), '50%');
      expect(FormatUtils.formatPercentage(0.333), '33%');
      expect(FormatUtils.formatPercentage(1.0), '100%');
    });
  });
}
