// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'match.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$MatchSummary {

 int get id;@JsonKey(name: 'profile_a') ProfileSummary get profileA;@JsonKey(name: 'profile_b') ProfileSummary get profileB;@JsonKey(name: 'my_profile_id') int get myProfileId;@JsonKey(name: 'match_type', fromJson: MatchType.fromJson) MatchType get matchType;@JsonKey(name: 'matched_at') String get matchedAt;
/// Create a copy of MatchSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MatchSummaryCopyWith<MatchSummary> get copyWith => _$MatchSummaryCopyWithImpl<MatchSummary>(this as MatchSummary, _$identity);

  /// Serializes this MatchSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as MatchSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is MatchSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileA, _this.profileA) || other.profileA == _this.profileA)&&(identical(other.profileB, _this.profileB) || other.profileB == _this.profileB)&&(identical(other.myProfileId, _this.myProfileId) || other.myProfileId == _this.myProfileId)&&(identical(other.matchType, _this.matchType) || other.matchType == _this.matchType)&&(identical(other.matchedAt, _this.matchedAt) || other.matchedAt == _this.matchedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as MatchSummary;
  return Object.hash(runtimeType,_this.id,_this.profileA,_this.profileB,_this.myProfileId,_this.matchType,_this.matchedAt);
}

@override
String toString() {
  final _this = this as MatchSummary;
  return 'MatchSummary(id: ${_this.id}, profileA: ${_this.profileA}, profileB: ${_this.profileB}, myProfileId: ${_this.myProfileId}, matchType: ${_this.matchType}, matchedAt: ${_this.matchedAt})';
}


}

/// @nodoc
abstract mixin class $MatchSummaryCopyWith<$Res>  {
  factory $MatchSummaryCopyWith(MatchSummary value, $Res Function(MatchSummary) _then) = _$MatchSummaryCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'profile_a') ProfileSummary profileA,@JsonKey(name: 'profile_b') ProfileSummary profileB,@JsonKey(name: 'my_profile_id') int myProfileId,@JsonKey(name: 'match_type', fromJson: MatchType.fromJson) MatchType matchType,@JsonKey(name: 'matched_at') String matchedAt
});


$ProfileSummaryCopyWith<$Res> get profileA;$ProfileSummaryCopyWith<$Res> get profileB;

}
/// @nodoc
class _$MatchSummaryCopyWithImpl<$Res>
    implements $MatchSummaryCopyWith<$Res> {
  _$MatchSummaryCopyWithImpl(this._self, this._then);

  final MatchSummary _self;
  final $Res Function(MatchSummary) _then;

/// Create a copy of MatchSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileA = null,Object? profileB = null,Object? myProfileId = null,Object? matchType = null,Object? matchedAt = null,}) {
  return _then(MatchSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileA: null == profileA ? _self.profileA : profileA // ignore: cast_nullable_to_non_nullable
as ProfileSummary,profileB: null == profileB ? _self.profileB : profileB // ignore: cast_nullable_to_non_nullable
as ProfileSummary,myProfileId: null == myProfileId ? _self.myProfileId : myProfileId // ignore: cast_nullable_to_non_nullable
as int,matchType: null == matchType ? _self.matchType : matchType // ignore: cast_nullable_to_non_nullable
as MatchType,matchedAt: null == matchedAt ? _self.matchedAt : matchedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}
/// Create a copy of MatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSummaryCopyWith<$Res> get profileA {
  
  return $ProfileSummaryCopyWith<$Res>(_self.profileA, (value) {
    return _then(_self.copyWith(profileA: value));
  });
}/// Create a copy of MatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSummaryCopyWith<$Res> get profileB {
  
  return $ProfileSummaryCopyWith<$Res>(_self.profileB, (value) {
    return _then(_self.copyWith(profileB: value));
  });
}
}


