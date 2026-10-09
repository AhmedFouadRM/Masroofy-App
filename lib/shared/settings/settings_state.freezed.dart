// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'settings_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$SettingsState {

 ThemeMode get themeMode; Currency get currency;/// Show Western digits (123) instead of Eastern Arabic digits (١٢٣) in Arabic.
 bool get westernDigits;/// First day of the week as a `DateTime.weekday` value, from the device
/// region (not the app language): Saturday in Egypt, Sunday in Saudi Arabia.
 int get firstWeekday;/// False until the user has picked a currency on first launch. Defaults to
/// true so a state built without it (tests) skips the first-launch step.
 bool get currencyChosen;/// The wallet new transactions go to when All wallets is viewed. Null only
/// until the app has checked it against the wallets (a fresh install).
 int? get defaultWalletId;/// The wallet the Transactions list and Analytics show; null is All wallets.
 int? get viewedWalletId;
/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SettingsStateCopyWith<SettingsState> get copyWith => _$SettingsStateCopyWithImpl<SettingsState>(this as SettingsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.westernDigits, westernDigits) || other.westernDigits == westernDigits)&&(identical(other.firstWeekday, firstWeekday) || other.firstWeekday == firstWeekday)&&(identical(other.currencyChosen, currencyChosen) || other.currencyChosen == currencyChosen)&&(identical(other.defaultWalletId, defaultWalletId) || other.defaultWalletId == defaultWalletId)&&(identical(other.viewedWalletId, viewedWalletId) || other.viewedWalletId == viewedWalletId));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,currency,westernDigits,firstWeekday,currencyChosen,defaultWalletId,viewedWalletId);

@override
String toString() {
  return 'SettingsState(themeMode: $themeMode, currency: $currency, westernDigits: $westernDigits, firstWeekday: $firstWeekday, currencyChosen: $currencyChosen, defaultWalletId: $defaultWalletId, viewedWalletId: $viewedWalletId)';
}


}

/// @nodoc
abstract mixin class $SettingsStateCopyWith<$Res>  {
  factory $SettingsStateCopyWith(SettingsState value, $Res Function(SettingsState) _then) = _$SettingsStateCopyWithImpl;
@useResult
$Res call({
 ThemeMode themeMode, Currency currency, bool westernDigits, int firstWeekday, bool currencyChosen, int? defaultWalletId, int? viewedWalletId
});




}
/// @nodoc
class _$SettingsStateCopyWithImpl<$Res>
    implements $SettingsStateCopyWith<$Res> {
  _$SettingsStateCopyWithImpl(this._self, this._then);

  final SettingsState _self;
  final $Res Function(SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? themeMode = null,Object? currency = null,Object? westernDigits = null,Object? firstWeekday = null,Object? currencyChosen = null,Object? defaultWalletId = freezed,Object? viewedWalletId = freezed,}) {
  return _then(_self.copyWith(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,westernDigits: null == westernDigits ? _self.westernDigits : westernDigits // ignore: cast_nullable_to_non_nullable
as bool,firstWeekday: null == firstWeekday ? _self.firstWeekday : firstWeekday // ignore: cast_nullable_to_non_nullable
as int,currencyChosen: null == currencyChosen ? _self.currencyChosen : currencyChosen // ignore: cast_nullable_to_non_nullable
as bool,defaultWalletId: freezed == defaultWalletId ? _self.defaultWalletId : defaultWalletId // ignore: cast_nullable_to_non_nullable
as int?,viewedWalletId: freezed == viewedWalletId ? _self.viewedWalletId : viewedWalletId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [SettingsState].
extension SettingsStatePatterns on SettingsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SettingsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SettingsState value)  $default,){
final _that = this;
switch (_that) {
case _SettingsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SettingsState value)?  $default,){
final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ThemeMode themeMode,  Currency currency,  bool westernDigits,  int firstWeekday,  bool currencyChosen,  int? defaultWalletId,  int? viewedWalletId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.themeMode,_that.currency,_that.westernDigits,_that.firstWeekday,_that.currencyChosen,_that.defaultWalletId,_that.viewedWalletId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ThemeMode themeMode,  Currency currency,  bool westernDigits,  int firstWeekday,  bool currencyChosen,  int? defaultWalletId,  int? viewedWalletId)  $default,) {final _that = this;
switch (_that) {
case _SettingsState():
return $default(_that.themeMode,_that.currency,_that.westernDigits,_that.firstWeekday,_that.currencyChosen,_that.defaultWalletId,_that.viewedWalletId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ThemeMode themeMode,  Currency currency,  bool westernDigits,  int firstWeekday,  bool currencyChosen,  int? defaultWalletId,  int? viewedWalletId)?  $default,) {final _that = this;
switch (_that) {
case _SettingsState() when $default != null:
return $default(_that.themeMode,_that.currency,_that.westernDigits,_that.firstWeekday,_that.currencyChosen,_that.defaultWalletId,_that.viewedWalletId);case _:
  return null;

}
}

}

