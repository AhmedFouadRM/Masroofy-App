// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'data_management_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$DataManagementState {

/// The action in progress; further taps are ignored meanwhile.
 DataAction? get busy;/// A backup that was picked and checked, awaiting the user's confirmation.
 PickedBackup? get pendingRestore;/// The action that just finished; reset when the next one starts, so the
/// screen's listener sees every completion.
 DataAction? get completed;/// The action that just failed, and why.
 DataAction? get failedAction; Failure? get failure;
/// Create a copy of DataManagementState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$DataManagementStateCopyWith<DataManagementState> get copyWith => _$DataManagementStateCopyWithImpl<DataManagementState>(this as DataManagementState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is DataManagementState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.pendingRestore, pendingRestore) || other.pendingRestore == pendingRestore)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.failedAction, failedAction) || other.failedAction == failedAction)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,busy,pendingRestore,completed,failedAction,failure);

@override
String toString() {
  return 'DataManagementState(busy: $busy, pendingRestore: $pendingRestore, completed: $completed, failedAction: $failedAction, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $DataManagementStateCopyWith<$Res>  {
  factory $DataManagementStateCopyWith(DataManagementState value, $Res Function(DataManagementState) _then) = _$DataManagementStateCopyWithImpl;
@useResult
$Res call({
 DataAction? busy, PickedBackup? pendingRestore, DataAction? completed, DataAction? failedAction, Failure? failure
});


$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$DataManagementStateCopyWithImpl<$Res>
    implements $DataManagementStateCopyWith<$Res> {
  _$DataManagementStateCopyWithImpl(this._self, this._then);

  final DataManagementState _self;
  final $Res Function(DataManagementState) _then;

/// Create a copy of DataManagementState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? busy = freezed,Object? pendingRestore = freezed,Object? completed = freezed,Object? failedAction = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
busy: freezed == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as DataAction?,pendingRestore: freezed == pendingRestore ? _self.pendingRestore : pendingRestore // ignore: cast_nullable_to_non_nullable
as PickedBackup?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as DataAction?,failedAction: freezed == failedAction ? _self.failedAction : failedAction // ignore: cast_nullable_to_non_nullable
as DataAction?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of DataManagementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [DataManagementState].
extension DataManagementStatePatterns on DataManagementState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _DataManagementState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _DataManagementState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _DataManagementState value)  $default,){
final _that = this;
switch (_that) {
case _DataManagementState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _DataManagementState value)?  $default,){
final _that = this;
switch (_that) {
case _DataManagementState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DataAction? busy,  PickedBackup? pendingRestore,  DataAction? completed,  DataAction? failedAction,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _DataManagementState() when $default != null:
return $default(_that.busy,_that.pendingRestore,_that.completed,_that.failedAction,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DataAction? busy,  PickedBackup? pendingRestore,  DataAction? completed,  DataAction? failedAction,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _DataManagementState():
return $default(_that.busy,_that.pendingRestore,_that.completed,_that.failedAction,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DataAction? busy,  PickedBackup? pendingRestore,  DataAction? completed,  DataAction? failedAction,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _DataManagementState() when $default != null:
return $default(_that.busy,_that.pendingRestore,_that.completed,_that.failedAction,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _DataManagementState implements DataManagementState {
  const _DataManagementState({this.busy, this.pendingRestore, this.completed, this.failedAction, this.failure});
  

/// The action in progress; further taps are ignored meanwhile.
@override final  DataAction? busy;
/// A backup that was picked and checked, awaiting the user's confirmation.
@override final  PickedBackup? pendingRestore;
/// The action that just finished; reset when the next one starts, so the
/// screen's listener sees every completion.
@override final  DataAction? completed;
/// The action that just failed, and why.
@override final  DataAction? failedAction;
@override final  Failure? failure;

/// Create a copy of DataManagementState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$DataManagementStateCopyWith<_DataManagementState> get copyWith => __$DataManagementStateCopyWithImpl<_DataManagementState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _DataManagementState&&(identical(other.busy, busy) || other.busy == busy)&&(identical(other.pendingRestore, pendingRestore) || other.pendingRestore == pendingRestore)&&(identical(other.completed, completed) || other.completed == completed)&&(identical(other.failedAction, failedAction) || other.failedAction == failedAction)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,busy,pendingRestore,completed,failedAction,failure);

@override
String toString() {
  return 'DataManagementState(busy: $busy, pendingRestore: $pendingRestore, completed: $completed, failedAction: $failedAction, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$DataManagementStateCopyWith<$Res> implements $DataManagementStateCopyWith<$Res> {
  factory _$DataManagementStateCopyWith(_DataManagementState value, $Res Function(_DataManagementState) _then) = __$DataManagementStateCopyWithImpl;
@override @useResult
$Res call({
 DataAction? busy, PickedBackup? pendingRestore, DataAction? completed, DataAction? failedAction, Failure? failure
});


@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$DataManagementStateCopyWithImpl<$Res>
    implements _$DataManagementStateCopyWith<$Res> {
  __$DataManagementStateCopyWithImpl(this._self, this._then);

  final _DataManagementState _self;
  final $Res Function(_DataManagementState) _then;

/// Create a copy of DataManagementState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? busy = freezed,Object? pendingRestore = freezed,Object? completed = freezed,Object? failedAction = freezed,Object? failure = freezed,}) {
  return _then(_DataManagementState(
busy: freezed == busy ? _self.busy : busy // ignore: cast_nullable_to_non_nullable
as DataAction?,pendingRestore: freezed == pendingRestore ? _self.pendingRestore : pendingRestore // ignore: cast_nullable_to_non_nullable
as PickedBackup?,completed: freezed == completed ? _self.completed : completed // ignore: cast_nullable_to_non_nullable
as DataAction?,failedAction: freezed == failedAction ? _self.failedAction : failedAction // ignore: cast_nullable_to_non_nullable
as DataAction?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of DataManagementState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
