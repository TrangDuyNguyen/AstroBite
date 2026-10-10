import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:astrobite/core/utils/food_icon_utils.dart';

void main() {
  group('FoodIconUtils Tests', () {
    test('resolves noodle dishes correctly', () {
      expect(FoodIconUtils.getFoodIcon('Phở bò tái lăn'), Icons.ramen_dining_rounded);
      expect(FoodIconUtils.getFoodIcon('Bún chả Hà Nội'), Icons.ramen_dining_rounded);
      expect(FoodIconUtils.getFoodIcon('Hủ tiếu Nam Vang'), Icons.ramen_dining_rounded);
      expect(FoodIconUtils.getFoodIcon('Miến gà'), Icons.ramen_dining_rounded);
      expect(FoodIconUtils.getFoodIcon('Mì xào hải sản'), Icons.ramen_dining_rounded);
    });

    test('resolves rice and bakery dishes correctly', () {
      expect(FoodIconUtils.getFoodIcon('Cơm tấm sườn'), Icons.rice_bowl_rounded);
      expect(FoodIconUtils.getFoodIcon('Xôi xéo'), Icons.rice_bowl_rounded);
      expect(FoodIconUtils.getFoodIcon('Bánh mì chả lụa'), Icons.bakery_dining_rounded);
    });

    test('resolves meat, seafood, egg and beverages correctly', () {
      expect(FoodIconUtils.getFoodIcon('Thịt kho tàu'), Icons.kebab_dining_rounded);
      expect(FoodIconUtils.getFoodIcon('Cá basa chiên xù'), Icons.set_meal_rounded);
      expect(FoodIconUtils.getFoodIcon('Trứng ốp la'), Icons.egg_alt_outlined);
      expect(FoodIconUtils.getFoodIcon('Salad xà lách'), Icons.eco_rounded);
      expect(FoodIconUtils.getFoodIcon('Cà phê sữa đá'), Icons.local_cafe_rounded);
    });

    test('falls back to default restaurant icon for unknown dish', () {
      expect(FoodIconUtils.getFoodIcon('Món ăn lạ'), Icons.restaurant_rounded);
    });
  });
}
