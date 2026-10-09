// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'sms_import_state.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$CatchUpState {

 CatchUpStatus get status; List<CatchUpCandidate> get candidates;/// The `smsKey`s of the checked candidates.
 Set<String> get selected;
/// Create a copy of CatchUpState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$CatchUpStateCopyWith<CatchUpState> get copyWith => _$CatchUpStateCopyWithImpl<CatchUpState>(this as CatchUpState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is CatchUpState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other.candidates, candidates)&&const DeepCollectionEquality().equals(other.selected, selected));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(candidates),const DeepCollectionEquality().hash(selected));

@override
String toString() {
  return 'CatchUpState(status: $status, candidates: $candidates, selected: $selected)';
}


}

/// @nodoc
abstract mixin class $CatchUpStateCopyWith<$Res>  {
  factory $CatchUpStateCopyWith(CatchUpState value, $Res Function(CatchUpState) _then) = _$CatchUpStateCopyWithImpl;
@useResult
$Res call({
 CatchUpStatus status, List<CatchUpCandidate> candidates, Set<String> selected
});




}
/// @nodoc
class _$CatchUpStateCopyWithImpl<$Res>
    implements $CatchUpStateCopyWith<$Res> {
  _$CatchUpStateCopyWithImpl(this._self, this._then);

  final CatchUpState _self;
  final $Res Function(CatchUpState) _then;

/// Create a copy of CatchUpState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? status = null,Object? candidates = null,Object? selected = null,}) {
  return _then(_self.copyWith(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CatchUpStatus,candidates: null == candidates ? _self.candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<CatchUpCandidate>,selected: null == selected ? _self.selected : selected // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}

}


/// Adds pattern-matching-related methods to [CatchUpState].
extension CatchUpStatePatterns on CatchUpState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _CatchUpState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _CatchUpState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _CatchUpState value)  $default,){
final _that = this;
switch (_that) {
case _CatchUpState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _CatchUpState value)?  $default,){
final _that = this;
switch (_that) {
case _CatchUpState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( CatchUpStatus status,  List<CatchUpCandidate> candidates,  Set<String> selected)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _CatchUpState() when $default != null:
return $default(_that.status,_that.candidates,_that.selected);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( CatchUpStatus status,  List<CatchUpCandidate> candidates,  Set<String> selected)  $default,) {final _that = this;
switch (_that) {
case _CatchUpState():
return $default(_that.status,_that.candidates,_that.selected);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( CatchUpStatus status,  List<CatchUpCandidate> candidates,  Set<String> selected)?  $default,) {final _that = this;
switch (_that) {
case _CatchUpState() when $default != null:
return $default(_that.status,_that.candidates,_that.selected);case _:
  return null;

}
}

}

/// @nodoc


class _CatchUpState extends CatchUpState {
  const _CatchUpState({this.status = CatchUpStatus.scanning, final  List<CatchUpCandidate> candidates = const <CatchUpCandidate>[], final  Set<String> selected = const <String>{}}): _candidates = candidates,_selected = selected,super._();
  

@override@JsonKey() final  CatchUpStatus status;
 final  List<CatchUpCandidate> _candidates;
@override@JsonKey() List<CatchUpCandidate> get candidates {
  if (_candidates is EqualUnmodifiableListView) return _candidates;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_candidates);
}

/// The `smsKey`s of the checked candidates.
 final  Set<String> _selected;
/// The `smsKey`s of the checked candidates.
@override@JsonKey() Set<String> get selected {
  if (_selected is EqualUnmodifiableSetView) return _selected;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableSetView(_selected);
}


/// Create a copy of CatchUpState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$CatchUpStateCopyWith<_CatchUpState> get copyWith => __$CatchUpStateCopyWithImpl<_CatchUpState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _CatchUpState&&(identical(other.status, status) || other.status == status)&&const DeepCollectionEquality().equals(other._candidates, _candidates)&&const DeepCollectionEquality().equals(other._selected, _selected));
}


@override
int get hashCode => Object.hash(runtimeType,status,const DeepCollectionEquality().hash(_candidates),const DeepCollectionEquality().hash(_selected));

@override
String toString() {
  return 'CatchUpState(status: $status, candidates: $candidates, selected: $selected)';
}


}

