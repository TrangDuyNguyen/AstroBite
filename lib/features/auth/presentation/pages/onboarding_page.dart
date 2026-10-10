import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../widgets/onboarding_steps/onboarding_step_gender.dart';
import '../widgets/onboarding_steps/onboarding_step_lifestyle.dart';
import '../widgets/onboarding_steps/onboarding_step_metrics.dart';

@RoutePage()
class OnboardingPage extends StatefulWidget {
  const OnboardingPage({super.key});

  @override
  State<OnboardingPage> createState() => _OnboardingPageState();
}

class _OnboardingPageState extends State<OnboardingPage> {
  final PageController _pageController = PageController();
  int _currentStep = 0;

  // Survey state
  String _gender = 'male';
  int _birthYear = 1998;
  double _heightCm = 175;
  double _weightKg = 75;
  double _targetWeightKg = 70;
  String _activityLevel = 'light';
  String _fitnessGoal = 'lose_weight';

  late final TextEditingController _birthYearController = TextEditingController(text: _birthYear.toString());
  late final TextEditingController _heightController = TextEditingController(text: _heightCm.round().toString());
  late final TextEditingController _weightController = TextEditingController(text: _weightKg.toStringAsFixed(1));
  late final TextEditingController _targetWeightController = TextEditingController(text: _targetWeightKg.toStringAsFixed(1));

  @override
  void dispose() {
    _pageController.dispose();
    _birthYearController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    super.dispose();
  }

  void _nextStep() {
    if (_currentStep < 4) {
      _pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      context.router.push(
        GoalSummaryRoute(
          gender: _gender,
          birthYear: _birthYear,
          heightCm: _heightCm,
          weightKg: _weightKg,
          targetWeightKg: _targetWeightKg,
          activityLevel: _activityLevel,
          fitnessGoal: _fitnessGoal,
        ),
      );
    }
  }

  void _previousStep() {
    if (_currentStep > 0) {
      _pageController.previousPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: _currentStep > 0
            ? IconButton(
                icon: const Icon(Icons.arrow_back_ios_new, color: AppColors.onSurface),
                onPressed: _previousStep,
              )
            : null,
        title: Text(
          'Bước ${_currentStep + 1} / 5',
          style: const TextStyle(
            color: AppColors.onSurfaceVariant,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Column(
          children: [
            _buildProgressBar(),
            const SizedBox(height: AppValues.spacing16),
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: [
                  OnboardingStepGender(
                    selectedGender: _gender,
                    onSelectGender: (v) => setState(() => _gender = v),
                  ),
                  OnboardingStepAgeAndHeight(
                    birthYearController: _birthYearController,
                    heightController: _heightController,
                    birthYear: _birthYear,
                    onBirthYearChanged: (v) => setState(() => _birthYear = v),
                    onHeightChanged: (v) => setState(() => _heightCm = v),
                  ),
                  OnboardingStepWeight(
                    weightController: _weightController,
                    targetWeightController: _targetWeightController,
                    weightKg: _weightKg,
                    heightCm: _heightCm,
                    onWeightChanged: (v) => setState(() => _weightKg = v),
                    onTargetWeightChanged: (v) => setState(() => _targetWeightKg = v),
                  ),
                  OnboardingStepActivityLevel(
                    activityLevel: _activityLevel,
                    onChanged: (v) => setState(() => _activityLevel = v),
                  ),
                  OnboardingStepFitnessGoal(
                    fitnessGoal: _fitnessGoal,
                    onChanged: (v) => setState(() => _fitnessGoal = v),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppValues.screenPadding),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: ClayButton(
                  onPressed: _nextStep,
                  text: _currentStep == 4 ? 'Xem Kế Hoạch Cá Nhân' : 'Tiếp tục',
                  height: 52,
                  width: double.infinity,
                  borderRadius: 22,
                  variant: ClayButtonVariant.primary,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding),
      child: Row(
        children: List.generate(5, (index) {
          final isActive = index <= _currentStep;
          return Expanded(
            child: Container(
              height: 4,
              margin: const EdgeInsets.symmetric(horizontal: 3),
              decoration: BoxDecoration(
                color: isActive ? AppColors.primary : AppColors.outline.withValues(alpha: 0.3),
                borderRadius: BorderRadius.circular(2),
                boxShadow: isActive
                    ? [
                        BoxShadow(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        )
                      ]
                    : null,
              ),
            ),
          );
        }),
      ),
    );
  }
}
