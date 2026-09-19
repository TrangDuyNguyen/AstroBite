import 'dart:async';
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/shared/widgets/celestial_particle_background.dart';
import 'package:astrobite/shared/widgets/cosmic_logo_badge.dart';
import '../../domain/auth_providers.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _fadeInAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<Offset> _slideTextAnimation;

  Timer? _navTimer;
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _fadeInAnimation = CurvedAnimation(
      parent: _animController,
      curve: const Interval(0.0, 0.65, curve: Curves.easeOut),
    );

    _scaleAnimation = Tween<double>(begin: 0.75, end: 1.0).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.75, curve: Curves.easeOutBack),
      ),
    );

    _slideTextAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.3, 0.9, curve: Curves.easeOutCubic),
      ),
    );

    _animController.forward();
    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    // Minimum branding exposure duration so the celestial animation is felt smoothly
    _navTimer = Timer(const Duration(milliseconds: 1600), () async {
      if (!mounted || _isNavigated) return;

      try {
        final authState = await ref.read(authStateProvider.future).timeout(
              const Duration(seconds: 4),
              onTimeout: () => null,
            );

        if (!mounted || _isNavigated) return;
        _isNavigated = true;

        if (authState != null) {
          final repo = ref.read(profileRepositoryProvider);
          final profile = await repo.getProfile(authState.uid).timeout(
                const Duration(seconds: 3),
                onTimeout: () => null,
              );

          if (!mounted) return;
          if (profile != null && profile.isOnboardingCompleted) {
            context.router.replaceAll([const ShellRoute()]);
          } else {
            context.router.replaceAll([const OnboardingRoute()]);
          }
        } else {
          context.router.replaceAll([const LoginRoute()]);
        }
      } catch (_) {
        if (!mounted) return;
        _isNavigated = true;
        context.router.replaceAll([const LoginRoute()]);
      }
    });
  }

  @override
  void dispose() {
    _navTimer?.cancel();
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.surface,
      body: CelestialParticleBackground(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // 1. Animated Emblem with Cosmic Breathing & Orbit
              ScaleTransition(
                scale: _scaleAnimation,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: const CosmicLogoBadge(
                    size: 110,
                    heroTag: 'astrobite-brand-logo',
                  ),
                ),
              ),
              const SizedBox(height: 28),

              // 2. Animated Brand Title & Slogan
              SlideTransition(
                position: _slideTextAnimation,
                child: FadeTransition(
                  opacity: _fadeInAnimation,
                  child: Column(
                    children: [
                      Text(
                        AppStrings.appName,
                        style: GoogleFonts.outfit(
                          fontSize: 34,
                          fontWeight: FontWeight.w800,
                          letterSpacing: 1.2,
                          color: AppColors.onSurface,
                          shadows: [
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              blurRadius: 20,
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
                          fontWeight: FontWeight.w600,
                          letterSpacing: 2.2,
                          color: AppColors.tertiary,
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        'AI Food Scanner & Macro Tracker',
                        style: GoogleFonts.inter(
                          fontSize: 13,
                          fontWeight: FontWeight.w400,
                          color: AppColors.onSurfaceVariant,
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 48),

              // 3. Subtle pulsing loading indicator
              FadeTransition(
                opacity: _fadeInAnimation,
                child: SizedBox(
                  width: 36,
                  height: 3,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(2),
                    child: const LinearProgressIndicator(
                      backgroundColor: AppColors.surfaceContainer,
                      valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
