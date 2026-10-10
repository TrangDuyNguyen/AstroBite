import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Claymorphic Micronutrient Chips Row displaying Sodium, Fiber, and Sugar
/// with 3D Clay volumetric icons and WCAG high-contrast labels.
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
              iconWidget: const Clay3DSaltShaker(size: 17),
              label: context.l10n.sodiumChip(sodiumMg.toStringAsFixed(0)),
              textColor: isHighSodium ? const Color(0xFFC2410C) : AppColors.onSurface,
              bgColor: isHighSodium ? const Color(0xFFFFF7ED) : const Color(0xFFF0F9FF),
              borderColor: isHighSodium ? const Color(0xFFFFEDD5) : const Color(0xFFBAE6FD),
              bevelColor: isHighSodium ? const Color(0xFFFDBA74) : const Color(0xFF7DD3FC),
            ),
            _MicroChip(
              iconWidget: const Clay3DSprout(size: 17),
              label: context.l10n.fiberChip(fiberG.toStringAsFixed(1)),
              textColor: AppColors.onSurface,
              bgColor: const Color(0xFFF0FDF4),
              borderColor: const Color(0xFFBBF7D0),
              bevelColor: const Color(0xFF86EFAC),
            ),
            _MicroChip(
              iconWidget: const Clay3DSugarCube(size: 17),
              label: context.l10n.sugarChip(sugarG.toStringAsFixed(1)),
              textColor: isHighSugar ? const Color(0xFFC2410C) : AppColors.onSurface,
              bgColor: isHighSugar ? const Color(0xFFFFF7ED) : const Color(0xFFF8FAFC),
              borderColor: isHighSugar ? const Color(0xFFFFEDD5) : const Color(0xFFE2E8F0),
              bevelColor: isHighSugar ? const Color(0xFFFDBA74) : const Color(0xFFCBD5E1),
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
    required this.iconWidget,
    required this.label,
    required this.textColor,
    required this.bgColor,
    required this.borderColor,
    required this.bevelColor,
  });

  final Widget iconWidget;
  final String label;
  final Color textColor;
  final Color bgColor;
  final Color borderColor;
  final Color bevelColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: borderColor,
          width: 1.2,
        ),
        boxShadow: [
          // 3D bottom bevel
          BoxShadow(
            color: bevelColor.withValues(alpha: 0.8),
            offset: const Offset(0, 2),
            blurRadius: 0,
          ),
          // Ambient soft glow
          BoxShadow(
            color: bevelColor.withValues(alpha: 0.2),
            offset: const Offset(0, 3),
            blurRadius: 5,
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          iconWidget,
          const SizedBox(width: 6),
          Text(
            label,
            style: GoogleFonts.inter(
              fontWeight: FontWeight.w700,
              color: textColor,
              fontSize: 11.5,
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
      message: context.l10n.highSodiumAlertTooltip,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
        decoration: BoxDecoration(
          color: const Color(0xFFFFF7ED),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFFFFB74D),
            width: 1,
          ),
          boxShadow: const [
            BoxShadow(
              color: Color(0x20FF9600),
              offset: Offset(0, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.warning_amber_rounded,
              color: Color(0xFFEA580C),
              size: 13,
            ),
            const SizedBox(width: 4),
            Text(
              context.l10n.highSodiumBadge,
              style: const TextStyle(
                color: Color(0xFFC2410C),
                fontSize: 10.5,
                fontWeight: FontWeight.w800,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
