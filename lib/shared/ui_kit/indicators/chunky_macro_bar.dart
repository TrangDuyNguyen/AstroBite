import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';

/// Horizontal chunky progress bar for a single macronutrient (Protein/Carbs/Fat).
/// 
/// Solar Fresh 2D design with 12pt height, smooth curved corners,
/// and responsive progress animation.
class ChunkyMacroBar extends StatelessWidget {
  const ChunkyMacroBar({
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
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(
              '${currentG}g / ${targetG}g',
              style: Theme.of(context).textTheme.labelMedium?.copyWith(
                letterSpacing: AppValues.calorieLetterSpacing,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ),
        const SizedBox(height: AppValues.spacing8),
        Container(
          height: 14,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.12),
            borderRadius: BorderRadius.circular(10),
            border: Border.all(
              color: color.withValues(alpha: 0.2),
              width: 1,
            ),
            boxShadow: [
              BoxShadow(
                color: Color.lerp(color, Colors.black, 0.22) ?? color,
                offset: const Offset(0, 2),
                blurRadius: 0,
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(9),
            child: Stack(
              children: [
                TweenAnimationBuilder<double>(
                  tween: Tween<double>(begin: 0, end: progress),
                  duration: const Duration(milliseconds: 500),
                  curve: Curves.easeOutCubic,
                  builder: (context, value, _) {
                    return LinearProgressIndicator(
                      value: value,
                      minHeight: 14,
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(color),
                      borderRadius: BorderRadius.circular(9),
                    );
                  },
                ),
                // Top glossy highlight reflection
                Positioned(
                  top: 0,
                  left: 0,
                  right: 0,
                  height: 5,
                  child: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.45),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

/// Backward compatibility alias
typedef MacroBar = ChunkyMacroBar;
