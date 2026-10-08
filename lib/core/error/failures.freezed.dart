// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'failures.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$Failure {





@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Failure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure()';
}


}

/// @nodoc
class $FailureCopyWith<$Res>  {
$FailureCopyWith(Failure _, $Res Function(Failure) __);
}


/// Adds pattern-matching-related methods to [Failure].
extension FailurePatterns on Failure {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>({TResult Function( ValidationFailure value)?  validation,TResult Function( NotFoundFailure value)?  notFound,TResult Function( ConstraintFailure value)?  constraint,TResult Function( StorageFailure value)?  storage,TResult Function( SecureStorageFailure value)?  secureStorage,TResult Function( ExportFailure value)?  exportFailed,TResult Function( UnexpectedFailure value)?  unexpected,required TResult orElse(),}){
final _that = this;
switch (_that) {
case ValidationFailure() when validation != null:
return validation(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ConstraintFailure() when constraint != null:
return constraint(_that);case StorageFailure() when storage != null:
return storage(_that);case SecureStorageFailure() when secureStorage != null:
return secureStorage(_that);case ExportFailure() when exportFailed != null:
return exportFailed(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult map<TResult extends Object?>({required TResult Function( ValidationFailure value)  validation,required TResult Function( NotFoundFailure value)  notFound,required TResult Function( ConstraintFailure value)  constraint,required TResult Function( StorageFailure value)  storage,required TResult Function( SecureStorageFailure value)  secureStorage,required TResult Function( ExportFailure value)  exportFailed,required TResult Function( UnexpectedFailure value)  unexpected,}){
final _that = this;
switch (_that) {
case ValidationFailure():
return validation(_that);case NotFoundFailure():
return notFound(_that);case ConstraintFailure():
return constraint(_that);case StorageFailure():
return storage(_that);case SecureStorageFailure():
return secureStorage(_that);case ExportFailure():
return exportFailed(_that);case UnexpectedFailure():
return unexpected(_that);}
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>({TResult? Function( ValidationFailure value)?  validation,TResult? Function( NotFoundFailure value)?  notFound,TResult? Function( ConstraintFailure value)?  constraint,TResult? Function( StorageFailure value)?  storage,TResult? Function( SecureStorageFailure value)?  secureStorage,TResult? Function( ExportFailure value)?  exportFailed,TResult? Function( UnexpectedFailure value)?  unexpected,}){
final _that = this;
switch (_that) {
case ValidationFailure() when validation != null:
return validation(_that);case NotFoundFailure() when notFound != null:
return notFound(_that);case ConstraintFailure() when constraint != null:
return constraint(_that);case StorageFailure() when storage != null:
return storage(_that);case SecureStorageFailure() when secureStorage != null:
return secureStorage(_that);case ExportFailure() when exportFailed != null:
return exportFailed(_that);case UnexpectedFailure() when unexpected != null:
return unexpected(_that);case _:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>({TResult Function( String field,  ValidationReason reason)?  validation,TResult Function()?  notFound,TResult Function( String message)?  constraint,TResult Function( String message)?  storage,TResult Function( String message)?  secureStorage,TResult Function( String message)?  exportFailed,TResult Function( Object error,  StackTrace? stackTrace)?  unexpected,required TResult orElse(),}) {final _that = this;
switch (_that) {
case ValidationFailure() when validation != null:
return validation(_that.field,_that.reason);case NotFoundFailure() when notFound != null:
return notFound();case ConstraintFailure() when constraint != null:
return constraint(_that.message);case StorageFailure() when storage != null:
return storage(_that.message);case SecureStorageFailure() when secureStorage != null:
return secureStorage(_that.message);case ExportFailure() when exportFailed != null:
return exportFailed(_that.message);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.error,_that.stackTrace);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>({required TResult Function( String field,  ValidationReason reason)  validation,required TResult Function()  notFound,required TResult Function( String message)  constraint,required TResult Function( String message)  storage,required TResult Function( String message)  secureStorage,required TResult Function( String message)  exportFailed,required TResult Function( Object error,  StackTrace? stackTrace)  unexpected,}) {final _that = this;
switch (_that) {
case ValidationFailure():
return validation(_that.field,_that.reason);case NotFoundFailure():
return notFound();case ConstraintFailure():
return constraint(_that.message);case StorageFailure():
return storage(_that.message);case SecureStorageFailure():
return secureStorage(_that.message);case ExportFailure():
return exportFailed(_that.message);case UnexpectedFailure():
return unexpected(_that.error,_that.stackTrace);}
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>({TResult? Function( String field,  ValidationReason reason)?  validation,TResult? Function()?  notFound,TResult? Function( String message)?  constraint,TResult? Function( String message)?  storage,TResult? Function( String message)?  secureStorage,TResult? Function( String message)?  exportFailed,TResult? Function( Object error,  StackTrace? stackTrace)?  unexpected,}) {final _that = this;
switch (_that) {
case ValidationFailure() when validation != null:
return validation(_that.field,_that.reason);case NotFoundFailure() when notFound != null:
return notFound();case ConstraintFailure() when constraint != null:
return constraint(_that.message);case StorageFailure() when storage != null:
return storage(_that.message);case SecureStorageFailure() when secureStorage != null:
return secureStorage(_that.message);case ExportFailure() when exportFailed != null:
return exportFailed(_that.message);case UnexpectedFailure() when unexpected != null:
return unexpected(_that.error,_that.stackTrace);case _:
  return null;

}
}

}

/// @nodoc


class ValidationFailure implements Failure {
  const ValidationFailure({required this.field, required this.reason});
  

 final  String field;
 final  ValidationReason reason;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ValidationFailureCopyWith<ValidationFailure> get copyWith => _$ValidationFailureCopyWithImpl<ValidationFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ValidationFailure&&(identical(other.field, field) || other.field == field)&&(identical(other.reason, reason) || other.reason == reason));
}


@override
int get hashCode => Object.hash(runtimeType,field,reason);

@override
String toString() {
  return 'Failure.validation(field: $field, reason: $reason)';
}


}

/// @nodoc
abstract mixin class $ValidationFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ValidationFailureCopyWith(ValidationFailure value, $Res Function(ValidationFailure) _then) = _$ValidationFailureCopyWithImpl;
@useResult
$Res call({
 String field, ValidationReason reason
});




}
/// @nodoc
class _$ValidationFailureCopyWithImpl<$Res>
    implements $ValidationFailureCopyWith<$Res> {
  _$ValidationFailureCopyWithImpl(this._self, this._then);

  final ValidationFailure _self;
  final $Res Function(ValidationFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? field = null,Object? reason = null,}) {
  return _then(ValidationFailure(
field: null == field ? _self.field : field // ignore: cast_nullable_to_non_nullable
as String,reason: null == reason ? _self.reason : reason // ignore: cast_nullable_to_non_nullable
as ValidationReason,
  ));
}


}

/// @nodoc


class NotFoundFailure implements Failure {
  const NotFoundFailure();
  






@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NotFoundFailure);
}


@override
int get hashCode => runtimeType.hashCode;

@override
String toString() {
  return 'Failure.notFound()';
}


}




/// @nodoc


class ConstraintFailure implements Failure {
  const ConstraintFailure({required this.message});
  

 final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConstraintFailureCopyWith<ConstraintFailure> get copyWith => _$ConstraintFailureCopyWithImpl<ConstraintFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConstraintFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.constraint(message: $message)';
}


}

/// @nodoc
abstract mixin class $ConstraintFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ConstraintFailureCopyWith(ConstraintFailure value, $Res Function(ConstraintFailure) _then) = _$ConstraintFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ConstraintFailureCopyWithImpl<$Res>
    implements $ConstraintFailureCopyWith<$Res> {
  _$ConstraintFailureCopyWithImpl(this._self, this._then);

  final ConstraintFailure _self;
  final $Res Function(ConstraintFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ConstraintFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class StorageFailure implements Failure {
  const StorageFailure({required this.message});
  

 final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StorageFailureCopyWith<StorageFailure> get copyWith => _$StorageFailureCopyWithImpl<StorageFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StorageFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.storage(message: $message)';
}


}

/// @nodoc
abstract mixin class $StorageFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $StorageFailureCopyWith(StorageFailure value, $Res Function(StorageFailure) _then) = _$StorageFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$StorageFailureCopyWithImpl<$Res>
    implements $StorageFailureCopyWith<$Res> {
  _$StorageFailureCopyWithImpl(this._self, this._then);

  final StorageFailure _self;
  final $Res Function(StorageFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(StorageFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class SecureStorageFailure implements Failure {
  const SecureStorageFailure({required this.message});
  

 final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SecureStorageFailureCopyWith<SecureStorageFailure> get copyWith => _$SecureStorageFailureCopyWithImpl<SecureStorageFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SecureStorageFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.secureStorage(message: $message)';
}


}

/// @nodoc
abstract mixin class $SecureStorageFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $SecureStorageFailureCopyWith(SecureStorageFailure value, $Res Function(SecureStorageFailure) _then) = _$SecureStorageFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$SecureStorageFailureCopyWithImpl<$Res>
    implements $SecureStorageFailureCopyWith<$Res> {
  _$SecureStorageFailureCopyWithImpl(this._self, this._then);

  final SecureStorageFailure _self;
  final $Res Function(SecureStorageFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(SecureStorageFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class ExportFailure implements Failure {
  const ExportFailure({required this.message});
  

 final  String message;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExportFailureCopyWith<ExportFailure> get copyWith => _$ExportFailureCopyWithImpl<ExportFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExportFailure&&(identical(other.message, message) || other.message == message));
}


@override
int get hashCode => Object.hash(runtimeType,message);

@override
String toString() {
  return 'Failure.exportFailed(message: $message)';
}


}

/// @nodoc
abstract mixin class $ExportFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $ExportFailureCopyWith(ExportFailure value, $Res Function(ExportFailure) _then) = _$ExportFailureCopyWithImpl;
@useResult
$Res call({
 String message
});




}
/// @nodoc
class _$ExportFailureCopyWithImpl<$Res>
    implements $ExportFailureCopyWith<$Res> {
  _$ExportFailureCopyWithImpl(this._self, this._then);

  final ExportFailure _self;
  final $Res Function(ExportFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? message = null,}) {
  return _then(ExportFailure(
message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

/// @nodoc


class UnexpectedFailure implements Failure {
  const UnexpectedFailure({required this.error, this.stackTrace});
  

 final  Object error;
 final  StackTrace? stackTrace;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$UnexpectedFailureCopyWith<UnexpectedFailure> get copyWith => _$UnexpectedFailureCopyWithImpl<UnexpectedFailure>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is UnexpectedFailure&&const DeepCollectionEquality().equals(other.error, error)&&(identical(other.stackTrace, stackTrace) || other.stackTrace == stackTrace));
}


@override
int get hashCode => Object.hash(runtimeType,const DeepCollectionEquality().hash(error),stackTrace);

@override
String toString() {
  return 'Failure.unexpected(error: $error, stackTrace: $stackTrace)';
}


}

/// @nodoc
abstract mixin class $UnexpectedFailureCopyWith<$Res> implements $FailureCopyWith<$Res> {
  factory $UnexpectedFailureCopyWith(UnexpectedFailure value, $Res Function(UnexpectedFailure) _then) = _$UnexpectedFailureCopyWithImpl;
@useResult
$Res call({
 Object error, StackTrace? stackTrace
});




}
/// @nodoc
class _$UnexpectedFailureCopyWithImpl<$Res>
    implements $UnexpectedFailureCopyWith<$Res> {
  _$UnexpectedFailureCopyWithImpl(this._self, this._then);

  final UnexpectedFailure _self;
  final $Res Function(UnexpectedFailure) _then;

/// Create a copy of Failure
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') $Res call({Object? error = null,Object? stackTrace = freezed,}) {
  return _then(UnexpectedFailure(
error: null == error ? _self.error : error ,stackTrace: freezed == stackTrace ? _self.stackTrace : stackTrace // ignore: cast_nullable_to_non_nullable
as StackTrace?,
  ));
}


}

// dart format on
