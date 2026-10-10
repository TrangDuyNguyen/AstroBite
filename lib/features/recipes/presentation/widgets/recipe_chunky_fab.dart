import 'package:flutter/material.dart';

/// 3D tactile Hero Floating Action Button for creating new recipes.
class RecipeChunkyFab extends StatefulWidget {
  const RecipeChunkyFab({super.key, required this.onTap});

  final VoidCallback onTap;

  @override
  State<RecipeChunkyFab> createState() => _RecipeChunkyFabState();
}

class _RecipeChunkyFabState extends State<RecipeChunkyFab> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Tạo Công Thức',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isPressed ? 2.5 : 0.0)
            ..scale(_isPressed ? 0.96 : 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF38BDF8),
                Color(0xFF1CB0F6),
                Color(0xFF0284C7),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFF1488C2),
              width: 1.5,
            ),
            boxShadow: [
              // 3D bottom bevel
              BoxShadow(
                color: const Color(0xFF0F74A8),
                offset: Offset(0, _isPressed ? 1.5 : 4.0),
                blurRadius: 0,
              ),
              // Blue ambient glow
              const BoxShadow(
                color: Color(0x351CB0F6),
                offset: Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 22),
              SizedBox(width: 6),
              Text(
                'Tạo Công Thức',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
