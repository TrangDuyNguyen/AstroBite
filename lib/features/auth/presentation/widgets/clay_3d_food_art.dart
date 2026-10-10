import 'package:flutter/material.dart';
import 'clay_3d_fruits_pastry_painters.dart';
import 'clay_3d_meals_drinks_painters.dart';

/// Enum specifying the 3D clay-sculpted food or fruit item to render.
enum Clay3DFoodType {
  apple,
  avocado,
  croissant,
  pizza,
  iceCream,
  sunnyEgg,
  cookie,
  ramen,
  coffee,
  cosmicStar,
}

/// A tactile, custom-drawn 3D claymorphic food/fruit illustration widget.
///
/// Instead of flat font icons, this widget paints high-fidelity, volumetric,
/// toy-like 3D clay food elements complete with radial gradient shading,
/// bottom clay bevels, multi-component clay parts, and glossy specular highlights.
class Clay3DFoodArt extends StatelessWidget {
  const Clay3DFoodArt({
    super.key,
    required this.foodType,
    this.size = 28,
  });

  final Clay3DFoodType foodType;
  final double size;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: size,
      height: size,
      child: CustomPaint(
        size: Size(size, size),
        painter: _Clay3DFoodPainter(foodType: foodType),
      ),
    );
  }
}

class _Clay3DFoodPainter extends CustomPainter {
  const _Clay3DFoodPainter({required this.foodType});

  final Clay3DFoodType foodType;

  @override
  void paint(Canvas canvas, Size size) {
    final w = size.width;
    final h = size.height;

    switch (foodType) {
      case Clay3DFoodType.apple:
        Clay3DFruitsPastryPainters.drawApple(canvas, w, h);
      case Clay3DFoodType.avocado:
        Clay3DFruitsPastryPainters.drawAvocado(canvas, w, h);
      case Clay3DFoodType.croissant:
        Clay3DFruitsPastryPainters.drawCroissant(canvas, w, h);
      case Clay3DFoodType.pizza:
        Clay3DFruitsPastryPainters.drawPizza(canvas, w, h);
      case Clay3DFoodType.iceCream:
        Clay3DFruitsPastryPainters.drawIceCream(canvas, w, h);
      case Clay3DFoodType.sunnyEgg:
        Clay3DMealsDrinksPainters.drawSunnyEgg(canvas, w, h);
      case Clay3DFoodType.cookie:
        Clay3DMealsDrinksPainters.drawCookie(canvas, w, h);
      case Clay3DFoodType.ramen:
        Clay3DMealsDrinksPainters.drawRamen(canvas, w, h);
      case Clay3DFoodType.coffee:
        Clay3DMealsDrinksPainters.drawCoffee(canvas, w, h);
      case Clay3DFoodType.cosmicStar:
        Clay3DMealsDrinksPainters.drawCosmicStar(canvas, w, h);
    }
  }

  @override
  bool shouldRepaint(covariant _Clay3DFoodPainter oldDelegate) {
    return oldDelegate.foodType != foodType;
  }
}
