// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'analytics_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$AnalyticsState {

 AnalyticsPeriod get period; DateRange get range;/// `DateTime.weekday` the week starts on, for weekly bars.
 int get firstWeekday; AnalyticsStatus get status; PeriodTotals get totals;/// Spending of the comparison period; null until it has loaded.
 Money? get previousTotal;/// What the breakdown card shows: spending or income by category.
 TransactionKind get breakdownKind;/// Totals per category of [breakdownKind].
 Map<int, Money> get byCategory; Map<LocalDate, PeriodTotals> get daily;/// Every category (hidden ones too), by id.
 Map<int, Category> get categories;/// Every budget in its own current week or month (ignores [range]).
 List<BudgetProgress> get budgets; Failure? get failure;
/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AnalyticsStateCopyWith<AnalyticsState> get copyWith => _$AnalyticsStateCopyWithImpl<AnalyticsState>(this as AnalyticsState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is AnalyticsState&&(identical(other.period, period) || other.period == period)&&(identical(other.range, range) || other.range == range)&&(identical(other.firstWeekday, firstWeekday) || other.firstWeekday == firstWeekday)&&(identical(other.status, status) || other.status == status)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.previousTotal, previousTotal) || other.previousTotal == previousTotal)&&(identical(other.breakdownKind, breakdownKind) || other.breakdownKind == breakdownKind)&&const DeepCollectionEquality().equals(other.byCategory, byCategory)&&const DeepCollectionEquality().equals(other.daily, daily)&&const DeepCollectionEquality().equals(other.categories, categories)&&const DeepCollectionEquality().equals(other.budgets, budgets)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,period,range,firstWeekday,status,totals,previousTotal,breakdownKind,const DeepCollectionEquality().hash(byCategory),const DeepCollectionEquality().hash(daily),const DeepCollectionEquality().hash(categories),const DeepCollectionEquality().hash(budgets),failure);

