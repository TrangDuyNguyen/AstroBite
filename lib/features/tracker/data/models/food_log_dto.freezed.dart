// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'food_log_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FoodLogDto {
  String get id;
  String get date;
  String get mealType;
  String get dishName;
  int get estimatedWeightG;
  int get calories;
  int get proteinG;
  int get carbsG;
  int get fatG;
  String get source;
  double? get confidenceScore;
  String? get imageUrl;
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  double? get sodiumMg;
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  double? get fiberG;
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  double? get sugarG;
  @JsonKey(name: 'sync_status', defaultValue: 'synced')
  String? get syncStatus;
  @JsonKey(name: 'dishes')
  List<Map<String, dynamic>>? get dishes;

  /// Create a copy of FoodLogDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $FoodLogDtoCopyWith<FoodLogDto> get copyWith =>
      _$FoodLogDtoCopyWithImpl<FoodLogDto>(this as FoodLogDto, _$identity);

  /// Serializes this FoodLogDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is FoodLogDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.estimatedWeightG, estimatedWeightG) ||
                other.estimatedWeightG == estimatedWeightG) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sodiumMg, sodiumMg) ||
                other.sodiumMg == sodiumMg) &&
            (identical(other.fiberG, fiberG) || other.fiberG == fiberG) &&
            (identical(other.sugarG, sugarG) || other.sugarG == sugarG) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            const DeepCollectionEquality().equals(other.dishes, dishes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      mealType,
      dishName,
      estimatedWeightG,
      calories,
      proteinG,
      carbsG,
      fatG,
      source,
      confidenceScore,
      imageUrl,
      sodiumMg,
      fiberG,
      sugarG,
      syncStatus,
      const DeepCollectionEquality().hash(dishes));

  @override
  String toString() {
    return 'FoodLogDto(id: $id, date: $date, mealType: $mealType, dishName: $dishName, estimatedWeightG: $estimatedWeightG, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, source: $source, confidenceScore: $confidenceScore, imageUrl: $imageUrl, sodiumMg: $sodiumMg, fiberG: $fiberG, sugarG: $sugarG, syncStatus: $syncStatus, dishes: $dishes)';
  }
}

/// @nodoc
abstract mixin class $FoodLogDtoCopyWith<$Res> {
  factory $FoodLogDtoCopyWith(
          FoodLogDto value, $Res Function(FoodLogDto) _then) =
      _$FoodLogDtoCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String date,
      String mealType,
      String dishName,
      int estimatedWeightG,
      int calories,
      int proteinG,
      int carbsG,
      int fatG,
      String source,
      double? confidenceScore,
      String? imageUrl,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG,
      @JsonKey(name: 'sync_status', defaultValue: 'synced') String? syncStatus,
      @JsonKey(name: 'dishes') List<Map<String, dynamic>>? dishes});
}

/// @nodoc
class _$FoodLogDtoCopyWithImpl<$Res> implements $FoodLogDtoCopyWith<$Res> {
  _$FoodLogDtoCopyWithImpl(this._self, this._then);

  final FoodLogDto _self;
  final $Res Function(FoodLogDto) _then;

  /// Create a copy of FoodLogDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? mealType = null,
    Object? dishName = null,
    Object? estimatedWeightG = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? source = null,
    Object? confidenceScore = freezed,
    Object? imageUrl = freezed,
    Object? sodiumMg = freezed,
    Object? fiberG = freezed,
    Object? sugarG = freezed,
    Object? syncStatus = freezed,
    Object? dishes = freezed,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _self.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      dishName: null == dishName
          ? _self.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedWeightG: null == estimatedWeightG
          ? _self.estimatedWeightG
          : estimatedWeightG // ignore: cast_nullable_to_non_nullable
              as int,
      calories: null == calories
          ? _self.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      proteinG: null == proteinG
          ? _self.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as int,
      carbsG: null == carbsG
          ? _self.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as int,
      fatG: null == fatG
          ? _self.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      confidenceScore: freezed == confidenceScore
          ? _self.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sodiumMg: freezed == sodiumMg
          ? _self.sodiumMg
          : sodiumMg // ignore: cast_nullable_to_non_nullable
              as double?,
      fiberG: freezed == fiberG
          ? _self.fiberG
          : fiberG // ignore: cast_nullable_to_non_nullable
              as double?,
      sugarG: freezed == sugarG
          ? _self.sugarG
          : sugarG // ignore: cast_nullable_to_non_nullable
              as double?,
      syncStatus: freezed == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      dishes: freezed == dishes
          ? _self.dishes
          : dishes // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
    ));
  }
}

