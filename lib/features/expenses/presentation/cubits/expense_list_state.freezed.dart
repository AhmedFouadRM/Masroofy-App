// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'expense_list_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ExpenseListState {

 ExpensePeriod get period; DateRange get range; ExpenseListStatus get status;/// The All / Income / Expenses filter; null is All.
 TransactionKind? get kind; int? get categoryId; String get search;/// The loaded page, including rows waiting out their undo window.
 List<Expense> get loaded; bool get hasMore; PeriodTotals get totals;/// Totals of the comparison period; null until loaded, and not loaded at
/// all on All (the balance card has no comparison).
 PeriodTotals? get previousTotals; Map<LocalDate, PeriodTotals> get dailyTotals;/// All categories by id (incl. hidden, which old expenses may use).
 Map<int, Category> get categories;/// Swiped away, still restorable with Undo.
 Set<int> get pendingDelete; Failure? get loadFailure;/// A failed delete, shown once as a snackbar.
 Failure? get actionFailure;
/// Create a copy of ExpenseListState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ExpenseListStateCopyWith<ExpenseListState> get copyWith => _$ExpenseListStateCopyWithImpl<ExpenseListState>(this as ExpenseListState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ExpenseListState&&(identical(other.period, period) || other.period == period)&&(identical(other.range, range) || other.range == range)&&(identical(other.status, status) || other.status == status)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.search, search) || other.search == search)&&const DeepCollectionEquality().equals(other.loaded, loaded)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.previousTotals, previousTotals) || other.previousTotals == previousTotals)&&const DeepCollectionEquality().equals(other.dailyTotals, dailyTotals)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.pendingDelete, pendingDelete)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,period,range,status,kind,categoryId,search,const DeepCollectionEquality().hash(loaded),hasMore,totals,previousTotals,const DeepCollectionEquality().hash(dailyTotals),const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(pendingDelete),loadFailure,actionFailure);

@override
String toString() {
  return 'ExpenseListState(period: $period, range: $range, status: $status, kind: $kind, categoryId: $categoryId, search: $search, loaded: $loaded, hasMore: $hasMore, totals: $totals, previousTotals: $previousTotals, dailyTotals: $dailyTotals, categories: $categories, pendingDelete: $pendingDelete, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class $ExpenseListStateCopyWith<$Res>  {
  factory $ExpenseListStateCopyWith(ExpenseListState value, $Res Function(ExpenseListState) _then) = _$ExpenseListStateCopyWithImpl;
@useResult
$Res call({
 ExpensePeriod period, DateRange range, ExpenseListStatus status, TransactionKind? kind, int? categoryId, String search, List<Expense> loaded, bool hasMore, PeriodTotals totals, PeriodTotals? previousTotals, Map<LocalDate, PeriodTotals> dailyTotals, Map<int, Category> categories, Set<int> pendingDelete, Failure? loadFailure, Failure? actionFailure
});


$FailureCopyWith<$Res>? get loadFailure;$FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class _$ExpenseListStateCopyWithImpl<$Res>
    implements $ExpenseListStateCopyWith<$Res> {
  _$ExpenseListStateCopyWithImpl(this._self, this._then);

  final ExpenseListState _self;
  final $Res Function(ExpenseListState) _then;

/// Create a copy of ExpenseListState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? range = null,Object? status = null,Object? kind = freezed,Object? categoryId = freezed,Object? search = null,Object? loaded = null,Object? hasMore = null,Object? totals = null,Object? previousTotals = freezed,Object? dailyTotals = null,Object? categories = null,Object? pendingDelete = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as ExpensePeriod,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseListStatus,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,loaded: null == loaded ? _self.loaded : loaded // ignore: cast_nullable_to_non_nullable
as List<Expense>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as PeriodTotals,previousTotals: freezed == previousTotals ? _self.previousTotals : previousTotals // ignore: cast_nullable_to_non_nullable
as PeriodTotals?,dailyTotals: null == dailyTotals ? _self.dailyTotals : dailyTotals // ignore: cast_nullable_to_non_nullable
as Map<LocalDate, PeriodTotals>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,pendingDelete: null == pendingDelete ? _self.pendingDelete : pendingDelete // ignore: cast_nullable_to_non_nullable
as Set<int>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of ExpenseListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get loadFailure {
    if (_self.loadFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.loadFailure!, (value) {
    return _then(_self.copyWith(loadFailure: value));
  });
}/// Create a copy of ExpenseListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get actionFailure {
    if (_self.actionFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.actionFailure!, (value) {
    return _then(_self.copyWith(actionFailure: value));
  });
}
}


