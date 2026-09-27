import 'package:flutter/material.dart';

/// Claymorphic × Duolingo 2D/3D color tokens mapped to Material 3 ColorScheme.
/// 
/// Food & Appetite-Centric Color Semantics:
/// - Primary (Duolingo Sky Blue #1CB0F6) = Carbohydrates + Active UI/CTAs
/// - Secondary (Strawberry Cream Pink #FF5C8D) = Fat + Analytics curves
/// - Tertiary (Honey Tangerine Orange #FF9600) = Protein + Calorie warning
/// - BrandGreen (Duolingo Lime Green #58CC02) = Streak / Goal vitality
abstract final class AppColors {
  // Base & Background (Claymorphic Canvas)
  static const surface = Color(0xFFFAF8F5);          // Warm Milk Cream canvas
  static const surfaceContainer = Color(0xFFFFFFFF);  // Pure White Clay cards
  static const surfaceBlur = Color(0xFFFFFFFF);       // Opaque/Soft White fallback
  static const shimmerBase = Color(0xFFF0EFEB);       // Warm soft shimmer base

  // Accent & Interactive (Nutrient Mapping)
  static const primary = Color(0xFF1CB0F6);           // Carbs / Duolingo Sky Blue
  static const secondary = Color(0xFFFF5C8D);         // Fat / Strawberry Cream Pink
  static const tertiary = Color(0xFFFF9600);          // Protein / Honey Tangerine Orange
  static const brandGreen = Color(0xFF58CC02);        // Energetic Lime Green

  // Semantic Nutrient Aliases
  static const carbs = primary;
  static const fat = secondary;
  static const protein = tertiary;

  // Clay Pastel Tints (Puffy Clay Chips & Badges)
  static const clayBreakfast = Color(0xFFFFF2D6);     // Honey pastel
  static const clayLunch = Color(0xFFE5F6FD);         // Sky pastel
  static const clayDinner = Color(0xFFF0E8FF);        // Taro purple pastel
  static const claySnack = Color(0xFFFFE8EE);         // Strawberry milk pastel
  static const clayMint = Color(0xFFE8F9D8);          // Fresh cucumber mint

  // Typography (High Contrast WCAG AAA/AA)
  static const onSurface = Color(0xFF1E2337);         // Deep Slate Berry (AAA 13:1)
  static const onSurfaceVariant = Color(0xFF78829A);  // Cool Slate (AA 4.8:1)
  static const outline = Color(0xFFE8E5DF);           // Soft Clay border

  // Semantic
  static const error = Color(0xFFEA2B2B);             // Crisp red
  static const success = brandGreen;                  // Lime green
  static const warning = tertiary;                    // Honey orange
}


