// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringFormState {

 LocalDate get startDate;/// Fraction digits of the app currency (2 for EGP, 3 for KWD).
 int get fractionDigits; RecurringFormStatus get status;/// The Expense | Income switch; the category must be of this kind.
 TransactionKind get kind;/// Null for a new template.
 int? get id;/// As typed: Western or Arabic-Indic digits, `.` or `٫`.
 String get amountText; int? get categoryId; String get title; RecurringFrequency get frequency; bool get isActive;/// Every visible category; the picker offers those of [kind].
 List<Category> get categories;/// Field errors, keyed by `amount`, `categoryId`, `title`.
 Map<String, ValidationReason> get errors;/// A load or save failure other than a field error.
 Failure? get failure;
/// Create a copy of RecurringFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringFormStateCopyWith<RecurringFormState> get copyWith => _$RecurringFormStateCopyWithImpl<RecurringFormState>(this as RecurringFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringFormState&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.fractionDigits, fractionDigits) || other.fractionDigits == fractionDigits)&&(identical(other.status, status) || other.status == status)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.amountText, amountText) || other.amountText == amountText)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,fractionDigits,status,kind,id,amountText,categoryId,title,frequency,isActive,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(errors),failure);

@override
String toString() {
  return 'RecurringFormState(startDate: $startDate, fractionDigits: $fractionDigits, status: $status, kind: $kind, id: $id, amountText: $amountText, categoryId: $categoryId, title: $title, frequency: $frequency, isActive: $isActive, categories: $categories, errors: $errors, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $RecurringFormStateCopyWith<$Res>  {
  factory $RecurringFormStateCopyWith(RecurringFormState value, $Res Function(RecurringFormState) _then) = _$RecurringFormStateCopyWithImpl;
@useResult
$Res call({
 LocalDate startDate, int fractionDigits, RecurringFormStatus status, TransactionKind kind, int? id, String amountText, int? categoryId, String title, RecurringFrequency frequency, bool isActive, List<Category> categories, Map<String, ValidationReason> errors, Failure? failure
});


$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$RecurringFormStateCopyWithImpl<$Res>
    implements $RecurringFormStateCopyWith<$Res> {
  _$RecurringFormStateCopyWithImpl(this._self, this._then);

  final RecurringFormState _self;
  final $Res Function(RecurringFormState) _then;

/// Create a copy of RecurringFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? startDate = null,Object? fractionDigits = null,Object? status = null,Object? kind = null,Object? id = freezed,Object? amountText = null,Object? categoryId = freezed,Object? title = null,Object? frequency = null,Object? isActive = null,Object? categories = null,Object? errors = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as LocalDate,fractionDigits: null == fractionDigits ? _self.fractionDigits : fractionDigits // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecurringFormStatus,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,amountText: null == amountText ? _self.amountText : amountText // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurringFrequency,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, ValidationReason>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of RecurringFormState
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


/// Adds pattern-matching-related methods to [RecurringFormState].
extension RecurringFormStatePatterns on RecurringFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringFormState value)  $default,){
final _that = this;
switch (_that) {
case _RecurringFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringFormState value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocalDate startDate,  int fractionDigits,  RecurringFormStatus status,  TransactionKind kind,  int? id,  String amountText,  int? categoryId,  String title,  RecurringFrequency frequency,  bool isActive,  List<Category> categories,  Map<String, ValidationReason> errors,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringFormState() when $default != null:
return $default(_that.startDate,_that.fractionDigits,_that.status,_that.kind,_that.id,_that.amountText,_that.categoryId,_that.title,_that.frequency,_that.isActive,_that.categories,_that.errors,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocalDate startDate,  int fractionDigits,  RecurringFormStatus status,  TransactionKind kind,  int? id,  String amountText,  int? categoryId,  String title,  RecurringFrequency frequency,  bool isActive,  List<Category> categories,  Map<String, ValidationReason> errors,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _RecurringFormState():
return $default(_that.startDate,_that.fractionDigits,_that.status,_that.kind,_that.id,_that.amountText,_that.categoryId,_that.title,_that.frequency,_that.isActive,_that.categories,_that.errors,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocalDate startDate,  int fractionDigits,  RecurringFormStatus status,  TransactionKind kind,  int? id,  String amountText,  int? categoryId,  String title,  RecurringFrequency frequency,  bool isActive,  List<Category> categories,  Map<String, ValidationReason> errors,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _RecurringFormState() when $default != null:
return $default(_that.startDate,_that.fractionDigits,_that.status,_that.kind,_that.id,_that.amountText,_that.categoryId,_that.title,_that.frequency,_that.isActive,_that.categories,_that.errors,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringFormState extends RecurringFormState {
  const _RecurringFormState({required this.startDate, required this.fractionDigits, this.status = RecurringFormStatus.loading, this.kind = TransactionKind.expense, this.id, this.amountText = '', this.categoryId, this.title = '', this.frequency = RecurringFrequency.monthly, this.isActive = true, final  List<Category> categories = const <Category>[], final  Map<String, ValidationReason> errors = const <String, ValidationReason>{}, this.failure}): _categories = categories,_errors = errors,super._();
  

@override final  LocalDate startDate;
/// Fraction digits of the app currency (2 for EGP, 3 for KWD).
@override final  int fractionDigits;
@override@JsonKey() final  RecurringFormStatus status;
/// The Expense | Income switch; the category must be of this kind.
@override@JsonKey() final  TransactionKind kind;
/// Null for a new template.
@override final  int? id;
/// As typed: Western or Arabic-Indic digits, `.` or `٫`.
@override@JsonKey() final  String amountText;
@override final  int? categoryId;
@override@JsonKey() final  String title;
@override@JsonKey() final  RecurringFrequency frequency;
@override@JsonKey() final  bool isActive;
/// Every visible category; the picker offers those of [kind].
 final  List<Category> _categories;
/// Every visible category; the picker offers those of [kind].
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

/// Field errors, keyed by `amount`, `categoryId`, `title`.
 final  Map<String, ValidationReason> _errors;
/// Field errors, keyed by `amount`, `categoryId`, `title`.
@override@JsonKey() Map<String, ValidationReason> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

/// A load or save failure other than a field error.
@override final  Failure? failure;

/// Create a copy of RecurringFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringFormStateCopyWith<_RecurringFormState> get copyWith => __$RecurringFormStateCopyWithImpl<_RecurringFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringFormState&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.fractionDigits, fractionDigits) || other.fractionDigits == fractionDigits)&&(identical(other.status, status) || other.status == status)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.amountText, amountText) || other.amountText == amountText)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,startDate,fractionDigits,status,kind,id,amountText,categoryId,title,frequency,isActive,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_errors),failure);

@override
String toString() {
  return 'RecurringFormState(startDate: $startDate, fractionDigits: $fractionDigits, status: $status, kind: $kind, id: $id, amountText: $amountText, categoryId: $categoryId, title: $title, frequency: $frequency, isActive: $isActive, categories: $categories, errors: $errors, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$RecurringFormStateCopyWith<$Res> implements $RecurringFormStateCopyWith<$Res> {
  factory _$RecurringFormStateCopyWith(_RecurringFormState value, $Res Function(_RecurringFormState) _then) = __$RecurringFormStateCopyWithImpl;
@override @useResult
$Res call({
 LocalDate startDate, int fractionDigits, RecurringFormStatus status, TransactionKind kind, int? id, String amountText, int? categoryId, String title, RecurringFrequency frequency, bool isActive, List<Category> categories, Map<String, ValidationReason> errors, Failure? failure
});


@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$RecurringFormStateCopyWithImpl<$Res>
    implements _$RecurringFormStateCopyWith<$Res> {
  __$RecurringFormStateCopyWithImpl(this._self, this._then);

  final _RecurringFormState _self;
  final $Res Function(_RecurringFormState) _then;

/// Create a copy of RecurringFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? startDate = null,Object? fractionDigits = null,Object? status = null,Object? kind = null,Object? id = freezed,Object? amountText = null,Object? categoryId = freezed,Object? title = null,Object? frequency = null,Object? isActive = null,Object? categories = null,Object? errors = null,Object? failure = freezed,}) {
  return _then(_RecurringFormState(
startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as LocalDate,fractionDigits: null == fractionDigits ? _self.fractionDigits : fractionDigits // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as RecurringFormStatus,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,amountText: null == amountText ? _self.amountText : amountText // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurringFrequency,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, ValidationReason>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of RecurringFormState
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
