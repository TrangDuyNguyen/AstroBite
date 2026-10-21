import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import '../../domain/entities/water_quick_preset.dart';

/// 3D Puffy Clay Preset Selection Card for Water Sheet
class ClayPresetCard extends StatefulWidget {
  const ClayPresetCard({
    super.key,
    required this.preset,
    required this.isSelected,
    required this.onTap,
  });

  final WaterQuickPreset preset;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  State<ClayPresetCard> createState() => _ClayPresetCardState();
}

class _ClayPresetCardState extends State<ClayPresetCard> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    const double bevelDepth = 3.6;
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
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          padding: const EdgeInsets.symmetric(vertical: 14),
          decoration: BoxDecoration(
            gradient: widget.isSelected
                ? const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Color(0xFF2EB9FF), Color(0xFF139CE4)],
                  )
                : const LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [Colors.white, Color(0xFFFAF7F2)],
                  ),
            borderRadius: BorderRadius.circular(18),
            border: Border.all(
              color: widget.isSelected
                  ? const Color(0xFF149EE5)
                  : const Color(0xFFEDE9E1),
              width: widget.isSelected ? 1.5 : 1.2,
            ),
            boxShadow: [
              // Layer 1: Solid 3D tactile bottom bevel
              BoxShadow(
                color: widget.isSelected
                    ? const Color(0xFF0F7EB8)
                    : const Color(0xFFDDD8CE),
                offset: Offset(0, effectiveBevel),
                blurRadius: 0,
              ),
              // Layer 2: Glossy top reflection
              BoxShadow(
                color: Colors.white.withValues(alpha: widget.isSelected ? 0.45 : 0.9),
                offset: const Offset(0, -1),
                blurRadius: 2,
              ),
              // Layer 3: Ambient float / glow
              BoxShadow(
                color: widget.isSelected
                    ? const Color(0x351CB0F6)
                    : const Color(0x121E2337),
                offset: Offset(0, _isPressed ? 2 : 5),
                blurRadius: _isPressed ? 4 : 10,
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Text(widget.preset.icon, style: const TextStyle(fontSize: 24)),
              const SizedBox(height: 6),
              Text(
                widget.preset.label,
                style: TextStyle(
                  fontSize: 13,
                  fontWeight: FontWeight.w800,
                  color: widget.isSelected ? Colors.white : AppColors.onSurface,
                  shadows: widget.isSelected
                      ? const [
                          Shadow(
                            color: Color(0x33000000),
                            blurRadius: 2,
                            offset: Offset(0, 1),
                          )
                        ]
                      : null,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

/// Custom 3D Puffy Clay Thumb for Sliders
class ClaySliderThumbShape extends SliderComponentShape {
  const ClaySliderThumbShape({this.thumbRadius = 14.0});

  final double thumbRadius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) =>
      Size.fromRadius(thumbRadius);

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final canvas = context.canvas;

    // Solid 3D bottom bevel
    final bevelPaint = Paint()..color = const Color(0xFF0F7EB8);
    canvas.drawCircle(center + const Offset(0, 2.5), thumbRadius, bevelPaint);

    // Main clay thumb body
    final thumbPaint = Paint()
      ..shader = const LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [Color(0xFF38BEFF), Color(0xFF139CE4)],
      ).createShader(Rect.fromCircle(center: center, radius: thumbRadius));
    canvas.drawCircle(center, thumbRadius, thumbPaint);

    // Inner white highlight bead
    final highlightPaint = Paint()..color = Colors.white;
    canvas.drawCircle(center - const Offset(0, 2.5), thumbRadius * 0.35, highlightPaint);
  }
}

/// 3D Mini Clay Stepper Button
class MiniClayStepButton extends StatelessWidget {
  const MiniClayStepButton({super.key, required this.icon, required this.onTap});

  final String icon;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
        decoration: BoxDecoration(
          color: const Color(0xFFF6F3ED),
          borderRadius: BorderRadius.circular(12),
          border: Border.all(color: const Color(0xFFEDE9E1), width: 1.2),
          boxShadow: const [
            BoxShadow(color: Color(0xFFDDD8CE), offset: Offset(0, 2)),
          ],
        ),
        child: Text(
          icon,
          style: const TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.w800,
            color: AppColors.onSurface,
          ),
        ),
      ),
    );
  }
}

