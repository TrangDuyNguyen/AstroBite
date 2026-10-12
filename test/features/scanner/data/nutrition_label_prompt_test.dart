import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/scanner/data/nutrition_label_prompt.dart';

void main() {
  group('NutritionLabelPrompt System Instruction Tests', () {
    test('contains mandatory json schema fields and OCR instructions', () {
      const prompt = NutritionLabelPrompt.systemPrompt;

      expect(prompt, contains('is_food'));
      expect(prompt, contains('total_calories'));
      expect(prompt, contains('protein_g'));
      expect(prompt, contains('carbs_g'));
      expect(prompt, contains('fat_g'));
      expect(prompt, contains('sodium_mg'));
      expect(prompt, contains('barcode'));
      expect(prompt, contains('serving_size'));
      expect(prompt, contains('dishes'));
      expect(prompt, contains('nutrition facts'));
    });
  });
}
