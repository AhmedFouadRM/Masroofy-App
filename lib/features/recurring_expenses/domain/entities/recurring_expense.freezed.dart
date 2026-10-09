// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'recurring_expense.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$RecurringExpense {

 int get id; String get title; Money get amount; int get categoryId; RecurringFrequency get frequency;/// Anchor: occurrence n is always computed from here, never chained.
 LocalDate get startDate; LocalDate get nextDueDate; DateTime get createdAt; DateTime get updatedAt; bool get isActive;/// The category's kind: the rows it generates are income or expenses.
 TransactionKind get kind;
/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$RecurringExpenseCopyWith<RecurringExpense> get copyWith => _$RecurringExpenseCopyWithImpl<RecurringExpense>(this as RecurringExpense, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is RecurringExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,amount,categoryId,frequency,startDate,nextDueDate,createdAt,updatedAt,isActive,kind);

@override
String toString() {
  return 'RecurringExpense(id: $id, title: $title, amount: $amount, categoryId: $categoryId, frequency: $frequency, startDate: $startDate, nextDueDate: $nextDueDate, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, kind: $kind)';
}


}

/// @nodoc
abstract mixin class $RecurringExpenseCopyWith<$Res>  {
  factory $RecurringExpenseCopyWith(RecurringExpense value, $Res Function(RecurringExpense) _then) = _$RecurringExpenseCopyWithImpl;
@useResult
$Res call({
 int id, String title, Money amount, int categoryId, RecurringFrequency frequency, LocalDate startDate, LocalDate nextDueDate, DateTime createdAt, DateTime updatedAt, bool isActive, TransactionKind kind
});




}
/// @nodoc
class _$RecurringExpenseCopyWithImpl<$Res>
    implements $RecurringExpenseCopyWith<$Res> {
  _$RecurringExpenseCopyWithImpl(this._self, this._then);

  final RecurringExpense _self;
  final $Res Function(RecurringExpense) _then;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? categoryId = null,Object? frequency = null,Object? startDate = null,Object? nextDueDate = null,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,Object? kind = null,}) {
  return _then(_self.copyWith(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurringFrequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as LocalDate,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as LocalDate,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,
  ));
}

}


/// Adds pattern-matching-related methods to [RecurringExpense].
extension RecurringExpensePatterns on RecurringExpense {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _RecurringExpense value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _RecurringExpense value)  $default,){
final _that = this;
switch (_that) {
case _RecurringExpense():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _RecurringExpense value)?  $default,){
final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String title,  Money amount,  int categoryId,  RecurringFrequency frequency,  LocalDate startDate,  LocalDate nextDueDate,  DateTime createdAt,  DateTime updatedAt,  bool isActive,  TransactionKind kind)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.categoryId,_that.frequency,_that.startDate,_that.nextDueDate,_that.createdAt,_that.updatedAt,_that.isActive,_that.kind);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String title,  Money amount,  int categoryId,  RecurringFrequency frequency,  LocalDate startDate,  LocalDate nextDueDate,  DateTime createdAt,  DateTime updatedAt,  bool isActive,  TransactionKind kind)  $default,) {final _that = this;
switch (_that) {
case _RecurringExpense():
return $default(_that.id,_that.title,_that.amount,_that.categoryId,_that.frequency,_that.startDate,_that.nextDueDate,_that.createdAt,_that.updatedAt,_that.isActive,_that.kind);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String title,  Money amount,  int categoryId,  RecurringFrequency frequency,  LocalDate startDate,  LocalDate nextDueDate,  DateTime createdAt,  DateTime updatedAt,  bool isActive,  TransactionKind kind)?  $default,) {final _that = this;
switch (_that) {
case _RecurringExpense() when $default != null:
return $default(_that.id,_that.title,_that.amount,_that.categoryId,_that.frequency,_that.startDate,_that.nextDueDate,_that.createdAt,_that.updatedAt,_that.isActive,_that.kind);case _:
  return null;

}
}

}

/// @nodoc


