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

/// Tactile Claymorphic × Duolingo 2D/3D Mechanical Button.
/// 
/// Features a chunky 3D bottom bevel (4.5pt), mechanical keycap down-shift on press,
/// glossy top highlight sheen, colored ambient drop shadow, and WCAG AAA/AA compliant contrast.
class ClayButton extends StatefulWidget {
  const ClayButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.variant = ClayButtonVariant.primary,
    this.isLoading = false,
    this.icon,
    this.height = 50.0,
    this.width,
    this.borderRadius = 16.0,
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
    ClayButtonVariant.primary => const Color(0xFF1278AE), // Deep contrasting blue
    ClayButtonVariant.success => const Color(0xFF3E8D02), // Deep lime
    ClayButtonVariant.warning => const Color(0xFFB36500), // Deep tangerine
    ClayButtonVariant.danger  => const Color(0xFF9B1515), // Deep red
    ClayButtonVariant.outline => const Color(0xFFD0CAC0), // Warm solid clay
  };

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 4.5;
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
            padding: const EdgeInsets.symmetric(horizontal: AppValues.spacing16),
            decoration: BoxDecoration(
              color: _isEnabled ? _baseColor : _baseColor.withValues(alpha: 0.5),
              gradient: _isEnabled && widget.variant != ClayButtonVariant.outline
                  ? LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color.lerp(_baseColor, Colors.white, 0.16)!,
                        _baseColor,
                      ],
                    )
                  : (widget.variant == ClayButtonVariant.outline
                      ? const LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [Colors.white, Color(0xFFFAF8F5)],
                        )
                      : null),
              borderRadius: BorderRadius.circular(widget.borderRadius),
              border: Border.all(
                color: widget.variant == ClayButtonVariant.outline
                    ? const Color(0xFFE2DDD5)
                    : _bevelColor,
                width: 1.2,
              ),
              boxShadow: _isEnabled
                  ? [
                      // Layer 1: Solid Duolingo 3D Chunky Bottom Bevel
                      BoxShadow(
                        color: _bevelColor,
                        offset: Offset(0, effectiveBevel),
                        blurRadius: 0,
                      ),
                      // Layer 2: Glossy Top Inner Highlight Sheen
                      BoxShadow(
                        color: Colors.white.withValues(
                          alpha: widget.variant == ClayButtonVariant.outline ? 0.8 : 0.30,
                        ),
                        offset: const Offset(0, 1.5),
                        blurRadius: 0,
                      ),
                      // Layer 3: Vibrant Ambient Colored 3D Float
                      if (widget.variant != ClayButtonVariant.outline)
                        BoxShadow(
                          color: _baseColor.withValues(alpha: 0.30),
                          offset: Offset(0, _isPressed ? 3 : effectiveBevel + 4),
                          blurRadius: _isPressed ? 6 : 14,
                        )
                      else
                        BoxShadow(
                          color: const Color(0x181E2337),
                          offset: Offset(0, _isPressed ? 2 : effectiveBevel + 3),
                          blurRadius: _isPressed ? 4 : 10,
                        ),
                    ]
                  : null,
            ),
            child: Center(
              child: widget.isLoading
                  ? SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2.2,
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
                            fontSize: 15,
                            fontWeight: FontWeight.w700,
                            color: _textColor,
                            letterSpacing: 0.3,
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
