import 'package:flutter/widgets.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';

enum Gender {
  male(
    value: 'male',
    label: 'Nam',
    icon: '👨',
    bmrOffset: 5.0,
    safetyFloor: 1500.0,
  ),
  female(
    value: 'female',
    label: 'Nữ',
    icon: '👩',
    bmrOffset: -161.0,
    safetyFloor: 1200.0,
  );

  const Gender({
    required this.value,
    required this.label,
    required this.icon,
    required this.bmrOffset,
    required this.safetyFloor,
  });

  final String value;
  final String label;
  final String icon;
  final double bmrOffset;
  final double safetyFloor;

  String localizedLabel(BuildContext context) => switch (this) {
        Gender.male => context.l10n.male,
        Gender.female => context.l10n.female,
      };

  static Gender fromValue(String? value) {
    if (value == null) return Gender.male;
    for (final e in Gender.values) {
      if (e.value == value) return e;
    }
    return Gender.male;
  }
}

enum ActivityLevel {
  sedentary(
    value: 'sedentary',
    label: 'Ít vận động (Bàn giấy)',
    multiplier: 1.2,
  ),
  light(
    value: 'light',
    label: 'Nhẹ (1-3 ngày/tuần)',
    multiplier: 1.375,
  ),
  moderate(
    value: 'moderate',
    label: 'Vừa phải (3-5 ngày/tuần)',
    multiplier: 1.55,
  ),
  active(
    value: 'active',
    label: 'Năng động (6-7 ngày/tuần)',
    multiplier: 1.725,
  ),
  veryActive(
    value: 'very_active',
    label: 'Rất năng động (2 buổi/ngày)',
    multiplier: 1.9,
  );

  const ActivityLevel({
    required this.value,
    required this.label,
    required this.multiplier,
  });

  final String value;
  final String label;
  final double multiplier;

  String localizedLabel(BuildContext context) => switch (this) {
        ActivityLevel.sedentary => context.l10n.sedentary,
        ActivityLevel.light => context.l10n.lightActivity,
        ActivityLevel.moderate => context.l10n.moderateActivity,
        ActivityLevel.active => context.l10n.activeActivity,
        ActivityLevel.veryActive => context.l10n.veryActiveActivity,
      };

  static ActivityLevel fromValue(String? value) {
    if (value == null) return ActivityLevel.moderate;
    for (final e in ActivityLevel.values) {
      if (e.value == value) return e;
    }
    if (value == 'extreme' || value == 'extremely_active') return ActivityLevel.veryActive;
    return ActivityLevel.sedentary;
  }
}

enum FitnessGoal {
  loseWeight(
    value: 'lose_weight',
    title: 'Giảm mỡ & Cải thiện vóc dáng',
    subtitle: 'Thâm hụt calo an toàn (-500 kcal/ngày)',
    icon: '🎯',
    calorieOffset: -500,
  ),
  maintain(
    value: 'maintain',
    title: 'Duy trì cân nặng',
    subtitle: 'Cân bằng calo nạp vào bằng chỉ số TDEE',
    icon: '⚖️',
    calorieOffset: 0,
  ),
  gainMuscle(
    value: 'gain_muscle',
    title: 'Tăng cơ & Khối lượng nạc',
    subtitle: 'Thặng dư nhẹ (+300 kcal/ngày) kết hợp tập luyện',
    icon: '💪',
    calorieOffset: 300,
  ),
  gainWeight(
    value: 'gain_weight',
    title: 'Tăng cân',
    subtitle: 'Thặng dư nhẹ (+300 kcal/ngày)',
    icon: '💪',
    calorieOffset: 300,
  );

  const FitnessGoal({
    required this.value,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.calorieOffset,
  });

  final String value;
  final String title;
  final String subtitle;
  final String icon;
  final int calorieOffset;

  String localizedTitle(BuildContext context) => switch (this) {
        FitnessGoal.loseWeight => context.l10n.goalLoseWeightTitle,
        FitnessGoal.maintain => context.l10n.goalMaintainTitle,
        FitnessGoal.gainMuscle => context.l10n.goalGainMuscleTitle,
        FitnessGoal.gainWeight => context.l10n.goalGainMuscleTitle,
      };

  String localizedSubtitle(BuildContext context) => switch (this) {
        FitnessGoal.loseWeight => context.l10n.goalLoseWeightSub,
        FitnessGoal.maintain => context.l10n.goalMaintainSub,
        FitnessGoal.gainMuscle => context.l10n.goalGainMuscleSub,
        FitnessGoal.gainWeight => context.l10n.goalGainMuscleSub,
      };

  static FitnessGoal fromValue(String? value) {
    if (value == null) return FitnessGoal.maintain;
    for (final e in FitnessGoal.values) {
      if (e.value == value) return e;
    }
    return FitnessGoal.maintain;
  }
}

abstract final class ProfileDefaults {
  static const int birthYear = 1995;
  static const double heightCm = 170.0;
  static const double weightKg = 65.0;
  static const int dailyTargetCalories = 2000;
  static const Gender gender = Gender.male;
  static const ActivityLevel activityLevel = ActivityLevel.moderate;
  static const FitnessGoal fitnessGoal = FitnessGoal.maintain;
}
