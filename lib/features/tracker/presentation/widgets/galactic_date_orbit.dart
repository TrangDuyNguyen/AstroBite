import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/gamification/domain/streak_record.dart';
import 'package:astrobite/features/gamification/presentation/controllers/streak_controller.dart';
import '../../domain/tracker_providers.dart';

/// Next-Gen Galactic Date Orbit Strip.
/// Tactile Duolingo 3D Keycaps for seamless 7-day date navigation:
/// - Chunky 3D bottom bevel with mechanical press-down physics
/// - Crisp, unobstructed typography with high contrast
/// - Radiant Sky Blue active tile with ambient celestial aura
/// - Duolingo Lime Green vitality indicator on streak days
class GalacticDateOrbit extends ConsumerWidget {
  const GalacticDateOrbit({super.key});

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
    final streak = ref.watch(streakNotifierProvider).valueOrNull;
    final today = DateTime.now();

    final days = List.generate(
      7,
      (index) => today.subtract(Duration(days: 6 - index)),
    );

    return SizedBox(
      height: 78,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: days.map((day) {
          final isSelected = _isSameDay(day, selectedDate);
          final isToday = _isSameDay(day, today);
          final isStreakDay = streak != null &&
              streak.activeDates.contains(StreakRecord.formatDate(day));

          return Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 2.5),
              child: _TactileDateKeycap(
                day: day,
                weekdayLabel: _weekdayLabel(day),
                isSelected: isSelected,
                isToday: isToday,
                isStreakDay: isStreakDay,
                onTap: () {
                  ref.read(selectedDateProvider.notifier).state = day;
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class _TactileDateKeycap extends StatefulWidget {
  const _TactileDateKeycap({
    required this.day,
    required this.weekdayLabel,
    required this.isSelected,
    required this.isToday,
    required this.isStreakDay,
    required this.onTap,
  });

  final DateTime day;
  final String weekdayLabel;
  final bool isSelected;
  final bool isToday;
  final bool isStreakDay;
  final VoidCallback onTap;

  @override
  State<_TactileDateKeycap> createState() => _TactileDateKeycapState();
}

class _TactileDateKeycapState extends State<_TactileDateKeycap> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final isSelected = widget.isSelected;
    final isToday = widget.isToday;
    final isStreak = widget.isStreakDay;

    // Visual styles based on state
    final Color bgColor;
    final Gradient? gradient;
    final Border border;
    final Color bevelColor;
    final List<BoxShadow> shadows;
    final Color weekdayColor;
    final Color dayColor;
    final Color dotColor;

    if (isSelected) {
      bgColor = AppColors.primary;
      gradient = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Color(0xFF26BCFF),
          Color(0xFF109DE3),
        ],
      );
      border = Border.all(color: const Color(0xFF0E7BB3), width: 1.2);
      bevelColor = const Color(0xFF0C7BAE);
      shadows = [
        BoxShadow(
          color: bevelColor,
          offset: Offset(0, _isPressed ? 1.5 : 4.0),
          blurRadius: 0,
        ),
        const BoxShadow(
          color: Color(0x351CB0F6),
          offset: Offset(0, 4),
          blurRadius: 10,
        ),
      ];
      weekdayColor = Colors.white.withValues(alpha: 0.9);
      dayColor = Colors.white;
      dotColor = Colors.white;
    } else if (isStreak) {
      bgColor = const Color(0xFFF7FCF2);
      gradient = null;
      border = Border.all(
        color: AppColors.brandGreen.withValues(alpha: 0.6),
        width: 1.2,
      );
      bevelColor = const Color(0xFFD4E5C9);
      shadows = [
        BoxShadow(
          color: bevelColor,
          offset: Offset(0, _isPressed ? 1.5 : 3.5),
          blurRadius: 0,
        ),
      ];
      weekdayColor = AppColors.brandGreen;
      dayColor = AppColors.onSurface;
      dotColor = AppColors.brandGreen;
    } else if (isToday) {
      bgColor = AppColors.surfaceContainer;
      gradient = null;
      border = Border.all(
        color: AppColors.primary.withValues(alpha: 0.85),
        width: 1.4,
      );
      bevelColor = const Color(0xFFDDD8CE);
      shadows = [
        BoxShadow(
          color: bevelColor,
          offset: Offset(0, _isPressed ? 1.5 : 3.5),
          blurRadius: 0,
        ),
      ];
      weekdayColor = AppColors.primary;
      dayColor = AppColors.onSurface;
      dotColor = AppColors.primary;
    } else {
      bgColor = AppColors.surfaceContainer;
      gradient = null;
      border = Border.all(color: const Color(0xFFEDE9E1), width: 1.0);
      bevelColor = const Color(0xFFDDD8CE);
      shadows = [
        BoxShadow(
          color: bevelColor,
          offset: Offset(0, _isPressed ? 1.5 : 3.5),
          blurRadius: 0,
        ),
      ];
      weekdayColor = AppColors.onSurfaceVariant;
      dayColor = AppColors.onSurface;
      dotColor = Colors.transparent;
    }

    return GestureDetector(
      onTapDown: (_) => setState(() => _isPressed = true),
      onTapUp: (_) => setState(() => _isPressed = false),
      onTapCancel: () => setState(() => _isPressed = false),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: widget.onTap,
          borderRadius: BorderRadius.circular(18),
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOutCubic,
            transform: Matrix4.translationValues(0, _isPressed ? 2.0 : 0.0, 0),
            decoration: BoxDecoration(
              color: bgColor,
              gradient: gradient,
              borderRadius: BorderRadius.circular(18),
              border: border,
              boxShadow: shadows,
            ),
            padding: const EdgeInsets.symmetric(vertical: 7),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                // Weekday (T2, T3, CN...)
                Text(
                  widget.weekdayLabel,
                  style: GoogleFonts.outfit(
                    fontSize: 11,
                    fontWeight: isSelected || isToday || isStreak
                        ? FontWeight.w800
                        : FontWeight.w600,
                    color: weekdayColor,
                    height: 1.1,
                  ),
                ),

                // Day number (5, 6, 11...)
                Text(
                  '${widget.day.day}',
                  style: GoogleFonts.outfit(
                    fontSize: 17,
                    fontWeight: FontWeight.w900,
                    color: dayColor,
                    height: 1.1,
                  ),
                ),

                // Bottom micro-dot
                Container(
                  width: 4.5,
                  height: 4.5,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                    boxShadow: isSelected
                        ? const [
                            BoxShadow(
                              color: Colors.white,
                              blurRadius: 4,
                            ),
                          ]
                        : null,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
