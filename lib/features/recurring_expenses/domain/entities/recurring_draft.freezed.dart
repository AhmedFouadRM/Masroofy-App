// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringDraft {

 String get title; Money get amount; int get walletId; int get categoryId; RecurringFrequency get frequency;/// May be in the past (back-fills, within the cap) or the future.
 LocalDate get startDate; bool get isActive;/// What the form is set to; the category must be of this kind.
 TransactionKind get kind;
/// Create a copy of RecurringDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringDraftCopyWith<RecurringDraft> get copyWith => _$RecurringDraftCopyWithImpl<RecurringDraft>(this as RecurringDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,title,amount,walletId,categoryId,frequency,startDate,isActive,kind);

@override
String toString() {
  return 'RecurringDraft(title: $title, amount: $amount, walletId: $walletId, categoryId: $categoryId, frequency: $frequency, startDate: $startDate, isActive: $isActive, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $RecurringDraftCopyWith<$Res>  {
  factory $RecurringDraftCopyWith(RecurringDraft value, $Res Function(RecurringDraft) _then) = _$RecurringDraftCopyWithImpl;
@useResult
$Res call({
 String title, Money amount, int walletId, int categoryId, RecurringFrequency frequency, LocalDate startDate, bool isActive, TransactionKind kind
});




}
/// @nodoc
class _$RecurringDraftCopyWithImpl<$Res>
    implements $RecurringDraftCopyWith<$Res> {
  _$RecurringDraftCopyWithImpl(this._self, this._then);

  final RecurringDraft _self;
  final $Res Function(RecurringDraft) _then;

/// Create a copy of RecurringDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? title = null,Object? amount = null,Object? walletId = null,Object? categoryId = null,Object? frequency = null,Object? startDate = null,Object? isActive = null,Object? kind = null,}) {
  return _then(_self.copyWith(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurringFrequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as LocalDate,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringDraft].
extension RecurringDraftPatterns on RecurringDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringDraft value)  $default,){
final _that = this;
switch (_that) {
case _RecurringDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringDraft value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String title,  Money amount,  int walletId,  int categoryId,  RecurringFrequency frequency,  LocalDate startDate,  bool isActive,  TransactionKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringDraft() when $default != null:
return $default(_that.title,_that.amount,_that.walletId,_that.categoryId,_that.frequency,_that.startDate,_that.isActive,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String title,  Money amount,  int walletId,  int categoryId,  RecurringFrequency frequency,  LocalDate startDate,  bool isActive,  TransactionKind kind)  $default,) {final _that = this;
switch (_that) {
case _RecurringDraft():
return $default(_that.title,_that.amount,_that.walletId,_that.categoryId,_that.frequency,_that.startDate,_that.isActive,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String title,  Money amount,  int walletId,  int categoryId,  RecurringFrequency frequency,  LocalDate startDate,  bool isActive,  TransactionKind kind)?  $default,) {final _that = this;
switch (_that) {
case _RecurringDraft() when $default != null:
return $default(_that.title,_that.amount,_that.walletId,_that.categoryId,_that.frequency,_that.startDate,_that.isActive,_that.kind);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringDraft implements RecurringDraft {
  const _RecurringDraft({required this.title, required this.amount, required this.walletId, required this.categoryId, required this.frequency, required this.startDate, this.isActive = true, this.kind = TransactionKind.expense});
  

@override final  String title;
@override final  Money amount;
@override final  int walletId;
@override final  int categoryId;
@override final  RecurringFrequency frequency;
/// May be in the past (back-fills, within the cap) or the future.
@override final  LocalDate startDate;
@override@JsonKey() final  bool isActive;
/// What the form is set to; the category must be of this kind.
@override@JsonKey() final  TransactionKind kind;

/// Create a copy of RecurringDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringDraftCopyWith<_RecurringDraft> get copyWith => __$RecurringDraftCopyWithImpl<_RecurringDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringDraft&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.walletId, walletId) || other.walletId == walletId)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,title,amount,walletId,categoryId,frequency,startDate,isActive,kind);

@override
String toString() {
  return 'RecurringDraft(title: $title, amount: $amount, walletId: $walletId, categoryId: $categoryId, frequency: $frequency, startDate: $startDate, isActive: $isActive, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$RecurringDraftCopyWith<$Res> implements $RecurringDraftCopyWith<$Res> {
  factory _$RecurringDraftCopyWith(_RecurringDraft value, $Res Function(_RecurringDraft) _then) = __$RecurringDraftCopyWithImpl;
@override @useResult
$Res call({
 String title, Money amount, int walletId, int categoryId, RecurringFrequency frequency, LocalDate startDate, bool isActive, TransactionKind kind
});




}
/// @nodoc
class __$RecurringDraftCopyWithImpl<$Res>
    implements _$RecurringDraftCopyWith<$Res> {
  __$RecurringDraftCopyWithImpl(this._self, this._then);

  final _RecurringDraft _self;
  final $Res Function(_RecurringDraft) _then;

/// Create a copy of RecurringDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? title = null,Object? amount = null,Object? walletId = null,Object? categoryId = null,Object? frequency = null,Object? startDate = null,Object? isActive = null,Object? kind = null,}) {
  return _then(_RecurringDraft(
title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurringFrequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as LocalDate,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,
  ));
}


}

// dart format on
