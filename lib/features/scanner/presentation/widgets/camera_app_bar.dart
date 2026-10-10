import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'camera_scanning_tips_sheet.dart';

/// Clean Celestial AppBar for Camera scanning page.
class CameraAppBar extends StatelessWidget implements PreferredSizeWidget {
  const CameraAppBar({
    super.key,
    required this.isTorchOn,
    required this.onToggleTorch,
  });

  final bool isTorchOn;
  final VoidCallback onToggleTorch;

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor: AppColors.surface.withValues(alpha: 0.85),
      elevation: 0,
      centerTitle: true,
      leading: Padding(
        padding: const EdgeInsets.only(left: 12),
        child: Center(
          child: ClayIconButton(
            icon: Icons.arrow_back_ios_new_rounded,
            size: 40,
            borderRadius: 14,
            tooltip: 'Quay lại',
            onPressed: () => context.router.maybePop(),
          ),
        ),
      ),
      title: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: const [
              Text(
                AppStrings.scanFood,
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                  letterSpacing: 0.3,
                ),
              ),
              SizedBox(width: AppValues.spacing8),
              Clay3DStar(size: 16),
            ],
          ),
          const SizedBox(height: 2),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
            decoration: BoxDecoration(
              color: const Color(0xFFE0F2FE),
              borderRadius: BorderRadius.circular(10),
            ),
            child: const Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                CircleAvatar(
                  radius: 3,
                  backgroundColor: Color(0xFF0284C7),
                ),
                SizedBox(width: 4),
                Text(
                  'Gemini Vision AI 2.0 • Active',
                  style: TextStyle(
                    fontSize: 10,
                    color: Color(0xFF0369A1),
                    fontWeight: FontWeight.w600,
                    letterSpacing: 0.2,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      actions: [
        ClayIconButton(
          icon: isTorchOn ? Icons.flash_on_rounded : Icons.flash_off_rounded,
          size: 40,
          borderRadius: 14,
          backgroundColor: isTorchOn ? const Color(0xFFFFF7ED) : AppColors.surfaceContainer,
          iconColor: isTorchOn ? AppColors.tertiary : AppColors.onSurfaceVariant,
          tooltip: 'Đèn Flash',
          onPressed: onToggleTorch,
        ),
        const SizedBox(width: AppValues.spacing8),
        ClayIconButton(
          icon: Icons.help_outline_rounded,
          size: 40,
          borderRadius: 14,
          iconColor: AppColors.onSurfaceVariant,
          tooltip: 'Mẹo quét',
          onPressed: () => CameraScanningTipsSheet.show(context),
        ),
        const SizedBox(width: 12),
      ],
    );
  }
}
