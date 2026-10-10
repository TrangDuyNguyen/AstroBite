import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Step 2: Age and Height survey.
class OnboardingStepAgeAndHeight extends StatelessWidget {
  const OnboardingStepAgeAndHeight({
    super.key,
    required this.birthYearController,
    required this.heightController,
    required this.birthYear,
    required this.onBirthYearChanged,
    required this.onHeightChanged,
  });

  final TextEditingController birthYearController;
  final TextEditingController heightController;
  final int birthYear;
  final ValueChanged<int> onBirthYearChanged;
  final ValueChanged<double> onHeightChanged;

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
              color: AppColors.tertiary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'TỌA ĐỘ KHÔNG GIAN',
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
            'Năm sinh & Chiều cao',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppValues.spacing8),
          const Text(
            'Năm sinh và chiều cao tạo nên khung tọa độ sinh học để AstroBite ước lượng chính xác năng lượng tiêu hao.',
            style: TextStyle(fontSize: 14, color: AppColors.onSurfaceVariant),
          ),
          const SizedBox(height: AppValues.spacing32),
          ClayCard(
            padding: const EdgeInsets.all(AppValues.spacing16),
            elevation: 4.0,
            borderRadius: AppValues.cardRadiusLarge,
            child: ClayTextField(
              controller: birthYearController,
              labelText: 'Năm sinh',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.onSurfaceVariant),
              suffixIcon: Padding(
                padding: const EdgeInsets.only(top: 14, right: 16),
                child: Text('(${DateTime.now().year - birthYear} tuổi)', style: const TextStyle(color: AppColors.primary, fontWeight: FontWeight.bold, fontSize: 16)),
              ),
              onChanged: (v) {
                final val = int.tryParse(v);
                if (val != null) onBirthYearChanged(val);
              },
            ),
          ),
          const SizedBox(height: AppValues.spacing16),
          ClayCard(
            padding: const EdgeInsets.all(AppValues.spacing16),
            elevation: 4.0,
            borderRadius: AppValues.cardRadiusLarge,
            child: ClayTextField(
              controller: heightController,
              labelText: 'Chiều cao',
              keyboardType: TextInputType.number,
              prefixIcon: const Icon(Icons.height_outlined, color: AppColors.onSurfaceVariant),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(top: 14, right: 16),
                child: Text('cm', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16)),
              ),
              onChanged: (v) {
                final val = double.tryParse(v);
                if (val != null) onHeightChanged(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}

/// Step 3: Weight and Target Weight survey.
class OnboardingStepWeight extends StatelessWidget {
  const OnboardingStepWeight({
    super.key,
    required this.weightController,
    required this.targetWeightController,
    required this.heightCm,
    required this.weightKg,
    required this.onWeightChanged,
    required this.onTargetWeightChanged,
  });

  final TextEditingController weightController;
  final TextEditingController targetWeightController;
  final double heightCm;
  final double weightKg;
  final ValueChanged<double> onWeightChanged;
  final ValueChanged<double> onTargetWeightChanged;

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Gầy';
    if (bmi < 24.9) return 'Bình thường';
    if (bmi < 29.9) return 'Tiền béo phì';
    return 'Béo phì';
  }

  @override
  Widget build(BuildContext context) {
    final heightM = heightCm / 100;
    final bmi = weightKg / (heightM * heightM);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(AppValues.screenPadding),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            decoration: BoxDecoration(
              color: AppColors.secondary.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(4),
            ),
            child: const Text(
              'TRỌNG LỰC QUỸ ĐẠO',
              style: TextStyle(
                color: AppColors.secondary,
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
            ),
          ),
          const SizedBox(height: AppValues.spacing8),
          const Text(
            'Cân nặng hiện tại & Mục tiêu',
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: AppValues.spacing8),
          Text(
            'Định vị cân nặng để thiết lập mục tiêu năng lượng. BMI hiện tại: ${bmi.toStringAsFixed(1)} (${_getBmiCategory(bmi)})',
            style: const TextStyle(fontSize: 14, color: AppColors.primary, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: AppValues.spacing24),
          ClayCard(
            padding: const EdgeInsets.all(AppValues.spacing16),
            elevation: 4.0,
            borderRadius: AppValues.cardRadiusLarge,
            child: ClayTextField(
              controller: weightController,
              labelText: 'Cân nặng hiện tại',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(Icons.monitor_weight_outlined, color: AppColors.onSurfaceVariant),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(top: 14, right: 16),
                child: Text('kg', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16)),
              ),
              onChanged: (v) {
                final val = double.tryParse(v);
                if (val != null) onWeightChanged(val);
              },
            ),
          ),
          const SizedBox(height: AppValues.spacing16),
          ClayCard(
            padding: const EdgeInsets.all(AppValues.spacing16),
            elevation: 4.0,
            borderRadius: AppValues.cardRadiusLarge,
            child: ClayTextField(
              controller: targetWeightController,
              labelText: 'Cân nặng mục tiêu',
              keyboardType: const TextInputType.numberWithOptions(decimal: true),
              prefixIcon: const Icon(Icons.flag_outlined, color: AppColors.onSurfaceVariant),
              suffixIcon: const Padding(
                padding: EdgeInsets.only(top: 14, right: 16),
                child: Text('kg', style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 16)),
              ),
              onChanged: (v) {
                final val = double.tryParse(v);
                if (val != null) onTargetWeightChanged(val);
              },
            ),
          ),
        ],
      ),
    );
  }
}