/// Adds pattern-matching-related methods to [FoodLogDto].
extension FoodLogDtoPatterns on FoodLogDto {
  /// A variant of `map` that fallback to returning `orElse`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeMap<TResult extends Object?>(
    TResult Function(_FoodLogDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodLogDto() when $default != null:
        return $default(_that);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// Callbacks receives the raw object, upcasted.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case final Subclass2 value:
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult map<TResult extends Object?>(
    TResult Function(_FoodLogDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodLogDto():
        return $default(_that);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `map` that fallback to returning `null`.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case final Subclass value:
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? mapOrNull<TResult extends Object?>(
    TResult? Function(_FoodLogDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodLogDto() when $default != null:
        return $default(_that);
      case _:
        return null;
    }
  }

  /// A variant of `when` that fallback to an `orElse` callback.
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return orElse();
  /// }
  /// ```

  @optionalTypeArgs
  TResult maybeWhen<TResult extends Object?>(
    TResult Function(
            String id,
            String date,
            String mealType,
            String dishName,
            int estimatedWeightG,
            int calories,
            int proteinG,
            int carbsG,
            int fatG,
            String source,
            double? confidenceScore,
            String? imageUrl,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG,
            @JsonKey(name: 'sync_status', defaultValue: 'synced')
            String? syncStatus,
            @JsonKey(name: 'dishes') List<Map<String, dynamic>>? dishes)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _FoodLogDto() when $default != null:
        return $default(
            _that.id,
            _that.date,
            _that.mealType,
            _that.dishName,
            _that.estimatedWeightG,
            _that.calories,
            _that.proteinG,
            _that.carbsG,
            _that.fatG,
            _that.source,
            _that.confidenceScore,
            _that.imageUrl,
            _that.sodiumMg,
            _that.fiberG,
            _that.sugarG,
            _that.syncStatus,
            _that.dishes);
      case _:
        return orElse();
    }
  }

  /// A `switch`-like method, using callbacks.
  ///
  /// As opposed to `map`, this offers destructuring.
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case Subclass2(:final field2):
  ///     return ...;
  /// }
  /// ```

  @optionalTypeArgs
  TResult when<TResult extends Object?>(
    TResult Function(
            String id,
            String date,
            String mealType,
            String dishName,
            int estimatedWeightG,
            int calories,
            int proteinG,
            int carbsG,
            int fatG,
            String source,
            double? confidenceScore,
            String? imageUrl,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG,
            @JsonKey(name: 'sync_status', defaultValue: 'synced')
            String? syncStatus,
            @JsonKey(name: 'dishes') List<Map<String, dynamic>>? dishes)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodLogDto():
        return $default(
            _that.id,
            _that.date,
            _that.mealType,
            _that.dishName,
            _that.estimatedWeightG,
            _that.calories,
            _that.proteinG,
            _that.carbsG,
            _that.fatG,
            _that.source,
            _that.confidenceScore,
            _that.imageUrl,
            _that.sodiumMg,
            _that.fiberG,
            _that.sugarG,
            _that.syncStatus,
            _that.dishes);
      case _:
        throw StateError('Unexpected subclass');
    }
  }

  /// A variant of `when` that fallback to returning `null`
  ///
  /// It is equivalent to doing:
  /// ```dart
  /// switch (sealedClass) {
  ///   case Subclass(:final field):
  ///     return ...;
  ///   case _:
  ///     return null;
  /// }
  /// ```

  @optionalTypeArgs
  TResult? whenOrNull<TResult extends Object?>(
    TResult? Function(
            String id,
            String date,
            String mealType,
            String dishName,
            int estimatedWeightG,
            int calories,
            int proteinG,
            int carbsG,
            int fatG,
            String source,
            double? confidenceScore,
            String? imageUrl,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG,
            @JsonKey(name: 'sync_status', defaultValue: 'synced')
            String? syncStatus,
            @JsonKey(name: 'dishes') List<Map<String, dynamic>>? dishes)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _FoodLogDto() when $default != null:
        return $default(
            _that.id,
            _that.date,
            _that.mealType,
            _that.dishName,
            _that.estimatedWeightG,
            _that.calories,
            _that.proteinG,
            _that.carbsG,
            _that.fatG,
            _that.source,
            _that.confidenceScore,
            _that.imageUrl,
            _that.sodiumMg,
            _that.fiberG,
            _that.sugarG,
            _that.syncStatus,
            _that.dishes);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _FoodLogDto implements FoodLogDto {
  const _FoodLogDto(
      {required this.id,
      required this.date,
      required this.mealType,
      required this.dishName,
      required this.estimatedWeightG,
      required this.calories,
      required this.proteinG,
      required this.carbsG,
      required this.fatG,
      required this.source,
      this.confidenceScore,
      this.imageUrl,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) this.sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) this.fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) this.sugarG,
      @JsonKey(name: 'sync_status', defaultValue: 'synced') this.syncStatus,
      @JsonKey(name: 'dishes') final List<Map<String, dynamic>>? dishes})
      : _dishes = dishes;
  factory _FoodLogDto.fromJson(Map<String, dynamic> json) =>
      _$FoodLogDtoFromJson(json);

