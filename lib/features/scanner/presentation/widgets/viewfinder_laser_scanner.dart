import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';

/// Animated glowing laser scanner line traversing the viewfinder vertically.
class ViewfinderLaserScannerLine extends StatelessWidget {
  const ViewfinderLaserScannerLine({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        // Laser glow gradient banner
        Container(
          height: 14,
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                AppColors.primary.withValues(alpha: 0.0),
                AppColors.primary.withValues(alpha: 0.18),
              ],
            ),
          ),
        ),
        // Intense bright center line
        Container(
          height: 2.2,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(2),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary,
                blurRadius: 8,
                spreadRadius: 1,
              ),
              const BoxShadow(
                color: Colors.white,
                blurRadius: 4,
              ),
            ],
          ),
        ),
      ],
    );
  }
}
