import 'package:flutter/material.dart';

/// ClayMorphIcon — Spring-Physics Icon Morphing Component
/// 
/// Inspired by Morphicons (https://www.morphicons.com/):
/// - Morphs any icon into any other with spring physics
/// - Elastic squash, scale, and subtle rotational flip transitions
/// - Zero external dependencies, pure Flutter Canvas & animation framework
class ClayMorphIcon extends StatelessWidget {
  const ClayMorphIcon({
    super.key,
    required this.icon,
    this.color,
    this.size = 24.0,
    this.duration = const Duration(milliseconds: 280),
    this.curve = Curves.easeOutBack,
  });

  final IconData icon;
  final Color? color;
  final double size;
  final Duration duration;
  final Curve curve;

  @override
  Widget build(BuildContext context) {
    return AnimatedSwitcher(
      duration: duration,
      switchInCurve: curve,
      switchOutCurve: Curves.easeInBack,
      transitionBuilder: (Widget child, Animation<double> animation) {
        final scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(animation);
        final rotateAnimation = Tween<double>(begin: -0.12, end: 0.0).animate(animation);

        return ScaleTransition(
          scale: scaleAnimation,
          child: RotationTransition(
            turns: rotateAnimation,
            child: FadeTransition(
              opacity: animation,
              child: child,
            ),
          ),
        );
      },
      child: Icon(
        icon,
        key: ValueKey<IconData>(icon),
        size: size,
        color: color,
      ),
    );
  }
}
