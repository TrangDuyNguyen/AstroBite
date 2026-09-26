import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/genui/a2ui_parser.dart';

void main() {
  group('A2uiParser Unit Tests', () {
    test('parses pure JSON with A2UI components', () {
      const raw = '''
{
  "surface": "chat_cockpit",
  "text": "Đây là thực đơn cho bạn:",
  "components": [
    {
      "id": "comp_1",
      "type": "MealQuickLogCard",
      "props": {
        "dishName": "Ức gà luộc",
        "calories": 200,
        "protein": 40.0,
        "carbs": 0.0,
        "fat": 3.0,
        "weightG": 150
      }
    }
  ]
}
''';
      final payload = A2uiParser.parse(raw);
      expect(payload.hasComponents, isTrue);
      expect(payload.text, 'Đây là thực đơn cho bạn:');
      expect(payload.components.length, 1);
      expect(payload.components.first.type, 'MealQuickLogCard');
      expect(payload.components.first.props['dishName'], 'Ức gà luộc');
      expect(payload.components.first.props['calories'], 200);
    });

    test('parses fenced ```a2ui code block and preserves leading text', () {
      const raw = '''
Bữa trưa hôm nay của bạn rất thanh đạm!
```a2ui
{
  "components": [
    {
      "id": "comp_2",
      "type": "MacroBudgetGauge",
      "props": {
        "projectedCalories": 350,
        "remainingCalories": 500,
        "targetCalories": 2000
      }
    }
  ]
}
```
''';
      final payload = A2uiParser.parse(raw);
      expect(payload.hasComponents, isTrue);
      expect(payload.text, contains('Bữa trưa hôm nay của bạn rất thanh đạm!'));
      expect(payload.components.first.type, 'MacroBudgetGauge');
      expect(payload.components.first.props['projectedCalories'], 350);
    });

    test('parses hidden HTML comment <!--a2ui:{...}-->', () {
      const raw = 'Gợi ý cho bạn món salad: <!--a2ui:{"components":[{"id":"c3","type":"QuickChoiceChips","props":{"chips":[{"label":"Ăn salad","payload":"Tôi chọn salad"}]}}]}-->';
      final payload = A2uiParser.parse(raw);
      expect(payload.hasComponents, isTrue);
      expect(payload.text, 'Gợi ý cho bạn món salad:');
      expect(payload.components.first.type, 'QuickChoiceChips');
    });

    test('backward compatibility with legacy ```astrobite-meal code block', () {
      const raw = '''
Món gợi ý:
```astrobite-meal
{
  "dishName": "Trứng ốp la",
  "calories": 150,
  "protein": 12,
  "carbs": 1,
  "fat": 10,
  "mealType": "breakfast"
}
```
''';
      final payload = A2uiParser.parse(raw);
      expect(payload.hasComponents, isTrue);
      expect(payload.components.first.type, 'MealQuickLogCard');
      expect(payload.components.first.props['dishName'], 'Trứng ốp la');
      expect(payload.components.first.props['calories'], 150);
    });

    test('gracefully falls back to plain text when input is standard text', () {
      const raw = 'Uống nhiều nước hơn nhé, bạn cần ít nhất 2 lít nước mỗi ngày.';
      final payload = A2uiParser.parse(raw);
      expect(payload.hasComponents, isFalse);
      expect(payload.text, raw);
    });

    test('gracefully handles broken/malformed JSON without crashing', () {
      const raw = '```a2ui { "broken": [unclosed } ```';
      final payload = A2uiParser.parse(raw);
      expect(payload.hasComponents, isFalse);
      expect(payload.text, contains('```a2ui'));
    });
  });
}
