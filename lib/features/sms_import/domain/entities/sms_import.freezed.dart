// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_import.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SmsImport {

 int get id; String get smsKey;/// The address the message came from, as received.
 String get sender; DateTime get receivedAt; TransactionKind get kind; Money get amount; String get currency; LocalDate get date; SmsImportStatus get status; String? get merchant; int? get categoryId; String? get cardLast4; String? get note;/// The transaction this import became.
 int? get expenseId;
/// Create a copy of SmsImport
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmsImportCopyWith<SmsImport> get copyWith => _$SmsImportCopyWithImpl<SmsImport>(this as SmsImport, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmsImport&&(identical(other.id, id) || other.id == id)&&(identical(other.smsKey, smsKey) || other.smsKey == smsKey)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.note, note) || other.note == note)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId));
}


@override
int get hashCode => Object.hash(runtimeType,id,smsKey,sender,receivedAt,kind,amount,currency,date,status,merchant,categoryId,cardLast4,note,expenseId);

@override
String toString() {
  return 'SmsImport(id: $id, smsKey: $smsKey, sender: $sender, receivedAt: $receivedAt, kind: $kind, amount: $amount, currency: $currency, date: $date, status: $status, merchant: $merchant, categoryId: $categoryId, cardLast4: $cardLast4, note: $note, expenseId: $expenseId)';
}


}

/// @nodoc
abstract mixin class $SmsImportCopyWith<$Res>  {
  factory $SmsImportCopyWith(SmsImport value, $Res Function(SmsImport) _then) = _$SmsImportCopyWithImpl;
@useResult
$Res call({
 int id, String smsKey, String sender, DateTime receivedAt, TransactionKind kind, Money amount, String currency, LocalDate date, SmsImportStatus status, String? merchant, int? categoryId, String? cardLast4, String? note, int? expenseId
});




}
/// @nodoc
class _$SmsImportCopyWithImpl<$Res>
    implements $SmsImportCopyWith<$Res> {
  _$SmsImportCopyWithImpl(this._self, this._then);

  final SmsImport _self;
  final $Res Function(SmsImport) _then;

/// Create a copy of SmsImport
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? smsKey = null,Object? sender = null,Object? receivedAt = null,Object? kind = null,Object? amount = null,Object? currency = null,Object? date = null,Object? status = null,Object? merchant = freezed,Object? categoryId = freezed,Object? cardLast4 = freezed,Object? note = freezed,Object? expenseId = freezed,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,smsKey: null == smsKey ? _self.smsKey : smsKey // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SmsImportStatus,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,cardLast4: freezed == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,expenseId: freezed == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SmsImport].
extension SmsImportPatterns on SmsImport {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmsImport value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmsImport() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmsImport value)  $default,){
final _that = this;
switch (_that) {
case _SmsImport():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmsImport value)?  $default,){
final _that = this;
switch (_that) {
case _SmsImport() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String smsKey,  String sender,  DateTime receivedAt,  TransactionKind kind,  Money amount,  String currency,  LocalDate date,  SmsImportStatus status,  String? merchant,  int? categoryId,  String? cardLast4,  String? note,  int? expenseId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmsImport() when $default != null:
return $default(_that.id,_that.smsKey,_that.sender,_that.receivedAt,_that.kind,_that.amount,_that.currency,_that.date,_that.status,_that.merchant,_that.categoryId,_that.cardLast4,_that.note,_that.expenseId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String smsKey,  String sender,  DateTime receivedAt,  TransactionKind kind,  Money amount,  String currency,  LocalDate date,  SmsImportStatus status,  String? merchant,  int? categoryId,  String? cardLast4,  String? note,  int? expenseId)  $default,) {final _that = this;
switch (_that) {
case _SmsImport():
return $default(_that.id,_that.smsKey,_that.sender,_that.receivedAt,_that.kind,_that.amount,_that.currency,_that.date,_that.status,_that.merchant,_that.categoryId,_that.cardLast4,_that.note,_that.expenseId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String smsKey,  String sender,  DateTime receivedAt,  TransactionKind kind,  Money amount,  String currency,  LocalDate date,  SmsImportStatus status,  String? merchant,  int? categoryId,  String? cardLast4,  String? note,  int? expenseId)?  $default,) {final _that = this;
switch (_that) {
case _SmsImport() when $default != null:
return $default(_that.id,_that.smsKey,_that.sender,_that.receivedAt,_that.kind,_that.amount,_that.currency,_that.date,_that.status,_that.merchant,_that.categoryId,_that.cardLast4,_that.note,_that.expenseId);case _:
  return null;

}
}

}

/// @nodoc


class _SmsImport extends SmsImport {
  const _SmsImport({required this.id, required this.smsKey, required this.sender, required this.receivedAt, required this.kind, required this.amount, required this.currency, required this.date, required this.status, this.merchant, this.categoryId, this.cardLast4, this.note, this.expenseId}): super._();
  

@override final  int id;
@override final  String smsKey;
/// The address the message came from, as received.
@override final  String sender;
@override final  DateTime receivedAt;
@override final  TransactionKind kind;
@override final  Money amount;
@override final  String currency;
@override final  LocalDate date;
@override final  SmsImportStatus status;
@override final  String? merchant;
@override final  int? categoryId;
@override final  String? cardLast4;
@override final  String? note;
/// The transaction this import became.
@override final  int? expenseId;

/// Create a copy of SmsImport
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmsImportCopyWith<_SmsImport> get copyWith => __$SmsImportCopyWithImpl<_SmsImport>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmsImport&&(identical(other.id, id) || other.id == id)&&(identical(other.smsKey, smsKey) || other.smsKey == smsKey)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.note, note) || other.note == note)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId));
}


