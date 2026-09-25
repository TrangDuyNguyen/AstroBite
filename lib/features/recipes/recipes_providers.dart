import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'data/repositories/recipe_repository_impl.dart';
import 'data/repositories/meal_plan_repository_impl.dart';
import 'domain/repositories/recipe_repository.dart';
import 'domain/repositories/meal_plan_repository.dart';

/// Provides the [RecipeRepository] singleton.
final recipeRepositoryProvider = Provider<RecipeRepository>(
  (_) => RecipeRepositoryImpl(),
);

/// Provides the [MealPlanRepository] singleton.
final mealPlanRepositoryProvider = Provider<MealPlanRepository>(
  (_) => MealPlanRepositoryImpl(),
);
