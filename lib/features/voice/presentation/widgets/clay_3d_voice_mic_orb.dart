import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'clay_3d_mic_fallback_painter.dart';

/// Next-Gen 3D Claymorphic Microphone Orb with reactive sound wave radar animation.
///
/// Features:
/// 1. Generated 3D Clay Microphone asset (no emojis).
/// 2. Multi-layer pulsating sound wave rings expanding outward.
/// 3. Voice volume sensitivity: responds dynamically to [soundLevel] (0.0 to 1.0).
/// 4. Gentle floating / breathing animation.
/// 5. Tactile tap to stop listening and parse.
class Clay3DVoiceMicOrb extends StatefulWidget {
  const Clay3DVoiceMicOrb({
    super.key,
    required this.isListening,
    required this.soundLevel,
    required this.onTap,
    this.isParsing = false,
  });

  final bool isListening;
  final double soundLevel;
  final VoidCallback onTap;
  final bool isParsing;

  @override
  State<Clay3DVoiceMicOrb> createState() => _Clay3DVoiceMicOrbState();
}

class _Clay3DVoiceMicOrbState extends State<Clay3DVoiceMicOrb>
    with TickerProviderStateMixin {
  late final AnimationController _pulseController;
  late final AnimationController _hoverController;

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2200),
    )..repeat();

    _hoverController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 3000),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _hoverController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // Dynamic scale booster based on live sound level (0.0 -> 1.0)
    final soundBoost = (widget.soundLevel.clamp(0.0, 1.0)) * 0.18;

    return Center(
      child: AnimatedBuilder(
        animation: Listenable.merge([_pulseController, _hoverController]),
        builder: (context, _) {
          final pulse = _pulseController.value;
          final hoverOffset = math.sin(_hoverController.value * math.pi) * 6.0;

          return SizedBox(
            width: 220,
            height: 220,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Layer 1: Ambient soft glowing halo
                Container(
                  width: 140 + (soundBoost * 120),
                  height: 140 + (soundBoost * 120),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.primary.withValues(
                          alpha: widget.isListening ? 0.35 : 0.15,
                        ),
                        blurRadius: 36,
                        spreadRadius: 8 + (soundBoost * 20),
                      ),
                      BoxShadow(
                        color: const Color(0xFF58CC02).withValues(
                          alpha: widget.isListening ? 0.20 : 0.05,
                        ),
                        blurRadius: 28,
                        spreadRadius: 4,
                      ),
                    ],
                  ),
                ),

                // Layer 2: Outer radar ripple 1 (expanding & fading)
                if (widget.isListening)
                  Transform.scale(
                    scale: 1.0 + (pulse * 0.65) + soundBoost,
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: AppColors.primary.withValues(
                            alpha: ((1.0 - pulse) * 0.55).clamp(0.0, 1.0),
                          ),
                          width: 2.5,
                        ),
                      ),
                    ),
                  ),

                // Layer 3: Outer radar ripple 2 (offset phase)
                if (widget.isListening)
                  Transform.scale(
                    scale: 1.0 + (((pulse + 0.5) % 1.0) * 0.55) + (soundBoost * 0.8),
                    child: Container(
                      width: 130,
                      height: 130,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: const Color(0xFF00E5FF).withValues(
                            alpha: ((1.0 - ((pulse + 0.5) % 1.0)) * 0.45).clamp(0.0, 1.0),
                          ),
                          width: 2.0,
                        ),
                      ),
                    ),
                  ),

                // Layer 4: Voice reactive energy glow ring
                Transform.scale(
                  scale: 1.0 + soundBoost,
                  child: Container(
                    width: 124,
                    height: 124,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: RadialGradient(
                        colors: [
                          const Color(0xFFE5F6FD),
                          AppColors.primary.withValues(alpha: 0.15),
                        ],
                      ),
                      border: Border.all(
                        color: AppColors.primary.withValues(
                          alpha: widget.isListening ? 0.6 : 0.2,
                        ),
                        width: 2.0,
                      ),
                    ),
                  ),
                ),

                // Layer 5: Main 3D Floating Mic Avatar
                Transform.translate(
                  offset: Offset(0, -hoverOffset),
                  child: Transform.scale(
                    scale: 1.0 + (soundBoost * 0.4),
                    child: GestureDetector(
                      onTap: () {
                        HapticFeedback.mediumImpact();
                        widget.onTap();
                      },
                      child: Container(
                        width: 104,
                        height: 104,
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white,
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0x261E2337),
                              blurRadius: 18,
                              offset: const Offset(0, 8),
                            ),
                            BoxShadow(
                              color: AppColors.primary.withValues(alpha: 0.25),
                              blurRadius: 12,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: ClipOval(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Image.asset(
                              'assets/images/clay_3d_mic.png',
                              fit: BoxFit.contain,
                              errorBuilder: (context, error, stackTrace) {
                                // High-fidelity procedural 3D clay mic fallback (Zero flat emojis)
                                return const CustomPaint(
                                  size: Size(80, 80),
                                  painter: Clay3DMicFallbackPainter(),
                                );
                              },
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),

                // Layer 6: Voice Listening Pulse Tag
                Positioned(
                  bottom: 6,
                  child: Container(
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 5),
                    decoration: BoxDecoration(
                      color: widget.isListening
                          ? const Color(0xFFE8F9D8) // clayMint
                          : AppColors.surfaceContainer,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: widget.isListening
                            ? AppColors.brandGreen.withValues(alpha: 0.6)
                            : AppColors.outline,
                        width: 1.2,
                      ),
                      boxShadow: const [
                        BoxShadow(
                          color: Color(0x101E2337),
                          blurRadius: 8,
                          offset: Offset(0, 2),
                        ),
                      ],
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Container(
                          width: 8,
                          height: 8,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: widget.isListening
                                ? AppColors.brandGreen
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                        const SizedBox(width: AppValues.spacing8),
                        Text(
                          widget.isParsing
                              ? 'Đang phân tích...'
                              : (widget.isListening
                                  ? 'Đang lắng nghe...'
                                  : 'Chạm để nói'),
                          style: GoogleFonts.outfit(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: widget.isListening
                                ? const Color(0xFF2E7D32)
                                : AppColors.onSurfaceVariant,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
