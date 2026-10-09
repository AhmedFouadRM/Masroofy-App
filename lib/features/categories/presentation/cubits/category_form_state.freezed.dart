// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'category_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CategoryFormState {

 String get icon; int get color; CategoryFormStatus get status;/// Null for a new category.
 int? get id; String get name; TransactionKind get kind;/// Shown under the name field; cleared as soon as the user types.
 ValidationReason? get nameError;/// A load, save or delete failure other than a name error.
 Failure? get failure;/// Usage of the category being edited, for the delete confirmation.
 CategorySummary? get usage;
/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CategoryFormStateCopyWith<CategoryFormState> get copyWith => _$CategoryFormStateCopyWithImpl<CategoryFormState>(this as CategoryFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CategoryFormState&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.usage, usage) || other.usage == usage));
}


@override
int get hashCode => Object.hash(runtimeType,icon,color,status,id,name,kind,nameError,failure,usage);

@override
String toString() {
  return 'CategoryFormState(icon: $icon, color: $color, status: $status, id: $id, name: $name, kind: $kind, nameError: $nameError, failure: $failure, usage: $usage)';
}


}

/// @nodoc
abstract mixin class $CategoryFormStateCopyWith<$Res>  {
  factory $CategoryFormStateCopyWith(CategoryFormState value, $Res Function(CategoryFormState) _then) = _$CategoryFormStateCopyWithImpl;
@useResult
$Res call({
 String icon, int color, CategoryFormStatus status, int? id, String name, TransactionKind kind, ValidationReason? nameError, Failure? failure, CategorySummary? usage
});


$FailureCopyWith<$Res>? get failure;$CategorySummaryCopyWith<$Res>? get usage;

}
/// @nodoc
class _$CategoryFormStateCopyWithImpl<$Res>
    implements $CategoryFormStateCopyWith<$Res> {
  _$CategoryFormStateCopyWithImpl(this._self, this._then);

  final CategoryFormState _self;
  final $Res Function(CategoryFormState) _then;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? icon = null,Object? color = null,Object? status = null,Object? id = freezed,Object? name = null,Object? kind = null,Object? nameError = freezed,Object? failure = freezed,Object? usage = freezed,}) {
  return _then(_self.copyWith(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CategoryFormStatus,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as ValidationReason?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as CategorySummary?,
  ));
}
/// Create a copy of CategoryFormState
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
}/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategorySummaryCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $CategorySummaryCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}


/// Adds pattern-matching-related methods to [CategoryFormState].
extension CategoryFormStatePatterns on CategoryFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CategoryFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CategoryFormState value)  $default,){
final _that = this;
switch (_that) {
case _CategoryFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CategoryFormState value)?  $default,){
final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String icon,  int color,  CategoryFormStatus status,  int? id,  String name,  TransactionKind kind,  ValidationReason? nameError,  Failure? failure,  CategorySummary? usage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
return $default(_that.icon,_that.color,_that.status,_that.id,_that.name,_that.kind,_that.nameError,_that.failure,_that.usage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String icon,  int color,  CategoryFormStatus status,  int? id,  String name,  TransactionKind kind,  ValidationReason? nameError,  Failure? failure,  CategorySummary? usage)  $default,) {final _that = this;
switch (_that) {
case _CategoryFormState():
return $default(_that.icon,_that.color,_that.status,_that.id,_that.name,_that.kind,_that.nameError,_that.failure,_that.usage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String icon,  int color,  CategoryFormStatus status,  int? id,  String name,  TransactionKind kind,  ValidationReason? nameError,  Failure? failure,  CategorySummary? usage)?  $default,) {final _that = this;
switch (_that) {
case _CategoryFormState() when $default != null:
return $default(_that.icon,_that.color,_that.status,_that.id,_that.name,_that.kind,_that.nameError,_that.failure,_that.usage);case _:
  return null;

}
}

}

/// @nodoc


class _CategoryFormState extends CategoryFormState {
  const _CategoryFormState({required this.icon, required this.color, this.status = CategoryFormStatus.loading, this.id, this.name = '', this.kind = TransactionKind.expense, this.nameError, this.failure, this.usage}): super._();
  

@override final  String icon;
@override final  int color;
@override@JsonKey() final  CategoryFormStatus status;
/// Null for a new category.
@override final  int? id;
@override@JsonKey() final  String name;
@override@JsonKey() final  TransactionKind kind;
/// Shown under the name field; cleared as soon as the user types.
@override final  ValidationReason? nameError;
/// A load, save or delete failure other than a name error.
@override final  Failure? failure;
/// Usage of the category being edited, for the delete confirmation.
@override final  CategorySummary? usage;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CategoryFormStateCopyWith<_CategoryFormState> get copyWith => __$CategoryFormStateCopyWithImpl<_CategoryFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CategoryFormState&&(identical(other.icon, icon) || other.icon == icon)&&(identical(other.color, color) || other.color == color)&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.nameError, nameError) || other.nameError == nameError)&&(identical(other.failure, failure) || other.failure == failure)&&(identical(other.usage, usage) || other.usage == usage));
}


@override
int get hashCode => Object.hash(runtimeType,icon,color,status,id,name,kind,nameError,failure,usage);

@override
String toString() {
  return 'CategoryFormState(icon: $icon, color: $color, status: $status, id: $id, name: $name, kind: $kind, nameError: $nameError, failure: $failure, usage: $usage)';
}


}

/// @nodoc
abstract mixin class _$CategoryFormStateCopyWith<$Res> implements $CategoryFormStateCopyWith<$Res> {
  factory _$CategoryFormStateCopyWith(_CategoryFormState value, $Res Function(_CategoryFormState) _then) = __$CategoryFormStateCopyWithImpl;
@override @useResult
$Res call({
 String icon, int color, CategoryFormStatus status, int? id, String name, TransactionKind kind, ValidationReason? nameError, Failure? failure, CategorySummary? usage
});


@override $FailureCopyWith<$Res>? get failure;@override $CategorySummaryCopyWith<$Res>? get usage;

}
/// @nodoc
class __$CategoryFormStateCopyWithImpl<$Res>
    implements _$CategoryFormStateCopyWith<$Res> {
  __$CategoryFormStateCopyWithImpl(this._self, this._then);

  final _CategoryFormState _self;
  final $Res Function(_CategoryFormState) _then;

/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? icon = null,Object? color = null,Object? status = null,Object? id = freezed,Object? name = null,Object? kind = null,Object? nameError = freezed,Object? failure = freezed,Object? usage = freezed,}) {
  return _then(_CategoryFormState(
icon: null == icon ? _self.icon : icon // ignore: cast_nullable_to_non_nullable
as String,color: null == color ? _self.color : color // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CategoryFormStatus,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,nameError: freezed == nameError ? _self.nameError : nameError // ignore: cast_nullable_to_non_nullable
as ValidationReason?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,usage: freezed == usage ? _self.usage : usage // ignore: cast_nullable_to_non_nullable
as CategorySummary?,
  ));
}

/// Create a copy of CategoryFormState
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
}/// Create a copy of CategoryFormState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CategorySummaryCopyWith<$Res>? get usage {
    if (_self.usage == null) {
    return null;
  }

  return $CategorySummaryCopyWith<$Res>(_self.usage!, (value) {
    return _then(_self.copyWith(usage: value));
  });
}
}

// dart format on
