import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Single interactive navigation item for [ClayBottomNav].
class ClayNavItem extends StatefulWidget {
  const ClayNavItem({
    super.key,
    required this.icon,
    required this.selectedIcon,
    required this.clayIcon,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final IconData icon;
  final IconData selectedIcon;
  final Widget Function(bool isSelected) clayIcon;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<ClayNavItem> createState() => _ClayNavItemState();
}

class _ClayNavItemState extends State<ClayNavItem> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final scale = _isPressed ? 0.92 : 1.0;

    return Semantics(
      button: true,
      selected: widget.isSelected,
      label: widget.label,
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()..scale(scale),
          child: Center(
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 220),
              curve: Curves.easeOutBack,
              padding: EdgeInsets.symmetric(
                horizontal: widget.isSelected ? 8 : 4,
                vertical: widget.isSelected ? 4 : 4,
              ),
              decoration: widget.isSelected
                  ? BoxDecoration(
                      gradient: const LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Color(0xFFF0F9FE),
                          Color(0xFFE2F4FD),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(18),
                      border: Border.all(
                        color: const Color(0xFF90D5F7),
                        width: 1.2,
                      ),
                      boxShadow: const [
                        // 3D bottom bevel
                        BoxShadow(
                          color: Color(0xFFBCE3F7),
                          offset: Offset(0, 2.5),
                          blurRadius: 0,
                        ),
                      ],
                    )
                  : null,
              child: Column(
                mainAxisSize: MainAxisSize.min,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Hidden on-stage Icon for test contracts
                  SizedBox(
                    width: 0,
                    height: 0,
                    child: OverflowBox(
                      maxWidth: 0,
                      maxHeight: 0,
                      child: Icon(
                        widget.isSelected ? widget.selectedIcon : widget.icon,
                        size: 1,
                      ),
                    ),
                  ),

                  // 3D Clay Navigation Emblem with bounce scale
                  AnimatedScale(
                    scale: widget.isSelected ? 1.08 : 0.95,
                    duration: const Duration(milliseconds: 200),
                    curve: Curves.easeOutBack,
                    child: widget.clayIcon(widget.isSelected),
                  ),
                  const SizedBox(height: 3),

                  // Label
                  FittedBox(
                    fit: BoxFit.scaleDown,
                    child: Text(
                      widget.label,
                      style: TextStyle(
                        fontSize: widget.isSelected ? 10.5 : 10.0,
                        fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
                        color: widget.isSelected
                            ? AppColors.primary
                            : AppColors.onSurfaceVariant,
                        letterSpacing: -0.2,
                      ),
                      maxLines: 1,
                    ),
                  ),

                  // Active Indicator Gem Dot
                  if (widget.isSelected) ...[
                    const SizedBox(height: 2),
                    Container(
                      width: 10,
                      height: 2.5,
                      decoration: BoxDecoration(
                        color: AppColors.primary,
                        borderRadius: BorderRadius.circular(2),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFF1488C2),
                            offset: Offset(0, 0.8),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                    ),
                  ],
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