@override
String toString() {
  return 'AnalyticsState(period: $period, range: $range, firstWeekday: $firstWeekday, status: $status, totals: $totals, previousTotal: $previousTotal, breakdownKind: $breakdownKind, byCategory: $byCategory, daily: $daily, categories: $categories, budgets: $budgets, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $AnalyticsStateCopyWith<$Res>  {
  factory $AnalyticsStateCopyWith(AnalyticsState value, $Res Function(AnalyticsState) _then) = _$AnalyticsStateCopyWithImpl;
@useResult
$Res call({
 AnalyticsPeriod period, DateRange range, int firstWeekday, AnalyticsStatus status, PeriodTotals totals, Money? previousTotal, TransactionKind breakdownKind, Map<int, Money> byCategory, Map<LocalDate, PeriodTotals> daily, Map<int, Category> categories, List<BudgetProgress> budgets, Failure? failure
});


$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$AnalyticsStateCopyWithImpl<$Res>
    implements $AnalyticsStateCopyWith<$Res> {
  _$AnalyticsStateCopyWithImpl(this._self, this._then);

  final AnalyticsState _self;
  final $Res Function(AnalyticsState) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? period = null,Object? range = null,Object? firstWeekday = null,Object? status = null,Object? totals = null,Object? previousTotal = freezed,Object? breakdownKind = null,Object? byCategory = null,Object? daily = null,Object? categories = null,Object? budgets = null,Object? failure = freezed,}) {
  return _then(_self.copyWith(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as AnalyticsPeriod,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,firstWeekday: null == firstWeekday ? _self.firstWeekday : firstWeekday // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AnalyticsStatus,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as PeriodTotals,previousTotal: freezed == previousTotal ? _self.previousTotal : previousTotal // ignore: cast_nullable_to_non_nullable
as Money?,breakdownKind: null == breakdownKind ? _self.breakdownKind : breakdownKind // ignore: cast_nullable_to_non_nullable
as TransactionKind,byCategory: null == byCategory ? _self.byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as Map<int, Money>,daily: null == daily ? _self.daily : daily // ignore: cast_nullable_to_non_nullable
as Map<LocalDate, PeriodTotals>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,budgets: null == budgets ? _self.budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<BudgetProgress>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of AnalyticsState
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


/// Adds pattern-matching-related methods to [AnalyticsState].
extension AnalyticsStatePatterns on AnalyticsState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _AnalyticsState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _AnalyticsState value)  $default,){
final _that = this;
switch (_that) {
case _AnalyticsState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _AnalyticsState value)?  $default,){
final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( AnalyticsPeriod period,  DateRange range,  int firstWeekday,  AnalyticsStatus status,  PeriodTotals totals,  Money? previousTotal,  TransactionKind breakdownKind,  Map<int, Money> byCategory,  Map<LocalDate, PeriodTotals> daily,  Map<int, Category> categories,  List<BudgetProgress> budgets,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
return $default(_that.period,_that.range,_that.firstWeekday,_that.status,_that.totals,_that.previousTotal,_that.breakdownKind,_that.byCategory,_that.daily,_that.categories,_that.budgets,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( AnalyticsPeriod period,  DateRange range,  int firstWeekday,  AnalyticsStatus status,  PeriodTotals totals,  Money? previousTotal,  TransactionKind breakdownKind,  Map<int, Money> byCategory,  Map<LocalDate, PeriodTotals> daily,  Map<int, Category> categories,  List<BudgetProgress> budgets,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _AnalyticsState():
return $default(_that.period,_that.range,_that.firstWeekday,_that.status,_that.totals,_that.previousTotal,_that.breakdownKind,_that.byCategory,_that.daily,_that.categories,_that.budgets,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( AnalyticsPeriod period,  DateRange range,  int firstWeekday,  AnalyticsStatus status,  PeriodTotals totals,  Money? previousTotal,  TransactionKind breakdownKind,  Map<int, Money> byCategory,  Map<LocalDate, PeriodTotals> daily,  Map<int, Category> categories,  List<BudgetProgress> budgets,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _AnalyticsState() when $default != null:
return $default(_that.period,_that.range,_that.firstWeekday,_that.status,_that.totals,_that.previousTotal,_that.breakdownKind,_that.byCategory,_that.daily,_that.categories,_that.budgets,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _AnalyticsState extends AnalyticsState {
  const _AnalyticsState({required this.period, required this.range, required this.firstWeekday, this.status = AnalyticsStatus.loading, this.totals = PeriodTotals.zero, this.previousTotal, this.breakdownKind = TransactionKind.expense, final  Map<int, Money> byCategory = const <int, Money>{}, final  Map<LocalDate, PeriodTotals> daily = const <LocalDate, PeriodTotals>{}, final  Map<int, Category> categories = const <int, Category>{}, final  List<BudgetProgress> budgets = const <BudgetProgress>[], this.failure}): _byCategory = byCategory,_daily = daily,_categories = categories,_budgets = budgets,super._();
  

@override final  AnalyticsPeriod period;
@override final  DateRange range;
/// `DateTime.weekday` the week starts on, for weekly bars.
@override final  int firstWeekday;
@override@JsonKey() final  AnalyticsStatus status;
@override@JsonKey() final  PeriodTotals totals;
/// Spending of the comparison period; null until it has loaded.
@override final  Money? previousTotal;
/// What the breakdown card shows: spending or income by category.
@override@JsonKey() final  TransactionKind breakdownKind;
/// Totals per category of [breakdownKind].
 final  Map<int, Money> _byCategory;
/// Totals per category of [breakdownKind].
@override@JsonKey() Map<int, Money> get byCategory {
  if (_byCategory is EqualUnmodifiableMapView) return _byCategory;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_byCategory);
}

 final  Map<LocalDate, PeriodTotals> _daily;
@override@JsonKey() Map<LocalDate, PeriodTotals> get daily {
  if (_daily is EqualUnmodifiableMapView) return _daily;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_daily);
}

/// Every category (hidden ones too), by id.
 final  Map<int, Category> _categories;
/// Every category (hidden ones too), by id.
@override@JsonKey() Map<int, Category> get categories {
  if (_categories is EqualUnmodifiableMapView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_categories);
}

/// Every budget in its own current week or month (ignores [range]).
 final  List<BudgetProgress> _budgets;
/// Every budget in its own current week or month (ignores [range]).
@override@JsonKey() List<BudgetProgress> get budgets {
  if (_budgets is EqualUnmodifiableListView) return _budgets;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_budgets);
}

@override final  Failure? failure;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AnalyticsStateCopyWith<_AnalyticsState> get copyWith => __$AnalyticsStateCopyWithImpl<_AnalyticsState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _AnalyticsState&&(identical(other.period, period) || other.period == period)&&(identical(other.range, range) || other.range == range)&&(identical(other.firstWeekday, firstWeekday) || other.firstWeekday == firstWeekday)&&(identical(other.status, status) || other.status == status)&&(identical(other.totals, totals) || other.totals == totals)&&(identical(other.previousTotal, previousTotal) || other.previousTotal == previousTotal)&&(identical(other.breakdownKind, breakdownKind) || other.breakdownKind == breakdownKind)&&const DeepCollectionEquality().equals(other._byCategory, _byCategory)&&const DeepCollectionEquality().equals(other._daily, _daily)&&const DeepCollectionEquality().equals(other._categories, _categories)&&const DeepCollectionEquality().equals(other._budgets, _budgets)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,period,range,firstWeekday,status,totals,previousTotal,breakdownKind,const DeepCollectionEquality().hash(_byCategory),const DeepCollectionEquality().hash(_daily),const DeepCollectionEquality().hash(_categories),const DeepCollectionEquality().hash(_budgets),failure);

@override
String toString() {
  return 'AnalyticsState(period: $period, range: $range, firstWeekday: $firstWeekday, status: $status, totals: $totals, previousTotal: $previousTotal, breakdownKind: $breakdownKind, byCategory: $byCategory, daily: $daily, categories: $categories, budgets: $budgets, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$AnalyticsStateCopyWith<$Res> implements $AnalyticsStateCopyWith<$Res> {
  factory _$AnalyticsStateCopyWith(_AnalyticsState value, $Res Function(_AnalyticsState) _then) = __$AnalyticsStateCopyWithImpl;
@override @useResult
$Res call({
 AnalyticsPeriod period, DateRange range, int firstWeekday, AnalyticsStatus status, PeriodTotals totals, Money? previousTotal, TransactionKind breakdownKind, Map<int, Money> byCategory, Map<LocalDate, PeriodTotals> daily, Map<int, Category> categories, List<BudgetProgress> budgets, Failure? failure
});


@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$AnalyticsStateCopyWithImpl<$Res>
    implements _$AnalyticsStateCopyWith<$Res> {
  __$AnalyticsStateCopyWithImpl(this._self, this._then);

  final _AnalyticsState _self;
  final $Res Function(_AnalyticsState) _then;

/// Create a copy of AnalyticsState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? period = null,Object? range = null,Object? firstWeekday = null,Object? status = null,Object? totals = null,Object? previousTotal = freezed,Object? breakdownKind = null,Object? byCategory = null,Object? daily = null,Object? categories = null,Object? budgets = null,Object? failure = freezed,}) {
  return _then(_AnalyticsState(
period: null == period ? _self.period : period // ignore: cast_nullable_to_non_nullable
as AnalyticsPeriod,range: null == range ? _self.range : range // ignore: cast_nullable_to_non_nullable
as DateRange,firstWeekday: null == firstWeekday ? _self.firstWeekday : firstWeekday // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as AnalyticsStatus,totals: null == totals ? _self.totals : totals // ignore: cast_nullable_to_non_nullable
as PeriodTotals,previousTotal: freezed == previousTotal ? _self.previousTotal : previousTotal // ignore: cast_nullable_to_non_nullable
as Money?,breakdownKind: null == breakdownKind ? _self.breakdownKind : breakdownKind // ignore: cast_nullable_to_non_nullable
as TransactionKind,byCategory: null == byCategory ? _self._byCategory : byCategory // ignore: cast_nullable_to_non_nullable
as Map<int, Money>,daily: null == daily ? _self._daily : daily // ignore: cast_nullable_to_non_nullable
as Map<LocalDate, PeriodTotals>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as Map<int, Category>,budgets: null == budgets ? _self._budgets : budgets // ignore: cast_nullable_to_non_nullable
as List<BudgetProgress>,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of AnalyticsState
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
