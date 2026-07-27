import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';

/// A card with glassmorphism effect (backdrop blur + translucent background).
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppValues.cardPadding),
    this.borderRadius = AppValues.cardRadius,
    this.blurSigma = 20,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double blurSigma;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(borderRadius),
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: blurSigma,
          sigmaY: blurSigma,
        ),
        child: Container(
          padding: padding,
          decoration: BoxDecoration(
            color: AppColors.surfaceBlur,
            borderRadius: BorderRadius.circular(borderRadius),
            border: Border.all(
              color: AppColors.outline.withValues(alpha: 0.3),
              width: 1,
            ),
          ),
          child: child,
        ),
      ),
    );
  }
}
