// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseFormState {

 LocalDate get date;/// Fraction digits of the app currency (2 for EGP, 3 for KWD).
 int get fractionDigits; ExpenseFormStatus get status;/// The Expense | Income switch; the category must be of this kind.
 TransactionKind get kind;/// Null for a new expense.
 int? get id;/// As typed: Western or Arabic-Indic digits, `.` or `٫`.
 String get amountText; int? get categoryId; String get title; String get note;/// Every visible category; the picker offers those of [kind].
 List<Category> get categories;/// Field errors, keyed by `amount`, `categoryId`, `title`, `date`, `note`.
 Map<String, ValidationReason> get errors;/// A load or save failure other than a field error.
 Failure? get failure;
/// Create a copy of ExpenseFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseFormStateCopyWith<ExpenseFormState> get copyWith => _$ExpenseFormStateCopyWithImpl<ExpenseFormState>(this as ExpenseFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseFormState&&(identical(other.date, date) || other.date == date)&&(identical(other.fractionDigits, fractionDigits) || other.fractionDigits == fractionDigits)&&(identical(other.status, status) || other.status == status)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.amountText, amountText) || other.amountText == amountText)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,date,fractionDigits,status,kind,id,amountText,categoryId,title,note,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(errors),failure);

@override
String toString() {
  return 'ExpenseFormState(date: $date, fractionDigits: $fractionDigits, status: $status, kind: $kind, id: $id, amountText: $amountText, categoryId: $categoryId, title: $title, note: $note, categories: $categories, errors: $errors, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $ExpenseFormStateCopyWith<$Res>  {
  factory $ExpenseFormStateCopyWith(ExpenseFormState value, $Res Function(ExpenseFormState) _then) = _$ExpenseFormStateCopyWithImpl;
@useResult
$Res call({
 LocalDate date, int fractionDigits, ExpenseFormStatus status, TransactionKind kind, int? id, String amountText, int? categoryId, String title, String note, List<Category> categories, Map<String, ValidationReason> errors, Failure? failure
});


$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$ExpenseFormStateCopyWithImpl<$Res>
    implements $ExpenseFormStateCopyWith<$Res> {
  _$ExpenseFormStateCopyWithImpl(this._self, this._then);

  final ExpenseFormState _self;
  final $Res Function(ExpenseFormState) _then;

/// Create a copy of ExpenseFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? date = null,Object? fractionDigits = null,Object? status = null,Object? kind = null,Object? id = freezed,Object? amountText = null,Object? categoryId = freezed,Object? title = null,Object? note = null,Object? categories = null,Object? errors = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,fractionDigits: null == fractionDigits ? _self.fractionDigits : fractionDigits // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseFormStatus,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,amountText: null == amountText ? _self.amountText : amountText // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, ValidationReason>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ExpenseFormState
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


/// Adds pattern-matching-related methods to [ExpenseFormState].
extension ExpenseFormStatePatterns on ExpenseFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseFormState value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseFormState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( LocalDate date,  int fractionDigits,  ExpenseFormStatus status,  TransactionKind kind,  int? id,  String amountText,  int? categoryId,  String title,  String note,  List<Category> categories,  Map<String, ValidationReason> errors,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseFormState() when $default != null:
return $default(_that.date,_that.fractionDigits,_that.status,_that.kind,_that.id,_that.amountText,_that.categoryId,_that.title,_that.note,_that.categories,_that.errors,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( LocalDate date,  int fractionDigits,  ExpenseFormStatus status,  TransactionKind kind,  int? id,  String amountText,  int? categoryId,  String title,  String note,  List<Category> categories,  Map<String, ValidationReason> errors,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _ExpenseFormState():
return $default(_that.date,_that.fractionDigits,_that.status,_that.kind,_that.id,_that.amountText,_that.categoryId,_that.title,_that.note,_that.categories,_that.errors,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( LocalDate date,  int fractionDigits,  ExpenseFormStatus status,  TransactionKind kind,  int? id,  String amountText,  int? categoryId,  String title,  String note,  List<Category> categories,  Map<String, ValidationReason> errors,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseFormState() when $default != null:
return $default(_that.date,_that.fractionDigits,_that.status,_that.kind,_that.id,_that.amountText,_that.categoryId,_that.title,_that.note,_that.categories,_that.errors,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseFormState extends ExpenseFormState {
  const _ExpenseFormState({required this.date, required this.fractionDigits, this.status = ExpenseFormStatus.loading, this.kind = TransactionKind.expense, this.id, this.amountText = '', this.categoryId, this.title = '', this.note = '', final  List<Category> categories = const <Category>[], final  Map<String, ValidationReason> errors = const <String, ValidationReason>{}, this.failure}): _categories = categories,_errors = errors,super._();
  

@override final  LocalDate date;
/// Fraction digits of the app currency (2 for EGP, 3 for KWD).
@override final  int fractionDigits;
@override@JsonKey() final  ExpenseFormStatus status;
/// The Expense | Income switch; the category must be of this kind.
@override@JsonKey() final  TransactionKind kind;
/// Null for a new expense.
@override final  int? id;
/// As typed: Western or Arabic-Indic digits, `.` or `٫`.
@override@JsonKey() final  String amountText;
@override final  int? categoryId;
@override@JsonKey() final  String title;
@override@JsonKey() final  String note;
/// Every visible category; the picker offers those of [kind].
 final  List<Category> _categories;
/// Every visible category; the picker offers those of [kind].
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

/// Field errors, keyed by `amount`, `categoryId`, `title`, `date`, `note`.
 final  Map<String, ValidationReason> _errors;
/// Field errors, keyed by `amount`, `categoryId`, `title`, `date`, `note`.
@override@JsonKey() Map<String, ValidationReason> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

/// A load or save failure other than a field error.
@override final  Failure? failure;

/// Create a copy of ExpenseFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseFormStateCopyWith<_ExpenseFormState> get copyWith => __$ExpenseFormStateCopyWithImpl<_ExpenseFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseFormState&&(identical(other.date, date) || other.date == date)&&(identical(other.fractionDigits, fractionDigits) || other.fractionDigits == fractionDigits)&&(identical(other.status, status) || other.status == status)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.id, id) || other.id == id)&&(identical(other.amountText, amountText) || other.amountText == amountText)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.title, title) || other.title == title)&&(identical(other.note, note) || other.note == note)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,date,fractionDigits,status,kind,id,amountText,categoryId,title,note,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_errors),failure);

@override
String toString() {
  return 'ExpenseFormState(date: $date, fractionDigits: $fractionDigits, status: $status, kind: $kind, id: $id, amountText: $amountText, categoryId: $categoryId, title: $title, note: $note, categories: $categories, errors: $errors, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$ExpenseFormStateCopyWith<$Res> implements $ExpenseFormStateCopyWith<$Res> {
  factory _$ExpenseFormStateCopyWith(_ExpenseFormState value, $Res Function(_ExpenseFormState) _then) = __$ExpenseFormStateCopyWithImpl;
@override @useResult
$Res call({
 LocalDate date, int fractionDigits, ExpenseFormStatus status, TransactionKind kind, int? id, String amountText, int? categoryId, String title, String note, List<Category> categories, Map<String, ValidationReason> errors, Failure? failure
});


@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$ExpenseFormStateCopyWithImpl<$Res>
    implements _$ExpenseFormStateCopyWith<$Res> {
  __$ExpenseFormStateCopyWithImpl(this._self, this._then);

  final _ExpenseFormState _self;
  final $Res Function(_ExpenseFormState) _then;

/// Create a copy of ExpenseFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? date = null,Object? fractionDigits = null,Object? status = null,Object? kind = null,Object? id = freezed,Object? amountText = null,Object? categoryId = freezed,Object? title = null,Object? note = null,Object? categories = null,Object? errors = null,Object? failure = freezed,}) {
  return _then(_ExpenseFormState(
date: null == date ? _self.date : date // ignore: cast_nullable_to_non_nullable
as LocalDate,fractionDigits: null == fractionDigits ? _self.fractionDigits : fractionDigits // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseFormStatus,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,amountText: null == amountText ? _self.amountText : amountText // ignore: cast_nullable_to_non_nullable
as String,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,note: null == note ? _self.note : note // ignore: cast_nullable_to_non_nullable
as String,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, ValidationReason>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ExpenseFormState
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
