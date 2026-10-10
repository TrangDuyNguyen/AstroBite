import 'package:flutter/material.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/recipe.dart';

/// Claymorphic recipe card tile with food badge, meta tags, and macro breakdown gems.
class RecipeCardTile extends StatelessWidget {
  const RecipeCardTile({
    super.key,
    required this.recipe,
    required this.index,
    this.onTap,
  });

  final Recipe recipe;
  final int index;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    // Pastel tint cycle for food badge
    final pastelTints = [
      const _BadgeTheme(Color(0xFFFFF2D6), Color(0xFFF7DEB0), Color(0xFFFF9600), Icons.restaurant_rounded),
      const _BadgeTheme(Color(0xFFE5F6FD), Color(0xFFBCE3F7), Color(0xFF1CB0F6), Icons.soup_kitchen_rounded),
      const _BadgeTheme(Color(0xFFE8F9D8), Color(0xFFC7F0A0), Color(0xFF58CC02), Icons.eco_rounded),
      const _BadgeTheme(Color(0xFFFFE8EE), Color(0xFFFAC4D2), Color(0xFFFF5C8D), Icons.local_dining_rounded),
      const _BadgeTheme(Color(0xFFF0E8FF), Color(0xFFDCC8FF), Color(0xFF8B5CF6), Icons.set_meal_rounded),
    ];
    final theme = pastelTints[index % pastelTints.length];

    return ClayCard(
      elevation: 3.5,
      borderRadius: 20.0,
      padding: const EdgeInsets.all(14.0),
      onTap: onTap,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // 1. Food Dish 3D Emblem Badge
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: theme.bg,
              borderRadius: BorderRadius.circular(16),
              border: Border.all(
                color: theme.bevel.withValues(alpha: 0.6),
                width: 1.2,
              ),
              boxShadow: [
                BoxShadow(
                  color: theme.bevel,
                  offset: const Offset(0, 2.5),
                  blurRadius: 0,
                ),
              ],
            ),
            alignment: Alignment.center,
            child: Stack(
              alignment: Alignment.center,
              children: [
                // Top inner highlight reflection
                Positioned(
                  top: 2,
                  child: Container(
                    width: 28,
                    height: 10,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.white.withValues(alpha: 0.8),
                          Colors.white.withValues(alpha: 0.0),
                        ],
                      ),
                    ),
                  ),
                ),
                Icon(
                  theme.icon,
                  size: 24,
                  color: theme.iconColor,
                ),
              ],
            ),
          ),
          const SizedBox(width: AppValues.spacing12),

          // 2. Recipe Info & Macros
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Recipe Name
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w800,
                        fontSize: 15,
                        letterSpacing: -0.2,
                      ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),

                if (recipe.description != null && recipe.description!.isNotEmpty) ...[
                  const SizedBox(height: 2),
                  Text(
                    recipe.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                          fontSize: 12,
                        ),
                  ),
                ],
                const SizedBox(height: 6),

                // Servings & Ingredients Meta Tags
                Row(
                  children: [
                    _MetaTag(
                      icon: Icons.people_outline_rounded,
                      label: '${recipe.servings} phần',
                    ),
                    const SizedBox(width: 6),
                    _MetaTag(
                      icon: Icons.kitchen_rounded,
                      label: '${recipe.ingredients.length} nguyên liệu',
                    ),
                  ],
                ),
                const SizedBox(height: 8),

                // Macro Gem Dots & Calories Row
                Row(
                  children: [
                    // Calorie pill
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F6F2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: const Color(0xFFEDE8DD),
                          width: 1.0,
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Color(0xFFDDD8CE),
                            offset: Offset(0, 1.2),
                            blurRadius: 0,
                          ),
                        ],
                      ),
                      child: Text(
                        '${recipe.totalCalories.round()} kcal',
                        style: const TextStyle(
                          color: AppColors.onSurface,
                          fontWeight: FontWeight.w800,
                          fontSize: 11.5,
                        ),
                      ),
                    ),
                    const SizedBox(width: 8),

                    // Macro Gems
                    _MiniMacroDot(
                      color: AppColors.carbs,
                      label: '${recipe.totalCarbs.round()}g C',
                    ),
                    const SizedBox(width: 6),
                    _MiniMacroDot(
                      color: AppColors.protein,
                      label: '${recipe.totalProtein.round()}g P',
                    ),
                    const SizedBox(width: 6),
                    _MiniMacroDot(
                      color: AppColors.fat,
                      label: '${recipe.totalFat.round()}g F',
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: 6),

          // 3. Tactile 3D Circular Chevron Button
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              color: const Color(0xFFF8F6F2),
              border: Border.all(
                color: const Color(0xFFEDE8DD),
                width: 1.2,
              ),
              boxShadow: const [
                BoxShadow(
                  color: Color(0xFFDDD8CE),
                  offset: Offset(0, 1.5),
                  blurRadius: 0,
                ),
              ],
            ),
            child: const Icon(
              Icons.chevron_right_rounded,
              size: 18,
              color: Color(0xFF78829A),
            ),
          ),
        ],
      ),
    );
  }
}

class _MetaTag extends StatelessWidget {
  const _MetaTag({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 5, vertical: 2),
      decoration: BoxDecoration(
        color: const Color(0xFFFAF8F5),
        borderRadius: BorderRadius.circular(6),
        border: Border.all(
          color: const Color(0xFFE8E5DF),
          width: 0.8,
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 11, color: AppColors.onSurfaceVariant),
          const SizedBox(width: 3),
          Text(
            label,
            style: const TextStyle(
              fontSize: 10,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}

class _MiniMacroDot extends StatelessWidget {
  const _MiniMacroDot({
    required this.color,
    required this.label,
  });

  final Color color;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 6.5,
          height: 6.5,
          decoration: BoxDecoration(
            color: color,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: 0.4),
                offset: const Offset(0, 1),
                blurRadius: 1,
              ),
            ],
          ),
        ),
        const SizedBox(width: 3),
        Text(
          label,
          style: TextStyle(
            fontSize: 10.5,
            fontWeight: FontWeight.w700,
            color: color,
          ),
        ),
      ],
    );
  }
}

class _BadgeTheme {
  const _BadgeTheme(this.bg, this.bevel, this.iconColor, this.icon);

  final Color bg;
  final Color bevel;
  final Color iconColor;
  final IconData icon;
}
