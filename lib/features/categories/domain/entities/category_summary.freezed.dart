// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategorySummary {

 Category get category; int get expenseCount; int get recurringCount; Money? get budgetLimit; BudgetPeriod? get budgetPeriod;
/// Create a copy of CategorySummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategorySummaryCopyWith<CategorySummary> get copyWith => _$CategorySummaryCopyWithImpl<CategorySummary>(this as CategorySummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategorySummary&&(identical(other.category, category) || other.category == category)&&(identical(other.expenseCount, expenseCount) || other.expenseCount == expenseCount)&&(identical(other.recurringCount, recurringCount) || other.recurringCount == recurringCount)&&(identical(other.budgetLimit, budgetLimit) || other.budgetLimit == budgetLimit)&&(identical(other.budgetPeriod, budgetPeriod) || other.budgetPeriod == budgetPeriod));
}


@override
int get hashCode => Object.hash(runtimeType,category,expenseCount,recurringCount,budgetLimit,budgetPeriod);

@override
String toString() {
  return 'CategorySummary(category: $category, expenseCount: $expenseCount, recurringCount: $recurringCount, budgetLimit: $budgetLimit, budgetPeriod: $budgetPeriod)';
}


}

/// @nodoc
abstract mixin class $CategorySummaryCopyWith<$Res>  {
  factory $CategorySummaryCopyWith(CategorySummary value, $Res Function(CategorySummary) _then) = _$CategorySummaryCopyWithImpl;
@useResult
$Res call({
 Category category, int expenseCount, int recurringCount, Money? budgetLimit, BudgetPeriod? budgetPeriod
});


$CategoryCopyWith<$Res> get category;

}
/// @nodoc
class _$CategorySummaryCopyWithImpl<$Res>
    implements $CategorySummaryCopyWith<$Res> {
  _$CategorySummaryCopyWithImpl(this._self, this._then);

  final CategorySummary _self;
  final $Res Function(CategorySummary) _then;

/// Create a copy of CategorySummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? category = null,Object? expenseCount = null,Object? recurringCount = null,Object? budgetLimit = freezed,Object? budgetPeriod = freezed,}) {
  return _then(_self.copyWith(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,expenseCount: null == expenseCount ? _self.expenseCount : expenseCount // ignore: cast_nullable_to_non_nullable
as int,recurringCount: null == recurringCount ? _self.recurringCount : recurringCount // ignore: cast_nullable_to_non_nullable
as int,budgetLimit: freezed == budgetLimit ? _self.budgetLimit : budgetLimit // ignore: cast_nullable_to_non_nullable
as Money?,budgetPeriod: freezed == budgetPeriod ? _self.budgetPeriod : budgetPeriod // ignore: cast_nullable_to_non_nullable
as BudgetPeriod?,
  ));
}
/// Create a copy of CategorySummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategorySummary].
extension CategorySummaryPatterns on CategorySummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategorySummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategorySummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategorySummary value)  $default,){
final _that = this;
switch (_that) {
case _CategorySummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategorySummary value)?  $default,){
final _that = this;
switch (_that) {
case _CategorySummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Category category,  int expenseCount,  int recurringCount,  Money? budgetLimit,  BudgetPeriod? budgetPeriod)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategorySummary() when $default != null:
return $default(_that.category,_that.expenseCount,_that.recurringCount,_that.budgetLimit,_that.budgetPeriod);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Category category,  int expenseCount,  int recurringCount,  Money? budgetLimit,  BudgetPeriod? budgetPeriod)  $default,) {final _that = this;
switch (_that) {
case _CategorySummary():
return $default(_that.category,_that.expenseCount,_that.recurringCount,_that.budgetLimit,_that.budgetPeriod);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Category category,  int expenseCount,  int recurringCount,  Money? budgetLimit,  BudgetPeriod? budgetPeriod)?  $default,) {final _that = this;
switch (_that) {
case _CategorySummary() when $default != null:
return $default(_that.category,_that.expenseCount,_that.recurringCount,_that.budgetLimit,_that.budgetPeriod);case _:
  return null;

}
}

}

/// @nodoc


class _CategorySummary extends CategorySummary {
  const _CategorySummary({required this.category, required this.expenseCount, required this.recurringCount, this.budgetLimit, this.budgetPeriod}): super._();
  

@override final  Category category;
@override final  int expenseCount;
@override final  int recurringCount;
@override final  Money? budgetLimit;
@override final  BudgetPeriod? budgetPeriod;

/// Create a copy of CategorySummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategorySummaryCopyWith<_CategorySummary> get copyWith => __$CategorySummaryCopyWithImpl<_CategorySummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategorySummary&&(identical(other.category, category) || other.category == category)&&(identical(other.expenseCount, expenseCount) || other.expenseCount == expenseCount)&&(identical(other.recurringCount, recurringCount) || other.recurringCount == recurringCount)&&(identical(other.budgetLimit, budgetLimit) || other.budgetLimit == budgetLimit)&&(identical(other.budgetPeriod, budgetPeriod) || other.budgetPeriod == budgetPeriod));
}


@override
int get hashCode => Object.hash(runtimeType,category,expenseCount,recurringCount,budgetLimit,budgetPeriod);

@override
String toString() {
  return 'CategorySummary(category: $category, expenseCount: $expenseCount, recurringCount: $recurringCount, budgetLimit: $budgetLimit, budgetPeriod: $budgetPeriod)';
}


}

/// @nodoc
abstract mixin class _$CategorySummaryCopyWith<$Res> implements $CategorySummaryCopyWith<$Res> {
  factory _$CategorySummaryCopyWith(_CategorySummary value, $Res Function(_CategorySummary) _then) = __$CategorySummaryCopyWithImpl;
@override @useResult
$Res call({
 Category category, int expenseCount, int recurringCount, Money? budgetLimit, BudgetPeriod? budgetPeriod
});


@override $CategoryCopyWith<$Res> get category;

}
/// @nodoc
class __$CategorySummaryCopyWithImpl<$Res>
    implements _$CategorySummaryCopyWith<$Res> {
  __$CategorySummaryCopyWithImpl(this._self, this._then);

  final _CategorySummary _self;
  final $Res Function(_CategorySummary) _then;

/// Create a copy of CategorySummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? category = null,Object? expenseCount = null,Object? recurringCount = null,Object? budgetLimit = freezed,Object? budgetPeriod = freezed,}) {
  return _then(_CategorySummary(
category: null == category ? _self.category : category // ignore: cast_nullable_to_non_nullable
as Category,expenseCount: null == expenseCount ? _self.expenseCount : expenseCount // ignore: cast_nullable_to_non_nullable
as int,recurringCount: null == recurringCount ? _self.recurringCount : recurringCount // ignore: cast_nullable_to_non_nullable
as int,budgetLimit: freezed == budgetLimit ? _self.budgetLimit : budgetLimit // ignore: cast_nullable_to_non_nullable
as Money?,budgetPeriod: freezed == budgetPeriod ? _self.budgetPeriod : budgetPeriod // ignore: cast_nullable_to_non_nullable
as BudgetPeriod?,
  ));
}

/// Create a copy of CategorySummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategoryCopyWith<$Res> get category {
  
  return $CategoryCopyWith<$Res>(_self.category, (value) {
    return _then(_self.copyWith(category: value));
  });
}
}

// dart format on
