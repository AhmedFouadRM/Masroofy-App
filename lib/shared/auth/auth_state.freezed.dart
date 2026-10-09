// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'auth_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AuthState {

/// App Lock is on (a PIN is set).
 bool get isEnabled;/// The lock screen must be shown. Starts true on a cold launch with the lock on.
 bool get isLocked;/// The user opted into fingerprint / face unlock.
 bool get biometricEnabled;/// The device has enrolled biometrics.
 bool get biometricAvailable;/// Consecutive wrong PINs; persisted so a restart doesn't reset it.
 int get failedAttempts;/// The current delay ends at this time, if one applies.
 DateTime? get lockedUntil;
/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AuthStateCopyWith<AuthState> get copyWith => _$AuthStateCopyWithImpl<AuthState>(this as AuthState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AuthState&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.biometricAvailable, biometricAvailable) || other.biometricAvailable == biometricAvailable)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil));
}


@override
int get hashCode => Object.hash(runtimeType,isEnabled,isLocked,biometricEnabled,biometricAvailable,failedAttempts,lockedUntil);

@override
String toString() {
  return 'AuthState(isEnabled: $isEnabled, isLocked: $isLocked, biometricEnabled: $biometricEnabled, biometricAvailable: $biometricAvailable, failedAttempts: $failedAttempts, lockedUntil: $lockedUntil)';
}


}

/// @nodoc
abstract mixin class $AuthStateCopyWith<$Res>  {
  factory $AuthStateCopyWith(AuthState value, $Res Function(AuthState) _then) = _$AuthStateCopyWithImpl;
@useResult
$Res call({
 bool isEnabled, bool isLocked, bool biometricEnabled, bool biometricAvailable, int failedAttempts, DateTime? lockedUntil
});




}
/// @nodoc
class _$AuthStateCopyWithImpl<$Res>
    implements $AuthStateCopyWith<$Res> {
  _$AuthStateCopyWithImpl(this._self, this._then);

  final AuthState _self;
  final $Res Function(AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? isEnabled = null,Object? isLocked = null,Object? biometricEnabled = null,Object? biometricAvailable = null,Object? failedAttempts = null,Object? lockedUntil = freezed,}) {
  return _then(_self.copyWith(
isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricAvailable: null == biometricAvailable ? _self.biometricAvailable : biometricAvailable // ignore: cast_nullable_to_non_nullable
as bool,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}

}


/// Adds pattern-matching-related methods to [AuthState].
extension AuthStatePatterns on AuthState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AuthState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AuthState value)  $default,){
final _that = this;
switch (_that) {
case _AuthState():
return $default(_that);case _:
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AuthState value)?  $default,){
final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool isEnabled,  bool isLocked,  bool biometricEnabled,  bool biometricAvailable,  int failedAttempts,  DateTime? lockedUntil)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.isEnabled,_that.isLocked,_that.biometricEnabled,_that.biometricAvailable,_that.failedAttempts,_that.lockedUntil);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool isEnabled,  bool isLocked,  bool biometricEnabled,  bool biometricAvailable,  int failedAttempts,  DateTime? lockedUntil)  $default,) {final _that = this;
switch (_that) {
case _AuthState():
return $default(_that.isEnabled,_that.isLocked,_that.biometricEnabled,_that.biometricAvailable,_that.failedAttempts,_that.lockedUntil);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool isEnabled,  bool isLocked,  bool biometricEnabled,  bool biometricAvailable,  int failedAttempts,  DateTime? lockedUntil)?  $default,) {final _that = this;
switch (_that) {
case _AuthState() when $default != null:
return $default(_that.isEnabled,_that.isLocked,_that.biometricEnabled,_that.biometricAvailable,_that.failedAttempts,_that.lockedUntil);case _:
  return null;

}
}

}

/// @nodoc


class _AuthState extends AuthState {
  const _AuthState({required this.isEnabled, required this.isLocked, this.biometricEnabled = false, this.biometricAvailable = false, this.failedAttempts = 0, this.lockedUntil}): super._();
  

/// App Lock is on (a PIN is set).
@override final  bool isEnabled;
/// The lock screen must be shown. Starts true on a cold launch with the lock on.
@override final  bool isLocked;
/// The user opted into fingerprint / face unlock.
@override@JsonKey() final  bool biometricEnabled;
/// The device has enrolled biometrics.
@override@JsonKey() final  bool biometricAvailable;
/// Consecutive wrong PINs; persisted so a restart doesn't reset it.
@override@JsonKey() final  int failedAttempts;
/// The current delay ends at this time, if one applies.
@override final  DateTime? lockedUntil;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AuthStateCopyWith<_AuthState> get copyWith => __$AuthStateCopyWithImpl<_AuthState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AuthState&&(identical(other.isEnabled, isEnabled) || other.isEnabled == isEnabled)&&(identical(other.isLocked, isLocked) || other.isLocked == isLocked)&&(identical(other.biometricEnabled, biometricEnabled) || other.biometricEnabled == biometricEnabled)&&(identical(other.biometricAvailable, biometricAvailable) || other.biometricAvailable == biometricAvailable)&&(identical(other.failedAttempts, failedAttempts) || other.failedAttempts == failedAttempts)&&(identical(other.lockedUntil, lockedUntil) || other.lockedUntil == lockedUntil));
}


@override
int get hashCode => Object.hash(runtimeType,isEnabled,isLocked,biometricEnabled,biometricAvailable,failedAttempts,lockedUntil);

@override
String toString() {
  return 'AuthState(isEnabled: $isEnabled, isLocked: $isLocked, biometricEnabled: $biometricEnabled, biometricAvailable: $biometricAvailable, failedAttempts: $failedAttempts, lockedUntil: $lockedUntil)';
}


}

/// @nodoc
abstract mixin class _$AuthStateCopyWith<$Res> implements $AuthStateCopyWith<$Res> {
  factory _$AuthStateCopyWith(_AuthState value, $Res Function(_AuthState) _then) = __$AuthStateCopyWithImpl;
@override @useResult
$Res call({
 bool isEnabled, bool isLocked, bool biometricEnabled, bool biometricAvailable, int failedAttempts, DateTime? lockedUntil
});




}
/// @nodoc
class __$AuthStateCopyWithImpl<$Res>
    implements _$AuthStateCopyWith<$Res> {
  __$AuthStateCopyWithImpl(this._self, this._then);

  final _AuthState _self;
  final $Res Function(_AuthState) _then;

/// Create a copy of AuthState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? isEnabled = null,Object? isLocked = null,Object? biometricEnabled = null,Object? biometricAvailable = null,Object? failedAttempts = null,Object? lockedUntil = freezed,}) {
  return _then(_AuthState(
isEnabled: null == isEnabled ? _self.isEnabled : isEnabled // ignore: cast_nullable_to_non_nullable
as bool,isLocked: null == isLocked ? _self.isLocked : isLocked // ignore: cast_nullable_to_non_nullable
as bool,biometricEnabled: null == biometricEnabled ? _self.biometricEnabled : biometricEnabled // ignore: cast_nullable_to_non_nullable
as bool,biometricAvailable: null == biometricAvailable ? _self.biometricAvailable : biometricAvailable // ignore: cast_nullable_to_non_nullable
as bool,failedAttempts: null == failedAttempts ? _self.failedAttempts : failedAttempts // ignore: cast_nullable_to_non_nullable
as int,lockedUntil: freezed == lockedUntil ? _self.lockedUntil : lockedUntil // ignore: cast_nullable_to_non_nullable
as DateTime?,
  ));
}


}

// dart format on
