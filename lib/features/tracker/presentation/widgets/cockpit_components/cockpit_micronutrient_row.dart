import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Tactile 3D Clay row displaying a single micronutrient with progress bar and status badge.
class CockpitMicronutrientRow extends StatelessWidget {
  final String label;
  final String current;
  final String limit;
  final bool isWarning;
  final Color accentColor;
  final Widget? icon;
  final double currentVal;
  final double targetVal;
  final String? statusBadgeText;

  const CockpitMicronutrientRow({
    super.key,
    required this.label,
    required this.current,
    required this.limit,
    required this.isWarning,
    required this.accentColor,
    this.icon,
    this.currentVal = 0,
    this.targetVal = 1,
    this.statusBadgeText,
  });

  @override
  Widget build(BuildContext context) {
    final progress = targetVal > 0 ? (currentVal / targetVal).clamp(0.0, 1.0) : 0.0;

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 9),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(AppValues.radius12),
        border: Border.all(
          color: isWarning ? AppColors.error : const Color(0xFFEDE8DD),
          width: isWarning ? 1.5 : 1.0,
        ),
        boxShadow: [
          BoxShadow(
            color: isWarning
                ? const Color(0x28FF4B4B)
                : const Color(0x12000000),
            offset: const Offset(0, 2.5),
            blurRadius: 0,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  if (icon != null) ...[
                    icon!,
                    const SizedBox(width: AppValues.spacing8),
                  ] else ...[
                    Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: accentColor,
                      ),
                    ),
                    const SizedBox(width: AppValues.spacing8),
                  ],
                  Text(
                    label,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w700,
                          color: AppColors.onSurface,
                        ),
                  ),
                ],
              ),
              Row(
                children: [
                  Text(
                    current,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          fontWeight: FontWeight.w800,
                          color: isWarning ? AppColors.error : AppColors.onSurface,
                        ),
                  ),
                  const SizedBox(width: 4),
                  Text(
                    '($limit)',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 10,
                        ),
                  ),
                  if (statusBadgeText != null) ...[
                    const SizedBox(width: 6),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                      decoration: BoxDecoration(
                        color: isWarning ? AppColors.error : accentColor.withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(AppValues.radius8),
                        border: Border.all(
                          color: isWarning ? AppColors.error : accentColor.withValues(alpha: 0.4),
                          width: 0.8,
                        ),
                      ),
                      child: Text(
                        statusBadgeText!,
                        style: TextStyle(
                          fontSize: 9,
                          fontWeight: FontWeight.w800,
                          color: isWarning ? Colors.white : accentColor,
                          letterSpacing: 0.2,
                        ),
                      ),
                    ),
                  ],
                ],
              ),
            ],
          ),
          const SizedBox(height: 6),
          // Chunky Mini Clay Progress Bar
          Container(
            height: 6.0,
            width: double.infinity,
            decoration: BoxDecoration(
              color: const Color(0xFFEBE7DF),
              borderRadius: BorderRadius.circular(3.0),
              border: Border.all(
                color: const Color(0xFFDDD8CE),
                width: 0.8,
              ),
            ),
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: progress,
              child: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.5),
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(accentColor, Colors.white, 0.3)!,
                      accentColor,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Color.lerp(accentColor, Colors.black, 0.3)!,
                      offset: const Offset(0, 1),
                      blurRadius: 0,
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
