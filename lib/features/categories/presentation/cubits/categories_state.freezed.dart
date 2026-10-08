// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'categories_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoriesState {

 CategoriesStatus get status; List<CategorySummary> get defaults; List<CategorySummary> get custom;/// Why loading failed (`status == failure`).
 Failure? get loadFailure;/// A failed delete, shown once as a snackbar by a `BlocListener`.
 Failure? get actionFailure;
/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoriesStateCopyWith<CategoriesState> get copyWith => _$CategoriesStateCopyWithImpl<CategoriesState>(this as CategoriesState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoriesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.defaults, defaults)&&const DeepCollectionEquality().equals(other.custom, custom)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(defaults),const DeepCollectionEquality().hash(custom),loadFailure,actionFailure);

@override
String toString() {
  return 'CategoriesState(status: $status, defaults: $defaults, custom: $custom, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class $CategoriesStateCopyWith<$Res>  {
  factory $CategoriesStateCopyWith(CategoriesState value, $Res Function(CategoriesState) _then) = _$CategoriesStateCopyWithImpl;
@useResult
$Res call({
 CategoriesStatus status, List<CategorySummary> defaults, List<CategorySummary> custom, Failure? loadFailure, Failure? actionFailure
});


$FailureCopyWith<$Res>? get loadFailure;$FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class _$CategoriesStateCopyWithImpl<$Res>
    implements $CategoriesStateCopyWith<$Res> {
  _$CategoriesStateCopyWithImpl(this._self, this._then);

  final CategoriesState _self;
  final $Res Function(CategoriesState) _then;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? defaults = null,Object? custom = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CategoriesStatus,defaults: null == defaults ? _self.defaults : defaults // ignore: cast_nullable_to_non_nullable
as List<CategorySummary>,custom: null == custom ? _self.custom : custom // ignore: cast_nullable_to_non_nullable
as List<CategorySummary>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get loadFailure {
    if (_self.loadFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.loadFailure!, (value) {
    return _then(_self.copyWith(loadFailure: value));
  });
}/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get actionFailure {
    if (_self.actionFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.actionFailure!, (value) {
    return _then(_self.copyWith(actionFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoriesState].
extension CategoriesStatePatterns on CategoriesState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoriesState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoriesState value)  $default,){
final _that = this;
switch (_that) {
case _CategoriesState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoriesState value)?  $default,){
final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CategoriesStatus status,  List<CategorySummary> defaults,  List<CategorySummary> custom,  Failure? loadFailure,  Failure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
return $default(_that.status,_that.defaults,_that.custom,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CategoriesStatus status,  List<CategorySummary> defaults,  List<CategorySummary> custom,  Failure? loadFailure,  Failure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _CategoriesState():
return $default(_that.status,_that.defaults,_that.custom,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CategoriesStatus status,  List<CategorySummary> defaults,  List<CategorySummary> custom,  Failure? loadFailure,  Failure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _CategoriesState() when $default != null:
return $default(_that.status,_that.defaults,_that.custom,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _CategoriesState implements CategoriesState {
  const _CategoriesState({this.status = CategoriesStatus.loading, final  List<CategorySummary> defaults = const <CategorySummary>[], final  List<CategorySummary> custom = const <CategorySummary>[], this.loadFailure, this.actionFailure}): _defaults = defaults,_custom = custom;
  

@override@JsonKey() final  CategoriesStatus status;
 final  List<CategorySummary> _defaults;
@override@JsonKey() List<CategorySummary> get defaults {
  if (_defaults is EqualUnmodifiableListView) return _defaults;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_defaults);
}

 final  List<CategorySummary> _custom;
@override@JsonKey() List<CategorySummary> get custom {
  if (_custom is EqualUnmodifiableListView) return _custom;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_custom);
}

/// Why loading failed (`status == failure`).
@override final  Failure? loadFailure;
/// A failed delete, shown once as a snackbar by a `BlocListener`.
@override final  Failure? actionFailure;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoriesStateCopyWith<_CategoriesState> get copyWith => __$CategoriesStateCopyWithImpl<_CategoriesState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoriesState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._defaults, _defaults)&&const DeepCollectionEquality().equals(other._custom, _custom)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_defaults),const DeepCollectionEquality().hash(_custom),loadFailure,actionFailure);

@override
String toString() {
  return 'CategoriesState(status: $status, defaults: $defaults, custom: $custom, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$CategoriesStateCopyWith<$Res> implements $CategoriesStateCopyWith<$Res> {
  factory _$CategoriesStateCopyWith(_CategoriesState value, $Res Function(_CategoriesState) _then) = __$CategoriesStateCopyWithImpl;
@override @useResult
$Res call({
 CategoriesStatus status, List<CategorySummary> defaults, List<CategorySummary> custom, Failure? loadFailure, Failure? actionFailure
});


@override $FailureCopyWith<$Res>? get loadFailure;@override $FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class __$CategoriesStateCopyWithImpl<$Res>
    implements _$CategoriesStateCopyWith<$Res> {
  __$CategoriesStateCopyWithImpl(this._self, this._then);

  final _CategoriesState _self;
  final $Res Function(_CategoriesState) _then;

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? defaults = null,Object? custom = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_CategoriesState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CategoriesStatus,defaults: null == defaults ? _self._defaults : defaults // ignore: cast_nullable_to_non_nullable
as List<CategorySummary>,custom: null == custom ? _self._custom : custom // ignore: cast_nullable_to_non_nullable
as List<CategorySummary>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get loadFailure {
    if (_self.loadFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.loadFailure!, (value) {
    return _then(_self.copyWith(loadFailure: value));
  });
}/// Create a copy of CategoriesState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get actionFailure {
    if (_self.actionFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.actionFailure!, (value) {
    return _then(_self.copyWith(actionFailure: value));
  });
}
}

// dart format on
