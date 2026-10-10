import 'package:flutter/material.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Modal bottom sheet showing expert photography tips for AI food recognition.
class CameraScanningTipsSheet extends StatelessWidget {
  const CameraScanningTipsSheet({super.key});

  static void show(BuildContext context) {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.surfaceContainer,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      builder: (_) => const CameraScanningTipsSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {
    final l10n = context.l10n;
    return Padding(
      padding: const EdgeInsets.all(AppValues.screenPadding),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 36,
              height: 4,
              margin: const EdgeInsets.only(bottom: AppValues.spacing12),
              decoration: BoxDecoration(
                color: AppColors.outline.withValues(alpha: 0.6),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
          ),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(6),
                decoration: BoxDecoration(
                  color: const Color(0xFFE5F6FD),
                  borderRadius: BorderRadius.circular(AppValues.radius12),
                  border: Border.all(
                    color: AppColors.primary.withValues(alpha: 0.25),
                    width: 1.2,
                  ),
                ),
                child: const Clay3DStar(size: 22),
              ),
              const SizedBox(width: AppValues.spacing12),
              Text(
                l10n.scanTipsTitle,
                style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: AppColors.onSurface,
                    ),
              ),
            ],
          ),
          const SizedBox(height: AppValues.spacing16),
          _TipItem(
            icon: Icons.lightbulb_rounded,
            badgeColor: const Color(0xFFFFF7ED),
            iconColor: AppColors.tertiary,
            text: l10n.scanTipLighting,
          ),
          const SizedBox(height: AppValues.spacing12),
          _TipItem(
            icon: Icons.crop_free_rounded,
            badgeColor: const Color(0xFFE5F6FD),
            iconColor: AppColors.primary,
            text: l10n.scanTipFraming,
          ),
          const SizedBox(height: AppValues.spacing12),
          _TipItem(
            icon: Icons.restaurant_rounded,
            badgeColor: const Color(0xFFE8F9D8),
            iconColor: AppColors.brandGreen,
            text: l10n.scanTipAngle,
          ),
          const SizedBox(height: AppValues.spacing20),
          SizedBox(
            width: double.infinity,
            height: 48,
            child: FilledButton(
              onPressed: () => Navigator.pop(context),
              style: FilledButton.styleFrom(
                backgroundColor: AppColors.brandGreen,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(AppValues.spacing48),
                ),
                elevation: 3,
                shadowColor: AppColors.brandGreen.withValues(alpha: 0.4),
              ),
              child: Text(
                l10n.gotIt,
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TipItem extends StatelessWidget {
  const _TipItem({
    required this.icon,
    required this.text,
    this.badgeColor,
    this.iconColor,
  });

  final IconData icon;
  final String text;
  final Color? badgeColor;
  final Color? iconColor;

  @override
  Widget build(BuildContext context) {
    final effectiveColor = iconColor ?? AppColors.primary;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Container(
          width: 36,
          height: 36,
          decoration: BoxDecoration(
            color: badgeColor ?? const Color(0xFFE5F6FD),
            borderRadius: BorderRadius.circular(AppValues.radius12),
            border: Border.all(
              color: effectiveColor.withValues(alpha: 0.25),
              width: 1.2,
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x081E2337),
                offset: Offset(0, 2),
                blurRadius: 4,
              ),
            ],
          ),
          child: Center(
            child: Icon(
              icon,
              size: 20,
              color: effectiveColor,
            ),
          ),
        ),
        const SizedBox(width: AppValues.spacing12),
        Expanded(
          child: Text(
            text,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.onSurface,
                  height: 1.35,
                ),
          ),
        ),
      ],
    );
  }
}