class _RecurringExpense implements RecurringExpense {
  const _RecurringExpense({required this.id, required this.title, required this.amount, required this.categoryId, required this.frequency, required this.startDate, required this.nextDueDate, required this.createdAt, required this.updatedAt, this.isActive = true, this.kind = TransactionKind.expense});
  

@override final  int id;
@override final  String title;
@override final  Money amount;
@override final  int categoryId;
@override final  RecurringFrequency frequency;
/// Anchor: occurrence n is always computed from here, never chained.
@override final  LocalDate startDate;
@override final  LocalDate nextDueDate;
@override final  DateTime createdAt;
@override final  DateTime updatedAt;
@override@JsonKey() final  bool isActive;
/// The category's kind: the rows it generates are income or expenses.
@override@JsonKey() final  TransactionKind kind;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$RecurringExpenseCopyWith<_RecurringExpense> get copyWith => __$RecurringExpenseCopyWithImpl<_RecurringExpense>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _RecurringExpense&&(identical(other.id, id) || other.id == id)&&(identical(other.title, title) || other.title == title)&&(identical(other.amount, amount) || other.amount == amount)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.frequency, frequency) || other.frequency == frequency)&&(identical(other.startDate, startDate) || other.startDate == startDate)&&(identical(other.nextDueDate, nextDueDate) || other.nextDueDate == nextDueDate)&&(identical(other.createdAt, createdAt) || other.createdAt == createdAt)&&(identical(other.updatedAt, updatedAt) || other.updatedAt == updatedAt)&&(identical(other.isActive, isActive) || other.isActive == isActive)&&(identical(other.kind, kind) || other.kind == kind));
}


@override
int get hashCode => Object.hash(runtimeType,id,title,amount,categoryId,frequency,startDate,nextDueDate,createdAt,updatedAt,isActive,kind);

@override
String toString() {
  return 'RecurringExpense(id: $id, title: $title, amount: $amount, categoryId: $categoryId, frequency: $frequency, startDate: $startDate, nextDueDate: $nextDueDate, createdAt: $createdAt, updatedAt: $updatedAt, isActive: $isActive, kind: $kind)';
}


}

/// @nodoc
abstract mixin class _$RecurringExpenseCopyWith<$Res> implements $RecurringExpenseCopyWith<$Res> {
  factory _$RecurringExpenseCopyWith(_RecurringExpense value, $Res Function(_RecurringExpense) _then) = __$RecurringExpenseCopyWithImpl;
@override @useResult
$Res call({
 int id, String title, Money amount, int categoryId, RecurringFrequency frequency, LocalDate startDate, LocalDate nextDueDate, DateTime createdAt, DateTime updatedAt, bool isActive, TransactionKind kind
});




}
/// @nodoc
class __$RecurringExpenseCopyWithImpl<$Res>
    implements _$RecurringExpenseCopyWith<$Res> {
  __$RecurringExpenseCopyWithImpl(this._self, this._then);

  final _RecurringExpense _self;
  final $Res Function(_RecurringExpense) _then;

/// Create a copy of RecurringExpense
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? title = null,Object? amount = null,Object? categoryId = null,Object? frequency = null,Object? startDate = null,Object? nextDueDate = null,Object? createdAt = null,Object? updatedAt = null,Object? isActive = null,Object? kind = null,}) {
  return _then(_RecurringExpense(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,title: null == title ? _self.title : title // ignore: cast_nullable_to_non_nullable
as String,amount: null == amount ? _self.amount : amount // ignore: cast_nullable_to_non_nullable
as Money,categoryId: null == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int,frequency: null == frequency ? _self.frequency : frequency // ignore: cast_nullable_to_non_nullable
as RecurringFrequency,startDate: null == startDate ? _self.startDate : startDate // ignore: cast_nullable_to_non_nullable
as LocalDate,nextDueDate: null == nextDueDate ? _self.nextDueDate : nextDueDate // ignore: cast_nullable_to_non_nullable
as LocalDate,createdAt: null == createdAt ? _self.createdAt : createdAt // ignore: cast_nullable_to_non_nullable
as DateTime,updatedAt: null == updatedAt ? _self.updatedAt : updatedAt // ignore: cast_nullable_to_non_nullable
as DateTime,isActive: null == isActive ? _self.isActive : isActive // ignore: cast_nullable_to_non_nullable
as bool,kind: null == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind,
  ));
}


}

// dart format on
