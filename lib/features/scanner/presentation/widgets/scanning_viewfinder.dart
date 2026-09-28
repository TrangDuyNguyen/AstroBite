import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

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

                // 2. Sci-Fi Micro Grid Overlay (Subtle)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HudGridPainter(),
                  ),
                ),

                // 3. Central Rotating Holographic Reticle
                Center(
                  child: RotationTransition(
                    turns: _reticleController,
                    child: CustomPaint(
                      size: const Size(120, 120),
                      painter: _HolographicReticlePainter(),
                    ),
                  ),
                ),

                // 4. Inner Precision Crosshair
                Center(
                  child: CustomPaint(
                    size: const Size(48, 48),
                    painter: _PrecisionCrosshairPainter(),
                  ),
                ),

                // 5. Smooth Rounded Corner Brackets in Duolingo Sky Blue (#1CB0F6)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ViewfinderCornerPainter(
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
                          const Text(
                            '✨ ĐANG ĐỊNH VỊ MÓN ĂN',
                            style: TextStyle(
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
                        child: const _LaserScannerLine(),
                      );
                    },
                  ),

                // 9. Floating Detected Food Holographic Tag (if dish identified)
                if (widget.detectedDishName != null)
                  Positioned(
                    bottom: -54,
                    left: 16,
                    right: 16,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        // Vertical connector line
                        Container(
                          width: 1.5,
                          height: 12,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                AppColors.primary,
                                AppColors.primary.withValues(alpha: 0.2),
                              ],
                            ),
                          ),
                        ),
                        // Clay White Card Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppValues.spacing12,
                            vertical: AppValues.spacing8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer,
                            borderRadius: BorderRadius.circular(AppValues.cardRadius),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.5),
                              width: 1.2,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0x181E2337),
                                blurRadius: 16,
                                offset: const Offset(0, 6),
                              ),
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.15),
                                blurRadius: 10,
                                offset: const Offset(0, 2),
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(4),
                                      decoration: BoxDecoration(
                                        color: AppColors.primary.withValues(alpha: 0.12),
                                        shape: BoxShape.circle,
                                      ),
                                      child: const Icon(
                                        Icons.restaurant_rounded,
                                        size: 16,
                                        color: AppColors.primary,
                                      ),
                                    ),
                                    const SizedBox(width: AppValues.spacing8),
                                    Flexible(
                                      child: Text(
                                        widget.detectedDishName!,
                                        overflow: TextOverflow.ellipsis,
                                        maxLines: 1,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          fontSize: 13,
                                          color: AppColors.onSurface,
                                        ),
                                      ),
                                    ),
                                    const SizedBox(width: AppValues.spacing8),
                                    Container(
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 6,
                                        vertical: 2,
                                      ),
                                      decoration: BoxDecoration(
                                        color: const Color(0xFFE8F9D8),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.brandGreen.withValues(alpha: 0.5),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: const Text(
                                        'AI VERIFIED',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: Color(0xFF2E7D32),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.detectedCalories != null) ...[
                                const SizedBox(width: AppValues.spacing8),
                                Container(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 3,
                                  ),
                                  decoration: BoxDecoration(
                                    color: AppColors.primary.withValues(alpha: 0.1),
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  child: Text(
                                    '${widget.detectedCalories} kcal',
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                      color: AppColors.primary,
                                    ),
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                      ],
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

/// Custom painter for the 4 glowing rounded corner brackets of the viewfinder.
class _ViewfinderCornerPainter extends CustomPainter {
  _ViewfinderCornerPainter({
    required this.color,
    required this.strokeWidth,
    required this.cornerLength,
  });

  final Color color;
  final double strokeWidth;
  final double cornerLength;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final glowPaint = Paint()
      ..color = color.withValues(alpha: 0.35)
      ..strokeWidth = strokeWidth + 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    const cornerRadius = 14.0;
    final l = cornerLength;
    final w = size.width;
    final h = size.height;

    // 1. Top-Left: from (l, 0) -> (cornerRadius, 0) -> (0, cornerRadius) -> (0, l)
    final pathTL = Path()
      ..moveTo(l, 0)
      ..lineTo(cornerRadius, 0)
      ..arcToPoint(const Offset(0, cornerRadius), radius: const Radius.circular(cornerRadius))
      ..lineTo(0, l);
    canvas.drawPath(pathTL, glowPaint);
    canvas.drawPath(pathTL, paint);

    // 2. Top-Right: from (w - l, 0) -> (w - cornerRadius, 0) -> (w, cornerRadius) -> (w, l)
    final pathTR = Path()
      ..moveTo(w - l, 0)
      ..lineTo(w - cornerRadius, 0)
      ..arcToPoint(Offset(w, cornerRadius), radius: const Radius.circular(cornerRadius), clockwise: true)
      ..lineTo(w, l);
    canvas.drawPath(pathTR, glowPaint);
    canvas.drawPath(pathTR, paint);

    // 3. Bottom-Left: from (0, h - l) -> (0, h - cornerRadius) -> (cornerRadius, h) -> (l, h)
    final pathBL = Path()
      ..moveTo(0, h - l)
      ..lineTo(0, h - cornerRadius)
      ..arcToPoint(Offset(cornerRadius, h), radius: const Radius.circular(cornerRadius), clockwise: false)
      ..lineTo(l, h);
    canvas.drawPath(pathBL, glowPaint);
    canvas.drawPath(pathBL, paint);

    // 4. Bottom-Right: from (w, h - l) -> (w, h - cornerRadius) -> (w - cornerRadius, h) -> (w - l, h)
    final pathBR = Path()
      ..moveTo(w, h - l)
      ..lineTo(w, h - cornerRadius)
      ..arcToPoint(Offset(w - cornerRadius, h), radius: const Radius.circular(cornerRadius), clockwise: true)
      ..lineTo(w - l, h);
    canvas.drawPath(pathBR, glowPaint);
    canvas.drawPath(pathBR, paint);
  }

  @override
  bool shouldRepaint(covariant _ViewfinderCornerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerLength != cornerLength;
  }
}

/// Custom painter for the rotating holographic reticle with dashed circular arcs.
class _HolographicReticlePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 2;

    final arcPaint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.6)
      ..strokeWidth = 1.5
      ..style = PaintingStyle.stroke;

    // Draw 4 dashed segments around the circle
    const segmentCount = 6;
    const sweep = (2 * math.pi) / segmentCount;
    for (int i = 0; i < segmentCount; i++) {
      final startAngle = i * sweep;
      canvas.drawArc(
        Rect.fromCircle(center: center, radius: radius),
        startAngle,
        sweep * 0.55,
        false,
        arcPaint,
      );
    }
  }

  @override
  bool shouldRepaint(covariant _HolographicReticlePainter oldDelegate) => false;
}

