// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_filter.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseFilter {

 DateRange get range; TransactionKind? get kind; int? get categoryId; String? get search;
/// Create a copy of ExpenseFilter
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseFilterCopyWith<ExpenseFilter> get copyWith => _$ExpenseFilterCopyWithImpl<ExpenseFilter>(this as ExpenseFilter, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseFilter&&(identical(other.range, range) || other.range == range)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,range,kind,categoryId,search);

@override
String toString() {
  return 'ExpenseFilter(range: $range, kind: $kind, categoryId: $categoryId, search: $search)';
}


}

/// @nodoc
abstract mixin class $ExpenseFilterCopyWith<$Res>  {
  factory $ExpenseFilterCopyWith(ExpenseFilter value, $Res Function(ExpenseFilter) _then) = _$ExpenseFilterCopyWithImpl;
@useResult
$Res call({
 DateRange range, TransactionKind? kind, int? categoryId, String? search
});




}
/// @nodoc
class _$ExpenseFilterCopyWithImpl<$Res>
    implements $ExpenseFilterCopyWith<$Res> {
  _$ExpenseFilterCopyWithImpl(this._self, this._then);

  final ExpenseFilter _self;
  final $Res Function(ExpenseFilter) _then;

/// Create a copy of ExpenseFilter
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? range = null,Object? kind = freezed,Object? categoryId = freezed,Object? search = freezed,}) {
  return _then(_self.copyWith(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseFilter].
extension ExpenseFilterPatterns on ExpenseFilter {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseFilter value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseFilter() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseFilter value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseFilter():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseFilter value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseFilter() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( DateRange range,  TransactionKind? kind,  int? categoryId,  String? search)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseFilter() when $default != null:
return $default(_that.range,_that.kind,_that.categoryId,_that.search);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( DateRange range,  TransactionKind? kind,  int? categoryId,  String? search)  $default,) {final _that = this;
switch (_that) {
case _ExpenseFilter():
return $default(_that.range,_that.kind,_that.categoryId,_that.search);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( DateRange range,  TransactionKind? kind,  int? categoryId,  String? search)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseFilter() when $default != null:
return $default(_that.range,_that.kind,_that.categoryId,_that.search);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseFilter extends ExpenseFilter {
  const _ExpenseFilter({required this.range, this.kind, this.categoryId, this.search}): super._();
  

@override final  DateRange range;
@override final  TransactionKind? kind;
@override final  int? categoryId;
@override final  String? search;

/// Create a copy of ExpenseFilter
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseFilterCopyWith<_ExpenseFilter> get copyWith => __$ExpenseFilterCopyWithImpl<_ExpenseFilter>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseFilter&&(identical(other.range, range) || other.range == range)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.search, search) || other.search == search));
}


@override
int get hashCode => Object.hash(runtimeType,range,kind,categoryId,search);

@override
String toString() {
  return 'ExpenseFilter(range: $range, kind: $kind, categoryId: $categoryId, search: $search)';
}


}

/// @nodoc
abstract mixin class _$ExpenseFilterCopyWith<$Res> implements $ExpenseFilterCopyWith<$Res> {
  factory _$ExpenseFilterCopyWith(_ExpenseFilter value, $Res Function(_ExpenseFilter) _then) = __$ExpenseFilterCopyWithImpl;
@override @useResult
$Res call({
 DateRange range, TransactionKind? kind, int? categoryId, String? search
});




}
/// @nodoc
class __$ExpenseFilterCopyWithImpl<$Res>
    implements _$ExpenseFilterCopyWith<$Res> {
  __$ExpenseFilterCopyWithImpl(this._self, this._then);

  final _ExpenseFilter _self;
  final $Res Function(_ExpenseFilter) _then;

/// Create a copy of ExpenseFilter
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? range = null,Object? kind = freezed,Object? categoryId = freezed,Object? search = freezed,}) {
  return _then(_ExpenseFilter(
range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,search: freezed == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
