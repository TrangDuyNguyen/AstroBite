import 'package:flutter/material.dart';
import 'clay_3d_food_art.dart';
import 'splash_constellation_specs.dart';

/// Standalone 3D clay food sculpture with a soft glowing celestial nebula aura.
class SplashFloatingFoodItem extends StatelessWidget {
  const SplashFloatingFoodItem({
    super.key,
    required this.spec,
  });

  final SplashFoodItemSpec spec;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        // Soft Celestial Nebula Aura Glow
        Container(
          width: spec.size * 0.90,
          height: spec.size * 0.90,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: spec.auraColor,
                blurRadius: spec.size * 0.50,
                spreadRadius: 2.5,
              ),
            ],
          ),
        ),
        // 3D Sculpted Clay Food Art
        Clay3DFoodArt(
          foodType: spec.foodType,
          size: spec.size,
        ),
      ],
    );
  }
}
