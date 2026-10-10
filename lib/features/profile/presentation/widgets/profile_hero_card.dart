import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/user_profile.dart';

class ProfileHeroCard extends StatelessWidget {
  const ProfileHeroCard({
    super.key,
    required this.user,
    required this.profile,
    required this.onEditPressed,
    this.isEditDisabled = false,
  });

  final User? user;
  final UserProfile profile;
  final VoidCallback onEditPressed;
  final bool isEditDisabled;

  String _translateFitnessGoal(BuildContext context, String? goal) {
    final l10n = context.l10n;
    return switch (goal) {
      'lose_weight' => l10n.goalLoseWeight,
      'maintain' => l10n.goalMaintain,
      'gain_muscle' => l10n.goalGainMuscle,
      _ => l10n.goalMaintain,
    };
  }

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      borderRadius: 22,
      elevation: 4,
      padding: const EdgeInsets.all(18),
      child: Column(
        children: [
          Row(
            children: [
              // Tactile 3D Avatar
              Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: const LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      Color(0xFF38BDF8),
                      AppColors.primary,
                    ],
                  ),
                  border: Border.all(
                    color: Colors.white,
                    width: 2.5,
                  ),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x301CB0F6),
                      offset: Offset(0, 4),
                      blurRadius: 10,
                    ),
                  ],
                ),
                alignment: Alignment.center,
                child: Text(
                  user?.email?.isNotEmpty == true ? user!.email![0].toUpperCase() : '👤',
                  style: const TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.w800,
                    color: Colors.white,
                  ),
                ),
              ),
              const SizedBox(width: 16),
              // User Info
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      user?.email ?? 'Chưa đăng nhập',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            fontWeight: FontWeight.w800,
                            fontSize: 16,
                            color: AppColors.onSurface,
                          ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 4),
                    Wrap(
                      spacing: 6,
                      runSpacing: 4,
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.clayLunch,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            '🎯 ${_translateFitnessGoal(context, profile.fitnessGoal)}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.primary,
                            ),
                          ),
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                          decoration: BoxDecoration(
                            color: AppColors.clayMint,
                            borderRadius: BorderRadius.circular(10),
                            border: Border.all(
                              color: AppColors.brandGreen.withValues(alpha: 0.25),
                            ),
                          ),
                          child: Text(
                            '📊 BMI ${profile.bmi.toStringAsFixed(1)} • ${profile.bmiCategory}',
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              color: AppColors.brandGreen,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          // Compact Edit Profile Button
          ClayButton(
            text: 'Chỉnh sửa thông số',
            height: 42,
            borderRadius: 16,
            variant: ClayButtonVariant.outline,
            icon: const Icon(Icons.tune_rounded, size: 16, color: AppColors.onSurface),
            onPressed: isEditDisabled ? null : onEditPressed,
          ),
        ],
      ),
    );
  }
}
