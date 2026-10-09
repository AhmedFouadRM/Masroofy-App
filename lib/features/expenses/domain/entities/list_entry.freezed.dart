// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'list_entry.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ListEntry {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ListEntry);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'ListEntry()';
}


}

/// @nodoc
class $ListEntryCopyWith<$Res>  {
$ListEntryCopyWith(ListEntry _, $Res Function(ListEntry) __);
}


/// Adds pattern-matching-related methods to [ListEntry].
extension ListEntryPatterns on ListEntry {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( TransactionEntry value)?  transaction,TResult Function( TransferEntry value)?  transfer,required TResult orElse(),}){
final _that = this;
switch (_that) {
case TransactionEntry() when transaction != null:
return transaction(_that);case TransferEntry() when transfer != null:
return transfer(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( TransactionEntry value)  transaction,required TResult Function( TransferEntry value)  transfer,}){
final _that = this;
switch (_that) {
case TransactionEntry():
return transaction(_that);case TransferEntry():
return transfer(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( TransactionEntry value)?  transaction,TResult? Function( TransferEntry value)?  transfer,}){
final _that = this;
switch (_that) {
case TransactionEntry() when transaction != null:
return transaction(_that);case TransferEntry() when transfer != null:
return transfer(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( Expense expense)?  transaction,TResult Function( Transfer transfer,  int rowId,  int walletId)?  transfer,required TResult orElse(),}) {final _that = this;
switch (_that) {
case TransactionEntry() when transaction != null:
return transaction(_that.expense);case TransferEntry() when transfer != null:
return transfer(_that.transfer,_that.rowId,_that.walletId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( Expense expense)  transaction,required TResult Function( Transfer transfer,  int rowId,  int walletId)  transfer,}) {final _that = this;
switch (_that) {
case TransactionEntry():
return transaction(_that.expense);case TransferEntry():
return transfer(_that.transfer,_that.rowId,_that.walletId);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( Expense expense)?  transaction,TResult? Function( Transfer transfer,  int rowId,  int walletId)?  transfer,}) {final _that = this;
switch (_that) {
case TransactionEntry() when transaction != null:
return transaction(_that.expense);case TransferEntry() when transfer != null:
return transfer(_that.transfer,_that.rowId,_that.walletId);case _:
  return null;

}
}

}

/// @nodoc


class TransactionEntry extends ListEntry {
  const TransactionEntry(this.expense): super._();
  

 final  Expense expense;

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransactionEntryCopyWith<TransactionEntry> get copyWith => _$TransactionEntryCopyWithImpl<TransactionEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransactionEntry&&(identical(other.expense, expense) || other.expense == expense));
}


@override
int get hashCode => Object.hash(runtimeType,expense);

@override
String toString() {
  return 'ListEntry.transaction(expense: $expense)';
}


}

/// @nodoc
abstract mixin class $TransactionEntryCopyWith<$Res> implements $ListEntryCopyWith<$Res> {
  factory $TransactionEntryCopyWith(TransactionEntry value, $Res Function(TransactionEntry) _then) = _$TransactionEntryCopyWithImpl;
@useResult
$Res call({
 Expense expense
});


$ExpenseCopyWith<$Res> get expense;

}
/// @nodoc
class _$TransactionEntryCopyWithImpl<$Res>
    implements $TransactionEntryCopyWith<$Res> {
  _$TransactionEntryCopyWithImpl(this._self, this._then);

  final TransactionEntry _self;
  final $Res Function(TransactionEntry) _then;

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? expense = null,}) {
  return _then(TransactionEntry(
null == expense ? _self.expense : expense // ignore: cast_nullable_to_non_nullable
as Expense,
  ));
}

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ExpenseCopyWith<$Res> get expense {
  
  return $ExpenseCopyWith<$Res>(_self.expense, (value) {
    return _then(_self.copyWith(expense: value));
  });
}
}

/// @nodoc


class TransferEntry extends ListEntry {
  const TransferEntry(this.transfer, {required this.rowId, required this.walletId}): super._();
  

 final  Transfer transfer;
 final  int rowId;
 final  int walletId;

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$TransferEntryCopyWith<TransferEntry> get copyWith => _$TransferEntryCopyWithImpl<TransferEntry>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is TransferEntry&&(identical(other.transfer, transfer) || other.transfer == transfer)&&(identical(other.rowId, rowId) || other.rowId == rowId)&&(identical(other.walletId, walletId) || other.walletId == walletId));
}


@override
int get hashCode => Object.hash(runtimeType,transfer,rowId,walletId);

@override
String toString() {
  return 'ListEntry.transfer(transfer: $transfer, rowId: $rowId, walletId: $walletId)';
}


}

/// @nodoc
abstract mixin class $TransferEntryCopyWith<$Res> implements $ListEntryCopyWith<$Res> {
  factory $TransferEntryCopyWith(TransferEntry value, $Res Function(TransferEntry) _then) = _$TransferEntryCopyWithImpl;
@useResult
$Res call({
 Transfer transfer, int rowId, int walletId
});


$TransferCopyWith<$Res> get transfer;

}
/// @nodoc
class _$TransferEntryCopyWithImpl<$Res>
    implements $TransferEntryCopyWith<$Res> {
  _$TransferEntryCopyWithImpl(this._self, this._then);

  final TransferEntry _self;
  final $Res Function(TransferEntry) _then;

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? transfer = null,Object? rowId = null,Object? walletId = null,}) {
  return _then(TransferEntry(
null == transfer ? _self.transfer : transfer // ignore: cast_nullable_to_non_nullable
as Transfer,rowId: null == rowId ? _self.rowId : rowId // ignore: cast_nullable_to_non_nullable
as int,walletId: null == walletId ? _self.walletId : walletId // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ListEntry
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$TransferCopyWith<$Res> get transfer {
  
  return $TransferCopyWith<$Res>(_self.transfer, (value) {
    return _then(_self.copyWith(transfer: value));
  });
}
}

// dart format on
