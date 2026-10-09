// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'pin_setup_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$PinSetupState {

 PinSetupStep get step;/// The digits typed on the current step.
 String get entry;/// The PIN from the create step, to compare the confirmation with.
 String get firstPin;/// The confirmation differed from the first PIN. Cleared by the next key.
 bool get mismatch;/// Set once both entries match; the screen then stores the PIN.
 String? get confirmedPin;
/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PinSetupStateCopyWith<PinSetupState> get copyWith => _$PinSetupStateCopyWithImpl<PinSetupState>(this as PinSetupState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PinSetupState&&(identical(other.step, step) || other.step == step)&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.firstPin, firstPin) || other.firstPin == firstPin)&&(identical(other.mismatch, mismatch) || other.mismatch == mismatch)&&(identical(other.confirmedPin, confirmedPin) || other.confirmedPin == confirmedPin));
}


@override
int get hashCode => Object.hash(runtimeType,step,entry,firstPin,mismatch,confirmedPin);

@override
String toString() {
  return 'PinSetupState(step: $step, entry: $entry, firstPin: $firstPin, mismatch: $mismatch, confirmedPin: $confirmedPin)';
}


}

/// @nodoc
abstract mixin class $PinSetupStateCopyWith<$Res>  {
  factory $PinSetupStateCopyWith(PinSetupState value, $Res Function(PinSetupState) _then) = _$PinSetupStateCopyWithImpl;
@useResult
$Res call({
 PinSetupStep step, String entry, String firstPin, bool mismatch, String? confirmedPin
});




}
/// @nodoc
class _$PinSetupStateCopyWithImpl<$Res>
    implements $PinSetupStateCopyWith<$Res> {
  _$PinSetupStateCopyWithImpl(this._self, this._then);

  final PinSetupState _self;
  final $Res Function(PinSetupState) _then;

/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? step = null,Object? entry = null,Object? firstPin = null,Object? mismatch = null,Object? confirmedPin = freezed,}) {
  return _then(_self.copyWith(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as PinSetupStep,entry: null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as String,firstPin: null == firstPin ? _self.firstPin : firstPin // ignore: cast_nullable_to_non_nullable
as String,mismatch: null == mismatch ? _self.mismatch : mismatch // ignore: cast_nullable_to_non_nullable
as bool,confirmedPin: freezed == confirmedPin ? _self.confirmedPin : confirmedPin // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [PinSetupState].
extension PinSetupStatePatterns on PinSetupState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PinSetupState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PinSetupState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PinSetupState value)  $default,){
final _that = this;
switch (_that) {
case _PinSetupState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PinSetupState value)?  $default,){
final _that = this;
switch (_that) {
case _PinSetupState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( PinSetupStep step,  String entry,  String firstPin,  bool mismatch,  String? confirmedPin)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PinSetupState() when $default != null:
return $default(_that.step,_that.entry,_that.firstPin,_that.mismatch,_that.confirmedPin);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( PinSetupStep step,  String entry,  String firstPin,  bool mismatch,  String? confirmedPin)  $default,) {final _that = this;
switch (_that) {
case _PinSetupState():
return $default(_that.step,_that.entry,_that.firstPin,_that.mismatch,_that.confirmedPin);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( PinSetupStep step,  String entry,  String firstPin,  bool mismatch,  String? confirmedPin)?  $default,) {final _that = this;
switch (_that) {
case _PinSetupState() when $default != null:
return $default(_that.step,_that.entry,_that.firstPin,_that.mismatch,_that.confirmedPin);case _:
  return null;

}
}

}

/// @nodoc


class _PinSetupState implements PinSetupState {
  const _PinSetupState({this.step = PinSetupStep.create, this.entry = '', this.firstPin = '', this.mismatch = false, this.confirmedPin});
  

@override@JsonKey() final  PinSetupStep step;
/// The digits typed on the current step.
@override@JsonKey() final  String entry;
/// The PIN from the create step, to compare the confirmation with.
@override@JsonKey() final  String firstPin;
/// The confirmation differed from the first PIN. Cleared by the next key.
@override@JsonKey() final  bool mismatch;
/// Set once both entries match; the screen then stores the PIN.
@override final  String? confirmedPin;

/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PinSetupStateCopyWith<_PinSetupState> get copyWith => __$PinSetupStateCopyWithImpl<_PinSetupState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _PinSetupState&&(identical(other.step, step) || other.step == step)&&(identical(other.entry, entry) || other.entry == entry)&&(identical(other.firstPin, firstPin) || other.firstPin == firstPin)&&(identical(other.mismatch, mismatch) || other.mismatch == mismatch)&&(identical(other.confirmedPin, confirmedPin) || other.confirmedPin == confirmedPin));
}


@override
int get hashCode => Object.hash(runtimeType,step,entry,firstPin,mismatch,confirmedPin);

@override
String toString() {
  return 'PinSetupState(step: $step, entry: $entry, firstPin: $firstPin, mismatch: $mismatch, confirmedPin: $confirmedPin)';
}


}

/// @nodoc
abstract mixin class _$PinSetupStateCopyWith<$Res> implements $PinSetupStateCopyWith<$Res> {
  factory _$PinSetupStateCopyWith(_PinSetupState value, $Res Function(_PinSetupState) _then) = __$PinSetupStateCopyWithImpl;
@override @useResult
$Res call({
 PinSetupStep step, String entry, String firstPin, bool mismatch, String? confirmedPin
});




}
/// @nodoc
class __$PinSetupStateCopyWithImpl<$Res>
    implements _$PinSetupStateCopyWith<$Res> {
  __$PinSetupStateCopyWithImpl(this._self, this._then);

  final _PinSetupState _self;
  final $Res Function(_PinSetupState) _then;

/// Create a copy of PinSetupState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? step = null,Object? entry = null,Object? firstPin = null,Object? mismatch = null,Object? confirmedPin = freezed,}) {
  return _then(_PinSetupState(
step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as PinSetupStep,entry: null == entry ? _self.entry : entry // ignore: cast_nullable_to_non_nullable
as String,firstPin: null == firstPin ? _self.firstPin : firstPin // ignore: cast_nullable_to_non_nullable
as String,mismatch: null == mismatch ? _self.mismatch : mismatch // ignore: cast_nullable_to_non_nullable
as bool,confirmedPin: freezed == confirmedPin ? _self.confirmedPin : confirmedPin // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
