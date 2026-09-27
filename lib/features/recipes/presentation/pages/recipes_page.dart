import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/constants/app_values.dart';
import 'package:astrobite/core/theme/app_colors.dart';
import 'package:astrobite/shared/widgets/glass_card.dart';
import 'package:astrobite/shared/widgets/skeleton_loader.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import '../../domain/entities/recipe.dart';
import '../controllers/recipe_builder_controller.dart';
import 'package:astrobite/core/router/app_router.dart';

@RoutePage()
class RecipesPage extends ConsumerWidget {
  const RecipesPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(authStateProvider).valueOrNull;
    final userId = user?.uid ?? '';
    final recipesAsync = ref.watch(recipesProvider(userId));

    return Scaffold(
      backgroundColor: AppColors.surface,
      appBar: AppBar(
        backgroundColor: AppColors.surface,
        surfaceTintColor: Colors.transparent,
        title: const Text('Công Thức Của Tôi'),
      ),
      floatingActionButton: FloatingActionButton.extended(
        heroTag: 'recipe_builder_fab',
        backgroundColor: AppColors.primary,
        shape: const StadiumBorder(),
        icon: const Icon(Icons.add, color: Colors.white),
        label: const Text(
          'Tạo Công Thức',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
        onPressed: () => context.router.push(const RecipeBuilderRoute()),
      ),
      body: recipesAsync.when(
        loading: () => const _RecipesLoading(),
        error: (e, _) => _ErrorState(message: e.toString()),
        data: (recipes) => recipes.isEmpty
            ? const _EmptyState()
            : _RecipesList(recipes: recipes),
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
      padding: const EdgeInsets.all(AppValues.screenPadding),
      itemCount: recipes.length,
      separatorBuilder: (_, __) => const SizedBox(height: AppValues.spacing12),
      itemBuilder: (_, i) => _RecipeCard(recipe: recipes[i]),
    );
  }
}

class _RecipeCard extends StatelessWidget {
  const _RecipeCard({required this.recipe});

  final Recipe recipe;

  @override
  Widget build(BuildContext context) {
    return GlassCard(
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  recipe.name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.onSurface,
                        fontWeight: FontWeight.w600,
                      ),
                ),
                if (recipe.description != null) ...[
                  const SizedBox(height: AppValues.spacing4),
                  Text(
                    recipe.description!,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: AppColors.onSurfaceVariant,
                        ),
                  ),
                ],
                const SizedBox(height: AppValues.spacing8),
                // Macro row
                Row(
                  children: [
                    _MacroBadge('${recipe.totalCalories.round()} kcal', AppColors.onSurfaceVariant),
                    const SizedBox(width: AppValues.spacing8),
                    _MacroBadge('C ${recipe.totalCarbs.round()}g', AppColors.carbs),
                    const SizedBox(width: AppValues.spacing4),
                    _MacroBadge('P ${recipe.totalProtein.round()}g', AppColors.protein),
                    const SizedBox(width: AppValues.spacing4),
                    _MacroBadge('F ${recipe.totalFat.round()}g', AppColors.fat),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(width: AppValues.spacing8),
          Text(
            '${recipe.ingredients.length} nguyên liệu',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: AppColors.onSurfaceVariant,
                ),
          ),
          const Icon(Icons.chevron_right, color: AppColors.onSurfaceVariant),
        ],
      ),
    );
  }
}

class _MacroBadge extends StatelessWidget {
  const _MacroBadge(this.text, this.color);

  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(color: color),
    );
  }
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
      itemBuilder: (_, __) => const SkeletonLoader(height: 80),
    );
  }
}

// ── Empty / Error ─────────────────────────────────────────────────────────────

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          const Icon(Icons.restaurant_menu, color: AppColors.onSurfaceVariant, size: 64),
          const SizedBox(height: AppValues.spacing16),
          Text(
            'Chưa có công thức nào.\nNhấn + để tạo công thức đầu tiên!',
            textAlign: TextAlign.center,
            style: Theme.of(context)
                .textTheme
                .bodyMedium
                ?.copyWith(color: AppColors.onSurfaceVariant),
          ),
        ],
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
      child: Text(
        'Lỗi tải công thức: $message',
        style: const TextStyle(color: AppColors.error),
      ),
    );
  }
}
