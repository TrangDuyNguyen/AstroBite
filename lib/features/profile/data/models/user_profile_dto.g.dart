// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_profile_dto.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_UserProfileDto _$UserProfileDtoFromJson(Map<String, dynamic> json) =>
    _UserProfileDto(
      uid: json['uid'] as String,
      gender: json['gender'] as String,
      birthYear: (json['birthYear'] as num).toInt(),
      heightCm: (json['heightCm'] as num).toDouble(),
      weightKg: (json['weightKg'] as num).toDouble(),
      activityLevel: json['activityLevel'] as String,
      dailyTargetCalories: (json['dailyTargetCalories'] as num).toInt(),
    );

Map<String, dynamic> _$UserProfileDtoToJson(_UserProfileDto instance) =>
    <String, dynamic>{
      'uid': instance.uid,
      'gender': instance.gender,
      'birthYear': instance.birthYear,
      'heightCm': instance.heightCm,
      'weightKg': instance.weightKg,
      'activityLevel': instance.activityLevel,
      'dailyTargetCalories': instance.dailyTargetCalories,
    };
