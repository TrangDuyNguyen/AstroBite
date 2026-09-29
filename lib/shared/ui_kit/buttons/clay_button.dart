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

/// Tactile Soft Matte Claymorphic × Duolingo 2D/3D Button.
/// 
/// Features:
/// - Velvety Soft Matte Clay body (smooth directional diffuse light, no harsh gloss cuts)
/// - Puffy 3D volume via continuous 3-stop top-left to bottom-right lighting
/// - Soft spherical radial highlight that smoothly bleeds into the clay
/// - Solid warm 3D bottom bevel (4.2pt) with mechanical keycap down-shift on press
/// - Embedded text depth shadow and soft ambient colored glow
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
    this.padding,
    this.fontSize,
    this.borderRadius = 24.0,
  });

  final String text;
  final VoidCallback? onPressed;
  final ClayButtonVariant variant;
  final bool isLoading;
  final Widget? icon;
  final double height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final double? fontSize;
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
    ClayButtonVariant.primary => const Color(0xFF1172A2), // Deep velvety matte blue
    ClayButtonVariant.success => const Color(0xFF388002), // Deep matte lime
    ClayButtonVariant.warning => const Color(0xFFA86000), // Deep matte tangerine
    ClayButtonVariant.danger  => const Color(0xFF941818), // Deep matte red
    ClayButtonVariant.outline => const Color(0xFFD0C9BE), // Warm soft clay
  };

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 4.2;
    final effectiveBevel = _isPressed ? 1.0 : bevelDepth;
    final downShift = _isPressed ? (bevelDepth - 1.0) : 0.0;

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
              border: widget.variant == ClayButtonVariant.outline
                  ? Border.all(
                      color: const Color(0xFFE2DDD4),
                      width: 1.2,
                    )
                  : null,
              boxShadow: _isEnabled
                  ? [
                      // Layer 1: Soft Velvety Clay Contact Depth (Mềm mại, không sắc lẹm)
                      BoxShadow(
                        color: _bevelColor.withValues(alpha: 0.90),
                        offset: Offset(0, effectiveBevel),
                        blurRadius: 3.5,
                        spreadRadius: -0.5,
                      ),
                      // Layer 2: Soft Ambient Colored Diffuse Glow
                      if (widget.variant != ClayButtonVariant.outline)
                        BoxShadow(
                          color: _baseColor.withValues(alpha: 0.28),
                          offset: Offset(0, _isPressed ? 2 : effectiveBevel + 4),
                          blurRadius: _isPressed ? 4 : 14,
                          spreadRadius: -1.0,
                        )
                      else
                        BoxShadow(
                          color: const Color(0x141E2337),
                          offset: Offset(0, _isPressed ? 2 : effectiveBevel + 3),
                          blurRadius: _isPressed ? 4 : 10,
                          spreadRadius: -0.5,
                        ),
                    ]
                  : null,
            ),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(widget.borderRadius),
              child: Stack(
                fit: StackFit.loose,
                alignment: Alignment.center,
                children: [
                  // 1. Soft Matte Clay Body — Continuous 3-stop directional gradient
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: widget.variant == ClayButtonVariant.outline
                            ? const LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: [0.0, 0.5, 1.0],
                                colors: [
                                  Colors.white,
                                  Color(0xFFFAF7F2),
                                  Color(0xFFF0EBE0),
                                ],
                              )
                            : LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                stops: const [0.0, 0.45, 1.0],
                                colors: [
                                  Color.lerp(_baseColor, Colors.white, 0.24)!,
                                  _baseColor,
                                  Color.lerp(_baseColor, Colors.black, 0.12)!,
                                ],
                              ),
                      ),
                    ),
                  ),

                  // 2. Diffuse Soft Ambient Light Pool (Radial, velvety soft, zero harsh lines)
                  Positioned.fill(
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        gradient: RadialGradient(
                          center: const Alignment(-0.25, -0.75),
                          radius: 1.15,
                          colors: [
                            Colors.white.withValues(
                              alpha: widget.variant == ClayButtonVariant.outline ? 0.65 : 0.28,
                            ),
                            Colors.white.withValues(alpha: 0.0),
                          ],
                        ),
                      ),
                    ),
                  ),

                  // 3. Button Content (Text with subtle molded depth shadow)
                  Padding(
                    padding: widget.padding ??
                        (widget.width != null
                            ? const EdgeInsets.symmetric(horizontal: AppValues.spacing8)
                            : const EdgeInsets.symmetric(horizontal: AppValues.spacing16)),
                    child: Center(
                      widthFactor: widget.width != null ? null : 1.0,
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
                              Flexible(
                                child: Text(
                                  widget.text,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: TextStyle(
                                    fontSize: widget.fontSize ?? (widget.height < 42 ? 13.5 : 16.0),
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
                                              color: _bevelColor.withValues(alpha: 0.50),
                                              offset: const Offset(0, 1.2),
                                              blurRadius: 2,
                                            ),
                                          ],
                                  ),
                                ),
                              ),
                            ],
                          ),
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
