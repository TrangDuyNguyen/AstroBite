import 'package:freezed_annotation/freezed_annotation.dart';

part 'food_log_dto.freezed.dart';
part 'food_log_dto.g.dart';

@freezed
abstract class FoodLogDto with _$FoodLogDto {
  const factory FoodLogDto({
    required String id,
    required String date,
    required String mealType,
    required String dishName,
    required int estimatedWeightG,
    required int calories,
    required int proteinG,
    required int carbsG,
    required int fatG,
    required String source,
    double? confidenceScore,
    String? imageUrl,
    @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
    @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
    @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG,
    @JsonKey(name: 'sync_status', defaultValue: 'synced') String? syncStatus,
    @JsonKey(name: 'dishes') List<Map<String, dynamic>>? dishes,
  }) = _FoodLogDto;

  factory FoodLogDto.fromJson(Map<String, dynamic> json) =>
      _$FoodLogDtoFromJson(json);
}