/// @nodoc


class _SettingsState implements SettingsState {
  const _SettingsState({required this.themeMode, required this.currency, required this.westernDigits, required this.firstWeekday, this.currencyChosen = true, this.defaultWalletId, this.viewedWalletId});
  

@override final  ThemeMode themeMode;
@override final  Currency currency;
/// Show Western digits (123) instead of Eastern Arabic digits (١٢٣) in Arabic.
@override final  bool westernDigits;
/// First day of the week as a `DateTime.weekday` value, from the device
/// region (not the app language): Saturday in Egypt, Sunday in Saudi Arabia.
@override final  int firstWeekday;
/// False until the user has picked a currency on first launch. Defaults to
/// true so a state built without it (tests) skips the first-launch step.
@override@JsonKey() final  bool currencyChosen;
/// The wallet new transactions go to when All wallets is viewed. Null only
/// until the app has checked it against the wallets (a fresh install).
@override final  int? defaultWalletId;
/// The wallet the Transactions list and Analytics show; null is All wallets.
@override final  int? viewedWalletId;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SettingsStateCopyWith<_SettingsState> get copyWith => __$SettingsStateCopyWithImpl<_SettingsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SettingsState&&(identical(other.themeMode, themeMode) || other.themeMode == themeMode)&&(identical(other.currency, currency) || other.currency == currency)&&(identical(other.westernDigits, westernDigits) || other.westernDigits == westernDigits)&&(identical(other.firstWeekday, firstWeekday) || other.firstWeekday == firstWeekday)&&(identical(other.currencyChosen, currencyChosen) || other.currencyChosen == currencyChosen)&&(identical(other.defaultWalletId, defaultWalletId) || other.defaultWalletId == defaultWalletId)&&(identical(other.viewedWalletId, viewedWalletId) || other.viewedWalletId == viewedWalletId));
}


@override
int get hashCode => Object.hash(runtimeType,themeMode,currency,westernDigits,firstWeekday,currencyChosen,defaultWalletId,viewedWalletId);

@override
String toString() {
  return 'SettingsState(themeMode: $themeMode, currency: $currency, westernDigits: $westernDigits, firstWeekday: $firstWeekday, currencyChosen: $currencyChosen, defaultWalletId: $defaultWalletId, viewedWalletId: $viewedWalletId)';
}


}

/// @nodoc
abstract mixin class _$SettingsStateCopyWith<$Res> implements $SettingsStateCopyWith<$Res> {
  factory _$SettingsStateCopyWith(_SettingsState value, $Res Function(_SettingsState) _then) = __$SettingsStateCopyWithImpl;
@override @useResult
$Res call({
 ThemeMode themeMode, Currency currency, bool westernDigits, int firstWeekday, bool currencyChosen, int? defaultWalletId, int? viewedWalletId
});




}
/// @nodoc
class __$SettingsStateCopyWithImpl<$Res>
    implements _$SettingsStateCopyWith<$Res> {
  __$SettingsStateCopyWithImpl(this._self, this._then);

  final _SettingsState _self;
  final $Res Function(_SettingsState) _then;

/// Create a copy of SettingsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? themeMode = null,Object? currency = null,Object? westernDigits = null,Object? firstWeekday = null,Object? currencyChosen = null,Object? defaultWalletId = freezed,Object? viewedWalletId = freezed,}) {
  return _then(_SettingsState(
themeMode: null == themeMode ? _self.themeMode : themeMode // ignore: cast_nullable_to_non_nullable
as ThemeMode,currency: null == currency ? _self.currency : currency // ignore: cast_nullable_to_non_nullable
as Currency,westernDigits: null == westernDigits ? _self.westernDigits : westernDigits // ignore: cast_nullable_to_non_nullable
as bool,firstWeekday: null == firstWeekday ? _self.firstWeekday : firstWeekday // ignore: cast_nullable_to_non_nullable
as int,currencyChosen: null == currencyChosen ? _self.currencyChosen : currencyChosen // ignore: cast_nullable_to_non_nullable
as bool,defaultWalletId: freezed == defaultWalletId ? _self.defaultWalletId : defaultWalletId // ignore: cast_nullable_to_non_nullable
as int?,viewedWalletId: freezed == viewedWalletId ? _self.viewedWalletId : viewedWalletId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}

// dart format on
