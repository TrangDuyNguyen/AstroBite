// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'food_log_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_FoodLogDto _$FoodLogDtoFromJson(Map<String, dynamic> json) => _FoodLogDto(
      id: json['id'] as String,
      date: json['date'] as String,
      mealType: json['mealType'] as String,
      dishName: json['dishName'] as String,
      estimatedWeightG: (json['estimatedWeightG'] as num).toInt(),
      calories: (json['calories'] as num).toInt(),
      proteinG: (json['proteinG'] as num).toInt(),
      carbsG: (json['carbsG'] as num).toInt(),
      fatG: (json['fatG'] as num).toInt(),
      source: json['source'] as String,
      confidenceScore: (json['confidenceScore'] as num?)?.toDouble(),
      imageUrl: json['imageUrl'] as String?,
    );

Map<String, dynamic> _$FoodLogDtoToJson(_FoodLogDto instance) =>
    <String, dynamic>{
      'id': instance.id,
      'date': instance.date,
      'mealType': instance.mealType,
      'dishName': instance.dishName,
      'estimatedWeightG': instance.estimatedWeightG,
      'calories': instance.calories,
      'proteinG': instance.proteinG,
      'carbsG': instance.carbsG,
      'fatG': instance.fatG,
      'source': instance.source,
      'confidenceScore': instance.confidenceScore,
      'imageUrl': instance.imageUrl,
    };
