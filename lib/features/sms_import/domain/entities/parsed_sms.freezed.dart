// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'parsed_sms.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ParsedSms {

 SmsKind get kind; Money get amount;/// ISO 4217 code of the amount, e.g. `EGP`.
 String get currency;/// When it happened: the date and time in the text, else the SMS time.
 DateTime get occurredAt;/// 0 to 1. At [highConfidence] and above, a real template matched; below
/// it, a generic pattern did, and the user is always asked.
 double get confidence;/// The merchant, or for a transfer the other party; null when the message
/// has none.
 String? get merchant;/// Last 4 digits of the card or account.
 String? get cardLast4;/// The balance after the transaction, in [currency].
 Money? get balance; String? get reference;/// The bank's display name, e.g. `EG Bank`.
 String? get bankName;/// How the money moved when it was not by card, e.g. `InstaPay`.
 String? get channel;
/// Create a copy of ParsedSms
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ParsedSmsCopyWith<ParsedSms> get copyWith => _$ParsedSmsCopyWithImpl<ParsedSms>(this as ParsedSms, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ParsedSms&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.channel, channel) || other.channel == channel));
}


@override
int get hashCode => Object.hash(runtimeType,kind,amount,currency,occurredAt,confidence,merchant,cardLast4,balance,reference,bankName,channel);

@override
String toString() {
  return 'ParsedSms(kind: $kind, amount: $amount, currency: $currency, occurredAt: $occurredAt, confidence: $confidence, merchant: $merchant, cardLast4: $cardLast4, balance: $balance, reference: $reference, bankName: $bankName, channel: $channel)';
}


}

/// @nodoc
abstract mixin class $ParsedSmsCopyWith<$Res>  {
  factory $ParsedSmsCopyWith(ParsedSms value, $Res Function(ParsedSms) _then) = _$ParsedSmsCopyWithImpl;
@useResult
$Res call({
 SmsKind kind, Money amount, String currency, DateTime occurredAt, double confidence, String? merchant, String? cardLast4, Money? balance, String? reference, String? bankName, String? channel
});




}
/// @nodoc
class _$ParsedSmsCopyWithImpl<$Res>
    implements $ParsedSmsCopyWith<$Res> {
  _$ParsedSmsCopyWithImpl(this._self, this._then);

  final ParsedSms _self;
  final $Res Function(ParsedSms) _then;

/// Create a copy of ParsedSms
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? kind = null,Object? amount = null,Object? currency = null,Object? occurredAt = null,Object? confidence = null,Object? merchant = freezed,Object? cardLast4 = freezed,Object? balance = freezed,Object? reference = freezed,Object? bankName = freezed,Object? channel = freezed,}) {
  return _then(_self.copyWith(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SmsKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,cardLast4: freezed == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String?,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as Money?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ParsedSms].
extension ParsedSmsPatterns on ParsedSms {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ParsedSms value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ParsedSms() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ParsedSms value)  $default,){
final _that = this;
switch (_that) {
case _ParsedSms():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ParsedSms value)?  $default,){
final _that = this;
switch (_that) {
case _ParsedSms() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( SmsKind kind,  Money amount,  String currency,  DateTime occurredAt,  double confidence,  String? merchant,  String? cardLast4,  Money? balance,  String? reference,  String? bankName,  String? channel)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ParsedSms() when $default != null:
return $default(_that.kind,_that.amount,_that.currency,_that.occurredAt,_that.confidence,_that.merchant,_that.cardLast4,_that.balance,_that.reference,_that.bankName,_that.channel);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( SmsKind kind,  Money amount,  String currency,  DateTime occurredAt,  double confidence,  String? merchant,  String? cardLast4,  Money? balance,  String? reference,  String? bankName,  String? channel)  $default,) {final _that = this;
switch (_that) {
case _ParsedSms():
return $default(_that.kind,_that.amount,_that.currency,_that.occurredAt,_that.confidence,_that.merchant,_that.cardLast4,_that.balance,_that.reference,_that.bankName,_that.channel);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( SmsKind kind,  Money amount,  String currency,  DateTime occurredAt,  double confidence,  String? merchant,  String? cardLast4,  Money? balance,  String? reference,  String? bankName,  String? channel)?  $default,) {final _that = this;
switch (_that) {
case _ParsedSms() when $default != null:
return $default(_that.kind,_that.amount,_that.currency,_that.occurredAt,_that.confidence,_that.merchant,_that.cardLast4,_that.balance,_that.reference,_that.bankName,_that.channel);case _:
  return null;

}
}

}

/// @nodoc


class _ParsedSms extends ParsedSms {
  const _ParsedSms({required this.kind, required this.amount, required this.currency, required this.occurredAt, required this.confidence, this.merchant, this.cardLast4, this.balance, this.reference, this.bankName, this.channel}): super._();
  

@override final  SmsKind kind;
@override final  Money amount;
/// ISO 4217 code of the amount, e.g. `EGP`.
@override final  String currency;
/// When it happened: the date and time in the text, else the SMS time.
@override final  DateTime occurredAt;
/// 0 to 1. At [highConfidence] and above, a real template matched; below
/// it, a generic pattern did, and the user is always asked.
@override final  double confidence;
/// The merchant, or for a transfer the other party; null when the message
/// has none.
@override final  String? merchant;
/// Last 4 digits of the card or account.
@override final  String? cardLast4;
/// The balance after the transaction, in [currency].
@override final  Money? balance;
@override final  String? reference;
/// The bank's display name, e.g. `EG Bank`.
@override final  String? bankName;
/// How the money moved when it was not by card, e.g. `InstaPay`.
@override final  String? channel;

/// Create a copy of ParsedSms
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ParsedSmsCopyWith<_ParsedSms> get copyWith => __$ParsedSmsCopyWithImpl<_ParsedSms>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ParsedSms&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.occurredAt, occurredAt) || other.occurredAt == occurredAt)&&(identical(other.confidence, confidence) || other.confidence == confidence)&&(identical(other.merchant, merchant) || other.merchant == merchant)&&(identical(other.cardLast4, cardLast4) || other.cardLast4 == cardLast4)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.reference, reference) || other.reference == reference)&&(identical(other.bankName, bankName) || other.bankName == bankName)&&(identical(other.channel, channel) || other.channel == channel));
}


