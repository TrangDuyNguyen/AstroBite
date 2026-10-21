import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Puffy 3D Claymorphic Quick Action Button with tactile keycap downshift
class WaterQuickActionButton extends StatefulWidget {
  const WaterQuickActionButton({
    super.key,
    required this.icon,
    required this.label,
    required this.onTap,
  });

  final String icon;
  final String label;
  final VoidCallback onTap;

  @override
  State<WaterQuickActionButton> createState() => _WaterQuickActionButtonState();
}

class _WaterQuickActionButtonState extends State<WaterQuickActionButton> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 3.2;
    final effectiveBevel = _isPressed ? 1.0 : bevelDepth;
    final downShift = _isPressed ? (bevelDepth - 1.0) : 0.0;

    return AnimatedContainer(
      duration: const Duration(milliseconds: 90),
      curve: Curves.easeOutCubic,
      transform: Matrix4.translationValues(0, downShift, 0),
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) => setState(() => _isPressed = false),
        onTapCancel: () => setState(() => _isPressed = false),
        onTap: widget.onTap,
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 90),
          height: 42,
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFFAF7F2)],
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: const Color(0xFFEDE9E1),
              width: 1.2,
            ),
            boxShadow: [
              // Layer 1: Solid 3D clay bottom bevel
              BoxShadow(
                color: const Color(0xFFD4CEC3),
                offset: Offset(0, effectiveBevel),
                blurRadius: 0,
              ),
              // Layer 2: Glossy top reflection
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, -1),
                blurRadius: 2,
              ),
              // Layer 3: Warm ambient shadow
              BoxShadow(
                color: const Color(0x141E2337),
                offset: Offset(0, _isPressed ? 2 : 5),
                blurRadius: _isPressed ? 3 : 8,
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(widget.icon, style: const TextStyle(fontSize: 15)),
              const SizedBox(width: 5),
              Text(
                widget.label,
                style: const TextStyle(
                  fontSize: 12,
                  fontWeight: FontWeight.w800,
                  color: AppColors.onSurface,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