/// @nodoc
abstract mixin class _$CatchUpStateCopyWith<$Res> implements $CatchUpStateCopyWith<$Res> {
  factory _$CatchUpStateCopyWith(_CatchUpState value, $Res Function(_CatchUpState) _then) = __$CatchUpStateCopyWithImpl;
@override @useResult
$Res call({
 CatchUpStatus status, List<CatchUpCandidate> candidates, Set<String> selected
});




}
/// @nodoc
class __$CatchUpStateCopyWithImpl<$Res>
    implements _$CatchUpStateCopyWith<$Res> {
  __$CatchUpStateCopyWithImpl(this._self, this._then);

  final _CatchUpState _self;
  final $Res Function(_CatchUpState) _then;

/// Create a copy of CatchUpState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? status = null,Object? candidates = null,Object? selected = null,}) {
  return _then(_CatchUpState(
status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as CatchUpStatus,candidates: null == candidates ? _self._candidates : candidates // ignore: cast_nullable_to_non_nullable
as List<CatchUpCandidate>,selected: null == selected ? _self._selected : selected // ignore: cast_nullable_to_non_nullable
as Set<String>,
  ));
}


}

/// @nodoc
mixin _$SmsImportState {

/// Until the settings and permission have been read.
 bool get loading;/// The switch. False whenever the SMS permission is missing.
 bool get enabled; SmsMode get mode;/// The user said no to the SMS permission; shows the Open settings card.
 bool get permissionDenied;/// Ask mode needs notifications.
 bool get notificationsGranted;/// Waiting for the permission prompts.
 bool get enabling; List<SmsSenderEntry> get senders;/// The imports of the last 30 days, newest first.
 List<SmsImport> get recent; List<Category> get categories;/// The catch-up review while its sheet is open.
 CatchUpState? get catchUp; Failure? get failure;
/// Create a copy of SmsImportState
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SmsImportStateCopyWith<SmsImportState> get copyWith => _$SmsImportStateCopyWithImpl<SmsImportState>(this as SmsImportState, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is SmsImportState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.permissionDenied, permissionDenied) || other.permissionDenied == permissionDenied)&&(identical(other.notificationsGranted, notificationsGranted) || other.notificationsGranted == notificationsGranted)&&(identical(other.enabling, enabling) || other.enabling == enabling)&&const DeepCollectionEquality().equals(other.senders, senders)&&const DeepCollectionEquality().equals(other.recent, recent)&&const DeepCollectionEquality().equals(other.categories, categories)&&(identical(other.catchUp, catchUp) || other.catchUp == catchUp)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,loading,enabled,mode,permissionDenied,notificationsGranted,enabling,const DeepCollectionEquality().hash(senders),const DeepCollectionEquality().hash(recent),const DeepCollectionEquality().hash(categories),catchUp,failure);

@override
String toString() {
  return 'SmsImportState(loading: $loading, enabled: $enabled, mode: $mode, permissionDenied: $permissionDenied, notificationsGranted: $notificationsGranted, enabling: $enabling, senders: $senders, recent: $recent, categories: $categories, catchUp: $catchUp, failure: $failure)';
}


}

