// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'user_profile_dto.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$UserProfileDto {
  String get uid;
  String get gender;
  int get birthYear;
  double get heightCm;
  double get weightKg;
  String get activityLevel;
  int get dailyTargetCalories;

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  $UserProfileDtoCopyWith<UserProfileDto> get copyWith =>
      _$UserProfileDtoCopyWithImpl<UserProfileDto>(
          this as UserProfileDto, _$identity);

  /// Serializes this UserProfileDto to a JSON map.
  Map<String, dynamic> toJson();

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is UserProfileDto &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthYear, birthYear) ||
                other.birthYear == birthYear) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.dailyTargetCalories, dailyTargetCalories) ||
                other.dailyTargetCalories == dailyTargetCalories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, gender, birthYear, heightCm,
      weightKg, activityLevel, dailyTargetCalories);

  @override
  String toString() {
    return 'UserProfileDto(uid: $uid, gender: $gender, birthYear: $birthYear, heightCm: $heightCm, weightKg: $weightKg, activityLevel: $activityLevel, dailyTargetCalories: $dailyTargetCalories)';
  }
}

/// @nodoc
abstract mixin class $UserProfileDtoCopyWith<$Res> {
  factory $UserProfileDtoCopyWith(
          UserProfileDto value, $Res Function(UserProfileDto) _then) =
      _$UserProfileDtoCopyWithImpl;
  @useResult
  $Res call(
      {String uid,
      String gender,
      int birthYear,
      double heightCm,
      double weightKg,
      String activityLevel,
      int dailyTargetCalories});
}

