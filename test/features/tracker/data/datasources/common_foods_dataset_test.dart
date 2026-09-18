import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/features/tracker/data/datasources/common_foods_dataset.dart';

void main() {
  group('CommonFoodItem & commonVietnameseFoods Tests', () {
    test('commonVietnameseFoods contains popular Vietnamese dishes', () {
      expect(commonVietnameseFoods.isNotEmpty, isTrue);
      expect(commonVietnameseFoods.any((f) => f.name.contains('Phở bò')), isTrue);
      expect(commonVietnameseFoods.any((f) => f.name.contains('Cơm tấm sườn')), isTrue);
      expect(commonVietnameseFoods.any((f) => f.name.contains('Ức gà áp chảo')), isTrue);
    });

    test('calculateCalories scales correctly with target weight', () {
      const item = CommonFoodItem(
        name: 'Ức gà áp chảo',
        baseWeightG: 100,
        baseCalories: 165,
        baseProteinG: 31,
        baseCarbsG: 0,
        baseFatG: 4,
      );

      expect(item.calculateCalories(100), 165);
      expect(item.calculateCalories(200), 330);
      expect(item.calculateCalories(50), 83);
    });

    test('calculateProtein, calculateCarbs, calculateFat scale correctly', () {
      const item = CommonFoodItem(
        name: 'Phở bò',
        baseWeightG: 350,
        baseCalories: 450,
        baseProteinG: 25,
        baseCarbsG: 55,
        baseFatG: 12,
      );

      // Doubled weight (700g)
      expect(item.calculateProtein(700), 50);
      expect(item.calculateCarbs(700), 110);
      expect(item.calculateFat(700), 24);
    });
  });
}