/// Adds pattern-matching-related methods to [ExpenseListState].
extension ExpenseListStatePatterns on ExpenseListState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ExpenseListState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ExpenseListState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ExpenseListState value)  $default,){
final _that = this;
switch (_that) {
case _ExpenseListState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ExpenseListState value)?  $default,){
final _that = this;
switch (_that) {
case _ExpenseListState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( ExpensePeriod period,  DateRange range,  ExpenseListStatus status,  TransactionKind? kind,  int? categoryId,  String search,  List<Expense> loaded,  bool hasMore,  PeriodTotals totals,  PeriodTotals? previousTotals,  Map<LocalDate, PeriodTotals> dailyTotals,  Map<int, Category> categories,  Set<int> pendingDelete,  Failure? loadFailure,  Failure? actionFailure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ExpenseListState() when $default != null:
return $default(_that.period,_that.range,_that.status,_that.kind,_that.categoryId,_that.search,_that.loaded,_that.hasMore,_that.totals,_that.previousTotals,_that.dailyTotals,_that.categories,_that.pendingDelete,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( ExpensePeriod period,  DateRange range,  ExpenseListStatus status,  TransactionKind? kind,  int? categoryId,  String search,  List<Expense> loaded,  bool hasMore,  PeriodTotals totals,  PeriodTotals? previousTotals,  Map<LocalDate, PeriodTotals> dailyTotals,  Map<int, Category> categories,  Set<int> pendingDelete,  Failure? loadFailure,  Failure? actionFailure)  $default,) {final _that = this;
switch (_that) {
case _ExpenseListState():
return $default(_that.period,_that.range,_that.status,_that.kind,_that.categoryId,_that.search,_that.loaded,_that.hasMore,_that.totals,_that.previousTotals,_that.dailyTotals,_that.categories,_that.pendingDelete,_that.loadFailure,_that.actionFailure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( ExpensePeriod period,  DateRange range,  ExpenseListStatus status,  TransactionKind? kind,  int? categoryId,  String search,  List<Expense> loaded,  bool hasMore,  PeriodTotals totals,  PeriodTotals? previousTotals,  Map<LocalDate, PeriodTotals> dailyTotals,  Map<int, Category> categories,  Set<int> pendingDelete,  Failure? loadFailure,  Failure? actionFailure)?  $default,) {final _that = this;
switch (_that) {
case _ExpenseListState() when $default != null:
return $default(_that.period,_that.range,_that.status,_that.kind,_that.categoryId,_that.search,_that.loaded,_that.hasMore,_that.totals,_that.previousTotals,_that.dailyTotals,_that.categories,_that.pendingDelete,_that.loadFailure,_that.actionFailure);case _:
  return null;

}
}

}

/// @nodoc


class _ExpenseListState extends ExpenseListState {
  const _ExpenseListState({required this.period, required this.range, this.status = ExpenseListStatus.loading, this.kind, this.categoryId, this.search = '', final  List<Expense> loaded = const <Expense>[], this.hasMore = false, this.totals = PeriodTotals.zero, this.previousTotals, final  Map<LocalDate, PeriodTotals> dailyTotals = const <LocalDate, PeriodTotals>{}, final  Map<int, Category> categories = const <int, Category>{}, final  Set<int> pendingDelete = const <int>{}, this.loadFailure, this.actionFailure}): _loaded = loaded,_dailyTotals = dailyTotals,_categories = categories,_pendingDelete = pendingDelete,super._();
  

@override final  ExpensePeriod period;
@override final  DateRange range;
@override@JsonKey() final  ExpenseListStatus status;
/// The All / Income / Expenses filter; null is All.
@override final  TransactionKind? kind;
@override final  int? categoryId;
@override@JsonKey() final  String search;
/// The loaded page, including rows waiting out their undo window.
 final  List<Expense> _loaded;
/// The loaded page, including rows waiting out their undo window.
@override@JsonKey() List<Expense> get loaded {
  if (_loaded is EqualUnmodifiableListView) return _loaded;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_loaded);
}

@override@JsonKey() final  bool hasMore;
@override@JsonKey() final  PeriodTotals totals;
/// Totals of the comparison period; null until loaded, and not loaded at
/// all on All (the balance card has no comparison).
@override final  PeriodTotals? previousTotals;
 final  Map<LocalDate, PeriodTotals> _dailyTotals;
@override@JsonKey() Map<LocalDate, PeriodTotals> get dailyTotals {
  if (_dailyTotals is EqualUnmodifiableMapView) return _dailyTotals;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_dailyTotals);
}

/// All categories by id (incl. hidden, which old expenses may use).
 final  Map<int, Category> _categories;
/// All categories by id (incl. hidden, which old expenses may use).
@override@JsonKey() Map<int, Category> get categories {
  if (_categories is EqualUnmodifiableMapView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categories);
}

/// Swiped away, still restorable with Undo.
 final  Set<int> _pendingDelete;
/// Swiped away, still restorable with Undo.
@override@JsonKey() Set<int> get pendingDelete {
  if (_pendingDelete is EqualUnmodifiableSetView) return _pendingDelete;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_pendingDelete);
}

@override final  Failure? loadFailure;
/// A failed delete, shown once as a snackbar.
@override final  Failure? actionFailure;

/// Create a copy of ExpenseListState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ExpenseListStateCopyWith<_ExpenseListState> get copyWith => __$ExpenseListStateCopyWithImpl<_ExpenseListState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ExpenseListState&&(identical(other.period, period) || other.period == period)&&(identical(other.range, range) || other.range == range)&&(identical(other.status, status) || other.status == status)&&(identical(other.kind, kind) || other.kind == kind)&&(identical(other.categoryId, categoryId) || other.categoryId == categoryId)&&(identical(other.search, search) || other.search == search)&&const DeepCollectionEquality().equals(other._loaded, _loaded)&&(identical(other.hasMore, hasMore) || other.hasMore == hasMore)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.previousTotals, previousTotals) || other.previousTotals == previousTotals)&&const DeepCollectionEquality().equals(other._dailyTotals, _dailyTotals)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._pendingDelete, _pendingDelete)&&(identical(other.loadFailure, loadFailure) || other.loadFailure == loadFailure)&&(identical(other.actionFailure, actionFailure) || other.actionFailure == actionFailure));
}


@override
int get hashCode => Object.hash(runtimeType,period,range,status,kind,categoryId,search,const DeepCollectionEquality().hash(_loaded),hasMore,totals,previousTotals,const DeepCollectionEquality().hash(_dailyTotals),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_pendingDelete),loadFailure,actionFailure);

