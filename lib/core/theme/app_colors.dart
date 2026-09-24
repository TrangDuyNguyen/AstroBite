import 'package:flutter/material.dart';

/// Celestial Dark UI color tokens mapped to Material 3 ColorScheme.
/// 
/// Color semantic mapping:
/// - Primary (Blue #1A73E8) = Carbohydrates + Active UI
/// - Secondary (Pink #FF69B4) = Fat + Analytics curves
/// - Tertiary (Gold #FFD700) = Protein + Calorie overflow warning
abstract final class AppColors {
  // Base & Background
  static const surface = Color(0xFF0A192F);         // Midnight sky background
  static const surfaceContainer = Color(0xFF112240); // Card backgrounds
  static const surfaceBlur = Color(0x99192A46);      // Glassmorphic overlays (60% opacity)

  // Accent & Interactive (Nutrient Mapping)
  static const primary = Color(0xFF1A73E8);          // Carbs / Active states
  static const secondary = Color(0xFFFF69B4);        // Fat / Weight trend curves
  static const tertiary = Color(0xFFFFD700);         // Protein / Calorie warning

  // Semantic Nutrient Aliases
  static const carbs = primary;
  static const fat = secondary;
  static const protein = tertiary;

  // Typography
  static const onSurface = Color(0xFFFFFFFF);        // Primary text
  static const onSurfaceVariant = Color(0xFF8892B0); // Secondary text
  static const outline = Color(0xFF495670);          // Borders, grid ticks

  // Semantic
  static const error = Color(0xFFCF6679);
  static const success = Color(0xFF4CAF50);
  static const warning = Color(0xFFFFAB00);
}
