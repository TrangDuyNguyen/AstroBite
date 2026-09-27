import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../indicators/clay_morph_icon.dart';

/// Claymorphic round or squircle tactile icon button.
/// Enforces minimum touch target of 44pt with Duolingo 3D mechanical press and 3-layer depth.
class ClayIconButton extends StatefulWidget {
  const ClayIconButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.size = 44.0,
    this.backgroundColor,
    this.iconColor,
    this.borderRadius = 14.0,
    this.tooltip,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final double size;
  final Color? backgroundColor;
  final Color? iconColor;
  final double borderRadius;
  final String? tooltip;

  @override
  State<ClayIconButton> createState() => _ClayIconButtonState();
}

class _ClayIconButtonState extends State<ClayIconButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 3.5;
    final effectiveElevation = _isPressed ? 1.0 : bevelDepth;
    final downShift = _isPressed ? (bevelDepth - 1.0) : 0.0;

    final isPrimary = widget.backgroundColor == AppColors.primary;
    final bgColor = widget.backgroundColor ?? AppColors.surfaceContainer;
    final bevelColor = isPrimary
        ? const Color(0xFF1278AE)
        : (widget.backgroundColor != null &&
                widget.backgroundColor != Colors.white &&
                widget.backgroundColor != AppColors.surfaceContainer
            ? (Color.lerp(widget.backgroundColor!, Colors.black, 0.18) ?? const Color(0xFFCEC8BD))
            : const Color(0xFFCEC8BD));

    Widget button = AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, widget.onPressed != null ? downShift : 0.0, 0),
      child: GestureDetector(
        onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
        onTapUp: widget.onPressed != null ? (_) => setState(() => _isPressed = false) : null,
        onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
        onTap: widget.onPressed,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            color: bgColor,
            gradient: isPrimary
                ? LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Color.lerp(AppColors.primary, Colors.white, 0.16)!,
                      AppColors.primary,
                    ],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFFAF7F2)],
                  ),
            borderRadius: BorderRadius.circular(widget.borderRadius),
            border: Border.all(
              color: isPrimary ? const Color(0xFF1278AE) : const Color(0xFFE2DDD5),
              width: 1.2,
            ),
            boxShadow: widget.onPressed != null
                ? [
                    // Layer 1: Solid 3D tactile bottom bevel
                    BoxShadow(
                      color: bevelColor,
                      offset: Offset(0, effectiveElevation),
                      blurRadius: 0,
                    ),
                    // Layer 2: Glossy white top highlight sheen
                    BoxShadow(
                      color: Colors.white.withValues(alpha: isPrimary ? 0.35 : 0.8),
                      offset: const Offset(0, 1.2),
                      blurRadius: 0,
                    ),
                    // Layer 3: Ambient shadow
                    BoxShadow(
                      color: isPrimary ? AppColors.primary.withValues(alpha: 0.28) : const Color(0x181E2337),
                      offset: Offset(0, _isPressed ? 2 : effectiveElevation + 2),
                      blurRadius: _isPressed ? 3 : 8,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: ClayMorphIcon(
              icon: widget.icon,
              size: widget.size * 0.5,
              color: widget.iconColor ?? (isPrimary ? Colors.white : AppColors.onSurface),
            ),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      button = Tooltip(message: widget.tooltip!, child: button);
    }

    return button;
  }
}
