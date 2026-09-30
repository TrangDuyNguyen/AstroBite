import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/utils/nutrition_calculator.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/features/profile/data/models/user_profile_dto.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

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
        surfaceTintColor: Colors.transparent,
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
              ClayCard(
                borderRadius: 20,
                elevation: 4,
                padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 24),
                child: Column(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                      decoration: BoxDecoration(
                        color: AppColors.clayLunch,
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Text(
                        'MỤC TIÊU HÀNG NGÀY',
                        style: TextStyle(
                          fontSize: 11,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.1,
                          color: AppColors.primary,
                        ),
                      ),
                    ),
                    const SizedBox(height: AppValues.spacing24),
                    CalorieProgressArc(
                      consumed: 0,
                      target: targetCalories,
                      size: 240,
                    ),
                    const SizedBox(height: AppValues.spacing24),
                    const Divider(color: Color(0xFFF0EFEB), height: 1),
                    const SizedBox(height: AppValues.spacing12),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        Column(
                          children: [
                            const Text(
                              'BMR',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${bmr.round()} kcal',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.primary),
                            ),
                            const Text(
                              'Năng lượng nghỉ',
                              style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
                            ),
                          ],
                        ),
                        Container(width: 1, height: 36, color: const Color(0xFFE8E5DF)),
                        Column(
                          children: [
                            const Text(
                              'TDEE',
                              style: TextStyle(fontSize: 12, fontWeight: FontWeight.w600, color: AppColors.onSurfaceVariant),
                            ),
                            const SizedBox(height: 2),
                            Text(
                              '${tdee.round()} kcal',
                              style: const TextStyle(fontWeight: FontWeight.w800, fontSize: 15, color: AppColors.tertiary),
                            ),
                            const Text(
                              'Tiêu thụ/ngày',
                              style: TextStyle(fontSize: 10, color: AppColors.onSurfaceVariant),
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
                    color: AppColors.clayBreakfast,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(color: AppColors.tertiary.withValues(alpha: 0.4)),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.info_outline, color: AppColors.tertiary, size: 20),
                      const SizedBox(width: AppValues.spacing8),
                      Expanded(
                        child: Text(
                          'Mục tiêu calo đã được điều chỉnh về ngưỡng an toàn tối thiểu (${safetyFloor.round()} kcal) để bảo vệ sức khỏe của bạn.',
                          style: const TextStyle(fontSize: 12, color: AppColors.onSurface, fontWeight: FontWeight.w500),
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
              ClayCard(
                borderRadius: 20,
                elevation: 4,
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: [
                    ChunkyMacroBar(
                      label: 'Carbohydrates (45%)',
                      currentG: macros.carbsG,
                      targetG: macros.carbsG,
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: AppValues.spacing16),
                    ChunkyMacroBar(
                      label: 'Protein (30%)',
                      currentG: macros.proteinG,
                      targetG: macros.proteinG,
                      color: AppColors.tertiary,
                    ),
                    const SizedBox(height: AppValues.spacing16),
                    ChunkyMacroBar(
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
              ClayButton(
                text: 'Bắt Đầu Hành Trình AstroBite',
                height: 52,
                borderRadius: 22,
                variant: ClayButtonVariant.primary,
                isLoading: _isSaving,
                onPressed: _isSaving ? null : () => _handleStartJourney(targetCalories),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
