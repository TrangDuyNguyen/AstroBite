import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/profile_enums.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

class FitnessGoalCard extends StatelessWidget {
  const FitnessGoalCard({
    super.key,
    required this.fitnessGoal,
    required this.onFitnessGoalChanged,
    required this.activityLevel,
    required this.onActivityLevelChanged,
    required this.recommendedCalories,
    required this.targetCalController,
    required this.onApplyRecommendation,
  });

  final FitnessGoal fitnessGoal;
  final ValueChanged<FitnessGoal> onFitnessGoalChanged;
  final ActivityLevel activityLevel;
  final ValueChanged<ActivityLevel> onActivityLevelChanged;
  final int recommendedCalories;
  final TextEditingController targetCalController;
  final VoidCallback onApplyRecommendation;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      borderRadius: 22,
      elevation: 4,
      padding: const EdgeInsets.all(18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Mục tiêu & Chế độ vận động',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: AppValues.spacing16),

          // Fitness Goal Selector
          const Text(
            'Mục tiêu thể hình',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 8),
          _GoalOption(
            goal: FitnessGoal.loseWeight,
            color: AppColors.primary,
            isSelected: fitnessGoal == FitnessGoal.loseWeight,
            onTap: () => onFitnessGoalChanged(FitnessGoal.loseWeight),
          ),
          const SizedBox(height: 8),
          _GoalOption(
            goal: FitnessGoal.maintain,
            color: AppColors.tertiary,
            isSelected: fitnessGoal == FitnessGoal.maintain,
            onTap: () => onFitnessGoalChanged(FitnessGoal.maintain),
          ),
          const SizedBox(height: 8),
          _GoalOption(
            goal: FitnessGoal.gainMuscle,
            color: AppColors.brandGreen,
            isSelected: fitnessGoal == FitnessGoal.gainMuscle,
            onTap: () => onFitnessGoalChanged(FitnessGoal.gainMuscle),
          ),

          const SizedBox(height: AppValues.spacing20),

          // Mức độ vận động
          const Text(
            'Mức độ vận động hàng tuần',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14),
            decoration: BoxDecoration(
              color: const Color(0xFFF6F4F0),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFE2DDD5), width: 1.2),
            ),
            child: DropdownButtonHideUnderline(
              child: DropdownButton<ActivityLevel>(
                value: activityLevel,
                isExpanded: true,
                icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                items: ActivityLevel.values.map((level) {
                  return DropdownMenuItem<ActivityLevel>(
                    value: level,
                    child: Text(level.label),
                  );
                }).toList(),
                onChanged: (v) {
                  if (v != null) {
                    onActivityLevelChanged(v);
                  }
                },
              ),
            ),
          ),

          const SizedBox(height: AppValues.spacing16),

          // Smart Recommendation Banner
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: AppColors.clayLunch,
              borderRadius: BorderRadius.circular(14),
              border: Border.all(color: AppColors.primary.withValues(alpha: 0.25)),
            ),
            child: Row(
              children: [
                const Text('💡', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 10),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Gợi ý chuẩn khoa học AstroBite',
                        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w700, color: AppColors.primary),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        'Khuyến nghị: $recommendedCalories kcal/ngày',
                        style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                      ),
                    ],
                  ),
                ),
                TextButton(
                  onPressed: onApplyRecommendation,
                  style: TextButton.styleFrom(
                    visualDensity: VisualDensity.compact,
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: const Text(
                    'Áp dụng',
                    style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold, color: AppColors.primary),
                  ),
                ),
              ],
            ),
          ),

          const SizedBox(height: AppValues.spacing16),

          // Mục tiêu Calo/ngày Text field
          ClayTextField(
            controller: targetCalController,
            labelText: 'Mục tiêu Calo/ngày (kcal)',
            hintText: 'VD: ${ProfileDefaults.dailyTargetCalories}',
            prefixIcon: const Icon(Icons.local_fire_department_outlined, color: AppColors.tertiary, size: 20),
            keyboardType: TextInputType.number,
            validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập mục tiêu calo',
          ),
        ],
      ),
    );
  }
}

class _GoalOption extends StatelessWidget {
  const _GoalOption({
    required this.goal,
    required this.color,
    required this.isSelected,
    required this.onTap,
  });

  final FitnessGoal goal;
  final Color color;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : const Color(0xFFF6F4F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? color : const Color(0xFFE2DDD5),
            width: isSelected ? 2 : 1.2,
          ),
        ),
        child: Row(
          children: [
            Text(goal.icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    goal.title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    goal.subtitle,
                    style: TextStyle(
                      fontSize: 11,
                      color: isSelected ? color : AppColors.onSurfaceVariant,
                      fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
                    ),
                  ),
                ],
              ),
            ),
            if (isSelected)
              Icon(Icons.check_circle_rounded, color: color, size: 20)
            else
              const Icon(Icons.circle_outlined, color: Color(0xFFC4BFB5), size: 20),
          ],
        ),
      ),
    );
  }
}
