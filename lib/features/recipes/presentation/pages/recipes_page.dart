import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:astrobite/core/router/app_router.dart';
import 'package:astrobite/features/auth/domain/auth_providers.dart';
import 'package:astrobite/shared/ui_kit/ui_kit.dart';
import '../controllers/recipe_builder_controller.dart';
import '../widgets/recipe_card_tile.dart';
import '../widgets/recipe_chunky_fab.dart';
import '../widgets/recipes_empty_state.dart';

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
      floatingActionButton: RecipeChunkyFab(
        onTap: () => context.router.push(const RecipeBuilderRoute()),
      ),
      body: recipesAsync.when(
        loading: () => const RecipesLoadingView(),
        error: (e, _) => RecipesErrorStateView(message: e.toString()),
        data: (recipes) {
          if (recipes.isEmpty) {
            return const RecipesEmptyStateView();
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
                    : ListView.separated(
                        padding: const EdgeInsets.fromLTRB(
                          AppValues.screenPadding,
                          AppValues.spacing4,
                          AppValues.screenPadding,
                          100, // Extra padding for FAB
                        ),
                        itemCount: filteredRecipes.length,
                        separatorBuilder: (_, __) =>
                            const SizedBox(height: AppValues.spacing12),
                        itemBuilder: (_, i) => RecipeCardTile(
                          recipe: filteredRecipes[i],
                          index: i,
                        ),
                      ),
              ),
            ],
          );
        },
      ),
    );
  }
}
