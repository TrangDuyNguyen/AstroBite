import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';

/// Horizontal progress bar for a single macronutrient (Protein/Carbs/Fat).
class MacroBar extends StatelessWidget {
  const MacroBar({
    super.key,
    required this.label,
    required this.currentG,
    required this.targetG,
    required this.color,
  });

  final String label;
  final int currentG;
  final int targetG;
  final Color color;

  double get progress => targetG > 0 ? (currentG / targetG).clamp(0, 1) : 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                color: color,
              ),
            ),
            Text(
              '${currentG}g / ${targetG}g',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                letterSpacing: AppValues.calorieLetterSpacing,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppValues.spacing4),
        ClipRRect(
          borderRadius: BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: progress,
            minHeight: 8,
            backgroundColor: color.withValues(alpha: 0.15),
            valueColor: AlwaysStoppedAnimation(color),
          ),
        ),
      ],
    );
  }
}
