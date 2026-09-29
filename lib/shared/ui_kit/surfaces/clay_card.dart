import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Claymorphic × Duolingo 2D/3D Puffy Card Component.
/// 
/// Builds an inflated, soft-clay surface with fat rounded corners (20pt default),
/// 4-layer depth shadow stack (solid chunky 3D bevel + warm ambient drop + soft wide diffusion + glossy top sheen),
/// and responsive tactile squash interaction on press.
class ClayCard extends StatefulWidget {
  const ClayCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppValues.cardPadding),
    this.borderRadius = 20.0,
    this.backgroundColor,
    this.borderColor,
    this.elevation = 5.0,
    this.bevelColor,
    this.onTap,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final Color? backgroundColor;
  final Color? borderColor;
  final double elevation;
  final Color? bevelColor;
  final VoidCallback? onTap;

  Color _resolveBevelColor(Color bg) {
    if (bevelColor != null) return bevelColor!;
    // If tinted card (e.g. pastel), derive deeper shade
    if (bg.toARGB32() != AppColors.surfaceContainer.toARGB32() && bg.toARGB32() != Colors.white.toARGB32()) {
      return Color.lerp(bg, Colors.black, 0.16) ?? const Color(0xFFCFC8BA);
    }
    // High-contrast warm clay bottom bevel for white surfaces
    return const Color(0xFFD0C9BD);
  }

  @override
  State<ClayCard> createState() => _ClayCardState();
}

class _ClayCardState extends State<ClayCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    final bgColor = widget.backgroundColor ?? AppColors.surfaceContainer;
    final bevelColor = widget._resolveBevelColor(bgColor);
    final effectiveElevation = _isPressed ? 1.5 : widget.elevation;
    final isWhite = bgColor.toARGB32() == AppColors.surfaceContainer.toARGB32() || bgColor.toARGB32() == Colors.white.toARGB32();

    final decoration = BoxDecoration(
      color: isWhite ? null : bgColor,
      gradient: isWhite
          ? const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Colors.white, Color(0xFFFAF7F2)],
            )
          : null,
      borderRadius: BorderRadius.circular(widget.borderRadius),
      border: Border.all(
        color: widget.borderColor ?? const Color(0xFFE5E0D8),
        width: 1.2,
      ),
      boxShadow: widget.elevation > 0
          ? [
              // Layer 1: Soft tactile 3D clay bottom bevel (Mềm mại, không sắc lẹm)
              BoxShadow(
                color: bevelColor.withValues(alpha: 0.90),
                offset: Offset(0, effectiveElevation),
                blurRadius: 4.0,
                spreadRadius: -1.0,
              ),
              // Layer 2: Glossy top white reflection
              const BoxShadow(
                color: Colors.white,
                offset: Offset(0, -1.5),
                blurRadius: 3,
              ),
              // Layer 3: Warm ambient floating drop shadow
              BoxShadow(
                color: const Color(0x1E1E2337),
                offset: Offset(0, _isPressed ? 3 : effectiveElevation + 5),
                blurRadius: _isPressed ? 5 : 16,
              ),
              // Layer 4: Soft wide diffusion for physical presence
              BoxShadow(
                color: const Color(0x0C1E2337),
                offset: Offset(0, _isPressed ? 6 : effectiveElevation + 12),
                blurRadius: _isPressed ? 8 : 28,
              ),
            ]
          : null,
    );

    // Static card (no onTap): Avoid AnimatedScale and AnimatedContainer entirely
    // for optimal 60 FPS performance and zero RenderTransform layout assertion issues.
    if (widget.onTap == null) {
      return Container(
        padding: widget.padding,
        decoration: decoration,
        child: widget.child,
      );
    }

    // Interactive card: Smooth 3D depth squash on press via AnimatedContainer
    return GestureDetector(
      onTap: widget.onTap,
      onTapDown: (_) {
        if (mounted) setState(() => _isPressed = true);
      },
      onTapUp: (_) {
        if (mounted) setState(() => _isPressed = false);
      },
      onTapCancel: () {
        if (mounted) setState(() => _isPressed = false);
      },
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 110),
        curve: Curves.easeOutCubic,
        padding: widget.padding,
        decoration: decoration,
        child: widget.child,
      ),
    );
  }
}

/// Backward compatibility alias for SolarCard
typedef SolarCard = ClayCard;
