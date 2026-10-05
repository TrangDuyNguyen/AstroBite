import 'package:flutter/material.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Waveform visualizer with 5 pulsating bars simulating real-time audio dynamics.
class WaveformVisualizer extends StatefulWidget {
  const WaveformVisualizer({
    super.key,
    this.soundLevel = 0.5,
    this.isListening = true,
  });

  final double soundLevel;
  final bool isListening;

  @override
  State<WaveformVisualizer> createState() => _WaveformVisualizerState();
}

class _WaveformVisualizerState extends State<WaveformVisualizer>
    with SingleTickerProviderStateMixin {
  late AnimationController _animCtrl;

  @override
  void initState() {
    super.initState();
    _animCtrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 600),
    )..repeat(reverse: true);
  }

  @override
  void dispose() {
    _animCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!widget.isListening) {
      return const SizedBox(height: 48);
    }

    return AnimatedBuilder(
      animation: _animCtrl,
      builder: (context, child) {
        final progress = _animCtrl.value;
        final baseLevel = widget.soundLevel.clamp(0.2, 1.0);

        final heights = [
          14.0 + (progress * 18.0 * baseLevel),
          22.0 + ((1.0 - progress) * 26.0 * baseLevel),
          30.0 + (progress * 22.0 * baseLevel),
          18.0 + ((1.0 - progress) * 28.0 * baseLevel),
          12.0 + (progress * 16.0 * baseLevel),
        ];

        return Row(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: List.generate(5, (index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 4),
              width: 6,
              height: heights[index],
              decoration: BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.circular(3),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.primary.withValues(alpha: 0.35),
                    blurRadius: 6,
                    offset: const Offset(0, 2),
                  ),
                ],
              ),
            );
          }),
        );
      },
    );
  }
}
