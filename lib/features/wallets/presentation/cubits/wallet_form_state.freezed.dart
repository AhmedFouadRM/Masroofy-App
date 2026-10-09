// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletFormState {

 String get icon; int get color; WalletFormStatus get status;/// Null for a new wallet.
 int? get id;/// The name as typed. Empty for the seeded wallet until it is edited: its
/// name comes from the translations, which the screen fills in.
 String get name;/// Whether the name was typed in; a seeded wallet's name is kept as it is
/// until then.
 bool get nameEdited;/// The wallet being edited.
 Wallet? get wallet;/// The **Set as default** switch (edit mode only), and whether the wallet
/// was the default when the form opened.
 bool get makeDefault; bool get wasDefault;/// Shown under the name field; cleared as soon as the user types.
 ValidationReason? get nameError;/// A load, save or delete failure other than a name error.
 Failure? get failure;/// Every wallet, for the delete dialog (where its rows can move to).
 List<WalletSummary> get wallets;
/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletFormStateCopyWith<WalletFormState> get copyWith => _$WalletFormStateCopyWithImpl<WalletFormState>(this as WalletFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletFormState&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEdited, nameEdited) || other.nameEdited == nameEdited)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.makeDefault, makeDefault) || other.makeDefault == makeDefault)&&(identical(other.wasDefault, wasDefault) || other.wasDefault == wasDefault)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.failure, failure) || other.failure == failure)&&const DeepCollectionEquality().equals(other.wallets, wallets));
}


@override
int get hashCode => Object.hash(runtimeType,icon,color,status,id,name,nameEdited,wallet,makeDefault,wasDefault,nameError,failure,const DeepCollectionEquality().hash(wallets));

@override
String toString() {
  return 'WalletFormState(icon: $icon, color: $color, status: $status, id: $id, name: $name, nameEdited: $nameEdited, wallet: $wallet, makeDefault: $makeDefault, wasDefault: $wasDefault, nameError: $nameError, failure: $failure, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class $WalletFormStateCopyWith<$Res>  {
  factory $WalletFormStateCopyWith(WalletFormState value, $Res Function(WalletFormState) _then) = _$WalletFormStateCopyWithImpl;
@useResult
$Res call({
 String icon, int color, WalletFormStatus status, int? id, String name, bool nameEdited, Wallet? wallet, bool makeDefault, bool wasDefault, ValidationReason? nameError, Failure? failure, List<WalletSummary> wallets
});


$WalletCopyWith<$Res>? get wallet;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$WalletFormStateCopyWithImpl<$Res>
    implements $WalletFormStateCopyWith<$Res> {
  _$WalletFormStateCopyWithImpl(this._self, this._then);

  final WalletFormState _self;
  final $Res Function(WalletFormState) _then;

/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? color = null,Object? status = null,Object? id = freezed,Object? name = null,Object? nameEdited = null,Object? wallet = freezed,Object? makeDefault = null,Object? wasDefault = null,Object? nameError = freezed,Object? failure = freezed,Object? wallets = null,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WalletFormStatus,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEdited: null == nameEdited ? _self.nameEdited : nameEdited // ignore: cast_nullable_to_non_nullable
as bool,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet?,makeDefault: null == makeDefault ? _self.makeDefault : makeDefault // ignore: cast_nullable_to_non_nullable
as bool,wasDefault: null == wasDefault ? _self.wasDefault : wasDefault // ignore: cast_nullable_to_non_nullable
as bool,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as ValidationReason?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,wallets: null == wallets ? _self.wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletSummary>,
  ));
}
/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}


/// Adds pattern-matching-related methods to [WalletFormState].
extension WalletFormStatePatterns on WalletFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletFormState value)  $default,){
final _that = this;
switch (_that) {
case _WalletFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletFormState value)?  $default,){
final _that = this;
switch (_that) {
case _WalletFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String icon,  int color,  WalletFormStatus status,  int? id,  String name,  bool nameEdited,  Wallet? wallet,  bool makeDefault,  bool wasDefault,  ValidationReason? nameError,  Failure? failure,  List<WalletSummary> wallets)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletFormState() when $default != null:
return $default(_that.icon,_that.color,_that.status,_that.id,_that.name,_that.nameEdited,_that.wallet,_that.makeDefault,_that.wasDefault,_that.nameError,_that.failure,_that.wallets);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String icon,  int color,  WalletFormStatus status,  int? id,  String name,  bool nameEdited,  Wallet? wallet,  bool makeDefault,  bool wasDefault,  ValidationReason? nameError,  Failure? failure,  List<WalletSummary> wallets)  $default,) {final _that = this;
switch (_that) {
case _WalletFormState():
return $default(_that.icon,_that.color,_that.status,_that.id,_that.name,_that.nameEdited,_that.wallet,_that.makeDefault,_that.wasDefault,_that.nameError,_that.failure,_that.wallets);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String icon,  int color,  WalletFormStatus status,  int? id,  String name,  bool nameEdited,  Wallet? wallet,  bool makeDefault,  bool wasDefault,  ValidationReason? nameError,  Failure? failure,  List<WalletSummary> wallets)?  $default,) {final _that = this;
switch (_that) {
case _WalletFormState() when $default != null:
return $default(_that.icon,_that.color,_that.status,_that.id,_that.name,_that.nameEdited,_that.wallet,_that.makeDefault,_that.wasDefault,_that.nameError,_that.failure,_that.wallets);case _:
  return null;

}
}

}

