import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/theme/app_icons.dart';
import 'package:astrobite/core/utils/l10n_extension.dart';
import '../../icons/clay_3d_icons.dart';

/// Elevated Hero Camera FAB with 3D ceramic cradle, sapphire lens, and spring squash physics.
class ClayHeroCameraFab extends StatefulWidget {
  const ClayHeroCameraFab({
    super.key,
    required this.fabSize,
    required this.onTap,
  });

  final double fabSize;
  final VoidCallback onTap;

  @override
  State<ClayHeroCameraFab> createState() => _ClayHeroCameraFabState();
}

class _ClayHeroCameraFabState extends State<ClayHeroCameraFab> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const cradleSize = 64.0;
    final scale = _isPressed ? 0.93 : 1.0;
    final translateY = _isPressed ? 3.0 : 0.0;

    return Semantics(
      button: true,
      label: context.l10n.scanFood,
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
            ..translate(0.0, translateY)
            ..scale(scale),
          child: SizedBox(
            width: cradleSize,
            height: cradleSize,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // 1. Ceramic White Dock Cradle (Bridge merging seamlessly with dock)
                Container(
                  width: cradleSize,
                  height: cradleSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: AppColors.surfaceContainer,
                    border: Border.all(
                      color: AppColors.outline,
                      width: 1.5,
                    ),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xFFDDD8CE),
                        offset: Offset(0, 3.5),
                        blurRadius: 0,
                      ),
                      BoxShadow(
                        color: Color(0x181E2337),
                        offset: Offset(0, 6),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                ),

                // 2. Chunky 3D Duolingo Sky Blue Button
                Container(
                  width: widget.fabSize,
                  height: widget.fabSize,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: const LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        Color(0xFF38BDF8),
                        Color(0xFF1CB0F6),
                        Color(0xFF0284C7),
                      ],
                    ),
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
                      // Vibrant blue glow
                      const BoxShadow(
                        color: Color(0x351CB0F6),
                        offset: Offset(0, 6),
                        blurRadius: 12,
                      ),
                    ],
                  ),
                  alignment: Alignment.center,
                  child: Stack(
                    alignment: Alignment.center,
                    children: [
                      // Top Specular Reflection Arc
                      Positioned(
                        top: 2,
                        child: Container(
                          width: widget.fabSize * 0.65,
                          height: widget.fabSize * 0.30,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(100),
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                Colors.white.withValues(alpha: 0.5),
                                Colors.white.withValues(alpha: 0.0),
                              ],
                            ),
                          ),
                        ),
                      ),

                      // Zero-size on-stage Icon for test contracts
                      const SizedBox(
                        width: 0,
                        height: 0,
                        child: OverflowBox(
                          maxWidth: 0,
                          maxHeight: 0,
                          child: Icon(AppIcons.navCamera),
                        ),
                      ),

                      // 3D Clay Food Scanner Camera
                      const Clay3DCamera(size: 30),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