@override
String toString() {
  return 'ExpenseListState(period: $period, range: $range, status: $status, kind: $kind, categoryId: $categoryId, search: $search, loaded: $loaded, hasMore: $hasMore, totals: $totals, previousTotals: $previousTotals, dailyTotals: $dailyTotals, categories: $categories, pendingDelete: $pendingDelete, loadFailure: $loadFailure, actionFailure: $actionFailure)';
}


}

/// @nodoc
abstract mixin class _$ExpenseListStateCopyWith<$Res> implements $ExpenseListStateCopyWith<$Res> {
  factory _$ExpenseListStateCopyWith(_ExpenseListState value, $Res Function(_ExpenseListState) _then) = __$ExpenseListStateCopyWithImpl;
@override @useResult
$Res call({
 ExpensePeriod period, DateRange range, ExpenseListStatus status, TransactionKind? kind, int? categoryId, String search, List<Expense> loaded, bool hasMore, PeriodTotals totals, PeriodTotals? previousTotals, Map<LocalDate, PeriodTotals> dailyTotals, Map<int, Category> categories, Set<int> pendingDelete, Failure? loadFailure, Failure? actionFailure
});


@override $FailureCopyWith<$Res>? get loadFailure;@override $FailureCopyWith<$Res>? get actionFailure;

}
/// @nodoc
class __$ExpenseListStateCopyWithImpl<$Res>
    implements _$ExpenseListStateCopyWith<$Res> {
  __$ExpenseListStateCopyWithImpl(this._self, this._then);

  final _ExpenseListState _self;
  final $Res Function(_ExpenseListState) _then;

/// Create a copy of ExpenseListState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? range = null,Object? status = null,Object? kind = freezed,Object? categoryId = freezed,Object? search = null,Object? loaded = null,Object? hasMore = null,Object? totals = null,Object? previousTotals = freezed,Object? dailyTotals = null,Object? categories = null,Object? pendingDelete = null,Object? loadFailure = freezed,Object? actionFailure = freezed,}) {
  return _then(_ExpenseListState(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as ExpensePeriod,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ExpenseListStatus,kind: freezed == kind ? _self.kind : kind // ignore: cast_nullable_to_non_nullable
as TransactionKind?,categoryId: freezed == categoryId ? _self.categoryId : categoryId // ignore: cast_nullable_to_non_nullable
as int?,search: null == search ? _self.search : search // ignore: cast_nullable_to_non_nullable
as String,loaded: null == loaded ? _self._loaded : loaded // ignore: cast_nullable_to_non_nullable
as List<Expense>,hasMore: null == hasMore ? _self.hasMore : hasMore // ignore: cast_nullable_to_non_nullable
as bool,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as PeriodTotals,previousTotals: freezed == previousTotals ? _self.previousTotals : previousTotals // ignore: cast_nullable_to_non_nullable
as PeriodTotals?,dailyTotals: null == dailyTotals ? _self._dailyTotals : dailyTotals // ignore: cast_nullable_to_non_nullable
as Map<LocalDate, PeriodTotals>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,pendingDelete: null == pendingDelete ? _self._pendingDelete : pendingDelete // ignore: cast_nullable_to_non_nullable
as Set<int>,loadFailure: freezed == loadFailure ? _self.loadFailure : loadFailure // ignore: cast_nullable_to_non_nullable
as Failure?,actionFailure: freezed == actionFailure ? _self.actionFailure : actionFailure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of ExpenseListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get loadFailure {
    if (_self.loadFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.loadFailure!, (value) {
    return _then(_self.copyWith(loadFailure: value));
  });
}/// Create a copy of ExpenseListState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$FailureCopyWith<$Res>? get actionFailure {
    if (_self.actionFailure == null) {
    return null;
  }

  return $FailureCopyWith<$Res>(_self.actionFailure!, (value) {
    return _then(_self.copyWith(actionFailure: value));
  });
}
}

// dart format on
