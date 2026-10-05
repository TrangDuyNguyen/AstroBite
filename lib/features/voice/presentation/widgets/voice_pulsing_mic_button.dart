import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Floating circular microphone button with pulsating radar ripples.
class VoicePulsingMicButton extends StatefulWidget {
  const VoicePulsingMicButton({
    super.key,
    required this.onTap,
    this.size = 56.0,
  });

  final VoidCallback onTap;
  final double size;

  @override
  State<VoicePulsingMicButton> createState() => _VoicePulsingMicButtonState();
}

class _VoicePulsingMicButtonState extends State<VoicePulsingMicButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _pulseCtrl;

  @override
  void initState() {
    super.initState();
    _pulseCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 2000),
    )..repeat();
  }

  @override
  void dispose() {
    _pulseCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _pulseCtrl,
      builder: (context, child) {
        final progress = _pulseCtrl.value;

        return SizedBox(
          width: widget.size + 24,
          height: widget.size + 24,
          child: Stack(
            alignment: Alignment.center,
            children: [
              // Outer ripple 1
              Container(
                width: widget.size + (24 * progress),
                height: widget.size + (24 * progress),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(
                    alpha: (0.35 * (1.0 - progress)).clamp(0.0, 1.0),
                  ),
                ),
              ),
              // Outer ripple 2
              Container(
                width: widget.size + (12 * progress),
                height: widget.size + (12 * progress),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary.withValues(
                    alpha: (0.45 * (1.0 - progress)).clamp(0.0, 1.0),
                  ),
                ),
              ),
              // Main button
              child!,
            ],
          ),
        );
      },
      child: GestureDetector(
        key: const Key('voice_pulsing_mic_button'),
        onTap: () {
          HapticFeedback.mediumImpact();
          widget.onTap();
        },
        child: Container(
          width: widget.size,
          height: widget.size,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            gradient: const LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                Color(0xFF1CB0F6),
                Color(0xFF0288D1),
              ],
            ),
            boxShadow: [
              BoxShadow(
                color: const Color(0xFF01579B).withValues(alpha: 0.4),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Center(
            child: Icon(
              Icons.mic_rounded,
              color: Colors.white,
              size: 28,
            ),
          ),
        ),
      ),
    );
  }
}
