import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../../domain/tracker_providers.dart';

/// Horizontal 7-day strip selector for quick date navigation.
/// Highlights selected date and clearly identifies today.
class DatePickerStrip extends ConsumerWidget {
  const DatePickerStrip({super.key});

  static String _weekdayLabel(DateTime date) => switch (date.weekday) {
        DateTime.monday => 'T2',
        DateTime.tuesday => 'T3',
        DateTime.wednesday => 'T4',
        DateTime.thursday => 'T5',
        DateTime.friday => 'T6',
        DateTime.saturday => 'T7',
        DateTime.sunday => 'CN',
        _ => '',
      };

  static bool _isSameDay(DateTime a, DateTime b) =>
      a.year == b.year && a.month == b.month && a.day == b.day;

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final selectedDate = ref.watch(selectedDateProvider);
    final today = DateTime.now();

    // 7 days ending at today
    final days = List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );

    return SizedBox(
      height: 74,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          final isSelected = _isSameDay(day, selectedDate);
          final isToday = _isSameDay(day, today);

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: () {
                    ref.read(selectedDateProvider.notifier).state = day;
                  },
                  borderRadius: BorderRadius.circular(16),
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    curve: Curves.easeOutCubic,
                    padding: const EdgeInsets.symmetric(vertical: 8),
                    decoration: BoxDecoration(
                      color: isSelected
                          ? AppColors.primary
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(16),
                      border: Border.all(
                        color: isSelected
                            ? const Color(0xFF1488C2)
                            : (isToday
                                ? AppColors.primary.withValues(alpha: 0.6)
                                : const Color(0xFFEDE9E1)),
                        width: isSelected || isToday ? 1.4 : 1.1,
                      ),
                      boxShadow: isSelected
                          ? const [
                              // 3D Duolingo bottom bevel
                              BoxShadow(
                                color: Color(0xFF1488C2),
                                offset: Offset(0, 3.5),
                                blurRadius: 0,
                              ),
                              // Floating blue glow
                              BoxShadow(
                                color: Color(0x351CB0F6),
                                blurRadius: 10,
                                offset: Offset(0, 5),
                              ),
                            ]
                          : const [
                              // Clay bottom bevel for unselected tiles
                              BoxShadow(
                                color: Color(0xFFDDD8CE),
                                offset: Offset(0, 3),
                                blurRadius: 0,
                              ),
                              // Ambient soft shadow
                              BoxShadow(
                                color: Color(0x0E1E2337),
                                offset: Offset(0, 4),
                                blurRadius: 6,
                              ),
                            ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          _weekdayLabel(day),
                          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : (isToday
                                        ? AppColors.primary
                                        : AppColors.onSurfaceVariant),
                                fontWeight: isSelected || isToday
                                    ? FontWeight.bold
                                    : FontWeight.w600,
                                fontSize: 11,
                              ),
                        ),
                        const SizedBox(height: 2),
                        Text(
                          '${day.day}',
                          style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                color: isSelected
                                    ? Colors.white
                                    : AppColors.onSurface,
                                fontWeight: FontWeight.w800,
                                fontSize: 15,
                              ),
                        ),
                        if (isToday)
                          Container(
                            margin: const EdgeInsets.only(top: 3),
                            width: 5,
                            height: 5,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: isSelected
                                  ? Colors.white
                                  : AppColors.primary,
                            ),
                          )
                        else
                          const SizedBox(height: 5),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}
