// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wallet_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$WalletDraft {

 String get icon; int get color;/// Null keeps the seeded name of "Me" as it is (translated); required for
/// every other wallet.
 String? get name;
/// Create a copy of WalletDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WalletDraftCopyWith<WalletDraft> get copyWith => _$WalletDraftCopyWithImpl<WalletDraft>(this as WalletDraft, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WalletDraft&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,icon,color,name);

@override
String toString() {
  return 'WalletDraft(icon: $icon, color: $color, name: $name)';
}


}

/// @nodoc
abstract mixin class $WalletDraftCopyWith<$Res>  {
  factory $WalletDraftCopyWith(WalletDraft value, $Res Function(WalletDraft) _then) = _$WalletDraftCopyWithImpl;
@useResult
$Res call({
 String icon, int color, String? name
});




}
/// @nodoc
class _$WalletDraftCopyWithImpl<$Res>
    implements $WalletDraftCopyWith<$Res> {
  _$WalletDraftCopyWithImpl(this._self, this._then);

  final WalletDraft _self;
  final $Res Function(WalletDraft) _then;

/// Create a copy of WalletDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? color = null,Object? name = freezed,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WalletDraft].
extension WalletDraftPatterns on WalletDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WalletDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WalletDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WalletDraft value)  $default,){
final _that = this;
switch (_that) {
case _WalletDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WalletDraft value)?  $default,){
final _that = this;
switch (_that) {
case _WalletDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String icon,  int color,  String? name)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WalletDraft() when $default != null:
return $default(_that.icon,_that.color,_that.name);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String icon,  int color,  String? name)  $default,) {final _that = this;
switch (_that) {
case _WalletDraft():
return $default(_that.icon,_that.color,_that.name);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String icon,  int color,  String? name)?  $default,) {final _that = this;
switch (_that) {
case _WalletDraft() when $default != null:
return $default(_that.icon,_that.color,_that.name);case _:
  return null;

}
}

}

/// @nodoc


class _WalletDraft implements WalletDraft {
  const _WalletDraft({required this.icon, required this.color, this.name});
  

@override final  String icon;
@override final  int color;
/// Null keeps the seeded name of "Me" as it is (translated); required for
/// every other wallet.
@override final  String? name;

/// Create a copy of WalletDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WalletDraftCopyWith<_WalletDraft> get copyWith => __$WalletDraftCopyWithImpl<_WalletDraft>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _WalletDraft&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.name, name) || other.name == name));
}


@override
int get hashCode => Object.hash(runtimeType,icon,color,name);

@override
String toString() {
  return 'WalletDraft(icon: $icon, color: $color, name: $name)';
}


}

/// @nodoc
abstract mixin class _$WalletDraftCopyWith<$Res> implements $WalletDraftCopyWith<$Res> {
  factory _$WalletDraftCopyWith(_WalletDraft value, $Res Function(_WalletDraft) _then) = __$WalletDraftCopyWithImpl;
@override @useResult
$Res call({
 String icon, int color, String? name
});




}
/// @nodoc
class __$WalletDraftCopyWithImpl<$Res>
    implements _$WalletDraftCopyWith<$Res> {
  __$WalletDraftCopyWithImpl(this._self, this._then);

  final _WalletDraft _self;
  final $Res Function(_WalletDraft) _then;

/// Create a copy of WalletDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? color = null,Object? name = freezed,}) {
  return _then(_WalletDraft(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
