import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../../domain/entities/recipe.dart';
import '../controllers/recipe_builder_controller.dart';

@RoutePage()
class RecipesPage extends ConsumerStatefulWidget {
  const RecipesPage({super.key});

  @override
  ConsumerState<RecipesPage> createState() => _RecipesPageState();
}

class _RecipesPageState extends ConsumerState<RecipesPage> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final userId = user?.uid ?? '';
    final recipesAsync = ref.watch(recipesProvider(userId));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        elevation: 0,
        centerTitle: false,
        title: Row(
          children: [
            const Clay3DCookbook(size: 28),
            const SizedBox(width: 10),
            Text(
              'Công Thức Của Tôi',
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                    letterSpacing: -0.3,
                  ),
            ),
            recipesAsync.maybeWhen(
              data: (recipes) => recipes.isNotEmpty
                  ? Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 2.5,
                        ),
                        decoration: BoxDecoration(
                          color: const Color(0xFFE5F6FD),
                          borderRadius: BorderRadius.circular(12),
                          border: Border.all(
                            color: const Color(0xFF90D5F7),
                            width: 1.0,
                          ),
                          boxShadow: const [
                            BoxShadow(
                              color: Color(0xFFBCE3F7),
                              offset: Offset(0, 1.5),
                              blurRadius: 0,
                            ),
                          ],
                        ),
                        child: Text(
                          '${recipes.length}',
                          style: const TextStyle(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w800,
                            fontSize: 11,
                          ),
                        ),
                      ),
                    )
                  : const SizedBox.shrink(),
              orElse: () => const SizedBox.shrink(),
            ),
          ],
        ),
      ),
      floatingActionButton: _ChunkyRecipeFab(
        onTap: () => context.router.push(const RecipeBuilderRoute()),
      ),
      body: recipesAsync.when(
        loading: () => const _RecipesLoading(),
        error: (e, _) => _ErrorState(message: e.toString()),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const _EmptyState();
          }

          final filteredRecipes = _searchQuery.isEmpty
              ? recipes
              : recipes
                  .where((r) =>
                      r.name.toLowerCase().contains(_searchQuery.toLowerCase()) ||
                      (r.description?.toLowerCase().contains(_searchQuery.toLowerCase()) ?? false))
                  .toList();

          return Column(
            children: [
              // Search bar
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  AppValues.screenPadding,
                  AppValues.spacing8,
                  AppValues.screenPadding,
                  AppValues.spacing12,
                ),
                child: ClaySearchBar(
                  hintText: 'Tìm kiếm công thức món...',
                  onChanged: (val) => setState(() => _searchQuery = val.trim()),
                ),
              ),

              // Filtered list
              Expanded(
                child: filteredRecipes.isEmpty
                    ? Center(
                        child: Text(
                          'Không tìm thấy công thức phù hợp',
                          style: TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontSize: 14,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      )
                    : _RecipesList(recipes: filteredRecipes),
              ),
            ],
          );
        },
      ),
    );
  }
}

// ── Hero Floating Action Button ───────────────────────────────────────────────

class _ChunkyRecipeFab extends StatefulWidget {
  const _ChunkyRecipeFab({required this.onTap});

  final VoidCallback onTap;

  @override
  State<_ChunkyRecipeFab> createState() => _ChunkyRecipeFabState();
}

class _ChunkyRecipeFabState extends State<_ChunkyRecipeFab> {
  bool _isPressed = false;

  @override
  Widget build(BuildContext context) {
    return Semantics(
      button: true,
      label: 'Tạo Công Thức',
      child: GestureDetector(
        onTapDown: (_) => setState(() => _isPressed = true),
        onTapUp: (_) {
          setState(() => _isPressed = false);
          widget.onTap();
        },
        onTapCancel: () => setState(() => _isPressed = false),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 120),
          curve: Curves.easeOutCubic,
          transform: Matrix4.identity()
            ..translate(0.0, _isPressed ? 2.5 : 0.0)
            ..scale(_isPressed ? 0.96 : 1.0),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 13),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF38BDF8),
                Color(0xFF1CB0F6),
                Color(0xFF0284C7),
              ],
            ),
            borderRadius: BorderRadius.circular(28),
            border: Border.all(
              color: const Color(0xFF1488C2),
              width: 1.5,
            ),
            boxShadow: [
              // 3D bottom bevel
              BoxShadow(
                color: const Color(0xFF0F74A8),
                offset: Offset(0, _isPressed ? 1.5 : 4.0),
                blurRadius: 0,
              ),
              // Blue ambient glow
              const BoxShadow(
                color: Color(0x351CB0F6),
                offset: Offset(0, 6),
                blurRadius: 12,
              ),
            ],
          ),
          child: const Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.add_rounded, color: Colors.white, size: 22),
              SizedBox(width: 6),
              Text(
                'Tạo Công Thức',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w800,
                  fontSize: 14.5,
                  letterSpacing: -0.2,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Recipes list ──────────────────────────────────────────────────────────────

class _RecipesList extends StatelessWidget {
  const _RecipesList({required this.recipes});

  final List<Recipe> recipes;

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.fromLTRB(
        AppValues.screenPadding,
        AppValues.spacing4,
        AppValues.screenPadding,
        100, // Extra padding for FAB
      ),
      itemCount: recipes.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppValues.spacing12),
      itemBuilder: (_, i) => _RecipeCard(
        recipe: recipes[i],
        index: i,
      ),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({
    required this.recipe,
    required this.index,
  });

  final Recipe recipe;
  final int index;

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
      onTap: () {
        // Future: Open recipe details
      },
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

// ── Loading skeleton ──────────────────────────────────────────────────────────

class _RecipesLoading extends StatelessWidget {
  const _RecipesLoading();

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      padding: const EdgeInsets.all(AppValues.screenPadding),
      itemCount: 5,
      separatorBuilder: (_, __) => const SizedBox(height: AppValues.spacing12),
      itemBuilder: (_, __) => const ClaySkeletonLoader(
        height: 100,
        borderRadius: 20,
      ),
    );
  }
}

// ── Empty / Error ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding * 1.5),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Clay3DCookbook(size: 72),
            const SizedBox(height: AppValues.spacing20),
            Text(
              'Chưa có công thức nào',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    color: AppColors.onSurface,
                    fontWeight: FontWeight.w800,
                    fontSize: 18,
                  ),
            ),
            const SizedBox(height: AppValues.spacing8),
            Text(
              'Sáng tạo và lưu lại các món ăn yêu thích với đầy đủ tính toán Calories & Macros chuẩn xác.\nNhấn nút bên dưới để bắt đầu!',
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.onSurfaceVariant,
                    fontSize: 13.5,
                    height: 1.5,
                  ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppValues.screenPadding),
        child: Text(
          'Lỗi tải công thức: $message',
          style: const TextStyle(
            color: AppColors.error,
            fontWeight: FontWeight.w600,
          ),
          textAlign: TextAlign.center,
        ),
      ),
    );
  }
}
