// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'transfer_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$TransferDraft {

 int get fromWalletId; int get toWalletId; Money get amount; LocalDate get date; String? get note;
/// Create a copy of TransferDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferDraftCopyWith<TransferDraft> get copyWith => _$TransferDraftCopyWithImpl<TransferDraft>(this as TransferDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferDraft&&(identical(other.fromWalletId, fromWalletId) || other.fromWalletId == fromWalletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,fromWalletId,toWalletId,amount,date,note);

@override
String toString() {
  return 'TransferDraft(fromWalletId: $fromWalletId, toWalletId: $toWalletId, amount: $amount, date: $date, note: $note)';
}


}

/// @nodoc
abstract mixin class $TransferDraftCopyWith<$Res>  {
  factory $TransferDraftCopyWith(TransferDraft value, $Res Function(TransferDraft) _then) = _$TransferDraftCopyWithImpl;
@useResult
$Res call({
 int fromWalletId, int toWalletId, Money amount, LocalDate date, String? note
});




}
/// @nodoc
class _$TransferDraftCopyWithImpl<$Res>
    implements $TransferDraftCopyWith<$Res> {
  _$TransferDraftCopyWithImpl(this._self, this._then);

  final TransferDraft _self;
  final $Res Function(TransferDraft) _then;

/// Create a copy of TransferDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fromWalletId = null,Object? toWalletId = null,Object? amount = null,Object? date = null,Object? note = freezed,}) {
  return _then(_self.copyWith(
fromWalletId: null == fromWalletId ? _self.fromWalletId : fromWalletId // ignore: cast_nullable_to_non_nullable
as int,toWalletId: null == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [TransferDraft].
extension TransferDraftPatterns on TransferDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _TransferDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _TransferDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _TransferDraft value)  $default,){
final _that = this;
switch (_that) {
case _TransferDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _TransferDraft value)?  $default,){
final _that = this;
switch (_that) {
case _TransferDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fromWalletId,  int toWalletId,  Money amount,  LocalDate date,  String? note)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _TransferDraft() when $default != null:
return $default(_that.fromWalletId,_that.toWalletId,_that.amount,_that.date,_that.note);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fromWalletId,  int toWalletId,  Money amount,  LocalDate date,  String? note)  $default,) {final _that = this;
switch (_that) {
case _TransferDraft():
return $default(_that.fromWalletId,_that.toWalletId,_that.amount,_that.date,_that.note);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fromWalletId,  int toWalletId,  Money amount,  LocalDate date,  String? note)?  $default,) {final _that = this;
switch (_that) {
case _TransferDraft() when $default != null:
return $default(_that.fromWalletId,_that.toWalletId,_that.amount,_that.date,_that.note);case _:
  return null;

}
}

}

/// @nodoc


class _TransferDraft implements TransferDraft {
  const _TransferDraft({required this.fromWalletId, required this.toWalletId, required this.amount, required this.date, this.note});
  

@override final  int fromWalletId;
@override final  int toWalletId;
@override final  Money amount;
@override final  LocalDate date;
@override final  String? note;

/// Create a copy of TransferDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$TransferDraftCopyWith<_TransferDraft> get copyWith => __$TransferDraftCopyWithImpl<_TransferDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _TransferDraft&&(identical(other.fromWalletId, fromWalletId) || other.fromWalletId == fromWalletId)&&(identical(other.toWalletId, toWalletId) || other.toWalletId == toWalletId)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.date, date) || other.date == date)&&(identical(other.note, note) || other.note == note));
}


@override
int get hashCode => Object.hash(runtimeType,fromWalletId,toWalletId,amount,date,note);

@override
String toString() {
  return 'TransferDraft(fromWalletId: $fromWalletId, toWalletId: $toWalletId, amount: $amount, date: $date, note: $note)';
}


}

/// @nodoc
abstract mixin class _$TransferDraftCopyWith<$Res> implements $TransferDraftCopyWith<$Res> {
  factory _$TransferDraftCopyWith(_TransferDraft value, $Res Function(_TransferDraft) _then) = __$TransferDraftCopyWithImpl;
@override @useResult
$Res call({
 int fromWalletId, int toWalletId, Money amount, LocalDate date, String? note
});




}
/// @nodoc
class __$TransferDraftCopyWithImpl<$Res>
    implements _$TransferDraftCopyWith<$Res> {
  __$TransferDraftCopyWithImpl(this._self, this._then);

  final _TransferDraft _self;
  final $Res Function(_TransferDraft) _then;

/// Create a copy of TransferDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fromWalletId = null,Object? toWalletId = null,Object? amount = null,Object? date = null,Object? note = freezed,}) {
  return _then(_TransferDraft(
fromWalletId: null == fromWalletId ? _self.fromWalletId : fromWalletId // ignore: cast_nullable_to_non_nullable
as int,toWalletId: null == toWalletId ? _self.toWalletId : toWalletId // ignore: cast_nullable_to_non_nullable
as int,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
