// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'scan_result_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$ScanResultDto {
  @JsonKey(name: 'is_food')
  bool get isFood;
  @JsonKey(name: 'total_calories')
  int get totalCalories;
  MacroDto get macros;
  List<DishDto> get dishes;
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  double? get sodiumMg;
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  double? get fiberG;
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  double? get sugarG;

  /// Create a copy of ScanResultDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $ScanResultDtoCopyWith<ScanResultDto> get copyWith =>
      _$ScanResultDtoCopyWithImpl<ScanResultDto>(
          this as ScanResultDto, _$identity);

  /// Serializes this ScanResultDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is ScanResultDto &&
            (identical(other.isFood, isFood) || other.isFood == isFood) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.macros, macros) || other.macros == macros) &&
            const DeepCollectionEquality().equals(other.dishes, dishes) &&
            (identical(other.sodiumMg, sodiumMg) ||
                other.sodiumMg == sodiumMg) &&
            (identical(other.fiberG, fiberG) || other.fiberG == fiberG) &&
            (identical(other.sugarG, sugarG) || other.sugarG == sugarG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isFood, totalCalories, macros,
      const DeepCollectionEquality().hash(dishes), sodiumMg, fiberG, sugarG);

  @override
  String toString() {
    return 'ScanResultDto(isFood: $isFood, totalCalories: $totalCalories, macros: $macros, dishes: $dishes, sodiumMg: $sodiumMg, fiberG: $fiberG, sugarG: $sugarG)';
  }
}

/// @nodoc
abstract mixin class $ScanResultDtoCopyWith<$Res> {
  factory $ScanResultDtoCopyWith(
          ScanResultDto value, $Res Function(ScanResultDto) _then) =
      _$ScanResultDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'is_food') bool isFood,
      @JsonKey(name: 'total_calories') int totalCalories,
      MacroDto macros,
      List<DishDto> dishes,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG});

  $MacroDtoCopyWith<$Res> get macros;
}

/// @nodoc
class _$ScanResultDtoCopyWithImpl<$Res>
    implements $ScanResultDtoCopyWith<$Res> {
  _$ScanResultDtoCopyWithImpl(this._self, this._then);

  final ScanResultDto _self;
  final $Res Function(ScanResultDto) _then;

  /// Create a copy of ScanResultDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? isFood = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? dishes = null,
    Object? sodiumMg = freezed,
    Object? fiberG = freezed,
    Object? sugarG = freezed,
  }) {
    return _then(_self.copyWith(
      isFood: null == isFood
          ? _self.isFood
          : isFood // ignore: cast_nullable_to_non_nullable
              as bool,
      totalCalories: null == totalCalories
          ? _self.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _self.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as MacroDto,
      dishes: null == dishes
          ? _self.dishes
          : dishes // ignore: cast_nullable_to_non_nullable
              as List<DishDto>,
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
    ));
  }

  /// Create a copy of ScanResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MacroDtoCopyWith<$Res> get macros {
    return $MacroDtoCopyWith<$Res>(_self.macros, (value) {
      return _then(_self.copyWith(macros: value));
    });
  }
}

