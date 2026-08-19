// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_progress.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetProgress {

 Budget get budget; double get spent; double get remaining; double get percentage; BudgetStatus get status;
/// Create a copy of BudgetProgress
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetProgressCopyWith<BudgetProgress> get copyWith => _$BudgetProgressCopyWithImpl<BudgetProgress>(this as BudgetProgress, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetProgress&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,budget,spent,remaining,percentage,status);

@override
String toString() {
  return 'BudgetProgress(budget: $budget, spent: $spent, remaining: $remaining, percentage: $percentage, status: $status)';
}


}

/// @nodoc
abstract mixin class $BudgetProgressCopyWith<$Res>  {
  factory $BudgetProgressCopyWith(BudgetProgress value, $Res Function(BudgetProgress) _then) = _$BudgetProgressCopyWithImpl;
@useResult
$Res call({
 Budget budget, double spent, double remaining, double percentage, BudgetStatus status
});


$BudgetCopyWith<$Res> get budget;

}
/// @nodoc
class _$BudgetProgressCopyWithImpl<$Res>
    implements $BudgetProgressCopyWith<$Res> {
  _$BudgetProgressCopyWithImpl(this._self, this._then);

  final BudgetProgress _self;
  final $Res Function(BudgetProgress) _then;

/// Create a copy of BudgetProgress
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? budget = null,Object? spent = null,Object? remaining = null,Object? percentage = null,Object? status = null,}) {
  return _then(_self.copyWith(
budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetStatus,
  ));
}
/// Create a copy of BudgetProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res> get budget {
  
  return $BudgetCopyWith<$Res>(_self.budget, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}


/// Adds pattern-matching-related methods to [BudgetProgress].
extension BudgetProgressPatterns on BudgetProgress {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetProgress value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetProgress() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetProgress value)  $default,){
final _that = this;
switch (_that) {
case _BudgetProgress():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetProgress value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetProgress() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Budget budget,  double spent,  double remaining,  double percentage,  BudgetStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetProgress() when $default != null:
return $default(_that.budget,_that.spent,_that.remaining,_that.percentage,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Budget budget,  double spent,  double remaining,  double percentage,  BudgetStatus status)  $default,) {final _that = this;
switch (_that) {
case _BudgetProgress():
return $default(_that.budget,_that.spent,_that.remaining,_that.percentage,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Budget budget,  double spent,  double remaining,  double percentage,  BudgetStatus status)?  $default,) {final _that = this;
switch (_that) {
case _BudgetProgress() when $default != null:
return $default(_that.budget,_that.spent,_that.remaining,_that.percentage,_that.status);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetProgress implements BudgetProgress {
  const _BudgetProgress({required this.budget, required this.spent, required this.remaining, required this.percentage, required this.status});
  

@override final  Budget budget;
@override final  double spent;
@override final  double remaining;
@override final  double percentage;
@override final  BudgetStatus status;

/// Create a copy of BudgetProgress
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetProgressCopyWith<_BudgetProgress> get copyWith => __$BudgetProgressCopyWithImpl<_BudgetProgress>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetProgress&&(identical(other.budget, budget) || other.budget == budget)&&(identical(other.spent, spent) || other.spent == spent)&&(identical(other.remaining, remaining) || other.remaining == remaining)&&(identical(other.percentage, percentage) || other.percentage == percentage)&&(identical(other.status, status) || other.status == status));
}


@override
int get hashCode => Object.hash(runtimeType,budget,spent,remaining,percentage,status);

@override
String toString() {
  return 'BudgetProgress(budget: $budget, spent: $spent, remaining: $remaining, percentage: $percentage, status: $status)';
}


}

/// @nodoc
abstract mixin class _$BudgetProgressCopyWith<$Res> implements $BudgetProgressCopyWith<$Res> {
  factory _$BudgetProgressCopyWith(_BudgetProgress value, $Res Function(_BudgetProgress) _then) = __$BudgetProgressCopyWithImpl;
@override @useResult
$Res call({
 Budget budget, double spent, double remaining, double percentage, BudgetStatus status
});


@override $BudgetCopyWith<$Res> get budget;

}
/// @nodoc
class __$BudgetProgressCopyWithImpl<$Res>
    implements _$BudgetProgressCopyWith<$Res> {
  __$BudgetProgressCopyWithImpl(this._self, this._then);

  final _BudgetProgress _self;
  final $Res Function(_BudgetProgress) _then;

/// Create a copy of BudgetProgress
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? budget = null,Object? spent = null,Object? remaining = null,Object? percentage = null,Object? status = null,}) {
  return _then(_BudgetProgress(
budget: null == budget ? _self.budget : budget // ignore: cast_nullable_to_non_nullable
as Budget,spent: null == spent ? _self.spent : spent // ignore: cast_nullable_to_non_nullable
as double,remaining: null == remaining ? _self.remaining : remaining // ignore: cast_nullable_to_non_nullable
as double,percentage: null == percentage ? _self.percentage : percentage // ignore: cast_nullable_to_non_nullable
as double,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetStatus,
  ));
}

/// Create a copy of BudgetProgress
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$BudgetCopyWith<$Res> get budget {
  
  return $BudgetCopyWith<$Res>(_self.budget, (value) {
    return _then(_self.copyWith(budget: value));
  });
}
}

// dart format on
