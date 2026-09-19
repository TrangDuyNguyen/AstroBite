import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';

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

  @override
  void dispose() {
    _pageController.dispose();
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
            // Progress Bar
            Padding(
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
            ),
            const SizedBox(height: AppValues.spacing16),

            // Page Content
            Expanded(
              child: PageView(
                controller: _pageController,
                physics: const NeverScrollableScrollPhysics(),
                onPageChanged: (index) => setState(() => _currentStep = index),
                children: [
                  _buildStepGender(),
                  _buildStepAgeAndHeight(),
                  _buildStepWeight(),
                  _buildStepActivityLevel(),
                  _buildStepFitnessGoal(),
                ],
              ),
            ),

            // Bottom CTA
            Padding(
              padding: const EdgeInsets.all(AppValues.screenPadding),
              child: SizedBox(
                width: double.infinity,
                height: 52,
                child: FilledButton(
                  onPressed: _nextStep,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppValues.cardRadius),
                    ),
                  ),
                  child: Text(
                    _currentStep == 4 ? 'Xem Kế Hoạch Cá Nhân' : 'Tiếp tục',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // Step 1: Gender
  Widget _buildStepGender() {
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
                child: _buildSelectCard(
                  title: 'Nam',
                  icon: Icons.male,
                  isSelected: _gender == 'male',
                  onTap: () => setState(() => _gender = 'male'),
                ),
              ),
              const SizedBox(width: AppValues.spacing16),
              Expanded(
                child: _buildSelectCard(
                  title: 'Nữ',
                  icon: Icons.female,
                  isSelected: _gender == 'female',
                  onTap: () => setState(() => _gender = 'female'),
                ),
              ),
            ],
          ),
          const Spacer(flex: 2),
        ],
      ),
    );
  }

  // Step 2: Age & Height
  Widget _buildStepAgeAndHeight() {
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
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Năm sinh', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    Text(
                      '$_birthYear (${DateTime.now().year - _birthYear} tuổi)',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                  ],
                ),
                Slider(
                  value: _birthYear.toDouble(),
                  min: 1950,
                  max: DateTime.now().year.toDouble() - 10,
                  divisions: DateTime.now().year - 1960,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _birthYear = v.round()),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.spacing16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Chiều cao', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    Text(
                      '${_heightCm.round()} cm',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.primary),
                    ),
                  ],
                ),
                Slider(
                  value: _heightCm,
                  min: 120,
                  max: 220,
                  divisions: 100,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _heightCm = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 3: Weight
  Widget _buildStepWeight() {
    final heightM = _heightCm / 100;
    final bmi = _weightKg / (heightM * heightM);

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
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cân nặng hiện tại', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    Text(
                      '${_weightKg.toStringAsFixed(1)} kg',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.onSurface),
                    ),
                  ],
                ),
                Slider(
                  value: _weightKg,
                  min: 35,
                  max: 180,
                  divisions: 290,
                  activeColor: AppColors.primary,
                  onChanged: (v) => setState(() => _weightKg = v),
                ),
              ],
            ),
          ),
          const SizedBox(height: AppValues.spacing16),
          GlassCard(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text('Cân nặng mục tiêu', style: TextStyle(color: AppColors.onSurfaceVariant)),
                    Text(
                      '${_targetWeightKg.toStringAsFixed(1)} kg',
                      style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: AppColors.tertiary),
                    ),
                  ],
                ),
                Slider(
                  value: _targetWeightKg,
                  min: 35,
                  max: 180,
                  divisions: 290,
                  activeColor: AppColors.tertiary,
                  onChanged: (v) => setState(() => _targetWeightKg = v),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Step 4: Activity Level
  Widget _buildStepActivityLevel() {
    final levels = [
      ('sedentary', 'Ít vận động', 'Ngồi văn phòng, không tập thể thao (x1.2)'),
      ('light', 'Vận động nhẹ', 'Tập nhẹ 1-3 ngày/tuần hoặc đi bộ (x1.375)'),
      ('moderate', 'Vừa phải', 'Tập thể dục 3-5 ngày/tuần (x1.55)'),
      ('very_active', 'Năng động cao', 'Tập nặng 6-7 ngày/tuần (x1.725)'),
      ('extremely_active', 'Cực kỳ nặng', 'Vận động viên hoặc lao động thể lực (x1.9)'),
    ];

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
          ...levels.map((item) {
            final isSelected = _activityLevel == item.$1;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppValues.spacing12),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppValues.cardRadius),
                onTap: () => setState(() => _activityLevel = item.$1),
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

  // Step 5: Fitness Goal
  Widget _buildStepFitnessGoal() {
    final goals = [
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
          ...goals.map((goal) {
            final isSelected = _fitnessGoal == goal.$1;
            return Padding(
              padding: const EdgeInsets.only(bottom: AppValues.spacing16),
              child: InkWell(
                borderRadius: BorderRadius.circular(AppValues.cardRadius),
                onTap: () => setState(() => _fitnessGoal = goal.$1),
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

  Widget _buildSelectCard({
    required String title,
    required IconData icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppValues.cardRadius),
      onTap: onTap,
      child: Container(
        height: 140,
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainer : AppColors.surfaceContainer.withValues(alpha: 0.4),
          borderRadius: BorderRadius.circular(AppValues.cardRadius),
          border: Border.all(
            color: isSelected ? AppColors.primary : AppColors.outline.withValues(alpha: 0.3),
            width: isSelected ? 2 : 1,
          ),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    blurRadius: 12,
                    spreadRadius: 2,
                  ),
                ]
              : null,
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 48,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(height: AppValues.spacing8),
            Text(
              title,
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _getBmiCategory(double bmi) {
    if (bmi < 18.5) return 'Gầy';
    if (bmi < 24.9) return 'Bình thường';
    if (bmi < 29.9) return 'Thừa cân';
    return 'Béo phì';
  }
}
