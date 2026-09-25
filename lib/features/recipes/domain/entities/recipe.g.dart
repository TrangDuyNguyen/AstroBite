// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'recipe.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_Recipe _$RecipeFromJson(Map<String, dynamic> json) => _Recipe(
      id: json['id'] as String,
      userId: json['userId'] as String,
      name: json['name'] as String,
      description: json['description'] as String?,
      servings: (json['servings'] as num?)?.toInt() ?? 1,
      ingredients: (json['ingredients'] as List<dynamic>)
          .map((e) => RecipeIngredient.fromJson(e as Map<String, dynamic>))
          .toList(),
      totalCalories: (json['totalCalories'] as num).toDouble(),
      totalCarbs: (json['totalCarbs'] as num).toDouble(),
      totalProtein: (json['totalProtein'] as num).toDouble(),
      totalFat: (json['totalFat'] as num).toDouble(),
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: DateTime.parse(json['updatedAt'] as String),
    );

Map<String, dynamic> _$RecipeToJson(_Recipe instance) => <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'name': instance.name,
      'description': instance.description,
      'servings': instance.servings,
      'ingredients': instance.ingredients.map((e) => e.toJson()).toList(),
      'totalCalories': instance.totalCalories,
      'totalCarbs': instance.totalCarbs,
      'totalProtein': instance.totalProtein,
      'totalFat': instance.totalFat,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt.toIso8601String(),
    };
