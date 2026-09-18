// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'scan_result_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_ScanResultDto _$ScanResultDtoFromJson(Map<String, dynamic> json) =>
    _ScanResultDto(
      isFood: json['is_food'] as bool,
      totalCalories: (json['total_calories'] as num).toInt(),
      macros: MacroDto.fromJson(json['macros'] as Map<String, dynamic>),
      dishes: (json['dishes'] as List<dynamic>)
          .map((e) => DishDto.fromJson(e as Map<String, dynamic>))
          .toList(),
      sodiumMg: (json['sodium_mg'] as num?)?.toDouble() ?? 0.0,
      fiberG: (json['fiber_g'] as num?)?.toDouble() ?? 0.0,
      sugarG: (json['sugar_g'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$ScanResultDtoToJson(_ScanResultDto instance) =>
    <String, dynamic>{
      'is_food': instance.isFood,
      'total_calories': instance.totalCalories,
      'macros': instance.macros,
      'dishes': instance.dishes,
      'sodium_mg': instance.sodiumMg,
      'fiber_g': instance.fiberG,
      'sugar_g': instance.sugarG,
    };

_MacroDto _$MacroDtoFromJson(Map<String, dynamic> json) => _MacroDto(
      proteinG: (json['protein_g'] as num).toInt(),
      carbsG: (json['carbs_g'] as num).toInt(),
      fatG: (json['fat_g'] as num).toInt(),
    );

Map<String, dynamic> _$MacroDtoToJson(_MacroDto instance) => <String, dynamic>{
      'protein_g': instance.proteinG,
      'carbs_g': instance.carbsG,
      'fat_g': instance.fatG,
    };

_DishDto _$DishDtoFromJson(Map<String, dynamic> json) => _DishDto(
      dishName: json['dish_name'] as String,
      confidenceScore: (json['confidence_score'] as num).toDouble(),
      estimatedWeightG: (json['estimated_weight_g'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      carbsG: (json['carbs_g'] as num?)?.toInt() ?? 0,
      proteinG: (json['protein_g'] as num?)?.toInt() ?? 0,
      fatG: (json['fat_g'] as num?)?.toInt() ?? 0,
      sodiumMg: (json['sodium_mg'] as num?)?.toDouble() ?? 0.0,
      fiberG: (json['fiber_g'] as num?)?.toDouble() ?? 0.0,
      sugarG: (json['sugar_g'] as num?)?.toDouble() ?? 0.0,
    );

Map<String, dynamic> _$DishDtoToJson(_DishDto instance) => <String, dynamic>{
      'dish_name': instance.dishName,
      'confidence_score': instance.confidenceScore,
      'estimated_weight_g': instance.estimatedWeightG,
      'calories': instance.calories,
      'carbs_g': instance.carbsG,
      'protein_g': instance.proteinG,
      'fat_g': instance.fatG,
      'sodium_mg': instance.sodiumMg,
      'fiber_g': instance.fiberG,
      'sugar_g': instance.sugarG,
    };
