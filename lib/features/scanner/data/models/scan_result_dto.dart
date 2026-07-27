import 'package:freezed_annotation/freezed_annotation.dart';

part 'scan_result_dto.freezed.dart';
part 'scan_result_dto.g.dart';

@freezed
abstract class ScanResultDto with _$ScanResultDto {
  const factory ScanResultDto({
    @JsonKey(name: 'is_food') required bool isFood,
    @JsonKey(name: 'total_calories') required int totalCalories,
    required MacroDto macros,
    required List<DishDto> dishes,
  }) = _ScanResultDto;

  factory ScanResultDto.fromJson(Map<String, dynamic> json) =>
      _$ScanResultDtoFromJson(json);
}

@freezed
abstract class MacroDto with _$MacroDto {
  const factory MacroDto({
    @JsonKey(name: 'protein_g') required int proteinG,
    @JsonKey(name: 'carbs_g') required int carbsG,
    @JsonKey(name: 'fat_g') required int fatG,
  }) = _MacroDto;

  factory MacroDto.fromJson(Map<String, dynamic> json) =>
      _$MacroDtoFromJson(json);
}

@freezed
abstract class DishDto with _$DishDto {
  const factory DishDto({
    @JsonKey(name: 'dish_name') required String dishName,
    @JsonKey(name: 'confidence_score') required double confidenceScore,
    @JsonKey(name: 'estimated_weight_g') required int estimatedWeightG,
    required int calories,
  }) = _DishDto;

  factory DishDto.fromJson(Map<String, dynamic> json) =>
      _$DishDtoFromJson(json);
}
