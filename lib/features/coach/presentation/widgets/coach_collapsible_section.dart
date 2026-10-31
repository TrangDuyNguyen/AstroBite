import 'package:flutter/material.dart';

/// Smooth collapsible container providing synchronized Slide, Fade, and Size transitions.
/// Used for AstroCoach top nutrition overview and bottom suggestions with physical momentum.
class CoachCollapsibleSection extends StatelessWidget {
  const CoachCollapsibleSection({
    super.key,
    required this.isExpanded,
    required this.isTop,
    required this.child,
    this.duration = const Duration(milliseconds: 300),
    this.reverseDuration = const Duration(milliseconds: 260),
  });

  /// Whether the section is expanded and visible.
  final bool isExpanded;

  /// True if placed at top (slides up/down), false if placed at bottom (slides down/up).
  final bool isTop;

  /// Content to show when expanded.
  final Widget child;

  /// Duration when expanding / sliding into view.
  final Duration duration;

  /// Duration when collapsing / sliding out of view.
  final Duration reverseDuration;

  @override
  Widget build(BuildContext context) {
    final slideOffset = isTop ? const Offset(0.0, -0.25) : const Offset(0.0, 0.25);
    final axisAlignment = isTop ? -1.0 : 1.0;
    final stackAlignment = isTop ? Alignment.topCenter : Alignment.bottomCenter;

    return AnimatedSwitcher(
      duration: duration,
      reverseDuration: reverseDuration,
      switchInCurve: Curves.easeOutCubic,
      switchOutCurve: Curves.easeInCubic,
      layoutBuilder: (currentChild, previousChildren) {
        return Stack(
          alignment: stackAlignment,
          clipBehavior: Clip.hardEdge,
          children: [
            ...previousChildren,
            if (currentChild != null) currentChild,
          ],
        );
      },
      transitionBuilder: (child, animation) {
        return SizeTransition(
          sizeFactor: animation,
          axis: Axis.vertical,
          axisAlignment: axisAlignment,
          child: FadeTransition(
            opacity: animation,
            child: SlideTransition(
              position: Tween<Offset>(
                begin: slideOffset,
                end: Offset.zero,
              ).animate(animation),
              child: child,
            ),
          ),
        );
      },
      child: isExpanded
          ? KeyedSubtree(
              key: ValueKey('expanded_${isTop ? "top" : "bottom"}'),
              child: child,
            )
          : SizedBox(
              key: ValueKey('collapsed_${isTop ? "top" : "bottom"}'),
              width: double.infinity,
              height: 0,
            ),
    );
  }
}
