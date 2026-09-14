/// Layout and business rule constants.
/// All spacing values follow the 4pt grid system.
abstract final class AppValues {
  // 4pt Grid spacing tokens
  static const double spacing4 = 4;
  static const double spacing8 = 8;
  static const double spacing12 = 12;
  static const double spacing16 = 16;
  static const double spacing24 = 24;
  static const double spacing32 = 32;
  static const double spacing44 = 44;
  static const double spacing48 = 48;

  // Layout
  static const double screenPadding = 16;
  static const double cardPadding = 16;
  static const double cardRadius = 12;
  static const double minTouchTarget = 44;
  static const double fabSize = 60;
  static const double calorieLetterSpacing = 0.5;

  // Business rules
  static const int maxDailyScans = 10;
  static const int scanTimeoutSeconds = 10;
  static const int defaultDailyCalories = 2000;

  // Activity multipliers for TDEE
  static const double sedentaryMultiplier = 1.2;
  static const double lightMultiplier = 1.375;
  static const double moderateMultiplier = 1.55;
  static const double activeMultiplier = 1.725;
  static const double extremeMultiplier = 1.9;
}