/// Adds pattern-matching-related methods to [ScanResultDto].
extension ScanResultDtoPatterns on ScanResultDto {
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
    TResult Function(_ScanResultDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScanResultDto() when $default != null:
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
    TResult Function(_ScanResultDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScanResultDto():
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
    TResult? Function(_ScanResultDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScanResultDto() when $default != null:
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
            @JsonKey(name: 'is_food') bool isFood,
            @JsonKey(name: 'total_calories') int totalCalories,
            MacroDto macros,
            List<DishDto> dishes,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _ScanResultDto() when $default != null:
        return $default(_that.isFood, _that.totalCalories, _that.macros,
            _that.dishes, _that.sodiumMg, _that.fiberG, _that.sugarG);
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
            @JsonKey(name: 'is_food') bool isFood,
            @JsonKey(name: 'total_calories') int totalCalories,
            MacroDto macros,
            List<DishDto> dishes,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScanResultDto():
        return $default(_that.isFood, _that.totalCalories, _that.macros,
            _that.dishes, _that.sodiumMg, _that.fiberG, _that.sugarG);
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
            @JsonKey(name: 'is_food') bool isFood,
            @JsonKey(name: 'total_calories') int totalCalories,
            MacroDto macros,
            List<DishDto> dishes,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _ScanResultDto() when $default != null:
        return $default(_that.isFood, _that.totalCalories, _that.macros,
            _that.dishes, _that.sodiumMg, _that.fiberG, _that.sugarG);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _ScanResultDto implements ScanResultDto {
  const _ScanResultDto(
      {@JsonKey(name: 'is_food') required this.isFood,
      @JsonKey(name: 'total_calories') required this.totalCalories,
      required this.macros,
      required final List<DishDto> dishes,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) this.sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) this.fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) this.sugarG})
      : _dishes = dishes;
  factory _ScanResultDto.fromJson(Map<String, dynamic> json) =>
      _$ScanResultDtoFromJson(json);

  @override
  @JsonKey(name: 'is_food')
  final bool isFood;
  @override
  @JsonKey(name: 'total_calories')
  final int totalCalories;
  @override
  final MacroDto macros;
  final List<DishDto> _dishes;
  @override
  List<DishDto> get dishes {
    if (_dishes is EqualUnmodifiableListView) return _dishes;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_dishes);
  }

  @override
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  final double? sodiumMg;
  @override
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  final double? fiberG;
  @override
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  final double? sugarG;

  /// Create a copy of ScanResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$ScanResultDtoCopyWith<_ScanResultDto> get copyWith =>
      __$ScanResultDtoCopyWithImpl<_ScanResultDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$ScanResultDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _ScanResultDto &&
            (identical(other.isFood, isFood) || other.isFood == isFood) &&
            (identical(other.totalCalories, totalCalories) ||
                other.totalCalories == totalCalories) &&
            (identical(other.macros, macros) || other.macros == macros) &&
            const DeepCollectionEquality().equals(other._dishes, _dishes) &&
            (identical(other.sodiumMg, sodiumMg) ||
                other.sodiumMg == sodiumMg) &&
            (identical(other.fiberG, fiberG) || other.fiberG == fiberG) &&
            (identical(other.sugarG, sugarG) || other.sugarG == sugarG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, isFood, totalCalories, macros,
      const DeepCollectionEquality().hash(_dishes), sodiumMg, fiberG, sugarG);

  @override
  String toString() {
    return 'ScanResultDto(isFood: $isFood, totalCalories: $totalCalories, macros: $macros, dishes: $dishes, sodiumMg: $sodiumMg, fiberG: $fiberG, sugarG: $sugarG)';
  }
}

/// @nodoc
abstract mixin class _$ScanResultDtoCopyWith<$Res>
    implements $ScanResultDtoCopyWith<$Res> {
  factory _$ScanResultDtoCopyWith(
          _ScanResultDto value, $Res Function(_ScanResultDto) _then) =
      __$ScanResultDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'is_food') bool isFood,
      @JsonKey(name: 'total_calories') int totalCalories,
      MacroDto macros,
      List<DishDto> dishes,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG});

  @override
  $MacroDtoCopyWith<$Res> get macros;
}

/// @nodoc
class __$ScanResultDtoCopyWithImpl<$Res>
    implements _$ScanResultDtoCopyWith<$Res> {
  __$ScanResultDtoCopyWithImpl(this._self, this._then);

  final _ScanResultDto _self;
  final $Res Function(_ScanResultDto) _then;

  /// Create a copy of ScanResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? isFood = null,
    Object? totalCalories = null,
    Object? macros = null,
    Object? dishes = null,
    Object? sodiumMg = freezed,
    Object? fiberG = freezed,
    Object? sugarG = freezed,
  }) {
    return _then(_ScanResultDto(
      isFood: null == isFood
          ? _self.isFood
          : isFood // ignore: cast_nullable_to_non_nullable
              as bool,
      totalCalories: null == totalCalories
          ? _self.totalCalories
          : totalCalories // ignore: cast_nullable_to_non_nullable
              as int,
      macros: null == macros
          ? _self.macros
          : macros // ignore: cast_nullable_to_non_nullable
              as MacroDto,
      dishes: null == dishes
          ? _self._dishes
          : dishes // ignore: cast_nullable_to_non_nullable
              as List<DishDto>,
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
    ));
  }

  /// Create a copy of ScanResultDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $MacroDtoCopyWith<$Res> get macros {
    return $MacroDtoCopyWith<$Res>(_self.macros, (value) {
      return _then(_self.copyWith(macros: value));
    });
  }
}

