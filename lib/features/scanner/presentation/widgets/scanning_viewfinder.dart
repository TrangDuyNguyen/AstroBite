import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Celestial viewfinder with 4 glowing corner brackets and an animated laser scan line.
class ScanningViewfinder extends StatefulWidget {
  const ScanningViewfinder({
    super.key,
    this.isScanning = true,
    this.child,
  });

  final bool isScanning;
  final Widget? child;

  @override
  State<ScanningViewfinder> createState() => _ScanningViewfinderState();
}

class _ScanningViewfinderState extends State<ScanningViewfinder>
    with SingleTickerProviderStateMixin {
  late final AnimationController _laserController;
  late final Animation<double> _laserAnimation;

  @override
  void initState() {
    super.initState();
    _laserController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    );

    _laserAnimation = CurvedAnimation(
      parent: _laserController,
      curve: Curves.easeInOut,
    );

    if (widget.isScanning) {
      _laserController.repeat(reverse: true);
    }
  }

  @override
  void didUpdateWidget(covariant ScanningViewfinder oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.isScanning && !_laserController.isAnimating) {
      _laserController.repeat(reverse: true);
    } else if (!widget.isScanning && _laserController.isAnimating) {
      _laserController.stop();
    }
  }

  @override
  void dispose() {
    _laserController.dispose();
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
                // Optional content inside the frame (e.g. preview image)
                if (widget.child != null)
                  Positioned.fill(
                    child: ClipRRect(
                      borderRadius: BorderRadius.circular(AppValues.radius12),
                      child: widget.child,
                    ),
                  ),

                // Subtle grid / targeting center crosshair
                Center(
                  child: Container(
                    width: 20,
                    height: 20,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      border: Border.all(
                        color: AppColors.primary.withValues(alpha: 0.3),
                        width: 1.5,
                      ),
                    ),
                  ),
                ),

                // Corner bracket overlay
                Positioned.fill(
                  child: CustomPaint(
                    painter: _ViewfinderCornerPainter(
                      color: AppColors.primary,
                      strokeWidth: 3.5,
                      cornerLength: 28,
                    ),
                  ),
                ),

                // Animated glowing laser scanner line
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
              ],
            ),
          ),
        );
      },
    );
  }
}

/// Custom painter for the 4 glowing corner brackets of the viewfinder.
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
      ..strokeWidth = strokeWidth + 3
      ..strokeCap = StrokeCap.round
      ..style = PaintingStyle.stroke;

    void drawCorner(Offset corner, Offset hDir, Offset vDir) {
      // Draw glow
      canvas.drawLine(corner, corner + hDir, glowPaint);
      canvas.drawLine(corner, corner + vDir, glowPaint);
      // Draw crisp line
      canvas.drawLine(corner, corner + hDir, paint);
      canvas.drawLine(corner, corner + vDir, paint);
    }

    final l = cornerLength;
    final w = size.width;
    final h = size.height;

    // Top-Left
    drawCorner(Offset.zero, Offset(l, 0), Offset(0, l));
    // Top-Right
    drawCorner(Offset(w, 0), Offset(-l, 0), Offset(0, l));
    // Bottom-Left
    drawCorner(Offset(0, h), Offset(l, 0), Offset(0, -l));
    // Bottom-Right
    drawCorner(Offset(w, h), Offset(-l, 0), Offset(0, -l));
  }

  @override
  bool shouldRepaint(covariant _ViewfinderCornerPainter oldDelegate) {
    return oldDelegate.color != color ||
        oldDelegate.strokeWidth != strokeWidth ||
        oldDelegate.cornerLength != cornerLength;
  }
}

/// Glowing laser horizontal scan line.
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
      ],
    );
  }
}
