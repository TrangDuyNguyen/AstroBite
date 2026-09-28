import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/utils/nutrition_calculator.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

import '../../data/models/user_profile_dto.dart';
import '../../domain/profile_providers.dart';
import '../controllers/profile_controller.dart';

@RoutePage()
class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  String _gender = 'male';
  late final TextEditingController _birthYearController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _targetWeightController;
  late final TextEditingController _targetCalController;
  String _activityLevel = 'moderate';
  String _fitnessGoal = 'maintain';

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileStreamProvider).valueOrNull;

    _gender = profile?.gender ?? 'male';
    _birthYearController = TextEditingController(text: '${profile?.birthYear ?? 1995}');
    _heightController = TextEditingController(text: '${profile?.heightCm.round() ?? 170}');
    _weightController = TextEditingController(text: '${profile?.weightKg.round() ?? 65}');
    _targetWeightController = TextEditingController(
      text: profile?.targetWeightKg != null ? '${profile!.targetWeightKg!.round()}' : '',
    );
    _targetCalController = TextEditingController(text: '${profile?.dailyTargetCalories ?? 2000}');
    _activityLevel = profile?.activityLevel ?? 'moderate';
    _fitnessGoal = profile?.fitnessGoal ?? 'maintain';

    _birthYearController.addListener(_onFieldChanged);
    _heightController.addListener(_onFieldChanged);
    _weightController.addListener(_onFieldChanged);
  }

  void _onFieldChanged() {
    setState(() {});
  }

  @override
  void dispose() {
    _birthYearController.removeListener(_onFieldChanged);
    _heightController.removeListener(_onFieldChanged);
    _weightController.removeListener(_onFieldChanged);
    _birthYearController.dispose();
    _heightController.dispose();
    _weightController.dispose();
    _targetWeightController.dispose();
    _targetCalController.dispose();
    super.dispose();
  }

  int get _calculatedTargetCalories {
    final birthYear = int.tryParse(_birthYearController.text) ?? 1995;
    final age = DateTime.now().year - birthYear;
    final height = double.tryParse(_heightController.text) ?? 170;
    final weight = double.tryParse(_weightController.text) ?? 65;
    final bmr = NutritionCalculator.calculateBMR(
      weightKg: weight,
      heightCm: height,
      age: age,
      gender: _gender,
    );
    final tdee = NutritionCalculator.calculateTDEE(
      bmr: bmr,
      activityLevel: _activityLevel,
    );
    return NutritionCalculator.calculateTargetCalories(
      tdee: tdee,
      goal: _fitnessGoal,
      gender: _gender,
    );
  }

  Future<void> _handleSave() async {
    if (!_formKey.currentState!.validate()) return;
    final user = ref.read(authRepositoryProvider).currentUser;
    if (user == null) return;

    final targetWeightText = _targetWeightController.text.trim();
    final targetWeight = targetWeightText.isNotEmpty ? double.tryParse(targetWeightText) : null;

    final dto = UserProfileDto(
      uid: user.uid,
      gender: _gender,
      birthYear: int.tryParse(_birthYearController.text) ?? 1995,
      heightCm: double.tryParse(_heightController.text) ?? 170,
      weightKg: double.tryParse(_weightController.text) ?? 65,
      targetWeightKg: targetWeight,
      fitnessGoal: _fitnessGoal,
      activityLevel: _activityLevel,
      dailyTargetCalories: int.tryParse(_targetCalController.text) ?? 2000,
      isOnboardingCompleted: true,
    );

    final success = await ref.read(profileControllerProvider.notifier).saveProfile(dto);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✨ Đã cập nhật hồ sơ & mục tiêu dinh dưỡng thành công!'),
          behavior: SnackBarBehavior.floating,
        ),
      );
      context.router.popForced();
    }
  }

  @override
  Widget build(BuildContext context) {
    final profileState = ref.watch(profileControllerProvider);
    final recommendedCal = _calculatedTargetCalories;

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: ClayAppBar(
        title: 'Chỉnh sửa hồ sơ',
        centerTitle: true,
        onBack: () => context.router.popForced(),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding, vertical: 12),
            children: [
              // 1. Biological Info Card
              ClayCard(
                borderRadius: 22,
                elevation: 4,
                padding: const EdgeInsets.all(18),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Thông tin sinh học',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurface,
                          ),
                    ),
                    const SizedBox(height: AppValues.spacing16),

                    // Giới tính
                    const Text(
                      'Giới tính sinh học',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Row(
                      children: [
                        Expanded(
                          child: _buildGenderOption(
                            label: 'Nam',
                            value: 'male',
                            icon: '👨',
                            isSelected: _gender == 'male',
                            onTap: () => setState(() => _gender = 'male'),
                          ),
                        ),
                        const SizedBox(width: 12),
                        Expanded(
                          child: _buildGenderOption(
                            label: 'Nữ',
                            value: 'female',
                            icon: '👩',
                            isSelected: _gender == 'female',
                            onTap: () => setState(() => _gender = 'female'),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: AppValues.spacing16),

                    // Năm sinh
                    ClayTextField(
                      controller: _birthYearController,
                      labelText: 'Năm sinh',
                      hintText: 'VD: 1998',
                      prefixIcon: const Icon(Icons.cake_outlined, color: AppColors.primary, size: 20),
                      keyboardType: TextInputType.number,
                      validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập năm sinh',
                    ),

                    const SizedBox(height: AppValues.spacing16),

                    // Chiều cao
                    ClayTextField(
                      controller: _heightController,
                      labelText: 'Chiều cao (cm)',
                      hintText: 'VD: 170',
                      prefixIcon: const Icon(Icons.height_rounded, color: AppColors.primary, size: 20),
                      keyboardType: TextInputType.number,
                      validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập chiều cao',
                    ),

                    const SizedBox(height: AppValues.spacing16),

                    // Cân nặng hiện tại
                    ClayTextField(
                      controller: _weightController,
                      labelText: 'Cân nặng hiện tại (kg)',
                      hintText: 'VD: 65',
                      prefixIcon: const Icon(Icons.scale_outlined, color: AppColors.secondary, size: 20),
                      keyboardType: TextInputType.number,
                      validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập cân nặng',
                    ),

                    const SizedBox(height: AppValues.spacing16),

                    // Cân nặng mục tiêu
                    ClayTextField(
                      controller: _targetWeightController,
                      labelText: 'Cân nặng mục tiêu (kg, tùy chọn)',
                      hintText: 'VD: 60',
                      prefixIcon: const Icon(Icons.flag_outlined, color: AppColors.brandGreen, size: 20),
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppValues.spacing20),

              // 2. Fitness Goal & Activity Card
              ClayCard(
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
                    _buildGoalOption(
                      title: 'Giảm mỡ & Cải thiện vóc dáng',
                      subtitle: 'Thâm hụt calo an toàn (-500 kcal/ngày)',
                      icon: '🎯',
                      value: 'lose_weight',
                      color: AppColors.primary,
                    ),
                    const SizedBox(height: 8),
                    _buildGoalOption(
                      title: 'Duy trì cân nặng',
                      subtitle: 'Cân bằng calo nạp vào bằng chỉ số TDEE',
                      icon: '⚖️',
                      value: 'maintain',
                      color: AppColors.tertiary,
                    ),
                    const SizedBox(height: 8),
                    _buildGoalOption(
                      title: 'Tăng cơ & Khối lượng nạc',
                      subtitle: 'Thặng dư nhẹ (+300 kcal/ngày) kết hợp tập luyện',
                      icon: '💪',
                      value: 'gain_muscle',
                      color: AppColors.brandGreen,
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
                        child: DropdownButton<String>(
                          value: _activityLevel,
                          isExpanded: true,
                          icon: const Icon(Icons.keyboard_arrow_down_rounded, color: AppColors.primary),
                          items: const [
                            DropdownMenuItem(value: 'sedentary', child: Text('Ít vận động (Ngồi nhiều, bàn giấy)')),
                            DropdownMenuItem(value: 'light', child: Text('Nhẹ (Tập nhẹ 1-3 ngày/tuần)')),
                            DropdownMenuItem(value: 'moderate', child: Text('Vừa phải (Tập 3-5 ngày/tuần)')),
                            DropdownMenuItem(value: 'active', child: Text('Năng động (Tập 6-7 ngày/tuần)')),
                            DropdownMenuItem(value: 'very_active', child: Text('Rất năng động (Lao động/Tập 2 buổi/ngày)')),
                          ],
                          onChanged: (v) {
                            if (v != null) {
                              setState(() => _activityLevel = v);
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
                                  'Khuyến nghị: $recommendedCal kcal/ngày',
                                  style: const TextStyle(fontSize: 13, fontWeight: FontWeight.w800, color: AppColors.onSurface),
                                ),
                              ],
                            ),
                          ),
                          TextButton(
                            onPressed: () {
                              setState(() {
                                _targetCalController.text = '$recommendedCal';
                              });
                            },
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
                      controller: _targetCalController,
                      labelText: 'Mục tiêu Calo/ngày (kcal)',
                      hintText: 'VD: 2000',
                      prefixIcon: const Icon(Icons.local_fire_department_outlined, color: AppColors.tertiary, size: 20),
                      keyboardType: TextInputType.number,
                      validator: (v) => v != null && v.isNotEmpty ? null : 'Vui lòng nhập mục tiêu calo',
                    ),
                  ],
                ),
              ),

              const SizedBox(height: AppValues.spacing24),

              ClayButton(
                text: 'Lưu thay đổi',
                height: 52,
                borderRadius: 22,
                variant: ClayButtonVariant.primary,
                isLoading: profileState.isLoading,
                onPressed: profileState.isLoading ? null : _handleSave,
              ),

              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildGenderOption({
    required String label,
    required String value,
    required String icon,
    required bool isSelected,
    required VoidCallback onTap,
  }) {
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
            Text(icon, style: const TextStyle(fontSize: 18)),
            const SizedBox(width: 8),
            Text(
              label,
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

  Widget _buildGoalOption({
    required String title,
    required String subtitle,
    required String icon,
    required String value,
    required Color color,
  }) {
    final isSelected = _fitnessGoal == value;
    return GestureDetector(
      onTap: () => setState(() => _fitnessGoal = value),
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
            Text(icon, style: const TextStyle(fontSize: 22)),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: TextStyle(
                      fontSize: 13.5,
                      fontWeight: isSelected ? FontWeight.w800 : FontWeight.w600,
                      color: isSelected ? AppColors.onSurface : AppColors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
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
