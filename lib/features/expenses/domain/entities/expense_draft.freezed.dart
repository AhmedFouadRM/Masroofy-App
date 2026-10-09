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

 Money get amount; int get walletId; int get categoryId; LocalDate get date;/// Null when the user left it empty; the UI then shows the category name.
 String? get title; String? get note;/// What the form is set to; the category must be of this kind.
 TransactionKind get kind;
/// Create a copy of ExpenseDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseDraftCopyWith<ExpenseDraft> get copyWith => _$ExpenseDraftCopyWithImpl<ExpenseDraft>(this as ExpenseDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseDraft&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,amount,walletId,categoryId,date,title,note,kind);

@override
String toString() {
  return 'ExpenseDraft(amount: $amount, walletId: $walletId, categoryId: $categoryId, date: $date, title: $title, note: $note, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $ExpenseDraftCopyWith<$Res>  {
  factory $ExpenseDraftCopyWith(ExpenseDraft value, $Res Function(ExpenseDraft) _then) = _$ExpenseDraftCopyWithImpl;
@useResult
$Res call({
 Money amount, int walletId, int categoryId, LocalDate date, String? title, String? note, TransactionKind kind
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
@pragma('vm:prefer-inline') @override $Res call({Object? amount = null,Object? walletId = null,Object? categoryId = null,Object? date = null,Object? title = freezed,Object? note = freezed,Object? kind = null,}) {
  return _then(_self.copyWith(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Money amount,  int walletId,  int categoryId,  LocalDate date,  String? title,  String? note,  TransactionKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseDraft() when $default != null:
return $default(_that.amount,_that.walletId,_that.categoryId,_that.date,_that.title,_that.note,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Money amount,  int walletId,  int categoryId,  LocalDate date,  String? title,  String? note,  TransactionKind kind)  $default,) {final _that = this;
switch (_that) {
case _ExpenseDraft():
return $default(_that.amount,_that.walletId,_that.categoryId,_that.date,_that.title,_that.note,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Money amount,  int walletId,  int categoryId,  LocalDate date,  String? title,  String? note,  TransactionKind kind)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseDraft() when $default != null:
return $default(_that.amount,_that.walletId,_that.categoryId,_that.date,_that.title,_that.note,_that.kind);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseDraft implements ExpenseDraft {
  const _ExpenseDraft({required this.amount, required this.walletId, required this.categoryId, required this.date, this.title, this.note, this.kind = TransactionKind.expense});
  

@override final  Money amount;
@override final  int walletId;
@override final  int categoryId;
@override final  LocalDate date;
/// Null when the user left it empty; the UI then shows the category name.
@override final  String? title;
@override final  String? note;
/// What the form is set to; the category must be of this kind.
@override@JsonKey() final  TransactionKind kind;

/// Create a copy of ExpenseDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseDraftCopyWith<_ExpenseDraft> get copyWith => __$ExpenseDraftCopyWithImpl<_ExpenseDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseDraft&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.date, date) || other.date == date)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,amount,walletId,categoryId,date,title,note,kind);

@override
String toString() {
  return 'ExpenseDraft(amount: $amount, walletId: $walletId, categoryId: $categoryId, date: $date, title: $title, note: $note, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$ExpenseDraftCopyWith<$Res> implements $ExpenseDraftCopyWith<$Res> {
  factory _$ExpenseDraftCopyWith(_ExpenseDraft value, $Res Function(_ExpenseDraft) _then) = __$ExpenseDraftCopyWithImpl;
@override @useResult
$Res call({
 Money amount, int walletId, int categoryId, LocalDate date, String? title, String? note, TransactionKind kind
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
@override @pragma('vm:prefer-inline') $Res call({Object? amount = null,Object? walletId = null,Object? categoryId = null,Object? date = null,Object? title = freezed,Object? note = freezed,Object? kind = null,}) {
  return _then(_ExpenseDraft(
amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,title: freezed == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,
  ));
}


}

// dart format on