  @override
  final String id;
  @override
  final String date;
  @override
  final String mealType;
  @override
  final String dishName;
  @override
  final int estimatedWeightG;
  @override
  final int calories;
  @override
  final int proteinG;
  @override
  final int carbsG;
  @override
  final int fatG;
  @override
  final String source;
  @override
  final double? confidenceScore;
  @override
  final String? imageUrl;
  @override
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  final double? sodiumMg;
  @override
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  final double? fiberG;
  @override
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  final double? sugarG;
  @override
  @JsonKey(name: 'sync_status', defaultValue: 'synced')
  final String? syncStatus;
  final List<Map<String, dynamic>>? _dishes;
  @override
  @JsonKey(name: 'dishes')
  List<Map<String, dynamic>>? get dishes {
    final value = _dishes;
    if (value == null) return null;
    if (_dishes is EqualUnmodifiableListView) return _dishes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(value);
  }

  /// Create a copy of FoodLogDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$FoodLogDtoCopyWith<_FoodLogDto> get copyWith =>
      __$FoodLogDtoCopyWithImpl<_FoodLogDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$FoodLogDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _FoodLogDto &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.estimatedWeightG, estimatedWeightG) ||
                other.estimatedWeightG == estimatedWeightG) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            (identical(other.source, source) || other.source == source) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.sodiumMg, sodiumMg) ||
                other.sodiumMg == sodiumMg) &&
            (identical(other.fiberG, fiberG) || other.fiberG == fiberG) &&
            (identical(other.sugarG, sugarG) || other.sugarG == sugarG) &&
            (identical(other.syncStatus, syncStatus) ||
                other.syncStatus == syncStatus) &&
            const DeepCollectionEquality().equals(other._dishes, _dishes));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      id,
      date,
      mealType,
      dishName,
      estimatedWeightG,
      calories,
      proteinG,
      carbsG,
      fatG,
      source,
      confidenceScore,
      imageUrl,
      sodiumMg,
      fiberG,
      sugarG,
      syncStatus,
      const DeepCollectionEquality().hash(_dishes));

  @override
  String toString() {
    return 'FoodLogDto(id: $id, date: $date, mealType: $mealType, dishName: $dishName, estimatedWeightG: $estimatedWeightG, calories: $calories, proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG, source: $source, confidenceScore: $confidenceScore, imageUrl: $imageUrl, sodiumMg: $sodiumMg, fiberG: $fiberG, sugarG: $sugarG, syncStatus: $syncStatus, dishes: $dishes)';
  }
}

/// @nodoc
abstract mixin class _$FoodLogDtoCopyWith<$Res>
    implements $FoodLogDtoCopyWith<$Res> {
  factory _$FoodLogDtoCopyWith(
          _FoodLogDto value, $Res Function(_FoodLogDto) _then) =
      __$FoodLogDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String date,
      String mealType,
      String dishName,
      int estimatedWeightG,
      int calories,
      int proteinG,
      int carbsG,
      int fatG,
      String source,
      double? confidenceScore,
      String? imageUrl,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG,
      @JsonKey(name: 'sync_status', defaultValue: 'synced') String? syncStatus,
      @JsonKey(name: 'dishes') List<Map<String, dynamic>>? dishes});
}

/// @nodoc
class __$FoodLogDtoCopyWithImpl<$Res> implements _$FoodLogDtoCopyWith<$Res> {
  __$FoodLogDtoCopyWithImpl(this._self, this._then);

  final _FoodLogDto _self;
  final $Res Function(_FoodLogDto) _then;

  /// Create a copy of FoodLogDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? date = null,
    Object? mealType = null,
    Object? dishName = null,
    Object? estimatedWeightG = null,
    Object? calories = null,
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
    Object? source = null,
    Object? confidenceScore = freezed,
    Object? imageUrl = freezed,
    Object? sodiumMg = freezed,
    Object? fiberG = freezed,
    Object? sugarG = freezed,
    Object? syncStatus = freezed,
    Object? dishes = freezed,
  }) {
    return _then(_FoodLogDto(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _self.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      dishName: null == dishName
          ? _self.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      estimatedWeightG: null == estimatedWeightG
          ? _self.estimatedWeightG
          : estimatedWeightG // ignore: cast_nullable_to_non_nullable
              as int,
      calories: null == calories
          ? _self.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      proteinG: null == proteinG
          ? _self.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as int,
      carbsG: null == carbsG
          ? _self.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as int,
      fatG: null == fatG
          ? _self.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as int,
      source: null == source
          ? _self.source
          : source // ignore: cast_nullable_to_non_nullable
              as String,
      confidenceScore: freezed == confidenceScore
          ? _self.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double?,
      imageUrl: freezed == imageUrl
          ? _self.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      sodiumMg: freezed == sodiumMg
          ? _self.sodiumMg
          : sodiumMg // ignore: cast_nullable_to_non_nullable
              as double?,
      fiberG: freezed == fiberG
          ? _self.fiberG
          : fiberG // ignore: cast_nullable_to_non_nullable
              as double?,
      sugarG: freezed == sugarG
          ? _self.sugarG
          : sugarG // ignore: cast_nullable_to_non_nullable
              as double?,
      syncStatus: freezed == syncStatus
          ? _self.syncStatus
          : syncStatus // ignore: cast_nullable_to_non_nullable
              as String?,
      dishes: freezed == dishes
          ? _self._dishes
          : dishes // ignore: cast_nullable_to_non_nullable
              as List<Map<String, dynamic>>?,
    ));
  }
}

// dart format on
