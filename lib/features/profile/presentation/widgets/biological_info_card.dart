import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/profile_enums.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

class BiologicalInfoCard extends StatelessWidget {
  const BiologicalInfoCard({
    super.key,
    required this.gender,
    required this.onGenderChanged,
    required this.birthYearController,
    required this.heightController,
    required this.weightController,
    required this.targetWeightController,
  });

  final Gender gender;
  final ValueChanged<Gender> onGenderChanged;
  final TextEditingController birthYearController;
  final TextEditingController heightController;
  final TextEditingController weightController;
  final TextEditingController targetWeightController;

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
            context.l10n.biologicalInfo,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w700,
                  color: AppColors.onSurface,
                ),
          ),
          const SizedBox(height: AppValues.spacing16),

          // Giới tính sinh học
          Text(
            context.l10n.biologicalGender,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Expanded(
                child: _GenderOption(
                  gender: Gender.male,
                  isSelected: gender == Gender.male,
                  onTap: () => onGenderChanged(Gender.male),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _GenderOption(
                  gender: Gender.female,
                  isSelected: gender == Gender.female,
                  onTap: () => onGenderChanged(Gender.female),
                ),
              ),
            ],
          ),

          const SizedBox(height: AppValues.spacing16),

          // Năm sinh
          ClayTextField(
            controller: birthYearController,
            labelText: context.l10n.birthYear,
            hintText: 'VD: ${ProfileDefaults.birthYear}',
            prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.primary, size: 20),
            keyboardType: TextInputType.number,
            validator: (v) => v != null && v.isNotEmpty ? null : context.l10n.enterBirthYear,
          ),

          const SizedBox(height: AppValues.spacing16),

          // Chiều cao
          ClayTextField(
            controller: heightController,
            labelText: '${context.l10n.height} (cm)',
            hintText: 'VD: ${ProfileDefaults.heightCm.round()}',
            prefixIcon: const Icon(Icons.height_rounded, color: AppColors.primary, size: 20),
            keyboardType: TextInputType.number,
            validator: (v) => v != null && v.isNotEmpty ? null : context.l10n.enterHeight,
          ),

          const SizedBox(height: AppValues.spacing16),

          // Cân nặng hiện tại
          ClayTextField(
            controller: weightController,
            labelText: context.l10n.currentWeight,
            hintText: 'VD: ${ProfileDefaults.weightKg.round()}',
            prefixIcon: const Icon(Icons.scale_outlined, color: AppColors.secondary, size: 20),
            keyboardType: TextInputType.number,
            validator: (v) => v != null && v.isNotEmpty ? null : context.l10n.enterCurrentWeight,
          ),

          const SizedBox(height: AppValues.spacing16),

          // Cân nặng mục tiêu
          ClayTextField(
            controller: targetWeightController,
            labelText: context.l10n.targetWeightOptional,
            hintText: 'VD: 60',
            prefixIcon: const Icon(Icons.flag_outlined, color: AppColors.brandGreen, size: 20),
            keyboardType: TextInputType.number,
          ),
        ],
      ),
    );
  }
}

class _GenderOption extends StatelessWidget {
  const _GenderOption({
    required this.gender,
    required this.isSelected,
    required this.onTap,
  });

  final Gender gender;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 140),
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.clayLunch : const Color(0xFFF6F4F0),
          borderRadius: BorderRadius.circular(16),
          border: Border.all(
            color: isSelected ? AppColors.primary : const Color(0xFFE2DDD5),
            width: isSelected ? 2 : 1.2,
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(gender.icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              gender.localizedLabel(context),
              style: TextStyle(
                fontSize: 14,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                color: isSelected ? AppColors.primary : AppColors.onSurface,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
