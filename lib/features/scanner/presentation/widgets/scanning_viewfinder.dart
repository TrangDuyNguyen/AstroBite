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

                // 2. Sci-Fi Micro Grid Overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: _HudGridPainter(),
                  ),
                ),

                // 3. Telemetry Coordinates Overlay
                // Left Axis
                Positioned(
                  left: -12,
                  top: boxSize / 2 - 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'X: 104.2',
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: 'monospace',
                          color: AppColors.primary.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'Y: 382.7',
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: 'monospace',
                          color: AppColors.primary.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
                // Right Axis
                Positioned(
                  right: -12,
                  top: boxSize / 2 - 16,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        'Z: 0.84m',
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: 'monospace',
                          color: AppColors.primary.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        'FPS: 60',
                        style: TextStyle(
                          fontSize: 9,
                          fontFamily: 'monospace',
                          color: AppColors.primary.withValues(alpha: 0.7),
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),

                // 4. Central Rotating Holographic Reticle
                Center(
                  child: RotationTransition(
                    turns: _reticleController,
                    child: CustomPaint(
                      size: const Size(120, 120),
                      painter: _HolographicReticlePainter(),
                    ),
                  ),
                ),

                // 5. Inner Precision Crosshair
                Center(
                  child: CustomPaint(
                    size: const Size(48, 48),
                    painter: _PrecisionCrosshairPainter(),
                  ),
                ),

                // 6. Double Corner Brackets in Electric Blue (#1A73E8)
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ViewfinderCornerPainter(
                      color: AppColors.primary,
                      strokeWidth: 3.5,
                      cornerLength: 28,
                    ),
                  ),
                ),

                // 7. Telemetry Focal Lock Badge (Top Center)
                Positioned(
                  top: -18,
                  left: 0,
                  right: 0,
                  child: Center(
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: AppValues.spacing12,
                        vertical: AppValues.spacing4,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.surface.withValues(alpha: 0.85),
                        borderRadius: BorderRadius.circular(AppValues.spacing48),
                        border: Border.all(
                          color: AppColors.primary.withValues(alpha: 0.4),
                          width: 1,
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.primary.withValues(alpha: 0.25),
                            blurRadius: 10,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          FadeTransition(
                            opacity: _pulseAnimation,
                            child: Container(
                              width: 6,
                              height: 6,
                              decoration: const BoxDecoration(
                                shape: BoxShape.circle,
                                color: AppColors.primary,
                              ),
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing8),
                          Text(
                            '[FOCAL LOCK: 98.4% CONFIDENCE]',
                            style: TextStyle(
                              fontSize: 10,
                              fontFamily: 'monospace',
                              fontWeight: FontWeight.bold,
                              letterSpacing: 0.8,
                              color: AppColors.primary,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),

                // 8. Animated glowing laser scanner line
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
                        // Glass Pill Tag
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: AppValues.spacing12,
                            vertical: AppValues.spacing8,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.surfaceContainer.withValues(alpha: 0.95),
                            borderRadius: BorderRadius.circular(AppValues.radius12),
                            border: Border.all(
                              color: AppColors.primary.withValues(alpha: 0.6),
                              width: 1,
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.5),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                              BoxShadow(
                                color: AppColors.primary.withValues(alpha: 0.2),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                child: Row(
                                  children: [
                                    Icon(
                                      Icons.restaurant_rounded,
                                      size: 16,
                                      color: AppColors.primary,
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
                                          color: Colors.white,
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
                                        color: AppColors.tertiary.withValues(alpha: 0.2),
                                        borderRadius: BorderRadius.circular(4),
                                        border: Border.all(
                                          color: AppColors.tertiary.withValues(alpha: 0.5),
                                          width: 0.8,
                                        ),
                                      ),
                                      child: const Text(
                                        'AI VERIFIED',
                                        style: TextStyle(
                                          fontSize: 9,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.tertiary,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              if (widget.detectedCalories != null) ...[
                                const SizedBox(width: AppValues.spacing8),
                                Text(
                                  '${widget.detectedCalories} kcal',
                                  style: TextStyle(
                                    fontWeight: FontWeight.bold,
                                    fontSize: 12,
                                    color: AppColors.primary,
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

/// Custom painter for the 4 glowing double corner brackets of the viewfinder.
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
      ..color = color.withValues(alpha: 0.4)
      ..strokeWidth = strokeWidth + 4
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    final innerCornerPaint = Paint()
      ..color = color.withValues(alpha: 0.5)
      ..strokeWidth = 1.5
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    void drawCorner(Offset corner, Offset hDir, Offset vDir, Offset innerOffset) {
      // 1. Soft glow outer
      canvas.drawLine(corner, corner + hDir, glowPaint);
      canvas.drawLine(corner, corner + vDir, glowPaint);
      // 2. Crisp outer bracket
      canvas.drawLine(corner, corner + hDir, paint);
      canvas.drawLine(corner, corner + vDir, paint);

      // 3. Double-layer sci-fi inner accent bracket
      final inner = corner + innerOffset;
      final innerH = hDir * 0.45;
      final innerV = vDir * 0.45;
      canvas.drawLine(inner, inner + innerH, innerCornerPaint);
      canvas.drawLine(inner, inner + innerV, innerCornerPaint);
    }

    final l = cornerLength;
    final w = size.width;
    final h = size.height;

    // Top-Left
    drawCorner(Offset.zero, Offset(l, 0), Offset(0, l), const Offset(5, 5));
    // Top-Right
    drawCorner(Offset(w, 0), Offset(-l, 0), Offset(0, l), const Offset(-5, 5));
    // Bottom-Left
    drawCorner(Offset(0, h), Offset(l, 0), Offset(0, -l), const Offset(5, -5));
    // Bottom-Right
    drawCorner(Offset(w, h), Offset(-l, 0), Offset(0, -l), const Offset(-5, -5));
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