/// @nodoc
mixin _$MacroDto {
  @JsonKey(name: 'protein_g')
  int get proteinG;
  @JsonKey(name: 'carbs_g')
  int get carbsG;
  @JsonKey(name: 'fat_g')
  int get fatG;

  /// Create a copy of MacroDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MacroDtoCopyWith<MacroDto> get copyWith =>
      _$MacroDtoCopyWithImpl<MacroDto>(this as MacroDto, _$identity);

  /// Serializes this MacroDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MacroDto &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, proteinG, carbsG, fatG);

  @override
  String toString() {
    return 'MacroDto(proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG)';
  }
}

/// @nodoc
abstract mixin class $MacroDtoCopyWith<$Res> {
  factory $MacroDtoCopyWith(MacroDto value, $Res Function(MacroDto) _then) =
      _$MacroDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'protein_g') int proteinG,
      @JsonKey(name: 'carbs_g') int carbsG,
      @JsonKey(name: 'fat_g') int fatG});
}

/// @nodoc
class _$MacroDtoCopyWithImpl<$Res> implements $MacroDtoCopyWith<$Res> {
  _$MacroDtoCopyWithImpl(this._self, this._then);

  final MacroDto _self;
  final $Res Function(MacroDto) _then;

  /// Create a copy of MacroDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
  }) {
    return _then(_self.copyWith(
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
    ));
  }
}

/// Adds pattern-matching-related methods to [MacroDto].
extension MacroDtoPatterns on MacroDto {
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
    TResult Function(_MacroDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MacroDto() when $default != null:
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
    TResult Function(_MacroDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MacroDto():
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
    TResult? Function(_MacroDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MacroDto() when $default != null:
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
            @JsonKey(name: 'protein_g') int proteinG,
            @JsonKey(name: 'carbs_g') int carbsG,
            @JsonKey(name: 'fat_g') int fatG)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MacroDto() when $default != null:
        return $default(_that.proteinG, _that.carbsG, _that.fatG);
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
            @JsonKey(name: 'protein_g') int proteinG,
            @JsonKey(name: 'carbs_g') int carbsG,
            @JsonKey(name: 'fat_g') int fatG)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MacroDto():
        return $default(_that.proteinG, _that.carbsG, _that.fatG);
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
            @JsonKey(name: 'protein_g') int proteinG,
            @JsonKey(name: 'carbs_g') int carbsG,
            @JsonKey(name: 'fat_g') int fatG)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MacroDto() when $default != null:
        return $default(_that.proteinG, _that.carbsG, _that.fatG);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MacroDto implements MacroDto {
  const _MacroDto(
      {@JsonKey(name: 'protein_g') required this.proteinG,
      @JsonKey(name: 'carbs_g') required this.carbsG,
      @JsonKey(name: 'fat_g') required this.fatG});
  factory _MacroDto.fromJson(Map<String, dynamic> json) =>
      _$MacroDtoFromJson(json);

  @override
  @JsonKey(name: 'protein_g')
  final int proteinG;
  @override
  @JsonKey(name: 'carbs_g')
  final int carbsG;
  @override
  @JsonKey(name: 'fat_g')
  final int fatG;

  /// Create a copy of MacroDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MacroDtoCopyWith<_MacroDto> get copyWith =>
      __$MacroDtoCopyWithImpl<_MacroDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MacroDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MacroDto &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, proteinG, carbsG, fatG);

  @override
  String toString() {
    return 'MacroDto(proteinG: $proteinG, carbsG: $carbsG, fatG: $fatG)';
  }
}

/// @nodoc
abstract mixin class _$MacroDtoCopyWith<$Res>
    implements $MacroDtoCopyWith<$Res> {
  factory _$MacroDtoCopyWith(_MacroDto value, $Res Function(_MacroDto) _then) =
      __$MacroDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'protein_g') int proteinG,
      @JsonKey(name: 'carbs_g') int carbsG,
      @JsonKey(name: 'fat_g') int fatG});
}

