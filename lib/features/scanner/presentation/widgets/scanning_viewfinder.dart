import 'package:flutter/material.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import 'viewfinder_detected_tag.dart';
import 'viewfinder_hud_painters.dart';
import 'viewfinder_laser_scanner.dart';

/// Holographic Sci-Fi AR HUD Viewfinder matching Stitch MCP Design.
/// Features double-layered corner brackets, rotating reticle, telemetry,
/// vertical laser beam, and optional floating AI verified tag.
class ScanningViewfinder extends StatefulWidget {
  const ScanningViewfinder({
    super.key,
    this.isScanning = true,
    this.child,
    this.detectedDishName,
    this.detectedCalories,
  });

  final bool isScanning;
  final Widget? child;
  final String? detectedDishName;
  final int? detectedCalories;

  @override
  State<ScanningViewfinder> createState() => _ScanningViewfinderState();
}

class _ScanningViewfinderState extends State<ScanningViewfinder>
    with TickerProviderStateMixin {
  late final AnimationController _laserController;
  late final Animation<double> _laserAnimation;

  late final AnimationController _reticleController;
  late final AnimationController _pulseController;
  late final Animation<double> _pulseAnimation;

  @override
  void initState() {
    super.initState();

    // 1. Vertical laser scan animation (2.2s ease-in-out)
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );
    _laserAnimation = CurvedAnimation(
      parent: _laserController,
      curve: Curves.easeInOut,
    );

    // 2. Holographic reticle slow rotation (16s linear)
    _reticleController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 16),
    );

    // 3. Telemetry focal dot pulse animation (1.5s ease-in-out)
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1500),
    );
    _pulseAnimation = CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    );

    if (widget.isScanning) {
      _laserController.repeat(reverse: true);
      _reticleController.repeat();
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ScanningViewfinder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning) {
      if (!_laserController.isAnimating) _laserController.repeat(reverse: true);
      if (!_reticleController.isAnimating) _reticleController.repeat();
      if (!_pulseController.isAnimating) _pulseController.repeat(reverse: true);
    } else {
      if (_laserController.isAnimating) _laserController.stop();
      if (_reticleController.isAnimating) _reticleController.stop();
      if (_pulseController.isAnimating) _pulseController.stop();
    }
  }

  @override
  void dispose() {
    _laserController.dispose();
    _reticleController.dispose();
    _pulseController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final boxSize = constraints.maxWidth < constraints.maxHeight
            ? constraints.maxWidth * 0.85
            : constraints.maxHeight * 0.75;

        return Center(
          child: SizedBox(
            width: boxSize,
            height: boxSize,
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                // 1. Optional preview image or camera stream background
                if (widget.child != null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppValues.radius12),
                      child: widget.child,
                    ),
                  ),

                // 2. Sci-Fi Micro Grid Overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: HudGridPainter(),
                  ),
                ),

                // 3. Central Rotating Holographic Reticle
                Center(
                  child: RotationTransition(
                    turns: _reticleController,
                    child: CustomPaint(
                      size: const Size(120, 120),
                      painter: HolographicReticlePainter(),
                    ),
                  ),
                ),

                // 4. Inner Precision Crosshair
                Center(
                  child: CustomPaint(
                    size: const Size(48, 48),
                    painter: PrecisionCrosshairPainter(),
                  ),
                ),

                // 5. Smooth Rounded Corner Brackets in Duolingo Sky Blue
                Positioned.fill(
                  child: CustomPaint(
                    painter: ViewfinderCornerPainter(
                      color: AppColors.primary,
                      strokeWidth: 3.5,
                      cornerLength: 32,
                    ),
                  ),
                ),

                // 6. AI Detection Status Badge (Top Center)
                Positioned(
                  top: -18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.spacing16,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surfaceContainer.withValues(alpha: 0.95),
                        borderRadius: BorderRadius.circular(AppValues.spacing48),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.5),
                          width: 1.2,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 12,
                            offset: const Offset(0, 2),
                          ),
                          const BoxShadow(
                            color: Color(0x121E2337),
                            blurRadius: 6,
                            offset: Offset(0, 2),
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeTransition(
                            opacity: _pulseAnimation,
                            child: Container(
                              width: 8,
                              height: 8,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.brandGreen,
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.brandGreen,
                                    blurRadius: 6,
                                  ),
                                ],
                              ),
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Text(
                            context.l10n.scanningLocatingFood,
                            style: const TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.w700,
                              letterSpacing: 0.5,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 7. Animated glowing laser scanner line
                if (widget.isScanning)
                  AnimatedBuilder(
                    animation: _laserAnimation,
                    builder: (context, _) {
                      return Positioned(
                        top: _laserAnimation.value * (boxSize - 4),
                        left: 8,
                        right: 8,
                        child: const ViewfinderLaserScannerLine(),
                      );
                    },
                  ),

                // 8. Floating Detected Food Holographic Tag (if dish identified)
                if (widget.detectedDishName != null)
                  Positioned(
                    bottom: -54,
                    left: 16,
                    right: 16,
                    child: ViewfinderDetectedTag(
                      detectedDishName: widget.detectedDishName!,
                      detectedCalories: widget.detectedCalories,
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
