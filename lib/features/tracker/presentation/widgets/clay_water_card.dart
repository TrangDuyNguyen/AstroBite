import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/water_log.dart';
import '../../domain/tracker_providers.dart';
import '../../domain/water_goal_calculator.dart';
import '../controllers/water_controller.dart';
import 'water_quick_action_button.dart';
import 'water_tracking_sheet.dart';
import 'water_wave_painter.dart';

/// Claymorphic Water Intake Tracker Card for Home Dashboard
class ClayWaterCard extends ConsumerWidget {
  const ClayWaterCard({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final waterLogAsync = ref.watch(dailyWaterStreamProvider);
    final waterLog = waterLogAsync.value ?? WaterDayLog.initial(date: 'today');
    final feedback = WaterGoalCalculator.evaluateStatus(
      waterLog.currentMl,
      waterLog.targetMl,
    );

    return ClayCard(
      onTap: () => WaterTrackingSheet.show(context),
      borderColor: waterLog.isGoalReached ? const Color(0xFFBCE3A1) : null,
      bevelColor: waterLog.isGoalReached ? const Color(0xFFC7EBB2) : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  // 3D Clay Squircle Water Icon
                  Container(
                    width: 34,
                    height: 34,
                    decoration: BoxDecoration(
                      color: const Color(0xFFE5F6FD),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFFCDECFB), width: 1.2),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFB8E2FA),
                          offset: Offset(0, 2),
                          blurRadius: 0,
                        ),
                        BoxShadow(
                          color: Color(0x101CB0F6),
                          offset: Offset(0, 3),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Text('💧', style: TextStyle(fontSize: 16)),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  const Text(
                    'Nước Uống Hôm Nay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              // 3D Puffy Clay Goal Badge
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: waterLog.isGoalReached
                      ? AppColors.clayMint
                      : AppColors.clayLunch,
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(
                    color: waterLog.isGoalReached
                        ? const Color(0xFFC7EBB2)
                        : const Color(0xFFCDECFB),
                    width: 1.2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: waterLog.isGoalReached
                          ? const Color(0xFFB8E3A0)
                          : const Color(0xFFBCE1F5),
                      offset: const Offset(0, 2),
                      blurRadius: 0,
                    ),
                  ],
                ),
                child: Text(
                  waterLog.isGoalReached
                      ? '🎉 Đạt mục tiêu!'
                      : '${waterLog.targetMl} ml 🎯',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: waterLog.isGoalReached
                        ? AppColors.brandGreen
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          Row(
            children: [
              WaterWaveIndicator(
                progress: waterLog.progress,
                isGoalReached: waterLog.isGoalReached,
                size: 82,
              ),
              const SizedBox(width: AppValues.spacing16),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.baseline,
                      textBaseline: TextBaseline.alphabetic,
                      children: [
                        Text(
                          '${waterLog.currentMl}',
                          style: const TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.w900,
                            color: AppColors.onSurface,
                            letterSpacing: -0.5,
                          ),
                        ),
                        Text(
                          ' / ${waterLog.targetMl} ml',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w700,
                            color: AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 2),
                    Text(
                      waterLog.isGoalReached
                          ? 'Đã vượt ${waterLog.currentMl - waterLog.targetMl} ml so với mục tiêu'
                          : 'Còn ${waterLog.remainingMl} ml nữa để đạt 100%',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        color: waterLog.isGoalReached
                            ? AppColors.brandGreen
                            : AppColors.primary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${feedback.icon} ${feedback.message}',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          Row(
            children: [
              Expanded(
                child: WaterQuickActionButton(
                  icon: '🥛',
                  label: '+250 ml',
                  onTap: () => ref
                      .read(waterControllerProvider.notifier)
                      .addWater(250),
                ),
              ),
              const SizedBox(width: AppValues.spacing8),
              Expanded(
                child: WaterQuickActionButton(
                  icon: '🧴',
                  label: '+500 ml',
                  onTap: () => ref
                      .read(waterControllerProvider.notifier)
                      .addWater(500),
                ),
              ),
              const SizedBox(width: AppValues.spacing8),
              Expanded(
                child: WaterQuickActionButton(
                  icon: '⚙️',
                  label: 'Tùy chọn',
                  onTap: () => WaterTrackingSheet.show(context),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