/// @nodoc
class __$MacroDtoCopyWithImpl<$Res> implements _$MacroDtoCopyWith<$Res> {
  __$MacroDtoCopyWithImpl(this._self, this._then);

  final _MacroDto _self;
  final $Res Function(_MacroDto) _then;

  /// Create a copy of MacroDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? proteinG = null,
    Object? carbsG = null,
    Object? fatG = null,
  }) {
    return _then(_MacroDto(
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
    ));
  }
}

/// @nodoc
mixin _$DishDto {
  @JsonKey(name: 'dish_name')
  String get dishName;
  @JsonKey(name: 'confidence_score')
  double get confidenceScore;
  @JsonKey(name: 'estimated_weight_g')
  int get estimatedWeightG;
  int get calories;
  @JsonKey(name: 'carbs_g', defaultValue: 0)
  int? get carbsG;
  @JsonKey(name: 'protein_g', defaultValue: 0)
  int? get proteinG;
  @JsonKey(name: 'fat_g', defaultValue: 0)
  int? get fatG;
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  double? get sodiumMg;
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  double? get fiberG;
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  double? get sugarG;

  /// Create a copy of DishDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $DishDtoCopyWith<DishDto> get copyWith =>
      _$DishDtoCopyWithImpl<DishDto>(this as DishDto, _$identity);

  /// Serializes this DishDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is DishDto &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.estimatedWeightG, estimatedWeightG) ||
                other.estimatedWeightG == estimatedWeightG) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            (identical(other.sodiumMg, sodiumMg) ||
                other.sodiumMg == sodiumMg) &&
            (identical(other.fiberG, fiberG) || other.fiberG == fiberG) &&
            (identical(other.sugarG, sugarG) || other.sugarG == sugarG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dishName,
      confidenceScore,
      estimatedWeightG,
      calories,
      carbsG,
      proteinG,
      fatG,
      sodiumMg,
      fiberG,
      sugarG);

  @override
  String toString() {
    return 'DishDto(dishName: $dishName, confidenceScore: $confidenceScore, estimatedWeightG: $estimatedWeightG, calories: $calories, carbsG: $carbsG, proteinG: $proteinG, fatG: $fatG, sodiumMg: $sodiumMg, fiberG: $fiberG, sugarG: $sugarG)';
  }
}

/// @nodoc
abstract mixin class $DishDtoCopyWith<$Res> {
  factory $DishDtoCopyWith(DishDto value, $Res Function(DishDto) _then) =
      _$DishDtoCopyWithImpl;
  @useResult
  $Res call(
      {@JsonKey(name: 'dish_name') String dishName,
      @JsonKey(name: 'confidence_score') double confidenceScore,
      @JsonKey(name: 'estimated_weight_g') int estimatedWeightG,
      int calories,
      @JsonKey(name: 'carbs_g', defaultValue: 0) int? carbsG,
      @JsonKey(name: 'protein_g', defaultValue: 0) int? proteinG,
      @JsonKey(name: 'fat_g', defaultValue: 0) int? fatG,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG});
}

/// @nodoc
class _$DishDtoCopyWithImpl<$Res> implements $DishDtoCopyWith<$Res> {
  _$DishDtoCopyWithImpl(this._self, this._then);

  final DishDto _self;
  final $Res Function(DishDto) _then;

  /// Create a copy of DishDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? dishName = null,
    Object? confidenceScore = null,
    Object? estimatedWeightG = null,
    Object? calories = null,
    Object? carbsG = freezed,
    Object? proteinG = freezed,
    Object? fatG = freezed,
    Object? sodiumMg = freezed,
    Object? fiberG = freezed,
    Object? sugarG = freezed,
  }) {
    return _then(_self.copyWith(
      dishName: null == dishName
          ? _self.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      confidenceScore: null == confidenceScore
          ? _self.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedWeightG: null == estimatedWeightG
          ? _self.estimatedWeightG
          : estimatedWeightG // ignore: cast_nullable_to_non_nullable
              as int,
      calories: null == calories
          ? _self.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      carbsG: freezed == carbsG
          ? _self.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as int?,
      proteinG: freezed == proteinG
          ? _self.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as int?,
      fatG: freezed == fatG
          ? _self.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as int?,
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
    ));
  }
}

