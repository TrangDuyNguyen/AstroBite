// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'meal_plan_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MealPlanItem {
  String get id;
  String get userId;

  /// ISO date string: YYYY-MM-DD
  String get date;

  /// breakfast | lunch | dinner | snack
  String get mealType;
  String? get recipeId;
  String get foodName;
  double get calories;
  double get carbs;
  double get protein;
  double get fat;
  bool get isLogged;

  /// Create a copy of MealPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $MealPlanItemCopyWith<MealPlanItem> get copyWith =>
      _$MealPlanItemCopyWithImpl<MealPlanItem>(
          this as MealPlanItem, _$identity);

  /// Serializes this MealPlanItem to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is MealPlanItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.isLogged, isLogged) ||
                other.isLogged == isLogged));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, date, mealType,
      recipeId, foodName, calories, carbs, protein, fat, isLogged);

  @override
  String toString() {
    return 'MealPlanItem(id: $id, userId: $userId, date: $date, mealType: $mealType, recipeId: $recipeId, foodName: $foodName, calories: $calories, carbs: $carbs, protein: $protein, fat: $fat, isLogged: $isLogged)';
  }
}

/// @nodoc
abstract mixin class $MealPlanItemCopyWith<$Res> {
  factory $MealPlanItemCopyWith(
          MealPlanItem value, $Res Function(MealPlanItem) _then) =
      _$MealPlanItemCopyWithImpl;
  @useResult
  $Res call(
      {String id,
      String userId,
      String date,
      String mealType,
      String? recipeId,
      String foodName,
      double calories,
      double carbs,
      double protein,
      double fat,
      bool isLogged});
}

/// @nodoc
class _$MealPlanItemCopyWithImpl<$Res> implements $MealPlanItemCopyWith<$Res> {
  _$MealPlanItemCopyWithImpl(this._self, this._then);

  final MealPlanItem _self;
  final $Res Function(MealPlanItem) _then;

  /// Create a copy of MealPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? mealType = null,
    Object? recipeId = freezed,
    Object? foodName = null,
    Object? calories = null,
    Object? carbs = null,
    Object? protein = null,
    Object? fat = null,
    Object? isLogged = null,
  }) {
    return _then(_self.copyWith(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _self.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      recipeId: freezed == recipeId
          ? _self.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
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
      isLogged: null == isLogged
          ? _self.isLogged
          : isLogged // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// Adds pattern-matching-related methods to [MealPlanItem].
extension MealPlanItemPatterns on MealPlanItem {
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
    TResult Function(_MealPlanItem value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealPlanItem() when $default != null:
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
    TResult Function(_MealPlanItem value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealPlanItem():
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
    TResult? Function(_MealPlanItem value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealPlanItem() when $default != null:
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
            String userId,
            String date,
            String mealType,
            String? recipeId,
            String foodName,
            double calories,
            double carbs,
            double protein,
            double fat,
            bool isLogged)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _MealPlanItem() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.date,
            _that.mealType,
            _that.recipeId,
            _that.foodName,
            _that.calories,
            _that.carbs,
            _that.protein,
            _that.fat,
            _that.isLogged);
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
            String userId,
            String date,
            String mealType,
            String? recipeId,
            String foodName,
            double calories,
            double carbs,
            double protein,
            double fat,
            bool isLogged)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealPlanItem():
        return $default(
            _that.id,
            _that.userId,
            _that.date,
            _that.mealType,
            _that.recipeId,
            _that.foodName,
            _that.calories,
            _that.carbs,
            _that.protein,
            _that.fat,
            _that.isLogged);
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
            String userId,
            String date,
            String mealType,
            String? recipeId,
            String foodName,
            double calories,
            double carbs,
            double protein,
            double fat,
            bool isLogged)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _MealPlanItem() when $default != null:
        return $default(
            _that.id,
            _that.userId,
            _that.date,
            _that.mealType,
            _that.recipeId,
            _that.foodName,
            _that.calories,
            _that.carbs,
            _that.protein,
            _that.fat,
            _that.isLogged);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _MealPlanItem implements MealPlanItem {
  const _MealPlanItem(
      {required this.id,
      required this.userId,
      required this.date,
      required this.mealType,
      this.recipeId,
      required this.foodName,
      required this.calories,
      required this.carbs,
      required this.protein,
      required this.fat,
      this.isLogged = false});
  factory _MealPlanItem.fromJson(Map<String, dynamic> json) =>
      _$MealPlanItemFromJson(json);

  @override
  final String id;
  @override
  final String userId;

  /// ISO date string: YYYY-MM-DD
  @override
  final String date;

  /// breakfast | lunch | dinner | snack
  @override
  final String mealType;
  @override
  final String? recipeId;
  @override
  final String foodName;
  @override
  final double calories;
  @override
  final double carbs;
  @override
  final double protein;
  @override
  final double fat;
  @override
  @JsonKey()
  final bool isLogged;

  /// Create a copy of MealPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$MealPlanItemCopyWith<_MealPlanItem> get copyWith =>
      __$MealPlanItemCopyWithImpl<_MealPlanItem>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$MealPlanItemToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _MealPlanItem &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.date, date) || other.date == date) &&
            (identical(other.mealType, mealType) ||
                other.mealType == mealType) &&
            (identical(other.recipeId, recipeId) ||
                other.recipeId == recipeId) &&
            (identical(other.foodName, foodName) ||
                other.foodName == foodName) &&
            (identical(other.calories, calories) ||
                other.calories == calories) &&
            (identical(other.carbs, carbs) || other.carbs == carbs) &&
            (identical(other.protein, protein) || other.protein == protein) &&
            (identical(other.fat, fat) || other.fat == fat) &&
            (identical(other.isLogged, isLogged) ||
                other.isLogged == isLogged));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, userId, date, mealType,
      recipeId, foodName, calories, carbs, protein, fat, isLogged);

  @override
  String toString() {
    return 'MealPlanItem(id: $id, userId: $userId, date: $date, mealType: $mealType, recipeId: $recipeId, foodName: $foodName, calories: $calories, carbs: $carbs, protein: $protein, fat: $fat, isLogged: $isLogged)';
  }
}

