// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'budget_form_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$BudgetFormState {

/// Fraction digits of the app currency (2 for EGP, 3 for KWD).
 int get fractionDigits; BudgetFormStatus get status;/// Null for a new budget.
 int? get id; int? get categoryId;/// As typed: Western or Arabic-Indic digits, `.` or `٫`.
 String get limitText; BudgetPeriod get period;/// Visible categories (for the picker and the locked edit field).
 List<Category> get categories;/// Categories that already have a budget, left out of the picker.
 Set<int> get budgeted;/// Field errors, keyed by `categoryId`, `limit`.
 Map<String, ValidationReason> get errors;/// A load or save failure other than a field error.
 Failure? get failure;
/// Create a copy of BudgetFormState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$BudgetFormStateCopyWith<BudgetFormState> get copyWith => _$BudgetFormStateCopyWithImpl<BudgetFormState>(this as BudgetFormState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is BudgetFormState&&(identical(other.fractionDigits, fractionDigits) || other.fractionDigits == fractionDigits)&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limitText, limitText) || other.limitText == limitText)&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.budgeted, budgeted)&&const DeepCollectionEquality().equals(other.errors, errors)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,fractionDigits,status,id,categoryId,limitText,period,const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(budgeted),const DeepCollectionEquality().hash(errors),failure);