/// Adds pattern-matching-related methods to [DishDto].
extension DishDtoPatterns on DishDto {
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
    TResult Function(_DishDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DishDto() when $default != null:
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
    TResult Function(_DishDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DishDto():
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
    TResult? Function(_DishDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DishDto() when $default != null:
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
            @JsonKey(name: 'dish_name') String dishName,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'estimated_weight_g') int estimatedWeightG,
            int calories,
            @JsonKey(name: 'carbs_g', defaultValue: 0) int? carbsG,
            @JsonKey(name: 'protein_g', defaultValue: 0) int? proteinG,
            @JsonKey(name: 'fat_g', defaultValue: 0) int? fatG,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _DishDto() when $default != null:
        return $default(
            _that.dishName,
            _that.confidenceScore,
            _that.estimatedWeightG,
            _that.calories,
            _that.carbsG,
            _that.proteinG,
            _that.fatG,
            _that.sodiumMg,
            _that.fiberG,
            _that.sugarG);
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
            @JsonKey(name: 'dish_name') String dishName,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'estimated_weight_g') int estimatedWeightG,
            int calories,
            @JsonKey(name: 'carbs_g', defaultValue: 0) int? carbsG,
            @JsonKey(name: 'protein_g', defaultValue: 0) int? proteinG,
            @JsonKey(name: 'fat_g', defaultValue: 0) int? fatG,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DishDto():
        return $default(
            _that.dishName,
            _that.confidenceScore,
            _that.estimatedWeightG,
            _that.calories,
            _that.carbsG,
            _that.proteinG,
            _that.fatG,
            _that.sodiumMg,
            _that.fiberG,
            _that.sugarG);
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
            @JsonKey(name: 'dish_name') String dishName,
            @JsonKey(name: 'confidence_score') double confidenceScore,
            @JsonKey(name: 'estimated_weight_g') int estimatedWeightG,
            int calories,
            @JsonKey(name: 'carbs_g', defaultValue: 0) int? carbsG,
            @JsonKey(name: 'protein_g', defaultValue: 0) int? proteinG,
            @JsonKey(name: 'fat_g', defaultValue: 0) int? fatG,
            @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
            @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
            @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _DishDto() when $default != null:
        return $default(
            _that.dishName,
            _that.confidenceScore,
            _that.estimatedWeightG,
            _that.calories,
            _that.carbsG,
            _that.proteinG,
            _that.fatG,
            _that.sodiumMg,
            _that.fiberG,
            _that.sugarG);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _DishDto implements DishDto {
  const _DishDto(
      {@JsonKey(name: 'dish_name') required this.dishName,
      @JsonKey(name: 'confidence_score') required this.confidenceScore,
      @JsonKey(name: 'estimated_weight_g') required this.estimatedWeightG,
      required this.calories,
      @JsonKey(name: 'carbs_g', defaultValue: 0) this.carbsG,
      @JsonKey(name: 'protein_g', defaultValue: 0) this.proteinG,
      @JsonKey(name: 'fat_g', defaultValue: 0) this.fatG,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) this.sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) this.fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) this.sugarG});
  factory _DishDto.fromJson(Map<String, dynamic> json) =>
      _$DishDtoFromJson(json);

  @override
  @JsonKey(name: 'dish_name')
  final String dishName;
  @override
  @JsonKey(name: 'confidence_score')
  final double confidenceScore;
  @override
  @JsonKey(name: 'estimated_weight_g')
  final int estimatedWeightG;
  @override
  final int calories;
  @override
  @JsonKey(name: 'carbs_g', defaultValue: 0)
  final int? carbsG;
  @override
  @JsonKey(name: 'protein_g', defaultValue: 0)
  final int? proteinG;
  @override
  @JsonKey(name: 'fat_g', defaultValue: 0)
  final int? fatG;
  @override
  @JsonKey(name: 'sodium_mg', defaultValue: 0.0)
  final double? sodiumMg;
  @override
  @JsonKey(name: 'fiber_g', defaultValue: 0.0)
  final double? fiberG;
  @override
  @JsonKey(name: 'sugar_g', defaultValue: 0.0)
  final double? sugarG;

  /// Create a copy of DishDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$DishDtoCopyWith<_DishDto> get copyWith =>
      __$DishDtoCopyWithImpl<_DishDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$DishDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _DishDto &&
            (identical(other.dishName, dishName) ||
                other.dishName == dishName) &&
            (identical(other.confidenceScore, confidenceScore) ||
                other.confidenceScore == confidenceScore) &&
            (identical(other.estimatedWeightG, estimatedWeightG) ||
                other.estimatedWeightG == estimatedWeightG) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.carbsG, carbsG) || other.carbsG == carbsG) &&
            (identical(other.proteinG, proteinG) ||
                other.proteinG == proteinG) &&
            (identical(other.fatG, fatG) || other.fatG == fatG) &&
            (identical(other.sodiumMg, sodiumMg) ||
                other.sodiumMg == sodiumMg) &&
            (identical(other.fiberG, fiberG) || other.fiberG == fiberG) &&
            (identical(other.sugarG, sugarG) || other.sugarG == sugarG));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      dishName,
      confidenceScore,
      estimatedWeightG,
      calories,
      carbsG,
      proteinG,
      fatG,
      sodiumMg,
      fiberG,
      sugarG);

  @override
  String toString() {
    return 'DishDto(dishName: $dishName, confidenceScore: $confidenceScore, estimatedWeightG: $estimatedWeightG, calories: $calories, carbsG: $carbsG, proteinG: $proteinG, fatG: $fatG, sodiumMg: $sodiumMg, fiberG: $fiberG, sugarG: $sugarG)';
  }
}

