import 'dart:math';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/daily_summary.dart';
import 'cockpit_components/clay_micronutrient_sheet.dart';

/// Next-Gen Solar Orbital Cockpit.
/// Displays 3 concentric 3D glowing orbital rings (Carbs, Protein, Fat)
/// encircling the central Calorie Core dial, with an interactive micronutrients sheet trigger.
class SolarOrbitalCockpit extends StatelessWidget {
  const SolarOrbitalCockpit({
    super.key,
    required this.summary,
  });

  final DailySummary summary;

  @override
  Widget build(BuildContext context) {
    final isOverBudget = summary.totalCalories > summary.targetCalories;
    final remainingKcal = max(0, summary.targetCalories - summary.totalCalories);

    final carbsProgress = summary.targetCarbsG > 0
        ? (summary.totalCarbsG / summary.targetCarbsG).clamp(0.0, 1.0)
        : 0.0;
    final proteinProgress = summary.targetProteinG > 0
        ? (summary.totalProteinG / summary.targetProteinG).clamp(0.0, 1.0)
        : 0.0;
    final fatProgress = summary.targetFatG > 0
        ? (summary.totalFatG / summary.targetFatG).clamp(0.0, 1.0)
        : 0.0;

    return ClayCard(
      borderRadius: 24,
      borderColor: isOverBudget ? AppColors.tertiary : const Color(0xFFEDE9E1),
      padding: const EdgeInsets.all(AppValues.spacing16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header: Cockpit Badge & Calorie Target
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 28,
                    height: 28,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: const Color(0xFFE5F6FD),
                      border: Border.all(
                        color: const Color(0xFFBCE3F7),
                        width: 1.0,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0xFFBCE3F7),
                          offset: Offset(0, 1.5),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                    alignment: Alignment.center,
                    child: const Clay3DRocket(size: 16),
                  ),
                  const SizedBox(width: AppValues.spacing8),
                  Text(
                    'SOLAR ORBITAL COCKPIT',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.primary,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 0.8,
                        ),
                  ),
                ],
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: AppColors.surface,
                  borderRadius: BorderRadius.circular(10),
                  border: Border.all(color: const Color(0xFFEDE9E1)),
                ),
                child: Text(
                  'Mục tiêu: ${summary.targetCalories} kcal',
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                        color: AppColors.onSurfaceVariant,
                        fontWeight: FontWeight.w600,
                      ),
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),

          // Main Center Row: Concentric Solar Orbital Painter + Macro Legend
          Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Concentric 3D Orbit Dial
              SizedBox(
                width: 130,
                height: 130,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    // Concentric Custom Painter
                    CustomPaint(
                      size: const Size(130, 130),
                      painter: _ConcentricOrbitalPainter(
                        carbsProgress: carbsProgress,
                        proteinProgress: proteinProgress,
                        fatProgress: fatProgress,
                        isOverBudget: isOverBudget,
                      ),
                    ),
                    // Center Solar Core Dial
                    Container(
                      width: 74,
                      height: 74,
                      padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 2),
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: AppColors.surfaceContainer,
                        border: Border.all(
                          color: isOverBudget
                              ? AppColors.tertiary.withValues(alpha: 0.5)
                              : const Color(0xFFEDE9E1),
                          width: 1.2,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFDDD8CE),
                            offset: Offset(0, 2),
                            blurRadius: 0,
                          ),
                          BoxShadow(
                            color: Color(0x101E2337),
                            offset: Offset(0, 4),
                            blurRadius: 6,
                          ),
                        ],
                      ),
                      alignment: Alignment.center,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isOverBudget
                                  ? '+${summary.totalCalories - summary.targetCalories} kcal'
                                  : '$remainingKcal kcal',
                              style: GoogleFonts.outfit(
                                fontSize: 13,
                                fontWeight: FontWeight.w800,
                                color: isOverBudget ? AppColors.tertiary : AppColors.primary,
                                letterSpacing: -0.3,
                              ),
                            ),
                          ),
                          const SizedBox(height: 1),
                          FittedBox(
                            fit: BoxFit.scaleDown,
                            child: Text(
                              isOverBudget ? context.l10n.overBudget : context.l10n.kcalRemaining,
                              style: const TextStyle(
                                fontSize: 9,
                                fontWeight: FontWeight.w600,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(width: AppValues.spacing16),

              // Macro Details on Right
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _MacroOrbitRow(
                      dotColor: AppColors.primary,
                      label: context.l10n.carbs,
                      consumed: summary.totalCarbsG,
                      target: summary.targetCarbsG,
                      progress: carbsProgress,
                    ),
                    const SizedBox(height: 10),
                    _MacroOrbitRow(
                      dotColor: AppColors.tertiary,
                      label: context.l10n.protein,
                      consumed: summary.totalProteinG,
                      target: summary.targetProteinG,
                      progress: proteinProgress,
                    ),
                    const SizedBox(height: 10),
                    _MacroOrbitRow(
                      dotColor: AppColors.secondary,
                      label: context.l10n.fat,
                      consumed: summary.totalFatG,
                      target: summary.targetFatG,
                      progress: fatProgress,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing12),

          // Micronutrients Trigger Pill
          InkWell(
            onTap: () => ClayMicronutrientSheet.show(context, summary),
            borderRadius: BorderRadius.circular(14),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFFF6F4EF),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: const Color(0xFFEDE9E1),
                  width: 1.0,
                ),
              ),
              child: Row(
                children: [
                  const Text('🧪', style: TextStyle(fontSize: 14)),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Vi chất: Natri ${summary.totalSodiumMg.toInt()}mg • Xơ ${summary.totalFiberG.toStringAsFixed(0)}g • Đường ${summary.totalSugarG.toStringAsFixed(0)}g',
                      style: const TextStyle(
                        fontSize: 11,
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
                  const Icon(
                    Icons.keyboard_arrow_down_rounded,
                    size: 18,
                    color: AppColors.onSurfaceVariant,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _MacroOrbitRow extends StatelessWidget {
  const _MacroOrbitRow({
    required this.dotColor,
    required this.label,
    required this.consumed,
    required this.target,
    required this.progress,
  });

  final Color dotColor;
  final String label;
  final int consumed;
  final int target;
  final double progress;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: dotColor,
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: AppColors.onSurface,
                  ),
                ),
              ],
            ),
            Text(
              '${consumed}g / ${target}g',
              style: const TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 5,
            backgroundColor: const Color(0xFFEDE9E1),
            valueColor: AlwaysStoppedAnimation<Color>(dotColor),
          ),
        ),
      ],
    );
  }
}

