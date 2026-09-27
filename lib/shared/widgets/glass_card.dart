import 'package:flutter/material.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/shared/ui_kit/surfaces/clay_card.dart';

/// Legacy card migrated to Claymorphic surface.
/// // ponytail: legacy GlassCard migrated to ClayCard for 0 GPU strain & Claymorphic aesthetics
class GlassCard extends StatelessWidget {
  const GlassCard({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppValues.cardPadding),
    this.borderRadius = AppValues.cardRadius,
    this.blurSigma = 20,
    this.borderColor,
  });

  final Widget child;
  final EdgeInsets padding;
  final double borderRadius;
  final double blurSigma;
  final Color? borderColor;

  @override
  Widget build(BuildContext context) {
    return ClayCard(
      padding: padding,
      borderRadius: borderRadius,
      borderColor: borderColor,
      child: child,
    );
  }
}