@override
String toString() {
  return 'BudgetFormState(fractionDigits: $fractionDigits, status: $status, id: $id, categoryId: $categoryId, limitText: $limitText, period: $period, categories: $categories, budgeted: $budgeted, errors: $errors, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $BudgetFormStateCopyWith<$Res>  {
  factory $BudgetFormStateCopyWith(BudgetFormState value, $Res Function(BudgetFormState) _then) = _$BudgetFormStateCopyWithImpl;
@useResult
$Res call({
 int fractionDigits, BudgetFormStatus status, int? id, int? categoryId, String limitText, BudgetPeriod period, List<Category> categories, Set<int> budgeted, Map<String, ValidationReason> errors, Failure? failure
});


$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$BudgetFormStateCopyWithImpl<$Res>
    implements $BudgetFormStateCopyWith<$Res> {
  _$BudgetFormStateCopyWithImpl(this._self, this._then);

  final BudgetFormState _self;
  final $Res Function(BudgetFormState) _then;

/// Create a copy of BudgetFormState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? fractionDigits = null,Object? status = null,Object? id = freezed,Object? categoryId = freezed,Object? limitText = null,Object? period = null,Object? categories = null,Object? budgeted = null,Object? errors = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
fractionDigits: null == fractionDigits ? _self.fractionDigits : fractionDigits // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetFormStatus,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,limitText: null == limitText ? _self.limitText : limitText // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as BudgetPeriod,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,budgeted: null == budgeted ? _self.budgeted : budgeted // ignore: cast_nullable_to_non_nullable
as Set<int>,errors: null == errors ? _self.errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, ValidationReason>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of BudgetFormState
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


/// Adds pattern-matching-related methods to [BudgetFormState].
extension BudgetFormStatePatterns on BudgetFormState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _BudgetFormState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _BudgetFormState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _BudgetFormState value)  $default,){
final _that = this;
switch (_that) {
case _BudgetFormState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _BudgetFormState value)?  $default,){
final _that = this;
switch (_that) {
case _BudgetFormState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int fractionDigits,  BudgetFormStatus status,  int? id,  int? categoryId,  String limitText,  BudgetPeriod period,  List<Category> categories,  Set<int> budgeted,  Map<String, ValidationReason> errors,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _BudgetFormState() when $default != null:
return $default(_that.fractionDigits,_that.status,_that.id,_that.categoryId,_that.limitText,_that.period,_that.categories,_that.budgeted,_that.errors,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int fractionDigits,  BudgetFormStatus status,  int? id,  int? categoryId,  String limitText,  BudgetPeriod period,  List<Category> categories,  Set<int> budgeted,  Map<String, ValidationReason> errors,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _BudgetFormState():
return $default(_that.fractionDigits,_that.status,_that.id,_that.categoryId,_that.limitText,_that.period,_that.categories,_that.budgeted,_that.errors,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int fractionDigits,  BudgetFormStatus status,  int? id,  int? categoryId,  String limitText,  BudgetPeriod period,  List<Category> categories,  Set<int> budgeted,  Map<String, ValidationReason> errors,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _BudgetFormState() when $default != null:
return $default(_that.fractionDigits,_that.status,_that.id,_that.categoryId,_that.limitText,_that.period,_that.categories,_that.budgeted,_that.errors,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _BudgetFormState extends BudgetFormState {
  const _BudgetFormState({required this.fractionDigits, this.status = BudgetFormStatus.loading, this.id, this.categoryId, this.limitText = '', this.period = BudgetPeriod.monthly, final  List<Category> categories = const <Category>[], final  Set<int> budgeted = const <int>{}, final  Map<String, ValidationReason> errors = const <String, ValidationReason>{}, this.failure}): _categories = categories,_budgeted = budgeted,_errors = errors,super._();
  

/// Fraction digits of the app currency (2 for EGP, 3 for KWD).
@override final  int fractionDigits;
@override@JsonKey() final  BudgetFormStatus status;
/// Null for a new budget.
@override final  int? id;
@override final  int? categoryId;
/// As typed: Western or Arabic-Indic digits, `.` or `٫`.
@override@JsonKey() final  String limitText;
@override@JsonKey() final  BudgetPeriod period;
/// Visible categories (for the picker and the locked edit field).
 final  List<Category> _categories;
/// Visible categories (for the picker and the locked edit field).
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

/// Categories that already have a budget, left out of the picker.
 final  Set<int> _budgeted;
/// Categories that already have a budget, left out of the picker.
@override@JsonKey() Set<int> get budgeted {
  if (_budgeted is EqualUnmodifiableSetView) return _budgeted;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_budgeted);
}

/// Field errors, keyed by `categoryId`, `limit`.
 final  Map<String, ValidationReason> _errors;
/// Field errors, keyed by `categoryId`, `limit`.
@override@JsonKey() Map<String, ValidationReason> get errors {
  if (_errors is EqualUnmodifiableMapView) return _errors;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_errors);
}

/// A load or save failure other than a field error.
@override final  Failure? failure;

/// Create a copy of BudgetFormState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$BudgetFormStateCopyWith<_BudgetFormState> get copyWith => __$BudgetFormStateCopyWithImpl<_BudgetFormState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _BudgetFormState&&(identical(other.fractionDigits, fractionDigits) || other.fractionDigits == fractionDigits)&&(identical(other.status, status) || other.status == status)&&(identical(other.id, id) || other.id == id)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.limitText, limitText) || other.limitText == limitText)&&(identical(other.period, period) || other.period == period)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._budgeted, _budgeted)&&const DeepCollectionEquality().equals(other._errors, _errors)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,fractionDigits,status,id,categoryId,limitText,period,const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_budgeted),const DeepCollectionEquality().hash(_errors),failure);

@override
String toString() {
  return 'BudgetFormState(fractionDigits: $fractionDigits, status: $status, id: $id, categoryId: $categoryId, limitText: $limitText, period: $period, categories: $categories, budgeted: $budgeted, errors: $errors, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$BudgetFormStateCopyWith<$Res> implements $BudgetFormStateCopyWith<$Res> {
  factory _$BudgetFormStateCopyWith(_BudgetFormState value, $Res Function(_BudgetFormState) _then) = __$BudgetFormStateCopyWithImpl;
@override @useResult
$Res call({
 int fractionDigits, BudgetFormStatus status, int? id, int? categoryId, String limitText, BudgetPeriod period, List<Category> categories, Set<int> budgeted, Map<String, ValidationReason> errors, Failure? failure
});


@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$BudgetFormStateCopyWithImpl<$Res>
    implements _$BudgetFormStateCopyWith<$Res> {
  __$BudgetFormStateCopyWithImpl(this._self, this._then);

  final _BudgetFormState _self;
  final $Res Function(_BudgetFormState) _then;

/// Create a copy of BudgetFormState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? fractionDigits = null,Object? status = null,Object? id = freezed,Object? categoryId = freezed,Object? limitText = null,Object? period = null,Object? categories = null,Object? budgeted = null,Object? errors = null,Object? failure = freezed,}) {
  return _then(_BudgetFormState(
fractionDigits: null == fractionDigits ? _self.fractionDigits : fractionDigits // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as BudgetFormStatus,id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,limitText: null == limitText ? _self.limitText : limitText // ignore: cast_nullable_to_non_nullable
as String,period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as BudgetPeriod,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,budgeted: null == budgeted ? _self._budgeted : budgeted // ignore: cast_nullable_to_non_nullable
as Set<int>,errors: null == errors ? _self._errors : errors // ignore: cast_nullable_to_non_nullable
as Map<String, ValidationReason>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of BudgetFormState
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