/// @nodoc
class _$UserProfileDtoCopyWithImpl<$Res>
    implements $UserProfileDtoCopyWith<$Res> {
  _$UserProfileDtoCopyWithImpl(this._self, this._then);

  final UserProfileDto _self;
  final $Res Function(UserProfileDto) _then;

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? uid = null,
    Object? gender = null,
    Object? birthYear = null,
    Object? heightCm = null,
    Object? weightKg = null,
    Object? activityLevel = null,
    Object? dailyTargetCalories = null,
  }) {
    return _then(_self.copyWith(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      birthYear: null == birthYear
          ? _self.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _self.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _self.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      activityLevel: null == activityLevel
          ? _self.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      dailyTargetCalories: null == dailyTargetCalories
          ? _self.dailyTargetCalories
          : dailyTargetCalories // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// Adds pattern-matching-related methods to [UserProfileDto].
extension UserProfileDtoPatterns on UserProfileDto {
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
    TResult Function(_UserProfileDto value)? $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserProfileDto() when $default != null:
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
    TResult Function(_UserProfileDto value) $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfileDto():
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
    TResult? Function(_UserProfileDto value)? $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfileDto() when $default != null:
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
    TResult Function(String uid, String gender, int birthYear, double heightCm,
            double weightKg, String activityLevel, int dailyTargetCalories)?
        $default, {
    required TResult orElse(),
  }) {
    final _that = this;
    switch (_that) {
      case _UserProfileDto() when $default != null:
        return $default(
            _that.uid,
            _that.gender,
            _that.birthYear,
            _that.heightCm,
            _that.weightKg,
            _that.activityLevel,
            _that.dailyTargetCalories);
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
    TResult Function(String uid, String gender, int birthYear, double heightCm,
            double weightKg, String activityLevel, int dailyTargetCalories)
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfileDto():
        return $default(
            _that.uid,
            _that.gender,
            _that.birthYear,
            _that.heightCm,
            _that.weightKg,
            _that.activityLevel,
            _that.dailyTargetCalories);
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
    TResult? Function(String uid, String gender, int birthYear, double heightCm,
            double weightKg, String activityLevel, int dailyTargetCalories)?
        $default,
  ) {
    final _that = this;
    switch (_that) {
      case _UserProfileDto() when $default != null:
        return $default(
            _that.uid,
            _that.gender,
            _that.birthYear,
            _that.heightCm,
            _that.weightKg,
            _that.activityLevel,
            _that.dailyTargetCalories);
      case _:
        return null;
    }
  }
}

/// @nodoc
@JsonSerializable()
class _UserProfileDto implements UserProfileDto {
  const _UserProfileDto(
      {required this.uid,
      required this.gender,
      required this.birthYear,
      required this.heightCm,
      required this.weightKg,
      required this.activityLevel,
      required this.dailyTargetCalories});
  factory _UserProfileDto.fromJson(Map<String, dynamic> json) =>
      _$UserProfileDtoFromJson(json);

  @override
  final String uid;
  @override
  final String gender;
  @override
  final int birthYear;
  @override
  final double heightCm;
  @override
  final double weightKg;
  @override
  final String activityLevel;
  @override
  final int dailyTargetCalories;

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  @pragma('vm:prefer-inline')
  _$UserProfileDtoCopyWith<_UserProfileDto> get copyWith =>
      __$UserProfileDtoCopyWithImpl<_UserProfileDto>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$UserProfileDtoToJson(
      this,
    );
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _UserProfileDto &&
            (identical(other.uid, uid) || other.uid == uid) &&
            (identical(other.gender, gender) || other.gender == gender) &&
            (identical(other.birthYear, birthYear) ||
                other.birthYear == birthYear) &&
            (identical(other.heightCm, heightCm) ||
                other.heightCm == heightCm) &&
            (identical(other.weightKg, weightKg) ||
                other.weightKg == weightKg) &&
            (identical(other.activityLevel, activityLevel) ||
                other.activityLevel == activityLevel) &&
            (identical(other.dailyTargetCalories, dailyTargetCalories) ||
                other.dailyTargetCalories == dailyTargetCalories));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, uid, gender, birthYear, heightCm,
      weightKg, activityLevel, dailyTargetCalories);

  @override
  String toString() {
    return 'UserProfileDto(uid: $uid, gender: $gender, birthYear: $birthYear, heightCm: $heightCm, weightKg: $weightKg, activityLevel: $activityLevel, dailyTargetCalories: $dailyTargetCalories)';
  }
}

/// @nodoc
abstract mixin class _$UserProfileDtoCopyWith<$Res>
    implements $UserProfileDtoCopyWith<$Res> {
  factory _$UserProfileDtoCopyWith(
          _UserProfileDto value, $Res Function(_UserProfileDto) _then) =
      __$UserProfileDtoCopyWithImpl;
  @override
  @useResult
  $Res call(
      {String uid,
      String gender,
      int birthYear,
      double heightCm,
      double weightKg,
      String activityLevel,
      int dailyTargetCalories});
}

/// @nodoc
class __$UserProfileDtoCopyWithImpl<$Res>
    implements _$UserProfileDtoCopyWith<$Res> {
  __$UserProfileDtoCopyWithImpl(this._self, this._then);

  final _UserProfileDto _self;
  final $Res Function(_UserProfileDto) _then;

  /// Create a copy of UserProfileDto
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $Res call({
    Object? uid = null,
    Object? gender = null,
    Object? birthYear = null,
    Object? heightCm = null,
    Object? weightKg = null,
    Object? activityLevel = null,
    Object? dailyTargetCalories = null,
  }) {
    return _then(_UserProfileDto(
      uid: null == uid
          ? _self.uid
          : uid // ignore: cast_nullable_to_non_nullable
              as String,
      gender: null == gender
          ? _self.gender
          : gender // ignore: cast_nullable_to_non_nullable
              as String,
      birthYear: null == birthYear
          ? _self.birthYear
          : birthYear // ignore: cast_nullable_to_non_nullable
              as int,
      heightCm: null == heightCm
          ? _self.heightCm
          : heightCm // ignore: cast_nullable_to_non_nullable
              as double,
      weightKg: null == weightKg
          ? _self.weightKg
          : weightKg // ignore: cast_nullable_to_non_nullable
              as double,
      activityLevel: null == activityLevel
          ? _self.activityLevel
          : activityLevel // ignore: cast_nullable_to_non_nullable
              as String,
      dailyTargetCalories: null == dailyTargetCalories
          ? _self.dailyTargetCalories
          : dailyTargetCalories // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

// dart format on
