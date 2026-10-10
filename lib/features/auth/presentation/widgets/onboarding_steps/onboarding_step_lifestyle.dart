import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Step 4: Activity level selection for onboarding survey.
class OnboardingStepActivityLevel extends StatelessWidget {
  final String activityLevel;
  final ValueChanged<String> onChanged;

  const OnboardingStepActivityLevel({
    super.key,
    required this.activityLevel,
    required this.onChanged,
  });

  static const _levels = [
    ('sedentary', 'Ít vận động', 'Ngồi văn phòng, không tập thể thao (x1.2)'),
    ('light', 'Vận động nhẹ', 'Tập nhẹ 1-3 ngày/tuần hoặc đi bộ (x1.375)'),
    ('moderate', 'Vừa phải', 'Tập thể dục 3-5 ngày/tuần (x1.55)'),
    ('very_active', 'Năng động cao', 'Tập nặng 6-7 ngày/tuần (x1.725)'),
    ('extremely_active', 'Cực kỳ nặng', 'Vận động viên hoặc lao động thể lực (x1.9)'),
  ];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppValues.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'TẦN SỐ VẬN ĐỘNG',
              style: TextStyle(
                color: AppColors.primary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: AppValues.spacing8),
          const Text(
            'Mức độ vận động',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppValues.spacing8),
          const Text(
            'Cường độ hoạt động thể chất quyết định hệ số tiêu hao năng lượng (TDEE) trong chu kỳ ngày của bạn.',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppValues.spacing16),
          ..._levels.map((item) {
            final isSelected = activityLevel == item.$1;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppValues.spacing12),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppValues.cardRadius),
                onTap: () => onChanged(item.$1),
                child: Container(
                  padding: const EdgeInsets.all(AppValues.cardPadding),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surfaceContainer : AppColors.surfaceContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppValues.cardRadius),
                    border: Border.all(
                      color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Icon(
                        isSelected ? Icons.radio_button_checked : Icons.radio_button_off,
                        color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
                      ),
                      const SizedBox(width: AppValues.spacing12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              item.$2,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              item.$3,
                              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
        ],
      ),
    );
  }
}

/// Step 5: Primary fitness goal selection.
class OnboardingStepFitnessGoal extends StatelessWidget {
  final String fitnessGoal;
  final ValueChanged<String> onChanged;

  const OnboardingStepFitnessGoal({
    super.key,
    required this.fitnessGoal,
    required this.onChanged,
  });

  static const _goals = [
    (
      'lose_weight',
      'Giảm cân (Thâm hụt calo)',
      'Giảm ~0.5kg/tuần với thâm hụt 500 kcal/ngày',
      Icons.trending_down,
      AppColors.primary,
    ),
    (
      'maintain',
      'Giữ cân (Cân bằng năng lượng)',
      'Duy trì thể trạng và phong độ ổn định',
      Icons.trending_flat,
      AppColors.tertiary,
    ),
    (
      'gain_weight',
      'Tăng cơ / Tăng cân',
      'Tối ưu phát triển cơ bắp với thặng dư 300 kcal/ngày',
      Icons.trending_up,
      AppColors.secondary,
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppValues.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.tertiary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'MỤC TIÊU QUỸ ĐẠO',
              style: TextStyle(
                color: AppColors.tertiary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: AppValues.spacing8),
          const Text(
            'Mục tiêu chính của bạn?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppValues.spacing8),
          const Text(
            'Chọn quỹ đạo phát triển vóc dáng của bạn — Đồng hành 24/7 cùng trợ lý thông minh AstroCoach AI.',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
          const Spacer(),
          ..._goals.map((goal) {
            final isSelected = fitnessGoal == goal.$1;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppValues.spacing16),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppValues.cardRadius),
                onTap: () => onChanged(goal.$1),
                child: Container(
                  padding: const EdgeInsets.all(AppValues.cardPadding),
                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.surfaceContainer : AppColors.surfaceContainer.withValues(alpha: 0.4),
                    borderRadius: BorderRadius.circular(AppValues.cardRadius),
                    border: Border.all(
                      color: isSelected ? goal.$5 : AppColors.outline.withValues(alpha: 0.3),
                      width: isSelected ? 2 : 1,
                    ),
                  ),
                  child: Row(
                    children: [
                      Container(
                        padding: const EdgeInsets.all(AppValues.spacing12),
                        decoration: BoxDecoration(
                          color: goal.$5.withValues(alpha: 0.15),
                          shape: BoxShape.circle,
                        ),
                        child: Icon(goal.$4, color: goal.$5, size: 28),
                      ),
                      const SizedBox(width: AppValues.spacing16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              goal.$2,
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                                color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              goal.$3,
                              style: const TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
