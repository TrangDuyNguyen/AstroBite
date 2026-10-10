import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'package:astrobite/shared/widgets/cosmic_logo_badge.dart';

/// Cosmic header view for the login page.
class LoginHeaderView extends StatelessWidget {
  final Animation<double> fadeAnimation;
  final Animation<Offset> slideAnimation;

  const LoginHeaderView({
    super.key,
    required this.fadeAnimation,
    required this.slideAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: slideAnimation,
      child: FadeTransition(
        opacity: fadeAnimation,
        child: Column(
          children: [
            const CosmicLogoBadge(
              size: 80,
              heroTag: 'astrobite-brand-logo',
            ),
            const SizedBox(height: AppValues.spacing16),
            Text(
              AppStrings.appName,
              style: GoogleFonts.outfit(
                fontSize: 30,
                fontWeight: FontWeight.w700,
                letterSpacing: 1.0,
                color: AppColors.onSurface,
              ),
            ),
            const SizedBox(height: AppValues.spacing4),
            Text(
              'Đăng nhập để theo dõi mục tiêu dinh dưỡng',
              style: GoogleFonts.inter(
                fontSize: 14,
                color: AppColors.onSurfaceVariant,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
