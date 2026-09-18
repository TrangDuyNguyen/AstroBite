import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';

class MicronutrientChipsRow extends StatelessWidget {
  const MicronutrientChipsRow({
    super.key,
    required this.sodiumMg,
    required this.fiberG,
    required this.sugarG,
    this.showHighSodiumAlert = true,
  });

  final double sodiumMg;
  final double fiberG;
  final double sugarG;
  final bool showHighSodiumAlert;

  @override
  Widget build(BuildContext context) {
    final isHighSodium = sodiumMg > 800.0;
    final isHighSugar = sugarG > 20.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: AppValues.spacing8,
          runSpacing: AppValues.spacing8,
          children: [
            _MicroChip(
              icon: Icons.grain_rounded,
              label: 'Muối: ${sodiumMg.toStringAsFixed(0)} mg',
              color: isHighSodium
                  ? const Color(0xFFFF9100)
                  : const Color(0xFF00E5FF),
            ),
            _MicroChip(
              icon: Icons.eco_rounded,
              label: 'Xơ: ${fiberG.toStringAsFixed(1)} g',
              color: const Color(0xFF00E676),
            ),
            _MicroChip(
              icon: Icons.water_drop_rounded,
              label: 'Đường: ${sugarG.toStringAsFixed(1)} g',
              color: isHighSugar
                  ? const Color(0xFFFF9100)
                  : const Color(0xFFE0E0E0),
            ),
          ],
        ),
        if (showHighSodiumAlert && isHighSodium) ...[
          const SizedBox(height: AppValues.spacing8),
          const HighSodiumAlertBadge(),
        ],
      ],
    );
  }
}

class _MicroChip extends StatelessWidget {
  const _MicroChip({
    required this.icon,
    required this.label,
    required this.color,
  });

  final IconData icon;
  final String label;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppValues.spacing8 + 2,
        vertical: AppValues.spacing4,
      ),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.05),
        borderRadius: BorderRadius.circular(AppValues.radius8),
        border: Border.all(
          color: color.withValues(alpha: 0.4),
          width: 1,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 14, color: color),
          const SizedBox(width: AppValues.spacing4),
          Text(
            label,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                  fontSize: 11,
                ),
          ),
        ],
      ),
    );
  }
}

class HighSodiumAlertBadge extends StatelessWidget {
  const HighSodiumAlertBadge({super.key});

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message:
          'Món ăn chứa hơn 800mg Natri (>1/3 hạn mức khuyến nghị cả ngày). Hãy chú ý uống đủ nước nhé!',
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
        decoration: BoxDecoration(
          color: const Color(0x26FF9100), // rgba(255, 145, 0, 0.15)
          borderRadius: BorderRadius.circular(4),
          border: Border.all(
            color: const Color(0xFFFF9100),
            width: 1,
          ),
        ),
        child: const Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFFF9100),
              size: 12,
            ),
            SizedBox(width: 4),
            Text(
              'Muối cao',
              style: TextStyle(
                color: Color(0xFFFFB74D),
                fontSize: 10,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
