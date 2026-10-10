import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Tactile Ceramic Clay Button for Re-scan and secondary actions.
class ScanTactileActionButton extends StatefulWidget {
  const ScanTactileActionButton({
    super.key,
    required this.icon,
    required this.onPressed,
    this.tooltip,
    this.iconSize = 24.0,
  });

  final IconData icon;
  final VoidCallback? onPressed;
  final String? tooltip;
  final double iconSize;

  @override
  State<ScanTactileActionButton> createState() => _ScanTactileActionButtonState();
}

class _ScanTactileActionButtonState extends State<ScanTactileActionButton> {
  bool _isPressed = false;
  static const double _buttonSize = 48.0;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 3.0;
    final downShift = _isPressed ? 2.0 : 0.0;

    Widget btn = GestureDetector(
      onTapDown: widget.onPressed != null ? (_) => setState(() => _isPressed = true) : null,
      onTapUp: widget.onPressed != null ? (_) => setState(() => _isPressed = false) : null,
      onTapCancel: widget.onPressed != null ? () => setState(() => _isPressed = false) : null,
      onTap: widget.onPressed,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 80),
        curve: Curves.easeOutCubic,
        transform: Matrix4.translationValues(0, downShift, 0),
        width: _buttonSize,
        height: _buttonSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: widget.onPressed != null ? Colors.white : const Color(0xFFF3F0EA),
          border: Border.all(
            color: const Color(0xFFE2DDD5),
            width: 1.2,
          ),
          boxShadow: widget.onPressed != null
              ? [
                  BoxShadow(
                    color: const Color(0xFFD4CEBF),
                    offset: Offset(0, _isPressed ? 1.0 : bevelDepth),
                    blurRadius: 0,
                  ),
                  BoxShadow(
                    color: const Color(0x101E2337),
                    offset: Offset(0, _isPressed ? 2.0 : 5.0),
                    blurRadius: 6,
                  ),
                ]
              : null,
        ),
        child: Center(
          child: Icon(
            widget.icon,
            size: widget.iconSize,
            color: widget.onPressed != null
                ? AppColors.onSurface
                : AppColors.onSurfaceVariant.withValues(alpha: 0.5),
          ),
        ),
      ),
    );

    if (widget.tooltip != null) {
      btn = Tooltip(message: widget.tooltip!, child: btn);
    }
    return btn;
  }
}
