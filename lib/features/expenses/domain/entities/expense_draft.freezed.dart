// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseDraft {

 Money get amount; int get categoryId; LocalDate get date;/// Null when the user left it empty; the UI then shows the category name.
 String? get title; String? get note;
/// Create a copy of ExpenseDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseDraftCopyWith<ExpenseDraft> get copyWith => _$ExpenseDraftCopyWithImpl<ExpenseDraft>(this as ExpenseDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseDraft&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,amount,categoryId,date,title,note);

@override
String toString() {
  return 'ExpenseDraft(amount: $amount, categoryId: $categoryId, date: $date, title: $title, note: $note)';
}


}

/// @nodoc
abstract mixin class $ExpenseDraftCopyWith<$Res>  {
  factory $ExpenseDraftCopyWith(ExpenseDraft value, $Res Function(ExpenseDraft) _then) = _$ExpenseDraftCopyWithImpl;
@useResult
$Res call({
 Money amount, int categoryId, LocalDate date, String? title, String? note
});




}
/// @nodoc
class _$ExpenseDraftCopyWithImpl<$Res>
    implements $ExpenseDraftCopyWith<$Res> {
  _$ExpenseDraftCopyWithImpl(this._self, this._then);

  final ExpenseDraft _self;
  final $Res Function(ExpenseDraft) _then;

/// Create a copy of ExpenseDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? categoryId = null,Object? date = null,Object? title = freezed,Object? note = freezed,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ExpenseDraft].
extension ExpenseDraftPatterns on ExpenseDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseDraft value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseDraft value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Money amount,  int categoryId,  LocalDate date,  String? title,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseDraft() when $default != null:
return $default(_that.amount,_that.categoryId,_that.date,_that.title,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Money amount,  int categoryId,  LocalDate date,  String? title,  String? note)  $default,) {final _that = this;
switch (_that) {
case _ExpenseDraft():
return $default(_that.amount,_that.categoryId,_that.date,_that.title,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Money amount,  int categoryId,  LocalDate date,  String? title,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseDraft() when $default != null:
return $default(_that.amount,_that.categoryId,_that.date,_that.title,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseDraft implements ExpenseDraft {
  const _ExpenseDraft({required this.amount, required this.categoryId, required this.date, this.title, this.note});
  

@override final  Money amount;
@override final  int categoryId;
@override final  LocalDate date;
/// Null when the user left it empty; the UI then shows the category name.
@override final  String? title;
@override final  String? note;

/// Create a copy of ExpenseDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseDraftCopyWith<_ExpenseDraft> get copyWith => __$ExpenseDraftCopyWithImpl<_ExpenseDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseDraft&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,amount,categoryId,date,title,note);

@override
String toString() {
  return 'ExpenseDraft(amount: $amount, categoryId: $categoryId, date: $date, title: $title, note: $note)';
}


}

/// @nodoc
abstract mixin class _$ExpenseDraftCopyWith<$Res> implements $ExpenseDraftCopyWith<$Res> {
  factory _$ExpenseDraftCopyWith(_ExpenseDraft value, $Res Function(_ExpenseDraft) _then) = __$ExpenseDraftCopyWithImpl;
@override @useResult
$Res call({
 Money amount, int categoryId, LocalDate date, String? title, String? note
});




}
/// @nodoc
class __$ExpenseDraftCopyWithImpl<$Res>
    implements _$ExpenseDraftCopyWith<$Res> {
  __$ExpenseDraftCopyWithImpl(this._self, this._then);

  final _ExpenseDraft _self;
  final $Res Function(_ExpenseDraft) _then;

/// Create a copy of ExpenseDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? categoryId = null,Object? date = null,Object? title = freezed,Object? note = freezed,}) {
  return _then(_ExpenseDraft(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