/// Custom painter for precision crosshairs and center dot.
class _PrecisionCrosshairPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.75)
      ..strokeWidth = 1.2
      ..style = PaintingStyle.stroke;

    final dotPaint = Paint()
      ..color = AppColors.primary
      ..style = PaintingStyle.fill;

    const crossLength = 8.0;
    const gap = 6.0;

    // Crosshairs lines
    canvas.drawLine(Offset(center.dx - gap - crossLength, center.dy), Offset(center.dx - gap, center.dy), paint);
    canvas.drawLine(Offset(center.dx + gap, center.dy), Offset(center.dx + gap + crossLength, center.dy), paint);
    canvas.drawLine(Offset(center.dx, center.dy - gap - crossLength), Offset(center.dx, center.dy - gap), paint);
    canvas.drawLine(Offset(center.dx, center.dy + gap), Offset(center.dx, center.dy + gap + crossLength), paint);

    // Center focal dot
    canvas.drawCircle(center, 2.5, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _PrecisionCrosshairPainter oldDelegate) => false;
}

/// Subtle sci-fi grid inside the viewfinder box.
class _HudGridPainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = AppColors.primary.withValues(alpha: 0.06)
      ..strokeWidth = 0.8
      ..style = PaintingStyle.stroke;

    const step = 24.0;
    for (double x = step; x < size.width; x += step) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }
    for (double y = step; y < size.height; y += step) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant _HudGridPainter oldDelegate) => false;
}

/// Glowing laser horizontal scan line with radar pulse trail.
class _LaserScannerLine extends StatelessWidget {
  const _LaserScannerLine();

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Upper soft glow
        Container(
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primary.withValues(alpha: 0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Bright core laser line
        Container(
          height: 2.5,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2),
            gradient: const LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primary,
                Colors.white,
                AppColors.primary,
                Colors.transparent,
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withValues(alpha: 0.8),
                blurRadius: 8,
                spreadRadius: 2,
              ),
            ],
          ),
        ),
        // Lower soft glow
        Container(
          height: 1.5,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                Colors.transparent,
                AppColors.primary.withValues(alpha: 0.5),
                Colors.transparent,
              ],
            ),
          ),
        ),
        // Celestial Radar Pulse Trail
        Container(
          height: 32,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withValues(alpha: 0.25),
                AppColors.primary.withValues(alpha: 0.05),
                Colors.transparent,
              ],
            ),
          ),
        ),
      ],
    );
  }
}
