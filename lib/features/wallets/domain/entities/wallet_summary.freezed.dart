// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletSummary {

 Wallet get wallet;/// Income and transfers in, minus spending and transfers out.
 Money get balance;/// Rows of the wallet, transfer legs included.
 int get transactionCount;/// How many of those rows are transfer legs.
 int get transferCount; int get templateCount;
/// Create a copy of WalletSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletSummaryCopyWith<WalletSummary> get copyWith => _$WalletSummaryCopyWithImpl<WalletSummary>(this as WalletSummary, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletSummary&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.transferCount, transferCount) || other.transferCount == transferCount)&&(identical(other.templateCount, templateCount) || other.templateCount == templateCount));
}


@override
int get hashCode => Object.hash(runtimeType,wallet,balance,transactionCount,transferCount,templateCount);

@override
String toString() {
  return 'WalletSummary(wallet: $wallet, balance: $balance, transactionCount: $transactionCount, transferCount: $transferCount, templateCount: $templateCount)';
}


}

/// @nodoc
abstract mixin class $WalletSummaryCopyWith<$Res>  {
  factory $WalletSummaryCopyWith(WalletSummary value, $Res Function(WalletSummary) _then) = _$WalletSummaryCopyWithImpl;
@useResult
$Res call({
 Wallet wallet, Money balance, int transactionCount, int transferCount, int templateCount
});


$WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class _$WalletSummaryCopyWithImpl<$Res>
    implements $WalletSummaryCopyWith<$Res> {
  _$WalletSummaryCopyWithImpl(this._self, this._then);

  final WalletSummary _self;
  final $Res Function(WalletSummary) _then;

/// Create a copy of WalletSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? wallet = null,Object? balance = null,Object? transactionCount = null,Object? transferCount = null,Object? templateCount = null,}) {
  return _then(_self.copyWith(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as Money,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,transferCount: null == transferCount ? _self.transferCount : transferCount // ignore: cast_nullable_to_non_nullable
as int,templateCount: null == templateCount ? _self.templateCount : templateCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of WalletSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletSummary].
extension WalletSummaryPatterns on WalletSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletSummary value)  $default,){
final _that = this;
switch (_that) {
case _WalletSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WalletSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Wallet wallet,  Money balance,  int transactionCount,  int transferCount,  int templateCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletSummary() when $default != null:
return $default(_that.wallet,_that.balance,_that.transactionCount,_that.transferCount,_that.templateCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Wallet wallet,  Money balance,  int transactionCount,  int transferCount,  int templateCount)  $default,) {final _that = this;
switch (_that) {
case _WalletSummary():
return $default(_that.wallet,_that.balance,_that.transactionCount,_that.transferCount,_that.templateCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Wallet wallet,  Money balance,  int transactionCount,  int transferCount,  int templateCount)?  $default,) {final _that = this;
switch (_that) {
case _WalletSummary() when $default != null:
return $default(_that.wallet,_that.balance,_that.transactionCount,_that.transferCount,_that.templateCount);case _:
  return null;

}
}

}

/// @nodoc


class _WalletSummary extends WalletSummary {
  const _WalletSummary({required this.wallet, required this.balance, required this.transactionCount, required this.transferCount, required this.templateCount}): super._();
  

@override final  Wallet wallet;
/// Income and transfers in, minus spending and transfers out.
@override final  Money balance;
/// Rows of the wallet, transfer legs included.
@override final  int transactionCount;
/// How many of those rows are transfer legs.
@override final  int transferCount;
@override final  int templateCount;

/// Create a copy of WalletSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletSummaryCopyWith<_WalletSummary> get copyWith => __$WalletSummaryCopyWithImpl<_WalletSummary>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletSummary&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.balance, balance) || other.balance == balance)&&(identical(other.transactionCount, transactionCount) || other.transactionCount == transactionCount)&&(identical(other.transferCount, transferCount) || other.transferCount == transferCount)&&(identical(other.templateCount, templateCount) || other.templateCount == templateCount));
}


@override
int get hashCode => Object.hash(runtimeType,wallet,balance,transactionCount,transferCount,templateCount);

@override
String toString() {
  return 'WalletSummary(wallet: $wallet, balance: $balance, transactionCount: $transactionCount, transferCount: $transferCount, templateCount: $templateCount)';
}


}

/// @nodoc
abstract mixin class _$WalletSummaryCopyWith<$Res> implements $WalletSummaryCopyWith<$Res> {
  factory _$WalletSummaryCopyWith(_WalletSummary value, $Res Function(_WalletSummary) _then) = __$WalletSummaryCopyWithImpl;
@override @useResult
$Res call({
 Wallet wallet, Money balance, int transactionCount, int transferCount, int templateCount
});


@override $WalletCopyWith<$Res> get wallet;

}
/// @nodoc
class __$WalletSummaryCopyWithImpl<$Res>
    implements _$WalletSummaryCopyWith<$Res> {
  __$WalletSummaryCopyWithImpl(this._self, this._then);

  final _WalletSummary _self;
  final $Res Function(_WalletSummary) _then;

/// Create a copy of WalletSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? wallet = null,Object? balance = null,Object? transactionCount = null,Object? transferCount = null,Object? templateCount = null,}) {
  return _then(_WalletSummary(
wallet: null == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet,balance: null == balance ? _self.balance : balance // ignore: cast_nullable_to_non_nullable
as Money,transactionCount: null == transactionCount ? _self.transactionCount : transactionCount // ignore: cast_nullable_to_non_nullable
as int,transferCount: null == transferCount ? _self.transferCount : transferCount // ignore: cast_nullable_to_non_nullable
as int,templateCount: null == templateCount ? _self.templateCount : templateCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of WalletSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res> get wallet {
  
  return $WalletCopyWith<$Res>(_self.wallet, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}
}

// dart format on
