import 'package:flutter/material.dart';
import 'clay_3d_food_art.dart';

/// Specification for a 3D clay food item in the Splash cosmic constellation.
class SplashFoodItemSpec {
  const SplashFoodItemSpec({
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
    this.delay = 0.0,
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
  final double delay;
}

/// 10 canonical celestial clay food items drifting in zero gravity during splash.
const List<SplashFoodItemSpec> kSplashConstellationSpecs = [
  // 1. 🍎 Red Apple 3D - Top-Left Constellation
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.apple,
    auraColor: Color(0x35FF5C8D),
    size: 50,
    relativeX: 0.14,
    relativeY: 0.12,
    amplitudeY: 12,
    amplitudeX: 8,
    speed: 1.0,
    phase: 0.0,
    maxRotation: 0.18,
    delay: 0.0,
  ),

  // 2. ✨ Cosmic Sparkle Star 3D - Top-Center
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.cosmicStar,
    auraColor: Color(0x45FFB703),
    size: 34,
    relativeX: 0.50,
    relativeY: 0.08,
    amplitudeY: 9,
    amplitudeX: 6,
    speed: 1.2,
    phase: 1.4,
    maxRotation: 0.32,
    delay: 0.04,
  ),

  // 3. 🥐 Croissant 3D - Top-Right Constellation
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.croissant,
    auraColor: Color(0x35FFAA00),
    size: 48,
    relativeX: 0.86,
    relativeY: 0.13,
    amplitudeY: 13,
    amplitudeX: 9,
    speed: 0.94,
    phase: 0.9,
    maxRotation: 0.22,
    delay: 0.08,
  ),

  // 4. 🥑 Avocado 3D - Mid-Left Flank
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.avocado,
    auraColor: Color(0x3558CC02),
    size: 48,
    relativeX: 0.09,
    relativeY: 0.38,
    amplitudeY: 14,
    amplitudeX: 8,
    speed: 0.88,
    phase: 2.2,
    maxRotation: -0.20,
    delay: 0.12,
  ),

  // 5. 🍪 Chocolate Cookie 3D - Mid-Right Flank
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.cookie,
    auraColor: Color(0x30D47A3B),
    size: 42,
    relativeX: 0.91,
    relativeY: 0.36,
    amplitudeY: 11,
    amplitudeX: 9,
    speed: 0.86,
    phase: 3.1,
    maxRotation: 0.20,
    delay: 0.16,
  ),

  // 6. 🍦 Ice Cream 3D - Lower-Mid Left
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.iceCream,
    auraColor: Color(0x351CB0F6),
    size: 46,
    relativeX: 0.10,
    relativeY: 0.65,
    amplitudeY: 13,
    amplitudeX: 8,
    speed: 0.92,
    phase: 4.1,
    maxRotation: 0.18,
    delay: 0.20,
  ),

  // 7. 🍕 Pizza Slice 3D - Lower-Mid Right
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.pizza,
    auraColor: Color(0x35FF9600),
    size: 50,
    relativeX: 0.90,
    relativeY: 0.64,
    amplitudeY: 14,
    amplitudeX: 8,
    speed: 1.05,
    phase: 1.8,
    maxRotation: -0.18,
    delay: 0.24,
  ),

  // 8. 🍜 Hot Ramen 3D - Bottom-Left Constellation
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.ramen,
    auraColor: Color(0x359D65FF),
    size: 46,
    relativeX: 0.20,
    relativeY: 0.86,
    amplitudeY: 12,
    amplitudeX: 8,
    speed: 0.95,
    phase: 2.8,
    maxRotation: 0.16,
    delay: 0.28,
  ),

  // 9. 🍳 Sunny Egg 3D - Bottom-Right Constellation
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.sunnyEgg,
    auraColor: Color(0x40FFD000),
    size: 46,
    relativeX: 0.80,
    relativeY: 0.86,
    amplitudeY: 13,
    amplitudeX: 7,
    speed: 1.02,
    phase: 4.9,
    maxRotation: -0.16,
    delay: 0.30,
  ),

  // 10. ☕ Hot Coffee 3D - Bottom-Center
  SplashFoodItemSpec(
    foodType: Clay3DFoodType.coffee,
    auraColor: Color(0x308D5B4C),
    size: 40,
    relativeX: 0.50,
    relativeY: 0.92,
    amplitudeY: 10,
    amplitudeX: 8,
    speed: 0.84,
    phase: 3.7,
    maxRotation: -0.14,
    delay: 0.18,
  ),
];
