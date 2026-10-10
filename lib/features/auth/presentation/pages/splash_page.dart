import 'dart:async';
import 'dart:math' as math;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/features/profile/domain/profile_providers.dart';
import '../widgets/splash_constellation_specs.dart';
import '../widgets/splash_cosmic_hero_view.dart';
import '../widgets/splash_floating_food_item.dart';
import '../widgets/zero_gravity_food_background.dart';
import '../../domain/auth_providers.dart';

@RoutePage()
class SplashPage extends ConsumerStatefulWidget {
  const SplashPage({super.key});

  @override
  ConsumerState<SplashPage> createState() => _SplashPageState();
}

class _SplashPageState extends ConsumerState<SplashPage> with TickerProviderStateMixin {
  late final AnimationController _entranceController;
  late final AnimationController _driftController;

  late final Animation<double> _logoScaleAnimation;
  late final Animation<double> _logoFadeAnimation;
  late final Animation<Offset> _textSlideAnimation;
  late final Animation<double> _textFadeAnimation;
  late final Animation<double> _progressFadeAnimation;

  Timer? _navTimer;
  bool _isNavigated = false;

  @override
  void initState() {
    super.initState();

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
          ..._buildAmbientGlows(),
          RepaintBoundary(
            child: LayoutBuilder(
              builder: (context, constraints) {
                final w = constraints.maxWidth;
                final h = constraints.maxHeight;

                if (!shouldAnimate) {
                  return Stack(
                    fit: StackFit.expand,
                    children: [
                      CustomPaint(size: Size(w, h), painter: const CosmicStardustPainter(progress: 0.25)),
                      ...kSplashConstellationSpecs.map((spec) => Positioned(
                            left: spec.relativeX * w - spec.size / 2,
                            top: spec.relativeY * h - spec.size / 2,
                            child: SplashFloatingFoodItem(spec: spec),
                          )),
                    ],
                  );
                }

                return AnimatedBuilder(
                  animation: Listenable.merge([_entranceController, _driftController]),
                  builder: (context, _) => _buildDriftingConstellation(w, h),
                );
              },
            ),
          ),
          SplashCosmicHeroView(
            logoScaleAnimation: _logoScaleAnimation,
            logoFadeAnimation: _logoFadeAnimation,
            textSlideAnimation: _textSlideAnimation,
            textFadeAnimation: _textFadeAnimation,
            progressFadeAnimation: _progressFadeAnimation,
          ),
        ],
      ),
    );
  }

  Widget _buildDriftingConstellation(double w, double h) {
    final entranceT = _entranceController.value;
    final driftT = _driftController.value;
    const twoPi = 2 * math.pi;

    return Stack(
      fit: StackFit.expand,
      children: [
        CustomPaint(size: Size(w, h), painter: CosmicStardustPainter(progress: driftT)),
        ...kSplashConstellationSpecs.map((spec) {
          final itemProgress = ((entranceT - spec.delay) / (1.0 - spec.delay)).clamp(0.0, 1.0);
          final bloomFactor = Curves.easeOutBack.transform(itemProgress);

          final angle = driftT * twoPi * spec.speed + spec.phase;
          final dx = math.cos(angle * 0.75 + spec.phase) * spec.amplitudeX;
          final dy = math.sin(angle) * spec.amplitudeY;
          final rot = math.sin(angle * 0.85 + spec.phase) * spec.maxRotation;
          final microScale = 1.0 + math.sin(angle * 0.5 + spec.phase) * 0.04;

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
                  child: SplashFloatingFoodItem(spec: spec),
                ),
              ),
            ),
          );
        }),
      ],
    );
  }

  List<Widget> _buildAmbientGlows() {
    return [
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
                colors: [AppColors.primary.withValues(alpha: 0.14), AppColors.primary.withValues(alpha: 0.0)],
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
                colors: [AppColors.secondary.withValues(alpha: 0.12), AppColors.secondary.withValues(alpha: 0.0)],
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
                colors: [AppColors.tertiary.withValues(alpha: 0.08), AppColors.tertiary.withValues(alpha: 0.0)],
              ),
            ),
          ),
        ),
      ),
    ];
  }
}
