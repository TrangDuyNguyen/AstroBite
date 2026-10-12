import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/scan_mode.dart';

/// Ergonomic Thumb-zone pill switcher to toggle between Plated Dish mode
/// and Packaged Food / Nutrition Label OCR mode.
class CameraModePillSwitcher extends StatelessWidget {
  const CameraModePillSwitcher({
    super.key,
    required this.currentMode,
    required this.onModeChanged,
  });

  final ScanMode currentMode;
  final ValueChanged<ScanMode> onModeChanged;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
        child: Container(
          height: 40,
          padding: const EdgeInsets.all(AppValues.spacing4),
          decoration: BoxDecoration(
            color: AppColors.surfaceContainer.withValues(alpha: 0.75),
            borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.6),
              width: 1,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              _buildPillTab(
                context: context,
                mode: ScanMode.dish,
                icon: Icons.restaurant_rounded,
                label: context.l10n.scanModeDish,
                isSelected: currentMode == ScanMode.dish,
              ),
              const SizedBox(width: AppValues.spacing4),
              _buildPillTab(
                context: context,
                mode: ScanMode.packaged,
                icon: Icons.qr_code_scanner_rounded,
                label: context.l10n.scanModePackaged,
                isSelected: currentMode == ScanMode.packaged,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPillTab({
    required BuildContext context,
    required ScanMode mode,
    required IconData icon,
    required String label,
    required bool isSelected,
  }) {
    return GestureDetector(
      onTap: () {
        if (!isSelected) {
          HapticFeedback.selectionClick();
          onModeChanged(mode);
        }
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        curve: Curves.easeOutCubic,
        padding: const EdgeInsets.symmetric(
          horizontal: AppValues.spacing12,
          vertical: AppValues.spacing4,
        ),
        decoration: BoxDecoration(
          color: isSelected ? AppColors.surfaceContainer : Colors.transparent,
          borderRadius: BorderRadius.circular(AppValues.cardRadiusClay),
          boxShadow: isSelected
              ? [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.08),
                    offset: const Offset(0, 2),
                    blurRadius: 4,
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: AppValues.spacing4),
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                color: isSelected ? AppColors.primary : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