/// Adds pattern-matching-related methods to [MatchSummary].
extension MatchSummaryPatterns on MatchSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _MatchSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _MatchSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _MatchSummary value)  $default,){
final _that = this;
switch (_that) {
case _MatchSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _MatchSummary value)?  $default,){
final _that = this;
switch (_that) {
case _MatchSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'profile_a')  ProfileSummary profileA, @JsonKey(name: 'profile_b')  ProfileSummary profileB, @JsonKey(name: 'my_profile_id')  int myProfileId, @JsonKey(name: 'match_type', fromJson: MatchType.fromJson)  MatchType matchType, @JsonKey(name: 'matched_at')  String matchedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _MatchSummary() when $default != null:
return $default(_that.id,_that.profileA,_that.profileB,_that.myProfileId,_that.matchType,_that.matchedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'profile_a')  ProfileSummary profileA, @JsonKey(name: 'profile_b')  ProfileSummary profileB, @JsonKey(name: 'my_profile_id')  int myProfileId, @JsonKey(name: 'match_type', fromJson: MatchType.fromJson)  MatchType matchType, @JsonKey(name: 'matched_at')  String matchedAt)  $default,) {final _that = this;
switch (_that) {
case _MatchSummary():
return $default(_that.id,_that.profileA,_that.profileB,_that.myProfileId,_that.matchType,_that.matchedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'profile_a')  ProfileSummary profileA, @JsonKey(name: 'profile_b')  ProfileSummary profileB, @JsonKey(name: 'my_profile_id')  int myProfileId, @JsonKey(name: 'match_type', fromJson: MatchType.fromJson)  MatchType matchType, @JsonKey(name: 'matched_at')  String matchedAt)?  $default,) {final _that = this;
switch (_that) {
case _MatchSummary() when $default != null:
return $default(_that.id,_that.profileA,_that.profileB,_that.myProfileId,_that.matchType,_that.matchedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _MatchSummary implements MatchSummary {
  const _MatchSummary({required this.id, @JsonKey(name: 'profile_a') required this.profileA, @JsonKey(name: 'profile_b') required this.profileB, @JsonKey(name: 'my_profile_id') required this.myProfileId, @JsonKey(name: 'match_type', fromJson: MatchType.fromJson) required this.matchType, @JsonKey(name: 'matched_at') required this.matchedAt});
  factory _MatchSummary.fromJson(Map<String, dynamic> json) => _$MatchSummaryFromJson(json);

@override final  int id;
@override@JsonKey(name: 'profile_a') final  ProfileSummary profileA;
@override@JsonKey(name: 'profile_b') final  ProfileSummary profileB;
@override@JsonKey(name: 'my_profile_id') final  int myProfileId;
@override@JsonKey(name: 'match_type', fromJson: MatchType.fromJson) final  MatchType matchType;
@override@JsonKey(name: 'matched_at') final  String matchedAt;

/// Create a copy of MatchSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MatchSummaryCopyWith<_MatchSummary> get copyWith => __$MatchSummaryCopyWithImpl<_MatchSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MatchSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _MatchSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.profileA, profileA) || other.profileA == profileA)&&(identical(other.profileB, profileB) || other.profileB == profileB)&&(identical(other.myProfileId, myProfileId) || other.myProfileId == myProfileId)&&(identical(other.matchType, matchType) || other.matchType == matchType)&&(identical(other.matchedAt, matchedAt) || other.matchedAt == matchedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,profileA,profileB,myProfileId,matchType,matchedAt);
}

@override
String toString() {
    return 'MatchSummary(id: $id, profileA: $profileA, profileB: $profileB, myProfileId: $myProfileId, matchType: $matchType, matchedAt: $matchedAt)';
}


}

/// @nodoc
abstract mixin class _$MatchSummaryCopyWith<$Res> implements $MatchSummaryCopyWith<$Res> {
  factory _$MatchSummaryCopyWith(_MatchSummary value, $Res Function(_MatchSummary) _then) = __$MatchSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'profile_a') ProfileSummary profileA,@JsonKey(name: 'profile_b') ProfileSummary profileB,@JsonKey(name: 'my_profile_id') int myProfileId,@JsonKey(name: 'match_type', fromJson: MatchType.fromJson) MatchType matchType,@JsonKey(name: 'matched_at') String matchedAt
});


