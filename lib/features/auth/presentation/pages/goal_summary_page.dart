import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/nutrition_calculator.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/profile/data/models/user_profile_dto.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import 'package:astrobite/shared/widgets/macro_bar.dart';

@RoutePage()
class GoalSummaryPage extends ConsumerStatefulWidget {
  const GoalSummaryPage({
    super.key,
    required this.gender,
    required this.birthYear,
    required this.heightCm,
    required this.weightKg,
    required this.targetWeightKg,
    required this.activityLevel,
    required this.fitnessGoal,
  });

  final String gender;
  final int birthYear;
  final double heightCm;
  final double weightKg;
  final double targetWeightKg;
  final String activityLevel;
  final String fitnessGoal;

  @override
  ConsumerState<GoalSummaryPage> createState() => _GoalSummaryPageState();
}

class _GoalSummaryPageState extends ConsumerState<GoalSummaryPage> {
  bool _isSaving = false;

  Future<void> _handleStartJourney(int targetCalories) async {
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    setState(() => _isSaving = true);
    try {
      final dto = UserProfileDto(
        uid: user.uid,
        gender: widget.gender,
        birthYear: widget.birthYear,
        heightCm: widget.heightCm,
        weightKg: widget.weightKg,
        activityLevel: widget.activityLevel,
        dailyTargetCalories: targetCalories,
        isOnboardingCompleted: true,
        targetWeightKg: widget.targetWeightKg,
        fitnessGoal: widget.fitnessGoal,
      );

      await ref.read(profileRepositoryProvider).saveProfile(dto);

      if (mounted) {
        context.router.replaceAll([const ShellRoute()]);
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Lưu thông tin thất bại: $e'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isSaving = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final age = DateTime.now().year - widget.birthYear;
    final bmr = NutritionCalculator.calculateBMR(
      weightKg: widget.weightKg,
      heightCm: widget.heightCm,
      age: age,
      gender: widget.gender,
    );
    final tdee = NutritionCalculator.calculateTDEE(
      bmr: bmr,
      activityLevel: widget.activityLevel,
    );
    final targetCalories = NutritionCalculator.calculateTargetCalories(
      tdee: tdee,
      goal: widget.fitnessGoal,
      gender: widget.gender,
    );
    final macros = NutritionCalculator.calculateMacros(targetCalories);

    final safetyFloor = widget.gender == 'female' ? 1200.0 : 1500.0;
    final isSafetyFloorTriggered =
        widget.fitnessGoal == 'lose_weight' && (tdee - 500) < safetyFloor;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: const Text(
          'Kế Hoạch Dinh Dưỡng',
          style: TextStyle(
            color: AppColors.onSurface,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppValues.screenPadding),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Text(
                'Mục Tiêu Cá Nhân Của Bạn 🚀',
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppValues.spacing8),
              const Text(
                'Dựa trên thông số cơ thể và mục tiêu cá nhân theo chuẩn y khoa Mifflin-St Jeor.',
                style: TextStyle(color: AppColors.onSurfaceVariant, fontSize: 14),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: AppValues.spacing24),

              // Main Calorie Target Card
              Container(
                padding: const EdgeInsets.all(AppValues.cardPadding * 1.5),
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.2),
                      AppColors.surfaceContainer,
                    ],
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                  ),
                  borderRadius: BorderRadius.circular(AppValues.cardRadius * 1.5),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primary.withValues(alpha: 0.2),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    const Text(
                      'MỤC TIÊU HÀNG NGÀY',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: AppValues.spacing8),
                    Text(
                      '$targetCalories',
                      style: const TextStyle(
                        fontSize: 48,
                        fontWeight: FontWeight.w900,
                        color: AppColors.onSurface,
                        letterSpacing: -1,
                      ),
                    ),
                    const Text(
                      'kcal / ngày',
                      style: TextStyle(
                        fontSize: 16,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: AppValues.spacing16),
                    const Divider(color: AppColors.outline),
                    const SizedBox(height: AppValues.spacing8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'BMR',
                              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${bmr.round()} kcal',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 28, color: AppColors.outline),
                        Column(
                          children: [
                            const Text(
                              'TDEE',
                              style: TextStyle(fontSize: 12, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tdee.round()} kcal',
                              style: const TextStyle(fontWeight: FontWeight.bold, color: AppColors.onSurface),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ),

              if (isSafetyFloorTriggered) ...[
                const SizedBox(height: AppValues.spacing16),
                Container(
                  padding: const EdgeInsets.all(AppValues.spacing12),
                  decoration: BoxDecoration(
                    color: AppColors.tertiary.withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(AppValues.cardRadius),
                    border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.tertiary, size: 20),
                      const SizedBox(width: AppValues.spacing8),
                      Expanded(
                        child: Text(
                          'Mục tiêu calo đã được điều chỉnh về ngưỡng an toàn tối thiểu (${safetyFloor.round()} kcal) để bảo vệ sức khỏe của bạn.',
                          style: const TextStyle(fontSize: 12, color: AppColors.tertiary),
                        ),
                      ),
                    ],
                  ),
                ),
              ],

              const SizedBox(height: AppValues.spacing24),

              // Macro Distribution
              const Text(
                'Phân Bổ Dinh Dưỡng Đa Lượng (Macro Split)',
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: AppColors.onSurface,
                ),
              ),
              const SizedBox(height: AppValues.spacing12),
              GlassCard(
                child: Column(
                  children: [
                    MacroBar(
                      label: 'Carbohydrates (45%)',
                      currentG: macros.carbsG,
                      targetG: macros.carbsG,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppValues.spacing16),
                    MacroBar(
                      label: 'Protein (30%)',
                      currentG: macros.proteinG,
                      targetG: macros.proteinG,
                      color: AppColors.tertiary,
                    ),
                    const SizedBox(height: AppValues.spacing16),
                    MacroBar(
                      label: 'Chất Béo / Fat (25%)',
                      currentG: macros.fatG,
                      targetG: macros.fatG,
                      color: AppColors.secondary,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppValues.spacing32),

              // CTA Button
              SizedBox(
                height: 52,
                child: FilledButton(
                  onPressed: _isSaving ? null : () => _handleStartJourney(targetCalories),
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppValues.cardRadius),
                    ),
                  ),
                  child: _isSaving
                      ? const SizedBox(
                          width: 24,
                          height: 24,
                          child: CircularProgressIndicator(color: Colors.white, strokeWidth: 2),
                        )
                      : const Text(
                          'Bắt Đầu Hành Trình AstroBite',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
