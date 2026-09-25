// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'meal_plan_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_MealPlanItem _$MealPlanItemFromJson(Map<String, dynamic> json) =>
    _MealPlanItem(
      id: json['id'] as String,
      userId: json['userId'] as String,
      date: json['date'] as String,
      mealType: json['mealType'] as String,
      recipeId: json['recipeId'] as String?,
      foodName: json['foodName'] as String,
      calories: (json['calories'] as num).toDouble(),
      carbs: (json['carbs'] as num).toDouble(),
      protein: (json['protein'] as num).toDouble(),
      fat: (json['fat'] as num).toDouble(),
      isLogged: json['isLogged'] as bool? ?? false,
    );

Map<String, dynamic> _$MealPlanItemToJson(_MealPlanItem instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'date': instance.date,
      'mealType': instance.mealType,
      'recipeId': instance.recipeId,
      'foodName': instance.foodName,
      'calories': instance.calories,
      'carbs': instance.carbs,
      'protein': instance.protein,
      'fat': instance.fat,
      'isLogged': instance.isLogged,
    };