@override $ProfileSummaryCopyWith<$Res> get profileA;@override $ProfileSummaryCopyWith<$Res> get profileB;

}
/// @nodoc
class __$MatchSummaryCopyWithImpl<$Res>
    implements _$MatchSummaryCopyWith<$Res> {
  __$MatchSummaryCopyWithImpl(this._self, this._then);

  final _MatchSummary _self;
  final $Res Function(_MatchSummary) _then;

/// Create a copy of MatchSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileA = null,Object? profileB = null,Object? myProfileId = null,Object? matchType = null,Object? matchedAt = null,}) {
  return _then(_MatchSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileA: null == profileA ? _self.profileA : profileA // ignore: cast_nullable_to_non_nullable
as ProfileSummary,profileB: null == profileB ? _self.profileB : profileB // ignore: cast_nullable_to_non_nullable
as ProfileSummary,myProfileId: null == myProfileId ? _self.myProfileId : myProfileId // ignore: cast_nullable_to_non_nullable
as int,matchType: null == matchType ? _self.matchType : matchType // ignore: cast_nullable_to_non_nullable
as MatchType,matchedAt: null == matchedAt ? _self.matchedAt : matchedAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

/// Create a copy of MatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSummaryCopyWith<$Res> get profileA {
  
  return $ProfileSummaryCopyWith<$Res>(_self.profileA, (value) {
    return _then(_self.copyWith(profileA: value));
  });
}/// Create a copy of MatchSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSummaryCopyWith<$Res> get profileB {
  
  return $ProfileSummaryCopyWith<$Res>(_self.profileB, (value) {
    return _then(_self.copyWith(profileB: value));
  });
}
}


/// @nodoc
mixin _$NewMatch {

 int get id;@JsonKey(name: 'profile_a_id') int get profileAId;@JsonKey(name: 'profile_b_id') int get profileBId;@JsonKey(name: 'match_type', fromJson: MatchType.fromJson) MatchType get matchType;
/// Create a copy of NewMatch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$NewMatchCopyWith<NewMatch> get copyWith => _$NewMatchCopyWithImpl<NewMatch>(this as NewMatch, _$identity);

  /// Serializes this NewMatch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as NewMatch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is NewMatch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileAId, _this.profileAId) || other.profileAId == _this.profileAId)&&(identical(other.profileBId, _this.profileBId) || other.profileBId == _this.profileBId)&&(identical(other.matchType, _this.matchType) || other.matchType == _this.matchType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as NewMatch;
  return Object.hash(runtimeType,_this.id,_this.profileAId,_this.profileBId,_this.matchType);
}

@override
String toString() {
  final _this = this as NewMatch;
  return 'NewMatch(id: ${_this.id}, profileAId: ${_this.profileAId}, profileBId: ${_this.profileBId}, matchType: ${_this.matchType})';
}


}

/// @nodoc
abstract mixin class $NewMatchCopyWith<$Res>  {
  factory $NewMatchCopyWith(NewMatch value, $Res Function(NewMatch) _then) = _$NewMatchCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'profile_a_id') int profileAId,@JsonKey(name: 'profile_b_id') int profileBId,@JsonKey(name: 'match_type', fromJson: MatchType.fromJson) MatchType matchType
});




}
/// @nodoc
class _$NewMatchCopyWithImpl<$Res>
    implements $NewMatchCopyWith<$Res> {
  _$NewMatchCopyWithImpl(this._self, this._then);

  final NewMatch _self;
  final $Res Function(NewMatch) _then;

/// Create a copy of NewMatch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileAId = null,Object? profileBId = null,Object? matchType = null,}) {
  return _then(NewMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileAId: null == profileAId ? _self.profileAId : profileAId // ignore: cast_nullable_to_non_nullable
as int,profileBId: null == profileBId ? _self.profileBId : profileBId // ignore: cast_nullable_to_non_nullable
as int,matchType: null == matchType ? _self.matchType : matchType // ignore: cast_nullable_to_non_nullable
as MatchType,
  ));
}

}


