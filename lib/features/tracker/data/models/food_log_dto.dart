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
  }) = _FoodLogDto;

  factory FoodLogDto.fromJson(Map<String, dynamic> json) =>
      _$FoodLogDtoFromJson(json);
}