/// @nodoc
abstract mixin class $SmsImportStateCopyWith<$Res>  {
  factory $SmsImportStateCopyWith(SmsImportState value, $Res Function(SmsImportState) _then) = _$SmsImportStateCopyWithImpl;
@useResult
$Res call({
 bool loading, bool enabled, SmsMode mode, bool permissionDenied, bool notificationsGranted, bool enabling, List<SmsSenderEntry> senders, List<SmsImport> recent, List<Category> categories, CatchUpState? catchUp, Failure? failure
});


$CatchUpStateCopyWith<$Res>? get catchUp;$FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class _$SmsImportStateCopyWithImpl<$Res>
    implements $SmsImportStateCopyWith<$Res> {
  _$SmsImportStateCopyWithImpl(this._self, this._then);

  final SmsImportState _self;
  final $Res Function(SmsImportState) _then;

/// Create a copy of SmsImportState
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? loading = null,Object? enabled = null,Object? mode = null,Object? permissionDenied = null,Object? notificationsGranted = null,Object? enabling = null,Object? senders = null,Object? recent = null,Object? categories = null,Object? catchUp = freezed,Object? failure = freezed,}) {
  return _then(_self.copyWith(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SmsMode,permissionDenied: null == permissionDenied ? _self.permissionDenied : permissionDenied // ignore: cast_nullable_to_non_nullable
as bool,notificationsGranted: null == notificationsGranted ? _self.notificationsGranted : notificationsGranted // ignore: cast_nullable_to_non_nullable
as bool,enabling: null == enabling ? _self.enabling : enabling // ignore: cast_nullable_to_non_nullable
as bool,senders: null == senders ? _self.senders : senders // ignore: cast_nullable_to_non_nullable
as List<SmsSenderEntry>,recent: null == recent ? _self.recent : recent // ignore: cast_nullable_to_non_nullable
as List<SmsImport>,categories: null == categories ? _self.categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,catchUp: freezed == catchUp ? _self.catchUp : catchUp // ignore: cast_nullable_to_non_nullable
as CatchUpState?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}
/// Create a copy of SmsImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatchUpStateCopyWith<$Res>? get catchUp {
    if (_self.catchUp == null) {
    return null;
  }

  return $CatchUpStateCopyWith<$Res>(_self.catchUp!, (value) {
    return _then(_self.copyWith(catchUp: value));
  });
}/// Create a copy of SmsImportState
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


/// Adds pattern-matching-related methods to [SmsImportState].
extension SmsImportStatePatterns on SmsImportState {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _SmsImportState value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _SmsImportState() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _SmsImportState value)  $default,){
final _that = this;
switch (_that) {
case _SmsImportState():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _SmsImportState value)?  $default,){
final _that = this;
switch (_that) {
case _SmsImportState() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool loading,  bool enabled,  SmsMode mode,  bool permissionDenied,  bool notificationsGranted,  bool enabling,  List<SmsSenderEntry> senders,  List<SmsImport> recent,  List<Category> categories,  CatchUpState? catchUp,  Failure? failure)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _SmsImportState() when $default != null:
return $default(_that.loading,_that.enabled,_that.mode,_that.permissionDenied,_that.notificationsGranted,_that.enabling,_that.senders,_that.recent,_that.categories,_that.catchUp,_that.failure);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool loading,  bool enabled,  SmsMode mode,  bool permissionDenied,  bool notificationsGranted,  bool enabling,  List<SmsSenderEntry> senders,  List<SmsImport> recent,  List<Category> categories,  CatchUpState? catchUp,  Failure? failure)  $default,) {final _that = this;
switch (_that) {
case _SmsImportState():
return $default(_that.loading,_that.enabled,_that.mode,_that.permissionDenied,_that.notificationsGranted,_that.enabling,_that.senders,_that.recent,_that.categories,_that.catchUp,_that.failure);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool loading,  bool enabled,  SmsMode mode,  bool permissionDenied,  bool notificationsGranted,  bool enabling,  List<SmsSenderEntry> senders,  List<SmsImport> recent,  List<Category> categories,  CatchUpState? catchUp,  Failure? failure)?  $default,) {final _that = this;
switch (_that) {
case _SmsImportState() when $default != null:
return $default(_that.loading,_that.enabled,_that.mode,_that.permissionDenied,_that.notificationsGranted,_that.enabling,_that.senders,_that.recent,_that.categories,_that.catchUp,_that.failure);case _:
  return null;

}
}

}

/// @nodoc


class _SmsImportState extends SmsImportState {
  const _SmsImportState({this.loading = true, this.enabled = false, this.mode = SmsMode.ask, this.permissionDenied = false, this.notificationsGranted = true, this.enabling = false, final  List<SmsSenderEntry> senders = const <SmsSenderEntry>[], final  List<SmsImport> recent = const <SmsImport>[], final  List<Category> categories = const <Category>[], this.catchUp, this.failure}): _senders = senders,_recent = recent,_categories = categories,super._();
  

/// Until the settings and permission have been read.
@override@JsonKey() final  bool loading;
/// The switch. False whenever the SMS permission is missing.
@override@JsonKey() final  bool enabled;
@override@JsonKey() final  SmsMode mode;
/// The user said no to the SMS permission; shows the Open settings card.
@override@JsonKey() final  bool permissionDenied;
/// Ask mode needs notifications.
@override@JsonKey() final  bool notificationsGranted;
/// Waiting for the permission prompts.
@override@JsonKey() final  bool enabling;
 final  List<SmsSenderEntry> _senders;
@override@JsonKey() List<SmsSenderEntry> get senders {
  if (_senders is EqualUnmodifiableListView) return _senders;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_senders);
}

/// The imports of the last 30 days, newest first.
 final  List<SmsImport> _recent;
/// The imports of the last 30 days, newest first.
@override@JsonKey() List<SmsImport> get recent {
  if (_recent is EqualUnmodifiableListView) return _recent;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_recent);
}

 final  List<Category> _categories;
@override@JsonKey() List<Category> get categories {
  if (_categories is EqualUnmodifiableListView) return _categories;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_categories);
}

/// The catch-up review while its sheet is open.
@override final  CatchUpState? catchUp;
@override final  Failure? failure;

