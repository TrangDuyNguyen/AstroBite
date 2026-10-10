import 'package:flutter/material.dart';
import 'clay_3d_food_art.dart';

/// Specification for an individual 3D clay food/fruit item floating directly in zero gravity.
class ClayFoodItemSpec {
  const ClayFoodItemSpec({
    required this.foodType,
    required this.auraColor,
    required this.size,
    required this.relativeX,
    required this.relativeY,
    required this.amplitudeY,
    required this.amplitudeX,
    required this.speed,
    required this.phase,
    required this.maxRotation,
    this.opacity = 0.95,
  });

  final Clay3DFoodType foodType;
  final Color auraColor;
  final double size;
  final double relativeX;
  final double relativeY;
  final double amplitudeY;
  final double amplitudeX;
  final double speed;
  final double phase;
  final double maxRotation;
  final double opacity;
}

/// 10 canonical floating 3D clay food items for zero-gravity authentication screen.
const List<ClayFoodItemSpec> zeroGravityFoodSpecs = [
  // 1. 🍎 Red Apple
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.apple,
    auraColor: Color(0x35FF5C8D),
    size: 46,
    relativeX: 0.12,
    relativeY: 0.10,
    amplitudeY: 14,
    amplitudeX: 9,
    speed: 1.0,
    phase: 0.0,
    maxRotation: 0.18,
  ),

  // 2. ✨ Cosmic Sparkle Star
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.cosmicStar,
    auraColor: Color(0x45FFB703),
    size: 30,
    relativeX: 0.32,
    relativeY: 0.065,
    amplitudeY: 10,
    amplitudeX: 6,
    speed: 1.25,
    phase: 1.8,
    maxRotation: 0.35,
    opacity: 0.90,
  ),

  // 3. 🍪 Chocolate Cookie
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.cookie,
    auraColor: Color(0x30D47A3B),
    size: 38,
    relativeX: 0.68,
    relativeY: 0.075,
    amplitudeY: 11,
    amplitudeX: 10,
    speed: 0.85,
    phase: 0.8,
    maxRotation: 0.22,
  ),

  // 4. 🥐 Croissant / Bread
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.croissant,
    auraColor: Color(0x35FFAA00),
    size: 46,
    relativeX: 0.86,
    relativeY: 0.11,
    amplitudeY: 13,
    amplitudeX: 10,
    speed: 0.92,
    phase: 1.2,
    maxRotation: 0.22,
  ),

  // 5. 🥑 Avocado / Fresh Veggie
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.avocado,
    auraColor: Color(0x3558CC02),
    size: 44,
    relativeX: 0.07,
    relativeY: 0.26,
    amplitudeY: 15,
    amplitudeX: 8,
    speed: 0.88,
    phase: 2.1,
    maxRotation: -0.20,
  ),

  // 6. 🍕 Pizza Slice
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.pizza,
    auraColor: Color(0x35FF9600),
    size: 48,
    relativeX: 0.93,
    relativeY: 0.28,
    amplitudeY: 14,
    amplitudeX: 8,
    speed: 1.05,
    phase: 3.5,
    maxRotation: -0.18,
  ),

  // 7. 🍦 Ice Cream
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.iceCream,
    auraColor: Color(0x351CB0F6),
    size: 44,
    relativeX: 0.07,
    relativeY: 0.70,
    amplitudeY: 12,
    amplitudeX: 9,
    speed: 0.90,
    phase: 4.3,
    maxRotation: 0.16,
  ),

  // 8. 🍳 Sunny Egg
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.sunnyEgg,
    auraColor: Color(0x40FFD000),
    size: 44,
    relativeX: 0.93,
    relativeY: 0.68,
    amplitudeY: 15,
    amplitudeX: 7,
    speed: 1.02,
    phase: 5.1,
    maxRotation: -0.15,
  ),

  // 9. 🍜 Ramen Bowl
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.ramen,
    auraColor: Color(0x359D65FF),
    size: 44,
    relativeX: 0.20,
    relativeY: 0.88,
    amplitudeY: 12,
    amplitudeX: 8,
    speed: 0.95,
    phase: 2.7,
    maxRotation: 0.16,
  ),

  // 10. ☕ Hot Coffee
  ClayFoodItemSpec(
    foodType: Clay3DFoodType.coffee,
    auraColor: Color(0x308D5B4C),
    size: 38,
    relativeX: 0.80,
    relativeY: 0.88,
    amplitudeY: 11,
    amplitudeX: 8,
    speed: 0.82,
    phase: 3.9,
    maxRotation: -0.16,
  ),
];
