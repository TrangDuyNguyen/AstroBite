import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

enum ClayButtonVariant {
  primary,
  success,
  warning,
  danger,
  outline,
}

/// Tactile Claymorphic × Duolingo 2D/3D Puffy Mechanical Button.
/// 
/// Features:
/// - Puffy 3D clay body with fat 24pt rounded corners
/// - Visible top specular gloss highlight sheen (the signature clay reflection)
/// - Bottom inner curvature shading (debossed clay contour)
/// - Solid chunky 3D bottom bevel (5.0pt) that physically sinks down 3.5px on press
/// - Embossed text with depth shadow
/// - Soft colored ambient glow
class ClayButton extends StatefulWidget {
  const ClayButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ClayButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.height = 52.0,
    this.width,
    this.borderRadius = 24.0,
  });

  final String text;
  final VoidCallback? onPressed;
  final ClayButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final double height;
  final double? width;
  final double borderRadius;

  @override
  State<ClayButton> createState() => _ClayButtonState();
}

class _ClayButtonState extends State<ClayButton> {
  bool _isPressed = false;

  bool get _isEnabled => widget.onPressed != null && !widget.isLoading;

  Color get _baseColor => switch (widget.variant) {
    ClayButtonVariant.primary => AppColors.primary,
    ClayButtonVariant.success => AppColors.brandGreen,
    ClayButtonVariant.warning => AppColors.tertiary,
    ClayButtonVariant.danger  => AppColors.error,
    ClayButtonVariant.outline => AppColors.surfaceContainer,
  };

  Color get _textColor => switch (widget.variant) {
    ClayButtonVariant.outline => AppColors.onSurface,
    _ => Colors.white,
  };

  Color get _bevelColor => switch (widget.variant) {
    ClayButtonVariant.primary => const Color(0xFF106D9E), // Deep rich blue
    ClayButtonVariant.success => const Color(0xFF357A02), // Deep lime
    ClayButtonVariant.warning => const Color(0xFFA65D00), // Deep tangerine
    ClayButtonVariant.danger  => const Color(0xFF8E1414), // Deep red
    ClayButtonVariant.outline => const Color(0xFFCEC7BC), // Warm clay
  };

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 5.0;
    final effectiveBevel = _isPressed ? 1.2 : bevelDepth;
    final downShift = _isPressed ? (bevelDepth - 1.2) : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, _isEnabled ? downShift : 0.0, 0),
      child: SizedBox(
        width: widget.width,
        height: widget.height,
        child: GestureDetector(
          onTapDown: _isEnabled ? (_) => setState(() => _isPressed = true) : null,
          onTapUp: _isEnabled ? (_) => setState(() => _isPressed = false) : null,
          onTapCancel: _isEnabled ? () => setState(() => _isPressed = false) : null,
          onTap: _isEnabled ? widget.onPressed : null,
          behavior: HitTestBehavior.opaque,
          child: AnimatedContainer(
            duration: const Duration(milliseconds: 90),
            curve: Curves.easeOutCubic,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.variant == ClayButtonVariant.outline
                    ? const Color(0xFFE0DBD2)
                    : Colors.white.withValues(alpha: 0.35),
                width: 1.5,
              ),
              boxShadow: _isEnabled
                  ? [
                      // Layer 1: Solid Chunky 3D Bottom Bevel
                      BoxShadow(
                        color: _bevelColor,
                        offset: Offset(0, effectiveBevel),
                        blurRadius: 0,
                      ),
                      // Layer 2: Vibrant Ambient Colored 3D Glow
                      if (widget.variant != ClayButtonVariant.outline)
                        BoxShadow(
                          color: _baseColor.withValues(alpha: 0.36),
                          offset: Offset(0, _isPressed ? 3 : effectiveBevel + 4),
                          blurRadius: _isPressed ? 6 : 16,
                        )
                      else
                        BoxShadow(
                          color: const Color(0x1A1E2337),
                          offset: Offset(0, _isPressed ? 2 : effectiveBevel + 3),
                          blurRadius: _isPressed ? 4 : 12,
                        ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius - 1.5),
              child: Stack(
                fit: StackFit.expand,
                children: [
                  // 1. Base Clay Body Gradient
                  DecoratedBox(
                    decoration: BoxDecoration(
                      gradient: widget.variant == ClayButtonVariant.outline
                          ? const LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [Colors.white, Color(0xFFF7F4EF)],
                            )
                          : LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Color.lerp(_baseColor, Colors.white, 0.22)!,
                                _baseColor,
                              ],
                            ),
                    ),
                  ),

                  // 2. Clay Specular Gloss Highlight (The signature top shiny oval)
                  Positioned(
                    top: 2.5,
                    left: 6.0,
                    right: 6.0,
                    height: widget.height * 0.44,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(widget.borderRadius - 4),
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.white.withValues(
                              alpha: widget.variant == ClayButtonVariant.outline ? 0.95 : 0.55,
                            ),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Bottom Inner Curvature Shadow (The clay depth crease)
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: widget.height * 0.32,
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            (widget.variant == ClayButtonVariant.outline
                                ? const Color(0xFFDDD7CE)
                                : Colors.black).withValues(alpha: 0.20),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 4. Button Content (Icon + Text with Embossed Depth Shadow)
                  Center(
                    child: widget.isLoading
                        ? SizedBox(
                            width: 22,
                            height: 22,
                            child: CircularProgressIndicator(
                              strokeWidth: 2.4,
                              valueColor: AlwaysStoppedAnimation<Color>(_textColor),
                            ),
                          )
                        : Row(
                            mainAxisSize: MainAxisSize.min,
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (widget.icon != null) ...[
                                widget.icon!,
                                const SizedBox(width: AppValues.spacing8),
                              ],
                              Text(
                                widget.text,
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w800,
                                  color: _textColor,
                                  letterSpacing: 0.3,
                                  shadows: widget.variant == ClayButtonVariant.outline
                                      ? const [
                                          Shadow(
                                            color: Colors.white,
                                            offset: Offset(0, 1),
                                            blurRadius: 1,
                                          ),
                                        ]
                                      : [
                                          Shadow(
                                            color: _bevelColor.withValues(alpha: 0.65),
                                            offset: const Offset(0, 1.5),
                                            blurRadius: 2,
                                          ),
                                        ],
                                ),
                              ),
                            ],
                          ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
