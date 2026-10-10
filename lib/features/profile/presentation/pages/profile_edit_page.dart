import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/profile_enums.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/core/utils/nutrition_calculator.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

import '../../data/models/user_profile_dto.dart';
import '../../domain/profile_providers.dart';
import '../controllers/profile_controller.dart';
import '../widgets/biological_info_card.dart';
import '../widgets/fitness_goal_card.dart';

@RoutePage()
class ProfileEditPage extends ConsumerStatefulWidget {
  const ProfileEditPage({super.key});

  @override
  ConsumerState<ProfileEditPage> createState() => _ProfileEditPageState();
}

class _ProfileEditPageState extends ConsumerState<ProfileEditPage> {
  final _formKey = GlobalKey<FormState>();
  Gender _gender = ProfileDefaults.gender;
  late final TextEditingController _birthYearController;
  late final TextEditingController _heightController;
  late final TextEditingController _weightController;
  late final TextEditingController _targetWeightController;
  late final TextEditingController _targetCalController;
  ActivityLevel _activityLevel = ProfileDefaults.activityLevel;
  FitnessGoal _fitnessGoal = ProfileDefaults.fitnessGoal;

  @override
  void initState() {
    super.initState();
    final profile = ref.read(userProfileStreamProvider).valueOrNull;

    _gender = profile?.genderEnum ?? ProfileDefaults.gender;
    _birthYearController = TextEditingController(
      text: '${profile?.birthYear ?? ProfileDefaults.birthYear}',
    );
    _heightController = TextEditingController(
      text: '${profile?.heightCm.round() ?? ProfileDefaults.heightCm.round()}',
    );
    _weightController = TextEditingController(
      text: '${profile?.weightKg.round() ?? ProfileDefaults.weightKg.round()}',
    );
    _targetWeightController = TextEditingController(
      text: profile?.targetWeightKg != null ? '${profile!.targetWeightKg!.round()}' : '',
    );
    _targetCalController = TextEditingController(
      text: '${profile?.dailyTargetCalories ?? ProfileDefaults.dailyTargetCalories}',
    );
    _activityLevel = profile?.activityLevelEnum ?? ProfileDefaults.activityLevel;
    _fitnessGoal = profile?.fitnessGoalEnum ?? ProfileDefaults.fitnessGoal;

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
    final birthYear = int.tryParse(_birthYearController.text) ?? ProfileDefaults.birthYear;
    final age = DateTime.now().year - birthYear;
    final height = double.tryParse(_heightController.text) ?? ProfileDefaults.heightCm;
    final weight = double.tryParse(_weightController.text) ?? ProfileDefaults.weightKg;
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
      gender: _gender.value,
      birthYear: int.tryParse(_birthYearController.text) ?? ProfileDefaults.birthYear,
      heightCm: double.tryParse(_heightController.text) ?? ProfileDefaults.heightCm,
      weightKg: double.tryParse(_weightController.text) ?? ProfileDefaults.weightKg,
      targetWeightKg: targetWeight,
      fitnessGoal: _fitnessGoal.value,
      activityLevel: _activityLevel.value,
      dailyTargetCalories: int.tryParse(_targetCalController.text) ?? ProfileDefaults.dailyTargetCalories,
      isOnboardingCompleted: true,
    );

    final success = await ref.read(profileControllerProvider.notifier).saveProfile(dto);

    if (success && mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(context.l10n.profileUpdateSuccess),
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
        title: context.l10n.editProfile,
        centerTitle: true,
        onBack: () => context.router.popForced(),
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: ListView(
            padding: const EdgeInsets.symmetric(horizontal: AppValues.screenPadding, vertical: 12),
            children: [
              BiologicalInfoCard(
                gender: _gender,
                onGenderChanged: (value) => setState(() => _gender = value),
                birthYearController: _birthYearController,
                heightController: _heightController,
                weightController: _weightController,
                targetWeightController: _targetWeightController,
              ),
              const SizedBox(height: AppValues.spacing20),
              FitnessGoalCard(
                fitnessGoal: _fitnessGoal,
                onFitnessGoalChanged: (value) => setState(() => _fitnessGoal = value),
                activityLevel: _activityLevel,
                onActivityLevelChanged: (value) => setState(() => _activityLevel = value),
                recommendedCalories: recommendedCal,
                targetCalController: _targetCalController,
                onApplyRecommendation: () {
                  setState(() {
                    _targetCalController.text = '$recommendedCal';
                  });
                },
              ),
              const SizedBox(height: AppValues.spacing24),
              ClayButton(
                text: context.l10n.saveChanges,
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
}