/// Create a copy of SmsImportState
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SmsImportStateCopyWith<_SmsImportState> get copyWith => __$SmsImportStateCopyWithImpl<_SmsImportState>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _SmsImportState&&(identical(other.loading, loading) || other.loading == loading)&&(identical(other.enabled, enabled) || other.enabled == enabled)&&(identical(other.mode, mode) || other.mode == mode)&&(identical(other.permissionDenied, permissionDenied) || other.permissionDenied == permissionDenied)&&(identical(other.notificationsGranted, notificationsGranted) || other.notificationsGranted == notificationsGranted)&&(identical(other.enabling, enabling) || other.enabling == enabling)&&const DeepCollectionEquality().equals(other._senders, _senders)&&const DeepCollectionEquality().equals(other._recent, _recent)&&const DeepCollectionEquality().equals(other._categories, _categories)&&(identical(other.catchUp, catchUp) || other.catchUp == catchUp)&&(identical(other.failure, failure) || other.failure == failure));
}


@override
int get hashCode => Object.hash(runtimeType,loading,enabled,mode,permissionDenied,notificationsGranted,enabling,const DeepCollectionEquality().hash(_senders),const DeepCollectionEquality().hash(_recent),const DeepCollectionEquality().hash(_categories),catchUp,failure);

@override
String toString() {
  return 'SmsImportState(loading: $loading, enabled: $enabled, mode: $mode, permissionDenied: $permissionDenied, notificationsGranted: $notificationsGranted, enabling: $enabling, senders: $senders, recent: $recent, categories: $categories, catchUp: $catchUp, failure: $failure)';
}


}

/// @nodoc
abstract mixin class _$SmsImportStateCopyWith<$Res> implements $SmsImportStateCopyWith<$Res> {
  factory _$SmsImportStateCopyWith(_SmsImportState value, $Res Function(_SmsImportState) _then) = __$SmsImportStateCopyWithImpl;
@override @useResult
$Res call({
 bool loading, bool enabled, SmsMode mode, bool permissionDenied, bool notificationsGranted, bool enabling, List<SmsSenderEntry> senders, List<SmsImport> recent, List<Category> categories, CatchUpState? catchUp, Failure? failure
});


@override $CatchUpStateCopyWith<$Res>? get catchUp;@override $FailureCopyWith<$Res>? get failure;

}
/// @nodoc
class __$SmsImportStateCopyWithImpl<$Res>
    implements _$SmsImportStateCopyWith<$Res> {
  __$SmsImportStateCopyWithImpl(this._self, this._then);

  final _SmsImportState _self;
  final $Res Function(_SmsImportState) _then;

/// Create a copy of SmsImportState
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? loading = null,Object? enabled = null,Object? mode = null,Object? permissionDenied = null,Object? notificationsGranted = null,Object? enabling = null,Object? senders = null,Object? recent = null,Object? categories = null,Object? catchUp = freezed,Object? failure = freezed,}) {
  return _then(_SmsImportState(
loading: null == loading ? _self.loading : loading // ignore: cast_nullable_to_non_nullable
as bool,enabled: null == enabled ? _self.enabled : enabled // ignore: cast_nullable_to_non_nullable
as bool,mode: null == mode ? _self.mode : mode // ignore: cast_nullable_to_non_nullable
as SmsMode,permissionDenied: null == permissionDenied ? _self.permissionDenied : permissionDenied // ignore: cast_nullable_to_non_nullable
as bool,notificationsGranted: null == notificationsGranted ? _self.notificationsGranted : notificationsGranted // ignore: cast_nullable_to_non_nullable
as bool,enabling: null == enabling ? _self.enabling : enabling // ignore: cast_nullable_to_non_nullable
as bool,senders: null == senders ? _self._senders : senders // ignore: cast_nullable_to_non_nullable
as List<SmsSenderEntry>,recent: null == recent ? _self._recent : recent // ignore: cast_nullable_to_non_nullable
as List<SmsImport>,categories: null == categories ? _self._categories : categories // ignore: cast_nullable_to_non_nullable
as List<Category>,catchUp: freezed == catchUp ? _self.catchUp : catchUp // ignore: cast_nullable_to_non_nullable
as CatchUpState?,failure: freezed == failure ? _self.failure : failure // ignore: cast_nullable_to_non_nullable
as Failure?,
  ));
}

/// Create a copy of SmsImportState
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$CatchUpStateCopyWith<$Res>? get catchUp {
    if (_self.catchUp == null) {
    return null;
  }

  return $CatchUpStateCopyWith<$Res>(_self.catchUp!, (value) {
    return _then(_self.copyWith(catchUp: value));
  });
}/// Create a copy of SmsImportState
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
