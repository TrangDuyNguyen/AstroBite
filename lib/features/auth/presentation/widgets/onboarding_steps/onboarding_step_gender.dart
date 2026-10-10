import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'onboarding_select_card.dart';

/// Step 1: Biological Gender Selection.
class OnboardingStepGender extends StatelessWidget {
  const OnboardingStepGender({
    super.key,
    required this.selectedGender,
    required this.onSelectGender,
  });

  final String selectedGender;
  final ValueChanged<String> onSelectGender;

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
              color: AppColors.primary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'TIỂU VŨ TRỤ SINH HỌC',
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
            'Giới tính sinh học của bạn?',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppValues.spacing8),
          const Text(
            'Mỗi cơ thể là một tiểu vũ trụ độc lập. Giới tính sinh học giúp AstroBite định vị tốc độ trao đổi chất cơ bản (BMR) theo chuẩn y khoa Mifflin-St Jeor.',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
          const Spacer(),
          Row(
            children: [
              Expanded(
                child: OnboardingSelectCard(
                  title: 'Nam',
                  icon: Icons.male,
                  isSelected: selectedGender == 'male',
                  onTap: () => onSelectGender('male'),
                ),
              ),
              const SizedBox(width: AppValues.spacing16),
              Expanded(
                child: OnboardingSelectCard(
                  title: 'Nữ',
                  icon: Icons.female,
                  isSelected: selectedGender == 'female',
                  onTap: () => onSelectGender('female'),
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }
}
