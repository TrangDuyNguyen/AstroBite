import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../icons/clay_3d_planet.dart';

/// Tactile Puffy 3D Clay Planet Selection Chip.
/// Replaces generic Material ChoiceChips with AstroBite's signature
/// Duolingo 2D/3D Claymorphic aesthetic and high-contrast WCAG AAA typography.
class ClayPlanetChip extends StatefulWidget {
  const ClayPlanetChip({
    super.key,
    required this.planetId,
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String planetId;
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<ClayPlanetChip> createState() => _ClayPlanetChipState();
}

class _ClayPlanetChipState extends State<ClayPlanetChip> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 3.5;
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
        onTap: () {
          HapticFeedback.selectionClick();
          widget.onTap();
        },
        behavior: HitTestBehavior.opaque,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 140),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
          decoration: BoxDecoration(
            color: widget.isSelected ? Colors.white : const Color(0xFFF7F5F0),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: widget.isSelected
                  ? AppColors.primary
                  : const Color(0xFFE5E0D8),
              width: widget.isSelected ? 2.0 : 1.2,
            ),
            boxShadow: [
              // Layer 1: Solid 3D Bottom Bevel
              BoxShadow(
                color: widget.isSelected
                    ? const Color(0xFF1488C2)
                    : const Color(0xFFDDD8CE),
                offset: Offset(0, effectiveBevel),
                blurRadius: 0,
              ),
              // Layer 2: Ambient Floating Glow
              if (widget.isSelected)
                BoxShadow(
                  color: AppColors.primary.withValues(alpha: 0.22),
                  offset: Offset(0, effectiveBevel + 3),
                  blurRadius: 10,
                )
              else
                const BoxShadow(
                  color: Color(0x0E1E2337),
                  offset: Offset(0, 3),
                  blurRadius: 6,
                ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // 3D Clay Planet Figurine
              Clay3DPlanet(planet: widget.planetId, size: 24),
              const SizedBox(width: 8),

              // High-Contrast Crisp Label Text
              Text(
                widget.label,
                style: TextStyle(
                  color: widget.isSelected
                      ? AppColors.onSurface
                      : AppColors.onSurfaceVariant,
                  fontSize: 14,
                  fontWeight: widget.isSelected ? FontWeight.w800 : FontWeight.w600,
                  letterSpacing: 0.2,
                ),
              ),

              if (widget.isSelected) ...[
                const SizedBox(width: 6),
                Container(
                  width: 16,
                  height: 16,
                  decoration: const BoxDecoration(
                    color: AppColors.primary,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.check,
                    size: 11,
                    color: Colors.white,
                  ),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}