/// Adds pattern-matching-related methods to [NewMatch].
extension NewMatchPatterns on NewMatch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _NewMatch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _NewMatch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _NewMatch value)  $default,){
final _that = this;
switch (_that) {
case _NewMatch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _NewMatch value)?  $default,){
final _that = this;
switch (_that) {
case _NewMatch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'profile_a_id')  int profileAId, @JsonKey(name: 'profile_b_id')  int profileBId, @JsonKey(name: 'match_type', fromJson: MatchType.fromJson)  MatchType matchType)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _NewMatch() when $default != null:
return $default(_that.id,_that.profileAId,_that.profileBId,_that.matchType);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'profile_a_id')  int profileAId, @JsonKey(name: 'profile_b_id')  int profileBId, @JsonKey(name: 'match_type', fromJson: MatchType.fromJson)  MatchType matchType)  $default,) {final _that = this;
switch (_that) {
case _NewMatch():
return $default(_that.id,_that.profileAId,_that.profileBId,_that.matchType);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'profile_a_id')  int profileAId, @JsonKey(name: 'profile_b_id')  int profileBId, @JsonKey(name: 'match_type', fromJson: MatchType.fromJson)  MatchType matchType)?  $default,) {final _that = this;
switch (_that) {
case _NewMatch() when $default != null:
return $default(_that.id,_that.profileAId,_that.profileBId,_that.matchType);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _NewMatch implements NewMatch {
  const _NewMatch({required this.id, @JsonKey(name: 'profile_a_id') required this.profileAId, @JsonKey(name: 'profile_b_id') required this.profileBId, @JsonKey(name: 'match_type', fromJson: MatchType.fromJson) required this.matchType});
  factory _NewMatch.fromJson(Map<String, dynamic> json) => _$NewMatchFromJson(json);

@override final  int id;
@override@JsonKey(name: 'profile_a_id') final  int profileAId;
@override@JsonKey(name: 'profile_b_id') final  int profileBId;
@override@JsonKey(name: 'match_type', fromJson: MatchType.fromJson) final  MatchType matchType;

/// Create a copy of NewMatch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$NewMatchCopyWith<_NewMatch> get copyWith => __$NewMatchCopyWithImpl<_NewMatch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$NewMatchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _NewMatch&&(identical(other.id, id) || other.id == id)&&(identical(other.profileAId, profileAId) || other.profileAId == profileAId)&&(identical(other.profileBId, profileBId) || other.profileBId == profileBId)&&(identical(other.matchType, matchType) || other.matchType == matchType));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,profileAId,profileBId,matchType);
}

@override
String toString() {
    return 'NewMatch(id: $id, profileAId: $profileAId, profileBId: $profileBId, matchType: $matchType)';
}


}

/// @nodoc
abstract mixin class _$NewMatchCopyWith<$Res> implements $NewMatchCopyWith<$Res> {
  factory _$NewMatchCopyWith(_NewMatch value, $Res Function(_NewMatch) _then) = __$NewMatchCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'profile_a_id') int profileAId,@JsonKey(name: 'profile_b_id') int profileBId,@JsonKey(name: 'match_type', fromJson: MatchType.fromJson) MatchType matchType
});




}
/// @nodoc
class __$NewMatchCopyWithImpl<$Res>
    implements _$NewMatchCopyWith<$Res> {
  __$NewMatchCopyWithImpl(this._self, this._then);

  final _NewMatch _self;
  final $Res Function(_NewMatch) _then;

/// Create a copy of NewMatch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileAId = null,Object? profileBId = null,Object? matchType = null,}) {
  return _then(_NewMatch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileAId: null == profileAId ? _self.profileAId : profileAId // ignore: cast_nullable_to_non_nullable
as int,profileBId: null == profileBId ? _self.profileBId : profileBId // ignore: cast_nullable_to_non_nullable
as int,matchType: null == matchType ? _self.matchType : matchType // ignore: cast_nullable_to_non_nullable
as MatchType,
  ));
}


}


/// @nodoc
mixin _$InterestResult {

 Interest get interest; NewMatch? get match;
/// Create a copy of InterestResult
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterestResultCopyWith<InterestResult> get copyWith => _$InterestResultCopyWithImpl<InterestResult>(this as InterestResult, _$identity);

  /// Serializes this InterestResult to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as InterestResult;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is InterestResult&&(identical(other.interest, _this.interest) || other.interest == _this.interest)&&(identical(other.match, _this.match) || other.match == _this.match));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as InterestResult;
  return Object.hash(runtimeType,_this.interest,_this.match);
}

@override
String toString() {
  final _this = this as InterestResult;
  return 'InterestResult(interest: ${_this.interest}, match: ${_this.match})';
}


}

