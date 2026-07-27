import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/utils/json_parser.dart';

void main() {
  group('JsonParser.tryParseGeminiResponse', () {
    test('parses clean JSON directly', () {
      const raw = '{"is_food": true, "total_calories": 500}';
      final result = JsonParser.tryParseGeminiResponse(raw);
      expect(result, isNotNull);
      expect(result!['is_food'], true);
      expect(result['total_calories'], 500);
    });

    test('strips markdown code fences', () {
      const raw = '```json\n{"is_food": true}\n```';
      final result = JsonParser.tryParseGeminiResponse(raw);
      expect(result, isNotNull);
      expect(result!['is_food'], true);
    });

    test('extracts JSON from surrounding text', () {
      const raw = 'Here is the result: {"is_food": false} Hope this helps!';
      final result = JsonParser.tryParseGeminiResponse(raw);
      expect(result, isNotNull);
      expect(result!['is_food'], false);
    });

    test('returns null for completely invalid input', () {
      const raw = 'This is not JSON at all';
      final result = JsonParser.tryParseGeminiResponse(raw);
      expect(result, isNull);
    });

    test('returns null for empty string', () {
      final result = JsonParser.tryParseGeminiResponse('');
      expect(result, isNull);
    });
  });
}
