// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetDraft {

 int get categoryId; Money get limit; BudgetPeriod get period;
/// Create a copy of BudgetDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetDraftCopyWith<BudgetDraft> get copyWith => _$BudgetDraftCopyWithImpl<BudgetDraft>(this as BudgetDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetDraft&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,limit,period);

@override
String toString() {
  return 'BudgetDraft(categoryId: $categoryId, limit: $limit, period: $period)';
}


}

/// @nodoc
abstract mixin class $BudgetDraftCopyWith<$Res>  {
  factory $BudgetDraftCopyWith(BudgetDraft value, $Res Function(BudgetDraft) _then) = _$BudgetDraftCopyWithImpl;
@useResult
$Res call({
 int categoryId, Money limit, BudgetPeriod period
});




}
/// @nodoc
class _$BudgetDraftCopyWithImpl<$Res>
    implements $BudgetDraftCopyWith<$Res> {
  _$BudgetDraftCopyWithImpl(this._self, this._then);

  final BudgetDraft _self;
  final $Res Function(BudgetDraft) _then;

/// Create a copy of BudgetDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? categoryId = null,Object? limit = null,Object? period = null,}) {
  return _then(_self.copyWith(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as Money,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as BudgetPeriod,
  ));
}

}


/// Adds pattern-matching-related methods to [BudgetDraft].
extension BudgetDraftPatterns on BudgetDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetDraft value)  $default,){
final _that = this;
switch (_that) {
case _BudgetDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetDraft value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int categoryId,  Money limit,  BudgetPeriod period)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetDraft() when $default != null:
return $default(_that.categoryId,_that.limit,_that.period);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int categoryId,  Money limit,  BudgetPeriod period)  $default,) {final _that = this;
switch (_that) {
case _BudgetDraft():
return $default(_that.categoryId,_that.limit,_that.period);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int categoryId,  Money limit,  BudgetPeriod period)?  $default,) {final _that = this;
switch (_that) {
case _BudgetDraft() when $default != null:
return $default(_that.categoryId,_that.limit,_that.period);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetDraft implements BudgetDraft {
  const _BudgetDraft({required this.categoryId, required this.limit, required this.period});
  

@override final  int categoryId;
@override final  Money limit;
@override final  BudgetPeriod period;

/// Create a copy of BudgetDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetDraftCopyWith<_BudgetDraft> get copyWith => __$BudgetDraftCopyWithImpl<_BudgetDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetDraft&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limit, limit) || other.limit == limit)&&(identical(other.period, period) || other.period == period));
}


@override
int get hashCode => Object.hash(runtimeType,categoryId,limit,period);

@override
String toString() {
  return 'BudgetDraft(categoryId: $categoryId, limit: $limit, period: $period)';
}


}

/// @nodoc
abstract mixin class _$BudgetDraftCopyWith<$Res> implements $BudgetDraftCopyWith<$Res> {
  factory _$BudgetDraftCopyWith(_BudgetDraft value, $Res Function(_BudgetDraft) _then) = __$BudgetDraftCopyWithImpl;
@override @useResult
$Res call({
 int categoryId, Money limit, BudgetPeriod period
});




}
/// @nodoc
class __$BudgetDraftCopyWithImpl<$Res>
    implements _$BudgetDraftCopyWith<$Res> {
  __$BudgetDraftCopyWithImpl(this._self, this._then);

  final _BudgetDraft _self;
  final $Res Function(_BudgetDraft) _then;

/// Create a copy of BudgetDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? categoryId = null,Object? limit = null,Object? period = null,}) {
  return _then(_BudgetDraft(
categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,limit: null == limit ? _self.limit : limit // ignore: cast_nullable_to_non_nullable
as Money,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as BudgetPeriod,
  ));
}


}

// dart format on
