import 'dart:math' as math;
import 'package:flutter/material.dart';
import 'package:lottie/lottie.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// Typing indicator displaying astronaut lottie and bouncing macro dots.
class CoachTypingIndicator extends StatelessWidget {
  const CoachTypingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        margin: const EdgeInsets.only(bottom: 8),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        decoration: BoxDecoration(
          color: AppColors.surfaceContainer,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: AppColors.primary.withValues(alpha: 0.18)),
          boxShadow: [
            BoxShadow(
              color: AppColors.primary.withValues(alpha: 0.08),
              blurRadius: 12,
              offset: const Offset(0, 3),
            ),
          ],
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(
              width: 32,
              height: 32,
              child: Lottie.asset(
                'assets/animations/astronaut_thinking.json',
                fit: BoxFit.contain,
                errorBuilder: (context, error, stackTrace) => const Icon(
                  Icons.auto_awesome,
                  size: 16,
                  color: AppColors.primary,
                ),
              ),
            ),
            const SizedBox(width: 8),
            const Text(
              'AstroCoach đang phân tích...',
              style: TextStyle(
                fontSize: 12.5,
                fontWeight: FontWeight.w600,
                color: AppColors.onSurfaceVariant,
              ),
            ),
            const SizedBox(width: 6),
            const BouncingMacroDots(),
          ],
        ),
      ),
    );
  }
}

/// 3 Bouncing Macro Dots (Carbs, Protein, Fat)
class BouncingMacroDots extends StatefulWidget {
  const BouncingMacroDots({super.key});

  @override
  State<BouncingMacroDots> createState() => _BouncingMacroDotsState();
}

class _BouncingMacroDotsState extends State<BouncingMacroDots>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Widget _buildDot(int index, Color color) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        final delay = index * 0.2;
        final progress = (_controller.value + delay) % 1.0;
        final bounce = math.sin(progress * math.pi);
        final offsetY = -4.0 * bounce;
        final scale = 0.8 + 0.45 * bounce;

        return Transform.translate(
          offset: Offset(0, offsetY),
          child: Transform.scale(
            scale: scale,
            child: Container(
              width: 5.5,
              height: 5.5,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color: color.withValues(alpha: 0.45),
                    blurRadius: 3,
                    offset: const Offset(0, 1),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        _buildDot(0, AppColors.carbs),
        const SizedBox(width: 4),
        _buildDot(1, AppColors.protein),
        const SizedBox(width: 4),
        _buildDot(2, AppColors.fat),
      ],
    );
  }
}
