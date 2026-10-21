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
      borderColor: waterLog.isGoalReached ? AppColors.brandGreen : null,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Row(
                children: [
                  Text('💧', style: TextStyle(fontSize: 18)),
                  SizedBox(width: AppValues.spacing8),
                  Text(
                    'Nước Uống Hôm Nay',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: AppColors.onSurface,
                    ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: waterLog.isGoalReached
                      ? AppColors.clayMint
                      : AppColors.clayLunch,
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Text(
                  waterLog.isGoalReached
                      ? '🎉 Đạt mục tiêu!'
                      : '${waterLog.targetMl} ml 🎯',
                  style: TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: waterLog.isGoalReached
                        ? AppColors.brandGreen
                        : AppColors.primary,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),
          Row(
            children: [
              WaterWaveIndicator(
                progress: waterLog.progress,
                isGoalReached: waterLog.isGoalReached,
                size: 80,
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
                            fontSize: 22,
                            fontWeight: FontWeight.w800,
                            color: AppColors.onSurface,
                          ),
                        ),
                        Text(
                          ' / ${waterLog.targetMl} ml',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
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
                        fontWeight: FontWeight.w600,
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
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),
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