/// @nodoc


class _WalletFormState extends WalletFormState {
  const _WalletFormState({required this.icon, required this.color, this.status = WalletFormStatus.loading, this.id, this.name = '', this.nameEdited = false, this.wallet, this.makeDefault = false, this.wasDefault = false, this.nameError, this.failure, final  List<WalletSummary> wallets = const <WalletSummary>[]}): _wallets = wallets,super._();
  

@override final  String icon;
@override final  int color;
@override@JsonKey() final  WalletFormStatus status;
/// Null for a new wallet.
@override final  int? id;
/// The name as typed. Empty for the seeded wallet until it is edited: its
/// name comes from the translations, which the screen fills in.
@override@JsonKey() final  String name;
/// Whether the name was typed in; a seeded wallet's name is kept as it is
/// until then.
@override@JsonKey() final  bool nameEdited;
/// The wallet being edited.
@override final  Wallet? wallet;
/// The **Set as default** switch (edit mode only), and whether the wallet
/// was the default when the form opened.
@override@JsonKey() final  bool makeDefault;
@override@JsonKey() final  bool wasDefault;
/// Shown under the name field; cleared as soon as the user types.
@override final  ValidationReason? nameError;
/// A load, save or delete failure other than a name error.
@override final  Failure? failure;
/// Every wallet, for the delete dialog (where its rows can move to).
 final  List<WalletSummary> _wallets;
/// Every wallet, for the delete dialog (where its rows can move to).
@override@JsonKey() List<WalletSummary> get wallets {
  if (_wallets is EqualUnmodifiableListView) return _wallets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_wallets);
}


/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletFormStateCopyWith<_WalletFormState> get copyWith => __$WalletFormStateCopyWithImpl<_WalletFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletFormState&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.nameEdited, nameEdited) || other.nameEdited == nameEdited)&&(identical(other.wallet, wallet) || other.wallet == wallet)&&(identical(other.makeDefault, makeDefault) || other.makeDefault == makeDefault)&&(identical(other.wasDefault, wasDefault) || other.wasDefault == wasDefault)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.failure, failure) || other.failure == failure)&&const DeepCollectionEquality().equals(other._wallets, _wallets));
}


@override
int get hashCode => Object.hash(runtimeType,icon,color,status,id,name,nameEdited,wallet,makeDefault,wasDefault,nameError,failure,const DeepCollectionEquality().hash(_wallets));

@override
String toString() {
  return 'WalletFormState(icon: $icon, color: $color, status: $status, id: $id, name: $name, nameEdited: $nameEdited, wallet: $wallet, makeDefault: $makeDefault, wasDefault: $wasDefault, nameError: $nameError, failure: $failure, wallets: $wallets)';
}


}

/// @nodoc
abstract mixin class _$WalletFormStateCopyWith<$Res> implements $WalletFormStateCopyWith<$Res> {
  factory _$WalletFormStateCopyWith(_WalletFormState value, $Res Function(_WalletFormState) _then) = __$WalletFormStateCopyWithImpl;
@override @useResult
$Res call({
 String icon, int color, WalletFormStatus status, int? id, String name, bool nameEdited, Wallet? wallet, bool makeDefault, bool wasDefault, ValidationReason? nameError, Failure? failure, List<WalletSummary> wallets
});


@override $WalletCopyWith<$Res>? get wallet;@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$WalletFormStateCopyWithImpl<$Res>
    implements _$WalletFormStateCopyWith<$Res> {
  __$WalletFormStateCopyWithImpl(this._self, this._then);

  final _WalletFormState _self;
  final $Res Function(_WalletFormState) _then;

/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? color = null,Object? status = null,Object? id = freezed,Object? name = null,Object? nameEdited = null,Object? wallet = freezed,Object? makeDefault = null,Object? wasDefault = null,Object? nameError = freezed,Object? failure = freezed,Object? wallets = null,}) {
  return _then(_WalletFormState(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as WalletFormStatus,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,nameEdited: null == nameEdited ? _self.nameEdited : nameEdited // ignore: cast_nullable_to_non_nullable
as bool,wallet: freezed == wallet ? _self.wallet : wallet // ignore: cast_nullable_to_non_nullable
as Wallet?,makeDefault: null == makeDefault ? _self.makeDefault : makeDefault // ignore: cast_nullable_to_non_nullable
as bool,wasDefault: null == wasDefault ? _self.wasDefault : wasDefault // ignore: cast_nullable_to_non_nullable
as bool,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as ValidationReason?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,wallets: null == wallets ? _self._wallets : wallets // ignore: cast_nullable_to_non_nullable
as List<WalletSummary>,
  ));
}

/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WalletCopyWith<$Res>? get wallet {
    if (_self.wallet == null) {
    return null;
  }

  return $WalletCopyWith<$Res>(_self.wallet!, (value) {
    return _then(_self.copyWith(wallet: value));
  });
}/// Create a copy of WalletFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get failure {
    if (_self.failure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.failure!, (value) {
    return _then(_self.copyWith(failure: value));
  });
}
}

// dart format on