/// @nodoc
abstract mixin class $InterestResultCopyWith<$Res>  {
  factory $InterestResultCopyWith(InterestResult value, $Res Function(InterestResult) _then) = _$InterestResultCopyWithImpl;
@useResult
$Res call({
 Interest interest, NewMatch? match
});


$InterestCopyWith<$Res> get interest;$NewMatchCopyWith<$Res>? get match;

}
/// @nodoc
class _$InterestResultCopyWithImpl<$Res>
    implements $InterestResultCopyWith<$Res> {
  _$InterestResultCopyWithImpl(this._self, this._then);

  final InterestResult _self;
  final $Res Function(InterestResult) _then;

/// Create a copy of InterestResult
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? interest = null,Object? match = freezed,}) {
  return _then(InterestResult(
interest: null == interest ? _self.interest : interest // ignore: cast_nullable_to_non_nullable
as Interest,match: freezed == match ? _self.match : match // ignore: cast_nullable_to_non_nullable
as NewMatch?,
  ));
}
/// Create a copy of InterestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InterestCopyWith<$Res> get interest {
  
  return $InterestCopyWith<$Res>(_self.interest, (value) {
    return _then(_self.copyWith(interest: value));
  });
}/// Create a copy of InterestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewMatchCopyWith<$Res>? get match {
    if (_self.match == null) {
    return null;
  }

  return $NewMatchCopyWith<$Res>(_self.match!, (value) {
    return _then(_self.copyWith(match: value));
  });
}
}


/// Adds pattern-matching-related methods to [InterestResult].
extension InterestResultPatterns on InterestResult {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _InterestResult value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _InterestResult() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _InterestResult value)  $default,){
final _that = this;
switch (_that) {
case _InterestResult():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _InterestResult value)?  $default,){
final _that = this;
switch (_that) {
case _InterestResult() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( Interest interest,  NewMatch? match)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _InterestResult() when $default != null:
return $default(_that.interest,_that.match);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( Interest interest,  NewMatch? match)  $default,) {final _that = this;
switch (_that) {
case _InterestResult():
return $default(_that.interest,_that.match);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( Interest interest,  NewMatch? match)?  $default,) {final _that = this;
switch (_that) {
case _InterestResult() when $default != null:
return $default(_that.interest,_that.match);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _InterestResult implements InterestResult {
  const _InterestResult({required this.interest, this.match});
  factory _InterestResult.fromJson(Map<String, dynamic> json) => _$InterestResultFromJson(json);

@override final  Interest interest;
@override final  NewMatch? match;

/// Create a copy of InterestResult
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterestResultCopyWith<_InterestResult> get copyWith => __$InterestResultCopyWithImpl<_InterestResult>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterestResultToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _InterestResult&&(identical(other.interest, interest) || other.interest == interest)&&(identical(other.match, match) || other.match == match));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,interest,match);
}

@override
String toString() {
    return 'InterestResult(interest: $interest, match: $match)';
}


}

/// @nodoc
abstract mixin class _$InterestResultCopyWith<$Res> implements $InterestResultCopyWith<$Res> {
  factory _$InterestResultCopyWith(_InterestResult value, $Res Function(_InterestResult) _then) = __$InterestResultCopyWithImpl;
@override @useResult
$Res call({
 Interest interest, NewMatch? match
});


@override $InterestCopyWith<$Res> get interest;@override $NewMatchCopyWith<$Res>? get match;

}
/// @nodoc
class __$InterestResultCopyWithImpl<$Res>
    implements _$InterestResultCopyWith<$Res> {
  __$InterestResultCopyWithImpl(this._self, this._then);

  final _InterestResult _self;
  final $Res Function(_InterestResult) _then;

/// Create a copy of InterestResult
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? interest = null,Object? match = freezed,}) {
  return _then(_InterestResult(
interest: null == interest ? _self.interest : interest // ignore: cast_nullable_to_non_nullable
as Interest,match: freezed == match ? _self.match : match // ignore: cast_nullable_to_non_nullable
as NewMatch?,
  ));
}

/// Create a copy of InterestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$InterestCopyWith<$Res> get interest {
  
  return $InterestCopyWith<$Res>(_self.interest, (value) {
    return _then(_self.copyWith(interest: value));
  });
}/// Create a copy of InterestResult
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$NewMatchCopyWith<$Res>? get match {
    if (_self.match == null) {
    return null;
  }

  return $NewMatchCopyWith<$Res>(_self.match!, (value) {
    return _then(_self.copyWith(match: value));
  });
}
}

// dart format on
