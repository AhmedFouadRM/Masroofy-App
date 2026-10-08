// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringListState {

 RecurringListStatus get status;/// Active first, each group by next due date.
 List<RecurringExpense> get templates;/// Every category (hidden ones too), by id.
 Map<int, Category> get categories; Failure? get loadFailure;/// A pause, resume or delete that failed; the row was restored.
 Failure? get actionFailure;
/// Create a copy of RecurringListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringListStateCopyWith<RecurringListState> get copyWith => _$RecurringListStateCopyWithImpl<RecurringListState>(this as RecurringListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.templates, templates)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(templates),const DeepCollectionEquality().hash(categories),loadFailure,actionFailure);

@override
String toString() {
  return 'RecurringListState(status: $status, templates: $templates, categories: $categories, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class $RecurringListStateCopyWith<$Res>  {
  factory $RecurringListStateCopyWith(RecurringListState value, $Res Function(RecurringListState) _then) = _$RecurringListStateCopyWithImpl;
@useResult
$Res call({
 RecurringListStatus status, List<RecurringExpense> templates, Map<int, Category> categories, Failure? loadFailure, Failure? actionFailure
});


$FailureCopyWith<$Res>? get loadFailure;$FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class _$RecurringListStateCopyWithImpl<$Res>
    implements $RecurringListStateCopyWith<$Res> {
  _$RecurringListStateCopyWithImpl(this._self, this._then);

  final RecurringListState _self;
  final $Res Function(RecurringListState) _then;

/// Create a copy of RecurringListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? templates = null,Object? categories = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecurringListStatus,templates: null == templates ? _self.templates : templates // ignore: cast_nullable_to_non_nullable
as List<RecurringExpense>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of RecurringListState
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
}/// Create a copy of RecurringListState
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


/// Adds pattern-matching-related methods to [RecurringListState].
extension RecurringListStatePatterns on RecurringListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringListState value)  $default,){
final _that = this;
switch (_that) {
case _RecurringListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringListState value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( RecurringListStatus status,  List<RecurringExpense> templates,  Map<int, Category> categories,  Failure? loadFailure,  Failure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringListState() when $default != null:
return $default(_that.status,_that.templates,_that.categories,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( RecurringListStatus status,  List<RecurringExpense> templates,  Map<int, Category> categories,  Failure? loadFailure,  Failure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _RecurringListState():
return $default(_that.status,_that.templates,_that.categories,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( RecurringListStatus status,  List<RecurringExpense> templates,  Map<int, Category> categories,  Failure? loadFailure,  Failure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _RecurringListState() when $default != null:
return $default(_that.status,_that.templates,_that.categories,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringListState extends RecurringListState {
  const _RecurringListState({this.status = RecurringListStatus.loading, final  List<RecurringExpense> templates = const <RecurringExpense>[], final  Map<int, Category> categories = const <int, Category>{}, this.loadFailure, this.actionFailure}): _templates = templates,_categories = categories,super._();
  

@override@JsonKey() final  RecurringListStatus status;
/// Active first, each group by next due date.
 final  List<RecurringExpense> _templates;
/// Active first, each group by next due date.
@override@JsonKey() List<RecurringExpense> get templates {
  if (_templates is EqualUnmodifiableListView) return _templates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_templates);
}

/// Every category (hidden ones too), by id.
 final  Map<int, Category> _categories;
/// Every category (hidden ones too), by id.
@override@JsonKey() Map<int, Category> get categories {
  if (_categories is EqualUnmodifiableMapView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categories);
}

@override final  Failure? loadFailure;
/// A pause, resume or delete that failed; the row was restored.
@override final  Failure? actionFailure;

/// Create a copy of RecurringListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringListStateCopyWith<_RecurringListState> get copyWith => __$RecurringListStateCopyWithImpl<_RecurringListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._templates, _templates)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_templates),const DeepCollectionEquality().hash(_categories),loadFailure,actionFailure);

@override
String toString() {
  return 'RecurringListState(status: $status, templates: $templates, categories: $categories, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$RecurringListStateCopyWith<$Res> implements $RecurringListStateCopyWith<$Res> {
  factory _$RecurringListStateCopyWith(_RecurringListState value, $Res Function(_RecurringListState) _then) = __$RecurringListStateCopyWithImpl;
@override @useResult
$Res call({
 RecurringListStatus status, List<RecurringExpense> templates, Map<int, Category> categories, Failure? loadFailure, Failure? actionFailure
});


@override $FailureCopyWith<$Res>? get loadFailure;@override $FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class __$RecurringListStateCopyWithImpl<$Res>
    implements _$RecurringListStateCopyWith<$Res> {
  __$RecurringListStateCopyWithImpl(this._self, this._then);

  final _RecurringListState _self;
  final $Res Function(_RecurringListState) _then;

/// Create a copy of RecurringListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? templates = null,Object? categories = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_RecurringListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecurringListStatus,templates: null == templates ? _self._templates : templates // ignore: cast_nullable_to_non_nullable
as List<RecurringExpense>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of RecurringListState
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
}/// Create a copy of RecurringListState
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
