import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/widgets/cosmic_logo_badge.dart';

/// Central Brand Column for SplashPage: Logo, Typography & Loading Capsule.
class SplashCosmicHeroView extends StatelessWidget {
  final Animation<double> logoScaleAnimation;
  final Animation<double> logoFadeAnimation;
  final Animation<Offset> textSlideAnimation;
  final Animation<double> textFadeAnimation;
  final Animation<double> progressFadeAnimation;

  const SplashCosmicHeroView({
    super.key,
    required this.logoScaleAnimation,
    required this.logoFadeAnimation,
    required this.textSlideAnimation,
    required this.textFadeAnimation,
    required this.progressFadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(flex: 3),

            // A. Animated Cosmic Emblem with Rotating Tri-Macro Rings
            ScaleTransition(
              scale: logoScaleAnimation,
              child: FadeTransition(
                opacity: logoFadeAnimation,
                child: const CosmicLogoBadge(
                  size: 118,
                  heroTag: 'astrobite-brand-logo',
                ),
              ),
            ),
            const SizedBox(height: 32),

            // B. Animated Brand Typography with Celestial Shadows
            SlideTransition(
              position: textSlideAnimation,
              child: FadeTransition(
                opacity: textFadeAnimation,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      context.l10n.appName,
                      style: GoogleFonts.outfit(
                        fontSize: 36,
                        fontWeight: FontWeight.w900,
                        letterSpacing: 1.2,
                        color: AppColors.onSurface,
                        shadows: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.35),
                            blurRadius: 24,
                            offset: const Offset(0, 4),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'VŨ TRỤ DINH DƯỠNG THÔNG MINH',
                      style: GoogleFonts.inter(
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                        letterSpacing: 2.4,
                        color: AppColors.tertiary,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'AI Food Scanner & Macro Tracker',
                      style: GoogleFonts.inter(
                        fontSize: 13,
                        fontWeight: FontWeight.w500,
                        color: AppColors.onSurfaceVariant,
                      ),
                    ),
                  ],
                ),
              ),
            ),

            const Spacer(flex: 2),

            // C. Duolingo-style 3D Clay Capsule Loading Indicator
            FadeTransition(
              opacity: progressFadeAnimation,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: 150,
                    height: 10,
                    padding: const EdgeInsets.all(2.5),
                    decoration: BoxDecoration(
                      color: AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.08),
                          offset: const Offset(0, 4),
                          blurRadius: 10,
                        ),
                        BoxShadow(
                          color: Colors.black.withValues(alpha: 0.04),
                          offset: const Offset(0, 1.5),
                          blurRadius: 0,
                        ),
                      ],
                    ),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10),
                    child: const LinearProgressIndicator(
                      backgroundColor: Colors.transparent,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
                const SizedBox(height: 10),
                Text(
                  'Đang kết nối vũ trụ dinh dưỡng...',
                  style: GoogleFonts.inter(
                    fontSize: 11,
                    fontWeight: FontWeight.w500,
                    letterSpacing: 0.3,
                    color: AppColors.onSurfaceVariant.withValues(alpha: 0.75),
                  ),
                ),
              ],
            ),
          ),

          const Spacer(),
        ],
      ),
    ),
  );
  }
}
