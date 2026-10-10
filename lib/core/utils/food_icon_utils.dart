import 'package:flutter/material.dart';

/// Utility to resolve food icons and visual semantics based on Vietnamese food keywords.
class FoodIconUtils {
  const FoodIconUtils._();

  /// Resolves an appropriate [IconData] based on food name keywords.
  static IconData getFoodIcon(String name) {
    final lower = name.toLowerCase();
    if (lower.contains('bánh')) {
      return Icons.bakery_dining_rounded;
    }
    if (lower.contains('phở') ||
        lower.contains('bún') ||
        lower.contains('hủ tiếu') ||
        lower.contains('miến') ||
        lower.contains('mì')) {
      return Icons.ramen_dining_rounded;
    }
    if (lower.contains('cơm') || lower.contains('xôi')) {
      return Icons.rice_bowl_rounded;
    }

    if (lower.contains('bò') ||
        lower.contains('gà') ||
        lower.contains('thịt') ||
        lower.contains('heo') ||
        lower.contains('sườn')) {
      return Icons.kebab_dining_rounded;
    }
    if (lower.contains('cá') || lower.contains('tôm') || lower.contains('hải sản')) {
      return Icons.set_meal_rounded;
    }
    if (lower.contains('trứng')) {
      return Icons.egg_alt_outlined;
    }
    if (lower.contains('salad') || lower.contains('rau') || lower.contains('canh')) {
      return Icons.eco_rounded;
    }
    if (lower.contains('sữa') || lower.contains('cà phê') || lower.contains('trà')) {
      return Icons.local_cafe_rounded;
    }
    return Icons.restaurant_rounded;
  }
}
