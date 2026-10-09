// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetListState {

 BudgetListStatus get status; List<BudgetProgress> get budgets;/// Every category (hidden ones too), by id.
 Map<int, Category> get categories; Failure? get loadFailure;/// A delete that failed; the row was restored.
 Failure? get actionFailure;
/// Create a copy of BudgetListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetListStateCopyWith<BudgetListState> get copyWith => _$BudgetListStateCopyWithImpl<BudgetListState>(this as BudgetListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.budgets, budgets)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(budgets),const DeepCollectionEquality().hash(categories),loadFailure,actionFailure);

@override
String toString() {
  return 'BudgetListState(status: $status, budgets: $budgets, categories: $categories, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class $BudgetListStateCopyWith<$Res>  {
  factory $BudgetListStateCopyWith(BudgetListState value, $Res Function(BudgetListState) _then) = _$BudgetListStateCopyWithImpl;
@useResult
$Res call({
 BudgetListStatus status, List<BudgetProgress> budgets, Map<int, Category> categories, Failure? loadFailure, Failure? actionFailure
});


$FailureCopyWith<$Res>? get loadFailure;$FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class _$BudgetListStateCopyWithImpl<$Res>
    implements $BudgetListStateCopyWith<$Res> {
  _$BudgetListStateCopyWithImpl(this._self, this._then);

  final BudgetListState _self;
  final $Res Function(BudgetListState) _then;

/// Create a copy of BudgetListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? budgets = null,Object? categories = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetListStatus,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<BudgetProgress>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of BudgetListState
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
}/// Create a copy of BudgetListState
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


/// Adds pattern-matching-related methods to [BudgetListState].
extension BudgetListStatePatterns on BudgetListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetListState value)  $default,){
final _that = this;
switch (_that) {
case _BudgetListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetListState value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( BudgetListStatus status,  List<BudgetProgress> budgets,  Map<int, Category> categories,  Failure? loadFailure,  Failure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetListState() when $default != null:
return $default(_that.status,_that.budgets,_that.categories,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( BudgetListStatus status,  List<BudgetProgress> budgets,  Map<int, Category> categories,  Failure? loadFailure,  Failure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _BudgetListState():
return $default(_that.status,_that.budgets,_that.categories,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( BudgetListStatus status,  List<BudgetProgress> budgets,  Map<int, Category> categories,  Failure? loadFailure,  Failure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _BudgetListState() when $default != null:
return $default(_that.status,_that.budgets,_that.categories,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetListState extends BudgetListState {
  const _BudgetListState({this.status = BudgetListStatus.loading, final  List<BudgetProgress> budgets = const <BudgetProgress>[], final  Map<int, Category> categories = const <int, Category>{}, this.loadFailure, this.actionFailure}): _budgets = budgets,_categories = categories,super._();
  

@override@JsonKey() final  BudgetListStatus status;
 final  List<BudgetProgress> _budgets;
@override@JsonKey() List<BudgetProgress> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
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
/// A delete that failed; the row was restored.
@override final  Failure? actionFailure;

/// Create a copy of BudgetListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetListStateCopyWith<_BudgetListState> get copyWith => __$BudgetListStateCopyWithImpl<_BudgetListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetListState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._budgets, _budgets)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_budgets),const DeepCollectionEquality().hash(_categories),loadFailure,actionFailure);

@override
String toString() {
  return 'BudgetListState(status: $status, budgets: $budgets, categories: $categories, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$BudgetListStateCopyWith<$Res> implements $BudgetListStateCopyWith<$Res> {
  factory _$BudgetListStateCopyWith(_BudgetListState value, $Res Function(_BudgetListState) _then) = __$BudgetListStateCopyWithImpl;
@override @useResult
$Res call({
 BudgetListStatus status, List<BudgetProgress> budgets, Map<int, Category> categories, Failure? loadFailure, Failure? actionFailure
});


@override $FailureCopyWith<$Res>? get loadFailure;@override $FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class __$BudgetListStateCopyWithImpl<$Res>
    implements _$BudgetListStateCopyWith<$Res> {
  __$BudgetListStateCopyWithImpl(this._self, this._then);

  final _BudgetListState _self;
  final $Res Function(_BudgetListState) _then;

/// Create a copy of BudgetListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? budgets = null,Object? categories = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_BudgetListState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetListStatus,budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<BudgetProgress>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of BudgetListState
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
}/// Create a copy of BudgetListState
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
