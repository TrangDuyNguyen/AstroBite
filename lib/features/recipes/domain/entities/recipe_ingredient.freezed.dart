// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recipe_ingredient.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$RecipeIngredient {
  String get foodId;
  String get name;
  double get amountGrams;
  double get calories;
  double get carbs;
  double get protein;
  double get fat;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $RecipeIngredientCopyWith<RecipeIngredient> get copyWith =>
      _$RecipeIngredientCopyWithImpl<RecipeIngredient>(
          this as RecipeIngredient, _$identity);

  /// Serializes this RecipeIngredient to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is RecipeIngredient &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amountGrams, amountGrams) ||
                other.amountGrams == amountGrams) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.fat, fat) || other.fat == fat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, foodId, name, amountGrams, calories, carbs, protein, fat);

  @override
  String toString() {
    return 'RecipeIngredient(foodId: $foodId, name: $name, amountGrams: $amountGrams, calories: $calories, carbs: $carbs, protein: $protein, fat: $fat)';
  }
}

/// @nodoc
abstract mixin class $RecipeIngredientCopyWith<$Res> {
  factory $RecipeIngredientCopyWith(
          RecipeIngredient value, $Res Function(RecipeIngredient) _then) =
      _$RecipeIngredientCopyWithImpl;
  @useResult
  $Res call(
      {String foodId,
      String name,
      double amountGrams,
      double calories,
      double carbs,
      double protein,
      double fat});
}

/// @nodoc
class _$RecipeIngredientCopyWithImpl<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  _$RecipeIngredientCopyWithImpl(this._self, this._then);

  final RecipeIngredient _self;
  final $Res Function(RecipeIngredient) _then;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? foodId = null,
    Object? name = null,
    Object? amountGrams = null,
    Object? calories = null,
    Object? carbs = null,
    Object? protein = null,
    Object? fat = null,
  }) {
    return _then(_self.copyWith(
      foodId: null == foodId
          ? _self.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amountGrams: null == amountGrams
          ? _self.amountGrams
          : amountGrams // ignore: cast_nullable_to_non_nullable
              as double,
      calories: null == calories
          ? _self.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _self.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      protein: null == protein
          ? _self.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _self.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

/// Adds pattern-matching-related methods to [RecipeIngredient].
extension RecipeIngredientPatterns on RecipeIngredient {
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
    TResult Function(_RecipeIngredient value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecipeIngredient() when $default != null:
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
    TResult Function(_RecipeIngredient value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecipeIngredient():
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
    TResult? Function(_RecipeIngredient value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecipeIngredient() when $default != null:
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
    TResult Function(String foodId, String name, double amountGrams,
            double calories, double carbs, double protein, double fat)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _RecipeIngredient() when $default != null:
        return $default(_that.foodId, _that.name, _that.amountGrams,
            _that.calories, _that.carbs, _that.protein, _that.fat);
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
    TResult Function(String foodId, String name, double amountGrams,
            double calories, double carbs, double protein, double fat)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecipeIngredient():
        return $default(_that.foodId, _that.name, _that.amountGrams,
            _that.calories, _that.carbs, _that.protein, _that.fat);
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
    TResult? Function(String foodId, String name, double amountGrams,
            double calories, double carbs, double protein, double fat)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _RecipeIngredient() when $default != null:
        return $default(_that.foodId, _that.name, _that.amountGrams,
            _that.calories, _that.carbs, _that.protein, _that.fat);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _RecipeIngredient implements RecipeIngredient {
  const _RecipeIngredient(
      {required this.foodId,
      required this.name,
      required this.amountGrams,
      required this.calories,
      required this.carbs,
      required this.protein,
      required this.fat});
  factory _RecipeIngredient.fromJson(Map<String, dynamic> json) =>
      _$RecipeIngredientFromJson(json);

  @override
  final String foodId;
  @override
  final String name;
  @override
  final double amountGrams;
  @override
  final double calories;
  @override
  final double carbs;
  @override
  final double protein;
  @override
  final double fat;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$RecipeIngredientCopyWith<_RecipeIngredient> get copyWith =>
      __$RecipeIngredientCopyWithImpl<_RecipeIngredient>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$RecipeIngredientToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _RecipeIngredient &&
            (identical(other.foodId, foodId) || other.foodId == foodId) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.amountGrams, amountGrams) ||
                other.amountGrams == amountGrams) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.fat, fat) || other.fat == fat));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
      runtimeType, foodId, name, amountGrams, calories, carbs, protein, fat);

  @override
  String toString() {
    return 'RecipeIngredient(foodId: $foodId, name: $name, amountGrams: $amountGrams, calories: $calories, carbs: $carbs, protein: $protein, fat: $fat)';
  }
}

/// @nodoc
abstract mixin class _$RecipeIngredientCopyWith<$Res>
    implements $RecipeIngredientCopyWith<$Res> {
  factory _$RecipeIngredientCopyWith(
          _RecipeIngredient value, $Res Function(_RecipeIngredient) _then) =
      __$RecipeIngredientCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String foodId,
      String name,
      double amountGrams,
      double calories,
      double carbs,
      double protein,
      double fat});
}

/// @nodoc
class __$RecipeIngredientCopyWithImpl<$Res>
    implements _$RecipeIngredientCopyWith<$Res> {
  __$RecipeIngredientCopyWithImpl(this._self, this._then);

  final _RecipeIngredient _self;
  final $Res Function(_RecipeIngredient) _then;

  /// Create a copy of RecipeIngredient
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? foodId = null,
    Object? name = null,
    Object? amountGrams = null,
    Object? calories = null,
    Object? carbs = null,
    Object? protein = null,
    Object? fat = null,
  }) {
    return _then(_RecipeIngredient(
      foodId: null == foodId
          ? _self.foodId
          : foodId // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _self.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      amountGrams: null == amountGrams
          ? _self.amountGrams
          : amountGrams // ignore: cast_nullable_to_non_nullable
              as double,
      calories: null == calories
          ? _self.calories
          : calories // ignore: cast_nullable_to_non_nullable
              as double,
      carbs: null == carbs
          ? _self.carbs
          : carbs // ignore: cast_nullable_to_non_nullable
              as double,
      protein: null == protein
          ? _self.protein
          : protein // ignore: cast_nullable_to_non_nullable
              as double,
      fat: null == fat
          ? _self.fat
          : fat // ignore: cast_nullable_to_non_nullable
              as double,
    ));
  }
}

// dart format on