/// @nodoc
abstract mixin class _$MealPlanItemCopyWith<$Res>
    implements $MealPlanItemCopyWith<$Res> {
  factory _$MealPlanItemCopyWith(
          _MealPlanItem value, $Res Function(_MealPlanItem) _then) =
      __$MealPlanItemCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String id,
      String userId,
      String date,
      String mealType,
      String? recipeId,
      String foodName,
      double calories,
      double carbs,
      double protein,
      double fat,
      bool isLogged});
}

/// @nodoc
class __$MealPlanItemCopyWithImpl<$Res>
    implements _$MealPlanItemCopyWith<$Res> {
  __$MealPlanItemCopyWithImpl(this._self, this._then);

  final _MealPlanItem _self;
  final $Res Function(_MealPlanItem) _then;

  /// Create a copy of MealPlanItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? date = null,
    Object? mealType = null,
    Object? recipeId = freezed,
    Object? foodName = null,
    Object? calories = null,
    Object? carbs = null,
    Object? protein = null,
    Object? fat = null,
    Object? isLogged = null,
  }) {
    return _then(_MealPlanItem(
      id: null == id
          ? _self.id
          : id // ignore: cast_nullable_to_non_nullable
              as String,
      userId: null == userId
          ? _self.userId
          : userId // ignore: cast_nullable_to_non_nullable
              as String,
      date: null == date
          ? _self.date
          : date // ignore: cast_nullable_to_non_nullable
              as String,
      mealType: null == mealType
          ? _self.mealType
          : mealType // ignore: cast_nullable_to_non_nullable
              as String,
      recipeId: freezed == recipeId
          ? _self.recipeId
          : recipeId // ignore: cast_nullable_to_non_nullable
              as String?,
      foodName: null == foodName
          ? _self.foodName
          : foodName // ignore: cast_nullable_to_non_nullable
              as String,
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
      isLogged: null == isLogged
          ? _self.isLogged
          : isLogged // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

// dart format on