@override
int get hashCode => Object.hash(runtimeType,id,smsKey,sender,receivedAt,kind,amount,currency,date,status,merchant,categoryId,cardLast4,note,expenseId);

@override
String toString() {
  return 'SmsImport(id: $id, smsKey: $smsKey, sender: $sender, receivedAt: $receivedAt, kind: $kind, amount: $amount, currency: $currency, date: $date, status: $status, merchant: $merchant, categoryId: $categoryId, cardLast4: $cardLast4, note: $note, expenseId: $expenseId)';
}


}

/// @nodoc
abstract mixin class _$SmsImportCopyWith<$Res> implements $SmsImportCopyWith<$Res> {
  factory _$SmsImportCopyWith(_SmsImport value, $Res Function(_SmsImport) _then) = __$SmsImportCopyWithImpl;
@override @useResult
$Res call({
 int id, String smsKey, String sender, DateTime receivedAt, TransactionKind kind, Money amount, String currency, LocalDate date, SmsImportStatus status, String? merchant, int? categoryId, String? cardLast4, String? note, int? expenseId
});




}
/// @nodoc
class __$SmsImportCopyWithImpl<$Res>
    implements _$SmsImportCopyWith<$Res> {
  __$SmsImportCopyWithImpl(this._self, this._then);

  final _SmsImport _self;
  final $Res Function(_SmsImport) _then;

/// Create a copy of SmsImport
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? smsKey = null,Object? sender = null,Object? receivedAt = null,Object? kind = null,Object? amount = null,Object? currency = null,Object? date = null,Object? status = null,Object? merchant = freezed,Object? categoryId = freezed,Object? cardLast4 = freezed,Object? note = freezed,Object? expenseId = freezed,}) {
  return _then(_SmsImport(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,smsKey: null == smsKey ? _self.smsKey : smsKey // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SmsImportStatus,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,cardLast4: freezed == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,expenseId: freezed == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

/// @nodoc
mixin _$SmsImportDraft {

 String get smsKey; String get sender; DateTime get receivedAt; TransactionKind get kind; Money get amount; String get currency; LocalDate get date; SmsImportStatus get status; String? get merchant; int? get categoryId; String? get cardLast4; String? get note; int? get expenseId;
/// Create a copy of SmsImportDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmsImportDraftCopyWith<SmsImportDraft> get copyWith => _$SmsImportDraftCopyWithImpl<SmsImportDraft>(this as SmsImportDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmsImportDraft&&(identical(other.smsKey, smsKey) || other.smsKey == smsKey)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.note, note) || other.note == note)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId));
}


@override
int get hashCode => Object.hash(runtimeType,smsKey,sender,receivedAt,kind,amount,currency,date,status,merchant,categoryId,cardLast4,note,expenseId);

@override
String toString() {
  return 'SmsImportDraft(smsKey: $smsKey, sender: $sender, receivedAt: $receivedAt, kind: $kind, amount: $amount, currency: $currency, date: $date, status: $status, merchant: $merchant, categoryId: $categoryId, cardLast4: $cardLast4, note: $note, expenseId: $expenseId)';
}


}

/// @nodoc
abstract mixin class $SmsImportDraftCopyWith<$Res>  {
  factory $SmsImportDraftCopyWith(SmsImportDraft value, $Res Function(SmsImportDraft) _then) = _$SmsImportDraftCopyWithImpl;
@useResult
$Res call({
 String smsKey, String sender, DateTime receivedAt, TransactionKind kind, Money amount, String currency, LocalDate date, SmsImportStatus status, String? merchant, int? categoryId, String? cardLast4, String? note, int? expenseId
});




}
/// @nodoc
class _$SmsImportDraftCopyWithImpl<$Res>
    implements $SmsImportDraftCopyWith<$Res> {
  _$SmsImportDraftCopyWithImpl(this._self, this._then);

  final SmsImportDraft _self;
  final $Res Function(SmsImportDraft) _then;

/// Create a copy of SmsImportDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? smsKey = null,Object? sender = null,Object? receivedAt = null,Object? kind = null,Object? amount = null,Object? currency = null,Object? date = null,Object? status = null,Object? merchant = freezed,Object? categoryId = freezed,Object? cardLast4 = freezed,Object? note = freezed,Object? expenseId = freezed,}) {
  return _then(_self.copyWith(
smsKey: null == smsKey ? _self.smsKey : smsKey // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SmsImportStatus,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,cardLast4: freezed == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,expenseId: freezed == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SmsImportDraft].
extension SmsImportDraftPatterns on SmsImportDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmsImportDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmsImportDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmsImportDraft value)  $default,){
final _that = this;
switch (_that) {
case _SmsImportDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmsImportDraft value)?  $default,){
final _that = this;
switch (_that) {
case _SmsImportDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String smsKey,  String sender,  DateTime receivedAt,  TransactionKind kind,  Money amount,  String currency,  LocalDate date,  SmsImportStatus status,  String? merchant,  int? categoryId,  String? cardLast4,  String? note,  int? expenseId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmsImportDraft() when $default != null:
return $default(_that.smsKey,_that.sender,_that.receivedAt,_that.kind,_that.amount,_that.currency,_that.date,_that.status,_that.merchant,_that.categoryId,_that.cardLast4,_that.note,_that.expenseId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String smsKey,  String sender,  DateTime receivedAt,  TransactionKind kind,  Money amount,  String currency,  LocalDate date,  SmsImportStatus status,  String? merchant,  int? categoryId,  String? cardLast4,  String? note,  int? expenseId)  $default,) {final _that = this;
switch (_that) {
case _SmsImportDraft():
return $default(_that.smsKey,_that.sender,_that.receivedAt,_that.kind,_that.amount,_that.currency,_that.date,_that.status,_that.merchant,_that.categoryId,_that.cardLast4,_that.note,_that.expenseId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String smsKey,  String sender,  DateTime receivedAt,  TransactionKind kind,  Money amount,  String currency,  LocalDate date,  SmsImportStatus status,  String? merchant,  int? categoryId,  String? cardLast4,  String? note,  int? expenseId)?  $default,) {final _that = this;
switch (_that) {
case _SmsImportDraft() when $default != null:
return $default(_that.smsKey,_that.sender,_that.receivedAt,_that.kind,_that.amount,_that.currency,_that.date,_that.status,_that.merchant,_that.categoryId,_that.cardLast4,_that.note,_that.expenseId);case _:
  return null;

}
}

}

/// @nodoc


class _SmsImportDraft implements SmsImportDraft {
  const _SmsImportDraft({required this.smsKey, required this.sender, required this.receivedAt, required this.kind, required this.amount, required this.currency, required this.date, this.status = SmsImportStatus.pending, this.merchant, this.categoryId, this.cardLast4, this.note, this.expenseId});
  

@override final  String smsKey;
@override final  String sender;
@override final  DateTime receivedAt;
@override final  TransactionKind kind;
@override final  Money amount;
@override final  String currency;
@override final  LocalDate date;
@override@JsonKey() final  SmsImportStatus status;
@override final  String? merchant;
@override final  int? categoryId;
@override final  String? cardLast4;
@override final  String? note;
@override final  int? expenseId;

/// Create a copy of SmsImportDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmsImportDraftCopyWith<_SmsImportDraft> get copyWith => __$SmsImportDraftCopyWithImpl<_SmsImportDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmsImportDraft&&(identical(other.smsKey, smsKey) || other.smsKey == smsKey)&&(identical(other.sender, sender) || other.sender == sender)&&(identical(other.receivedAt, receivedAt) || other.receivedAt == receivedAt)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.date, date) || other.date == date)&&(identical(other.status, status) || other.status == status)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.note, note) || other.note == note)&&(identical(other.expenseId, expenseId) || other.expenseId == expenseId));
}


@override
int get hashCode => Object.hash(runtimeType,smsKey,sender,receivedAt,kind,amount,currency,date,status,merchant,categoryId,cardLast4,note,expenseId);

@override
String toString() {
  return 'SmsImportDraft(smsKey: $smsKey, sender: $sender, receivedAt: $receivedAt, kind: $kind, amount: $amount, currency: $currency, date: $date, status: $status, merchant: $merchant, categoryId: $categoryId, cardLast4: $cardLast4, note: $note, expenseId: $expenseId)';
}


}

/// @nodoc
abstract mixin class _$SmsImportDraftCopyWith<$Res> implements $SmsImportDraftCopyWith<$Res> {
  factory _$SmsImportDraftCopyWith(_SmsImportDraft value, $Res Function(_SmsImportDraft) _then) = __$SmsImportDraftCopyWithImpl;
@override @useResult
$Res call({
 String smsKey, String sender, DateTime receivedAt, TransactionKind kind, Money amount, String currency, LocalDate date, SmsImportStatus status, String? merchant, int? categoryId, String? cardLast4, String? note, int? expenseId
});




}
/// @nodoc
class __$SmsImportDraftCopyWithImpl<$Res>
    implements _$SmsImportDraftCopyWith<$Res> {
  __$SmsImportDraftCopyWithImpl(this._self, this._then);

  final _SmsImportDraft _self;
  final $Res Function(_SmsImportDraft) _then;

/// Create a copy of SmsImportDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? smsKey = null,Object? sender = null,Object? receivedAt = null,Object? kind = null,Object? amount = null,Object? currency = null,Object? date = null,Object? status = null,Object? merchant = freezed,Object? categoryId = freezed,Object? cardLast4 = freezed,Object? note = freezed,Object? expenseId = freezed,}) {
  return _then(_SmsImportDraft(
smsKey: null == smsKey ? _self.smsKey : smsKey // ignore: cast_nullable_to_non_nullable
as String,sender: null == sender ? _self.sender : sender // ignore: cast_nullable_to_non_nullable
as String,receivedAt: null == receivedAt ? _self.receivedAt : receivedAt // ignore: cast_nullable_to_non_nullable
as DateTime,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SmsImportStatus,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,cardLast4: freezed == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String?,note: freezed == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String?,expenseId: freezed == expenseId ? _self.expenseId : expenseId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
