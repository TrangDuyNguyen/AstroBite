import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/recipe.dart';
import '../../domain/entities/recipe_ingredient.dart';
import '../../domain/repositories/recipe_repository.dart';

/// Firestore implementation of [RecipeRepository].
/// Collection path: `users/{userId}/recipes`
class RecipeRepositoryImpl implements RecipeRepository {
  RecipeRepositoryImpl({FirebaseFirestore? firestore})
      : _db = firestore ?? FirebaseFirestore.instance;

  final FirebaseFirestore _db;

  CollectionReference<Map<String, dynamic>> _col(String userId) =>
      _db.collection('users').doc(userId).collection('recipes');

  @override
  Future<List<Recipe>> getRecipes(String userId) async {
    if (userId.trim().isEmpty) return [];
    try {
      final snap = await _col(userId)
          .orderBy('createdAt', descending: true)
          .get();
      return snap.docs.map((d) => _fromDoc(d.id, d.data())).toList();
    } catch (_) {
      return [];
    }
  }

  @override
  Future<Recipe> saveRecipe(Recipe recipe) async {
    final effectiveUserId = recipe.userId.isNotEmpty ? recipe.userId : 'guest_user';
    final data = _toMap(recipe.copyWith(userId: effectiveUserId));
    if (recipe.id.isEmpty) {
      final ref = await _col(effectiveUserId).add(data);
      return recipe.copyWith(id: ref.id, userId: effectiveUserId);
    } else {
      await _col(effectiveUserId).doc(recipe.id).set(data, SetOptions(merge: true));
      return recipe;
    }
  }

  Future<void> deleteRecipeForUser(String userId, String recipeId) =>
      _col(userId).doc(recipeId).delete();

  // ── Mapping helpers ────────────────────────────────────────────────────────

  Recipe _fromDoc(String id, Map<String, dynamic> d) {
    return Recipe(
      id: id,
      userId: d['userId'] as String,
      name: d['name'] as String,
      description: d['description'] as String?,
      servings: (d['servings'] as int?) ?? 1,
      ingredients: (d['ingredients'] as List<dynamic>)
          .map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (d['totalCalories'] as num).toDouble(),
      totalCarbs: (d['totalCarbs'] as num).toDouble(),
      totalProtein: (d['totalProtein'] as num).toDouble(),
      totalFat: (d['totalFat'] as num).toDouble(),
      createdAt: (d['createdAt'] as Timestamp).toDate(),
      updatedAt: (d['updatedAt'] as Timestamp).toDate(),
    );
  }

  Map<String, dynamic> _toMap(Recipe r) => {
        'userId': r.userId,
        'name': r.name,
        if (r.description != null) 'description': r.description,
        'servings': r.servings,
        'ingredients': r.ingredients.map((i) => i.toJson()).toList(),
        'totalCalories': r.totalCalories,
        'totalCarbs': r.totalCarbs,
        'totalProtein': r.totalProtein,
        'totalFat': r.totalFat,
        'createdAt': r.createdAt,
        'updatedAt': r.updatedAt,
      };
}
