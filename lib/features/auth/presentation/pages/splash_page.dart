import 'dart:async';
import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import 'package:astrobite/shared/widgets/cosmic_logo_badge.dart';
import '../widgets/zero_gravity_food_background.dart';
import '../../domain/auth_providers.dart';

/// Specification for a 3D clay food item in the Splash cosmic constellation.
class _SplashFoodItemSpec {
  const _SplashFoodItemSpec({
    required this.foodType,
    required this.auraColor,
    required this.size,
    required this.relativeX,
    required this.relativeY,
    required this.amplitudeY,
    required this.amplitudeX,
    required this.speed,
    required this.phase,
    required this.maxRotation,
    this.delay = 0.0,
  });

  final Clay3DFoodType foodType;
  final Color auraColor;
  final double size;
  final double relativeX;
  final double relativeY;
  final double amplitudeY;
  final double amplitudeX;
  final double speed;
  final double phase;
  final double maxRotation;
  final double delay;
}

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage>
    with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _driftController;

  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _progressFadeAnimation;

  Timer? _navTimer;
  bool _isNavigated = false;

  static const List<_SplashFoodItemSpec> _constellation = [
    // 1. 🍎 Red Apple 3D - Top-Left Constellation
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.apple,
      auraColor: Color(0x35FF5C8D),
      size: 50,
      relativeX: 0.14,
      relativeY: 0.12,
      amplitudeY: 12,
      amplitudeX: 8,
      speed: 1.0,
      phase: 0.0,
      maxRotation: 0.18,
      delay: 0.0,
    ),

    // 2. ✨ Cosmic Sparkle Star 3D - Top-Center
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.cosmicStar,
      auraColor: Color(0x45FFB703),
      size: 34,
      relativeX: 0.50,
      relativeY: 0.08,
      amplitudeY: 9,
      amplitudeX: 6,
      speed: 1.2,
      phase: 1.4,
      maxRotation: 0.32,
      delay: 0.04,
    ),

    // 3. 🥐 Croissant 3D - Top-Right Constellation
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.croissant,
      auraColor: Color(0x35FFAA00),
      size: 48,
      relativeX: 0.86,
      relativeY: 0.13,
      amplitudeY: 13,
      amplitudeX: 9,
      speed: 0.94,
      phase: 0.9,
      maxRotation: 0.22,
      delay: 0.08,
    ),

    // 4. 🥑 Avocado 3D - Mid-Left Flank
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.avocado,
      auraColor: Color(0x3558CC02),
      size: 48,
      relativeX: 0.09,
      relativeY: 0.38,
      amplitudeY: 14,
      amplitudeX: 8,
      speed: 0.88,
      phase: 2.2,
      maxRotation: -0.20,
      delay: 0.12,
    ),

    // 5. 🍪 Chocolate Cookie 3D - Mid-Right Flank
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.cookie,
      auraColor: Color(0x30D47A3B),
      size: 42,
      relativeX: 0.91,
      relativeY: 0.36,
      amplitudeY: 11,
      amplitudeX: 9,
      speed: 0.86,
      phase: 3.1,
      maxRotation: 0.20,
      delay: 0.16,
    ),

    // 6. 🍦 Ice Cream 3D - Lower-Mid Left
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.iceCream,
      auraColor: Color(0x351CB0F6),
      size: 46,
      relativeX: 0.10,
      relativeY: 0.65,
      amplitudeY: 13,
      amplitudeX: 8,
      speed: 0.92,
      phase: 4.1,
      maxRotation: 0.18,
      delay: 0.20,
    ),

    // 7. 🍕 Pizza Slice 3D - Lower-Mid Right
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.pizza,
      auraColor: Color(0x35FF9600),
      size: 50,
      relativeX: 0.90,
      relativeY: 0.64,
      amplitudeY: 14,
      amplitudeX: 8,
      speed: 1.05,
      phase: 1.8,
      maxRotation: -0.18,
      delay: 0.24,
    ),

    // 8. 🍜 Hot Ramen 3D - Bottom-Left Constellation
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.ramen,
      auraColor: Color(0x359D65FF),
      size: 46,
      relativeX: 0.20,
      relativeY: 0.86,
      amplitudeY: 12,
      amplitudeX: 8,
      speed: 0.95,
      phase: 2.8,
      maxRotation: 0.16,
      delay: 0.28,
    ),

    // 9. 🍳 Sunny Egg 3D - Bottom-Right Constellation
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.sunnyEgg,
      auraColor: Color(0x40FFD000),
      size: 46,
      relativeX: 0.80,
      relativeY: 0.86,
      amplitudeY: 13,
      amplitudeX: 7,
      speed: 1.02,
      phase: 4.9,
      maxRotation: -0.16,
      delay: 0.30,
    ),

    // 10. ☕ Hot Coffee 3D - Bottom-Center
    _SplashFoodItemSpec(
      foodType: Clay3DFoodType.coffee,
      auraColor: Color(0x308D5B4C),
      size: 40,
      relativeX: 0.50,
      relativeY: 0.92,
      amplitudeY: 10,
      amplitudeX: 8,
      speed: 0.84,
      phase: 3.7,
      maxRotation: -0.14,
      delay: 0.18,
    ),
  ];

  @override
  void initState() {
    super.initState();

    // 1. One-shot Entrance Orchestration
    _entranceController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );

    _logoScaleAnimation = Tween<double>(begin: 0.55, end: 1.0).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.08, 0.72, curve: Curves.easeOutBack),
      ),
    );

    _logoFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.0, 0.45, curve: Curves.easeOut),
    );

    _textSlideAnimation = Tween<Offset>(
      begin: const Offset(0, 0.35),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _entranceController,
        curve: const Interval(0.35, 0.85, curve: Curves.easeOutCubic),
      ),
    );

    _textFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.35, 0.75, curve: Curves.easeOut),
    );

    _progressFadeAnimation = CurvedAnimation(
      parent: _entranceController,
      curve: const Interval(0.55, 0.95, curve: Curves.easeOut),
    );

    // 2. Continuous Weightless Zero-Gravity Orbital Drift (18s duration)
    _driftController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 18),
    );

    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    if (!isTest) {
      _entranceController.forward();
      _driftController.repeat();
    } else {
      _entranceController.value = 1.0;
    }

    _checkAuthAndNavigate();
  }

  void _checkAuthAndNavigate() {
    // 1800ms exposure allows full appreciation of the cosmic bloom choreography
    _navTimer = Timer(const Duration(milliseconds: 1800), () async {
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
    _entranceController.dispose();
    _driftController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final disableAnimations = MediaQuery.maybeDisableAnimationsOf(context) ?? false;
    final isTest = WidgetsBinding.instance.runtimeType.toString().contains('Test');
    final shouldAnimate = !disableAnimations && !isTest;

    return Scaffold(
      backgroundColor: AppColors.surface,
      body: Stack(
        fit: StackFit.expand,
        children: [
          // 1. Ambient Cosmic Galaxy Nebulae (Warm Milk Canvas + Sky, Pink & Amber auras)
          Positioned(
            top: -100,
            right: -80,
            width: 320,
            height: 320,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primary.withValues(alpha: 0.14),
                      AppColors.primary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            bottom: -90,
            left: -80,
            width: 300,
            height: 300,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.secondary.withValues(alpha: 0.12),
                      AppColors.secondary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),
          Positioned(
            top: 200,
            left: -60,
            width: 240,
            height: 240,
            child: IgnorePointer(
              child: DecoratedBox(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.tertiary.withValues(alpha: 0.08),
                      AppColors.tertiary.withValues(alpha: 0.0),
                    ],
                  ),
                ),
              ),
            ),
          ),

          // 2. Twinkling Cosmic Stardust & 3D Clay Food Orbit
          RepaintBoundary(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                if (!shouldAnimate) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(
                        size: Size(w, h),
                        painter: const CosmicStardustPainter(progress: 0.25),
                      ),
                      ...List.generate(_constellation.length, (i) {
                        final spec = _constellation[i];
                        final x = spec.relativeX * w - spec.size / 2;
                        final y = spec.relativeY * h - spec.size / 2;

                        return Positioned(
                          left: x,
                          top: y,
                          child: _SplashFoodItem(spec: spec),
                        );
                      }),
                    ],
                  );
                }

                return AnimatedBuilder(
                  animation: Listenable.merge([_entranceController, _driftController]),
                  builder: (context, _) {
                    final entranceT = _entranceController.value;
                    final driftT = _driftController.value;
                    final twoPi = 2 * math.pi;

                    return Stack(
                      fit: StackFit.expand,
                      children: [
                        // Twinkling Starfield
                        CustomPaint(
                          size: Size(w, h),
                          painter: CosmicStardustPainter(progress: driftT),
                        ),

                        // Blooming & Drifting 3D Clay Food Sculptures
                        ...List.generate(_constellation.length, (i) {
                          final spec = _constellation[i];

                          // Staggered bloom progression
                          final itemProgress = ((entranceT - spec.delay) / (1.0 - spec.delay)).clamp(0.0, 1.0);
                          final bloomFactor = Curves.easeOutBack.transform(itemProgress);

                          // Weightless Lissajous orbital physics
                          final angle = driftT * twoPi * spec.speed + spec.phase;
                          final dx = math.cos(angle * 0.75 + spec.phase) * spec.amplitudeX;
                          final dy = math.sin(angle) * spec.amplitudeY;
                          final rot = math.sin(angle * 0.85 + spec.phase) * spec.maxRotation;
                          final microScale = 1.0 + math.sin(angle * 0.5 + spec.phase) * 0.04;

                          // Radial expansion from screen center to orbit
                          final centerX = w * 0.5;
                          final centerY = h * 0.5;
                          final targetX = spec.relativeX * w + dx;
                          final targetY = spec.relativeY * h + dy;

                          final curX = centerX + (targetX - centerX) * bloomFactor - spec.size / 2;
                          final curY = centerY + (targetY - centerY) * bloomFactor - spec.size / 2;

                          return Positioned(
                            left: curX,
                            top: curY,
                            child: Opacity(
                              opacity: itemProgress.clamp(0.0, 1.0),
                              child: Transform.rotate(
                                angle: rot * bloomFactor,
                                child: Transform.scale(
                                  scale: bloomFactor * microScale,
                                  child: _SplashFoodItem(spec: spec),
                                ),
                              ),
                            ),
                          );
                        }),
                      ],
                    );
                  },
                );
              },
            ),
          ),

          // 3. Central Brand Column: Cosmic Logo Badge, Typography & 3D Clay Loading Capsule
          SafeArea(
            child: Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Spacer(flex: 3),

                  // A. Animated Cosmic Emblem with Rotating Tri-Macro Rings
                  ScaleTransition(
                    scale: _logoScaleAnimation,
                    child: FadeTransition(
                      opacity: _logoFadeAnimation,
                      child: const CosmicLogoBadge(
                        size: 118,
                        heroTag: 'astrobite-brand-logo',
                      ),
                    ),
                  ),
                  const SizedBox(height: 32),

                  // B. Animated Brand Typography with Celestial Shadows
                  SlideTransition(
                    position: _textSlideAnimation,
                    child: FadeTransition(
                      opacity: _textFadeAnimation,
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            AppStrings.appName,
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
                    opacity: _progressFadeAnimation,
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
          ),
        ],
      ),
    );
  }
}

/// Standalone 3D clay food sculpture with a soft glowing celestial nebula aura.
class _SplashFoodItem extends StatelessWidget {
  const _SplashFoodItem({required this.spec});

  final _SplashFoodItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft Celestial Nebula Aura Glow
        Container(
          width: spec.size * 0.90,
          height: spec.size * 0.90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: spec.auraColor,
                blurRadius: spec.size * 0.50,
                spreadRadius: 2.5,
              ),
            ],
          ),
        ),
        // 3D Sculpted Clay Food Art
        Clay3DFoodArt(
          foodType: spec.foodType,
          size: spec.size,
        ),
      ],
    );
  }
}
