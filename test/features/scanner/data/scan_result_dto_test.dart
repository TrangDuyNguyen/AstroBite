import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/scanner/data/models/scan_result_dto.dart';

void main() {
  group('ScanResultDto', () {
    test('deserializes Gemini JSON correctly', () {
      final json = {
        'is_food': true,
        'total_calories': 595,
        'macros': {'protein_g': 34, 'carbs_g': 75, 'fat_g': 17},
        'dishes': [
          {
            'dish_name': 'Cơm trắng',
            'confidence_score': 0.96,
            'estimated_weight_g': 200,
            'calories': 260,
          },
          {
            'dish_name': 'Sườn heo nướng',
            'confidence_score': 0.92,
            'estimated_weight_g': 120,
            'calories': 290,
          },
        ],
      };

      final dto = ScanResultDto.fromJson(json);

      expect(dto.isFood, true);
      expect(dto.totalCalories, 595);
      expect(dto.macros.proteinG, 34);
      expect(dto.macros.carbsG, 75);
      expect(dto.macros.fatG, 17);
      expect(dto.dishes.length, 2);
      expect(dto.dishes[0].dishName, 'Cơm trắng');
      expect(dto.dishes[0].estimatedWeightG, 200);
      expect(dto.dishes[0].calories, 260);
    });
  });
}