@override
int get hashCode => Object.hash(runtimeType,kind,amount,currency,occurredAt,confidence,merchant,cardLast4,balance,reference,bankName,channel);

@override
String toString() {
  return 'ParsedSms(kind: $kind, amount: $amount, currency: $currency, occurredAt: $occurredAt, confidence: $confidence, merchant: $merchant, cardLast4: $cardLast4, balance: $balance, reference: $reference, bankName: $bankName, channel: $channel)';
}


}

/// @nodoc
abstract mixin class _$ParsedSmsCopyWith<$Res> implements $ParsedSmsCopyWith<$Res> {
  factory _$ParsedSmsCopyWith(_ParsedSms value, $Res Function(_ParsedSms) _then) = __$ParsedSmsCopyWithImpl;
@override @useResult
$Res call({
 SmsKind kind, Money amount, String currency, DateTime occurredAt, double confidence, String? merchant, String? cardLast4, Money? balance, String? reference, String? bankName, String? channel
});




}
/// @nodoc
class __$ParsedSmsCopyWithImpl<$Res>
    implements _$ParsedSmsCopyWith<$Res> {
  __$ParsedSmsCopyWithImpl(this._self, this._then);

  final _ParsedSms _self;
  final $Res Function(_ParsedSms) _then;

/// Create a copy of ParsedSms
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? kind = null,Object? amount = null,Object? currency = null,Object? occurredAt = null,Object? confidence = null,Object? merchant = freezed,Object? cardLast4 = freezed,Object? balance = freezed,Object? reference = freezed,Object? bankName = freezed,Object? channel = freezed,}) {
  return _then(_ParsedSms(
kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as SmsKind,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as String,occurredAt: null == occurredAt ? _self.occurredAt : occurredAt // ignore: cast_nullable_to_non_nullable
as DateTime,confidence: null == confidence ? _self.confidence : confidence // ignore: cast_nullable_to_non_nullable
as double,merchant: freezed == merchant ? _self.merchant : merchant // ignore: cast_nullable_to_non_nullable
as String?,cardLast4: freezed == cardLast4 ? _self.cardLast4 : cardLast4 // ignore: cast_nullable_to_non_nullable
as String?,balance: freezed == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as Money?,reference: freezed == reference ? _self.reference : reference // ignore: cast_nullable_to_non_nullable
as String?,bankName: freezed == bankName ? _self.bankName : bankName // ignore: cast_nullable_to_non_nullable
as String?,channel: freezed == channel ? _self.channel : channel // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
