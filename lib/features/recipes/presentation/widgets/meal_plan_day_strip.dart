import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../controllers/meal_plan_controller.dart';

/// 7-day horizontal calendar carousel adhering to Duolingo 3D Claymorphism.
class MealPlanDayStrip extends ConsumerWidget {
  const MealPlanDayStrip({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedPlanDateProvider);
    final today = DateTime.now();

    return SizedBox(
      height: 82,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.screenPadding,
          vertical: AppValues.spacing4,
        ),
        itemCount: 7,
        separatorBuilder: (_, __) => const SizedBox(width: AppValues.spacing8),
        itemBuilder: (context, i) {
          final day = today.add(Duration(days: i));
          final iso = _toIso(day);
          final isSelected = iso == selectedDate;
          final isToday = i == 0;

          return GestureDetector(
            onTap: () =>
                ref.read(selectedPlanDateProvider.notifier).state = iso,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 180),
              curve: Curves.easeOutCubic,
              width: 52,
              decoration: BoxDecoration(
                color: isSelected ? AppColors.primary : AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
                border: Border.all(
                  color: isSelected
                      ? const Color(0xFF1488C2)
                      : const Color(0xFFEDE9E1),
                  width: 1.2,
                ),
                boxShadow: [
                  // Solid bottom bevel
                  BoxShadow(
                    color: isSelected
                        ? const Color(0xFF1488C2)
                        : const Color(0xFFDDD8CE),
                    offset: const Offset(0, 3.5),
                    blurRadius: 0,
                  ),
                  // Ambient float shadow
                  BoxShadow(
                    color: const Color(0x141E2337),
                    offset: const Offset(0, 6),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    isToday ? 'Nay' : _weekday(day),
                    style: TextStyle(
                      color: isSelected
                          ? Colors.white.withValues(alpha: 0.9)
                          : AppColors.onSurfaceVariant,
                      fontSize: 11,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: AppValues.spacing4),
                  Text(
                    '${day.day}',
                    style: TextStyle(
                      color: isSelected ? Colors.white : AppColors.onSurface,
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                  if (isToday) ...[
                    const SizedBox(height: 3),
                    Container(
                      width: 5,
                      height: 5,
                      decoration: BoxDecoration(
                        color: isSelected ? Colors.white : AppColors.brandGreen,
                        shape: BoxShape.circle,
                      ),
                    ),
                  ],
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _toIso(DateTime d) =>
      '${d.year}-${d.month.toString().padLeft(2, '0')}-${d.day.toString().padLeft(2, '0')}';

  String _weekday(DateTime d) => const [
        'CN', 'T2', 'T3', 'T4', 'T5', 'T6', 'T7'
      ][d.weekday % 7];
}

