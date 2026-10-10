import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/user_profile.dart';

class ProfileMetricsCard extends StatelessWidget {
  const ProfileMetricsCard({
    super.key,
    required this.profile,
    required this.onEditPressed,
    this.isEditDisabled = false,
  });

  final UserProfile profile;
  final VoidCallback onEditPressed;
  final bool isEditDisabled;

  String _translateActivityLevel(String level) {
    return switch (level) {
      'sedentary' => 'Ít vận động',
      'light' => 'Nhẹ (1-3 ngày)',
      'moderate' => 'Vừa phải (3-5 ngày)',
      'active' => 'Năng động (6-7 ngày)',
      'very_active' => 'Rất năng động',
      _ => level,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      borderRadius: 20,
      elevation: 4,
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Thông số cá nhân',
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
              ),
              InkWell(
                onTap: isEditDisabled ? null : onEditPressed,
                borderRadius: BorderRadius.circular(8),
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                  child: Text(
                    'Sửa',
                    style: TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: isEditDisabled ? AppColors.onSurfaceVariant : AppColors.primary,
                    ),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),
          GridView.count(
            crossAxisCount: 2,
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            mainAxisSpacing: 10,
            crossAxisSpacing: 10,
            childAspectRatio: 2.3,
            children: [
              _StatTile(
                icon: '🚻',
                label: 'Giới tính',
                value: profile.gender == 'male' ? 'Nam' : 'Nữ',
              ),
              _StatTile(
                icon: '🎂',
                label: 'Năm sinh',
                value: '${profile.birthYear} (${profile.age}t)',
              ),
              _StatTile(
                icon: '📏',
                label: 'Chiều cao',
                value: '${profile.heightCm.round()} cm',
              ),
              _StatTile(
                icon: '⚖️',
                label: 'Cân nặng hiện tại',
                value: '${profile.weightKg} kg',
              ),
              _StatTile(
                icon: '🎯',
                label: 'Cân nặng mục tiêu',
                value: profile.targetWeightKg != null
                    ? '${profile.targetWeightKg!.round()} kg'
                    : 'Chưa đặt',
                valueColor: profile.targetWeightKg != null ? AppColors.brandGreen : null,
              ),
              _StatTile(
                icon: '🏃',
                label: 'Mức độ vận động',
                value: _translateActivityLevel(profile.activityLevel),
              ),
              _StatTile(
                icon: '📊',
                label: 'Chỉ số BMI',
                value: '${profile.bmi.toStringAsFixed(1)} (${profile.bmiCategory})',
                valueColor: AppColors.primary,
              ),
              _StatTile(
                icon: '🔥',
                label: 'Mục tiêu Calo/ngày',
                value: '${profile.dailyTargetCalories} kcal',
                valueColor: AppColors.tertiary,
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({
    required this.icon,
    required this.label,
    required this.value,
    this.valueColor,
  });

  final String icon;
  final String label;
  final String value;
  final Color? valueColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
      decoration: BoxDecoration(
        color: const Color(0xFFF6F4F0),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFE8E5DF), width: 1),
      ),
      child: Row(
        children: [
          Text(icon, style: const TextStyle(fontSize: 18)),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 10.5,
                    color: AppColors.onSurfaceVariant,
                    fontWeight: FontWeight.w500,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 2),
                Text(
                  value,
                  style: TextStyle(
                    fontSize: 13,
                    fontWeight: FontWeight.w700,
                    color: valueColor ?? AppColors.onSurface,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