class _ConcentricOrbitalPainter extends CustomPainter {
  const _ConcentricOrbitalPainter({
    required this.carbsProgress,
    required this.proteinProgress,
    required this.fatProgress,
    required this.isOverBudget,
  });

  final double carbsProgress;
  final double proteinProgress;
  final double fatProgress;
  final bool isOverBudget;

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    const startAngle = -pi / 2;
    const fullSweep = 2 * pi;

    final rings = [
      (radius: 58.0, stroke: 6.0, progress: carbsProgress, color: AppColors.primary),
      (radius: 48.0, stroke: 6.0, progress: proteinProgress, color: AppColors.tertiary),
      (radius: 38.0, stroke: 6.0, progress: fatProgress, color: AppColors.secondary),
    ];

    for (final ring in rings) {
      // Background track
      final trackPaint = Paint()
        ..color = const Color(0xFFEDE9E1)
        ..style = PaintingStyle.stroke
        ..strokeWidth = ring.stroke
        ..strokeCap = StrokeCap.round;

      canvas.drawCircle(center, ring.radius, trackPaint);

      // Active progress arc
      if (ring.progress > 0) {
        final arcPaint = Paint()
          ..color = ring.color
          ..style = PaintingStyle.stroke
          ..strokeWidth = ring.stroke
          ..strokeCap = StrokeCap.round;

        final sweepAngle = fullSweep * ring.progress;
        canvas.drawArc(
          Rect.fromCircle(center: center, radius: ring.radius),
          startAngle,
          sweepAngle,
          false,
          arcPaint,
        );
      }
    }
  }

  @override
  bool shouldRepaint(covariant _ConcentricOrbitalPainter oldDelegate) {
    return oldDelegate.carbsProgress != carbsProgress ||
        oldDelegate.proteinProgress != proteinProgress ||
        oldDelegate.fatProgress != fatProgress ||
        oldDelegate.isOverBudget != isOverBudget;
  }
}
