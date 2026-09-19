import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_strings.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Premium Google Sign-In button with authentic Google 4-color vector emblem,
/// tactile spring-press animation, and Celestial Glassmorphic styling.
class GoogleSignInButton extends StatefulWidget {
  const GoogleSignInButton({
    super.key,
    required this.onPressed,
    this.isLoading = false,
  });

  final VoidCallback? onPressed;
  final bool isLoading;

  @override
  State<GoogleSignInButton> createState() => _GoogleSignInButtonState();
}

class _GoogleSignInButtonState extends State<GoogleSignInButton> {
  bool _isPressed = false;

  void _handleTapDown(TapDownDetails _) {
    if (!widget.isLoading && widget.onPressed != null) {
      setState(() => _isPressed = true);
    }
  }

  void _handleTapUp(TapUpDetails _) {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  void _handleTapCancel() {
    if (_isPressed) {
      setState(() => _isPressed = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final bool isInteractive = !widget.isLoading && widget.onPressed != null;

    return AnimatedScale(
      scale: _isPressed ? 0.97 : 1.0,
      duration: const Duration(milliseconds: 120),
      curve: Curves.easeOutCubic,
      child: SizedBox(
        height: AppValues.minTouchTarget,
        child: Material(
          color: Colors.transparent,
          borderRadius: BorderRadius.circular(AppValues.cardRadius),
          child: InkWell(
            onTap: isInteractive ? widget.onPressed : null,
            onTapDown: _handleTapDown,
            onTapUp: _handleTapUp,
            onTapCancel: _handleTapCancel,
            borderRadius: BorderRadius.circular(AppValues.cardRadius),
            splashColor: Colors.white.withValues(alpha: 0.1),
            highlightColor: Colors.white.withValues(alpha: 0.05),
            child: Ink(
              decoration: BoxDecoration(
                color: AppColors.surfaceContainer,
                borderRadius: BorderRadius.circular(AppValues.cardRadius),
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.15),
                  width: 1.2,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.25),
                    blurRadius: 8,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: AppValues.spacing16),
                child: widget.isLoading
                    ? const Center(
                        child: SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
                          ),
                        ),
                      )
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Container(
                            width: 24,
                            height: 24,
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(4),
                            ),
                            padding: const EdgeInsets.all(2.5),
                            child: const CustomPaint(
                              painter: _GoogleLogoPainter(),
                            ),
                          ),
                          const SizedBox(width: AppValues.spacing12),
                          const Text(
                            AppStrings.googleSignIn,
                            style: TextStyle(
                              color: AppColors.onSurface,
                              fontSize: 15,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.2,
                            ),
                          ),
                        ],
                      ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

/// Official 4-color Google "G" logo vector painter.
class _GoogleLogoPainter extends CustomPainter {
  const _GoogleLogoPainter();

  @override
  void paint(Canvas canvas, Size size) {
    final double w = size.width;
    final double h = size.height;
    final double cx = w / 2;
    final double cy = h / 2;
    final double r = w / 2;

    final paint = Paint()
      ..style = PaintingStyle.fill
      ..isAntiAlias = true;

    // 1. Red Top Arc (#EA4335)
    paint.color = const Color(0xFFEA4335);
    final pathRed = Path()
      ..moveTo(cx, cy)
      ..lineTo(cx + r * math.cos(-math.pi / 4), cy - r * math.sin(math.pi / 4))
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        -math.pi / 4,
        -math.pi / 2,
        false,
      )
      ..close();
    canvas.drawPath(pathRed, paint);

    // 2. Yellow Left Arc (#FBBC05)
    paint.color = const Color(0xFFFBBC05);
    final pathYellow = Path()
      ..moveTo(cx, cy)
      ..lineTo(cx - r, cy)
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        math.pi,
        -math.pi / 4,
        false,
      )
      ..close();
    canvas.drawPath(pathYellow, paint);

    // 3. Green Bottom Arc (#34A853)
    paint.color = const Color(0xFF34A853);
    final pathGreen = Path()
      ..moveTo(cx, cy)
      ..lineTo(cx, cy + r)
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        math.pi / 2,
        math.pi / 2,
        false,
      )
      ..close();
    canvas.drawPath(pathGreen, paint);

    // 4. Blue Right Arc & Horizontal Bar (#4285F4)
    paint.color = const Color(0xFF4285F4);
    final pathBlue = Path()
      ..moveTo(cx, cy)
      ..lineTo(cx + r, cy)
      ..arcTo(
        Rect.fromCircle(center: Offset(cx, cy), radius: r),
        0,
        math.pi / 2,
        false,
      )
      ..lineTo(cx, cy)
      ..close();
    canvas.drawPath(pathBlue, paint);

    // 5. Center cutout (Inner circle)
    final cutoutPaint = Paint()
      ..color = Colors.white
      ..style = PaintingStyle.fill;
    canvas.drawCircle(Offset(cx, cy), r * 0.54, cutoutPaint);

    // 6. Right Horizontal Bar of "G"
    final barPaint = Paint()
      ..color = const Color(0xFF4285F4)
      ..style = PaintingStyle.fill;
    canvas.drawRect(
      Rect.fromLTWH(cx - r * 0.05, cy - r * 0.22, r * 1.05, r * 0.44),
      barPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