/// @nodoc
abstract mixin class _$DishDtoCopyWith<$Res> implements $DishDtoCopyWith<$Res> {
  factory _$DishDtoCopyWith(_DishDto value, $Res Function(_DishDto) _then) =
      __$DishDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'dish_name') String dishName,
      @JsonKey(name: 'confidence_score') double confidenceScore,
      @JsonKey(name: 'estimated_weight_g') int estimatedWeightG,
      int calories,
      @JsonKey(name: 'carbs_g', defaultValue: 0) int? carbsG,
      @JsonKey(name: 'protein_g', defaultValue: 0) int? proteinG,
      @JsonKey(name: 'fat_g', defaultValue: 0) int? fatG,
      @JsonKey(name: 'sodium_mg', defaultValue: 0.0) double? sodiumMg,
      @JsonKey(name: 'fiber_g', defaultValue: 0.0) double? fiberG,
      @JsonKey(name: 'sugar_g', defaultValue: 0.0) double? sugarG});
}

/// @nodoc
class __$DishDtoCopyWithImpl<$Res> implements _$DishDtoCopyWith<$Res> {
  __$DishDtoCopyWithImpl(this._self, this._then);

  final _DishDto _self;
  final $Res Function(_DishDto) _then;

  /// Create a copy of DishDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? dishName = null,
    Object? confidenceScore = null,
    Object? estimatedWeightG = null,
    Object? calories = null,
    Object? carbsG = freezed,
    Object? proteinG = freezed,
    Object? fatG = freezed,
    Object? sodiumMg = freezed,
    Object? fiberG = freezed,
    Object? sugarG = freezed,
  }) {
    return _then(_DishDto(
      dishName: null == dishName
          ? _self.dishName
          : dishName // ignore: cast_nullable_to_non_nullable
              as String,
      confidenceScore: null == confidenceScore
          ? _self.confidenceScore
          : confidenceScore // ignore: cast_nullable_to_non_nullable
              as double,
      estimatedWeightG: null == estimatedWeightG
          ? _self.estimatedWeightG
          : estimatedWeightG // ignore: cast_nullable_to_non_nullable
              as int,
      calories: null == calories
          ? _self.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as int,
      carbsG: freezed == carbsG
          ? _self.carbsG
          : carbsG // ignore: cast_nullable_to_non_nullable
              as int?,
      proteinG: freezed == proteinG
          ? _self.proteinG
          : proteinG // ignore: cast_nullable_to_non_nullable
              as int?,
      fatG: freezed == fatG
          ? _self.fatG
          : fatG // ignore: cast_nullable_to_non_nullable
              as int?,
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
    ));
  }
}

// dart format on
