// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'introduction.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$WardSummary {

 int get id; String get name; String? get city;
/// Create a copy of WardSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$WardSummaryCopyWith<WardSummary> get copyWith => _$WardSummaryCopyWithImpl<WardSummary>(this as WardSummary, _$identity);

  /// Serializes this WardSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as WardSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is WardSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.city, _this.city) || other.city == _this.city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as WardSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.city);
}

@override
String toString() {
  final _this = this as WardSummary;
  return 'WardSummary(id: ${_this.id}, name: ${_this.name}, city: ${_this.city})';
}


}

/// @nodoc
abstract mixin class $WardSummaryCopyWith<$Res>  {
  factory $WardSummaryCopyWith(WardSummary value, $Res Function(WardSummary) _then) = _$WardSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? city
});




}
/// @nodoc
class _$WardSummaryCopyWithImpl<$Res>
    implements $WardSummaryCopyWith<$Res> {
  _$WardSummaryCopyWithImpl(this._self, this._then);

  final WardSummary _self;
  final $Res Function(WardSummary) _then;

/// Create a copy of WardSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? city = freezed,}) {
  return _then(WardSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [WardSummary].
extension WardSummaryPatterns on WardSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _WardSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _WardSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _WardSummary value)  $default,){
final _that = this;
switch (_that) {
case _WardSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _WardSummary value)?  $default,){
final _that = this;
switch (_that) {
case _WardSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? city)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _WardSummary() when $default != null:
return $default(_that.id,_that.name,_that.city);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? city)  $default,) {final _that = this;
switch (_that) {
case _WardSummary():
return $default(_that.id,_that.name,_that.city);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? city)?  $default,) {final _that = this;
switch (_that) {
case _WardSummary() when $default != null:
return $default(_that.id,_that.name,_that.city);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _WardSummary implements WardSummary {
  const _WardSummary({required this.id, required this.name, this.city});
  factory _WardSummary.fromJson(Map<String, dynamic> json) => _$WardSummaryFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? city;

/// Create a copy of WardSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$WardSummaryCopyWith<_WardSummary> get copyWith => __$WardSummaryCopyWithImpl<_WardSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$WardSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _WardSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,city);
}

@override
String toString() {
    return 'WardSummary(id: $id, name: $name, city: $city)';
}


}

/// @nodoc
abstract mixin class _$WardSummaryCopyWith<$Res> implements $WardSummaryCopyWith<$Res> {
  factory _$WardSummaryCopyWith(_WardSummary value, $Res Function(_WardSummary) _then) = __$WardSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? city
});




}
/// @nodoc
class __$WardSummaryCopyWithImpl<$Res>
    implements _$WardSummaryCopyWith<$Res> {
  __$WardSummaryCopyWithImpl(this._self, this._then);

  final _WardSummary _self;
  final $Res Function(_WardSummary) _then;

/// Create a copy of WardSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? city = freezed,}) {
  return _then(_WardSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}


/// @nodoc
mixin _$Introduction {

 int get id;@JsonKey(name: 'parent_match_id') int get parentMatchId;@JsonKey(fromJson: IntroductionStatus.fromJson) IntroductionStatus get status;@JsonKey(name: 'ward_a') WardSummary get wardA;@JsonKey(name: 'ward_b') WardSummary get wardB;
/// Create a copy of Introduction
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$IntroductionCopyWith<Introduction> get copyWith => _$IntroductionCopyWithImpl<Introduction>(this as Introduction, _$identity);

  /// Serializes this Introduction to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Introduction;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Introduction&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.parentMatchId, _this.parentMatchId) || other.parentMatchId == _this.parentMatchId)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.wardA, _this.wardA) || other.wardA == _this.wardA)&&(identical(other.wardB, _this.wardB) || other.wardB == _this.wardB));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Introduction;
  return Object.hash(runtimeType,_this.id,_this.parentMatchId,_this.status,_this.wardA,_this.wardB);
}

@override
String toString() {
  final _this = this as Introduction;
  return 'Introduction(id: ${_this.id}, parentMatchId: ${_this.parentMatchId}, status: ${_this.status}, wardA: ${_this.wardA}, wardB: ${_this.wardB})';
}


}

/// @nodoc
abstract mixin class $IntroductionCopyWith<$Res>  {
  factory $IntroductionCopyWith(Introduction value, $Res Function(Introduction) _then) = _$IntroductionCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'parent_match_id') int parentMatchId,@JsonKey(fromJson: IntroductionStatus.fromJson) IntroductionStatus status,@JsonKey(name: 'ward_a') WardSummary wardA,@JsonKey(name: 'ward_b') WardSummary wardB
});


$WardSummaryCopyWith<$Res> get wardA;$WardSummaryCopyWith<$Res> get wardB;

}
/// @nodoc
class _$IntroductionCopyWithImpl<$Res>
    implements $IntroductionCopyWith<$Res> {
  _$IntroductionCopyWithImpl(this._self, this._then);

  final Introduction _self;
  final $Res Function(Introduction) _then;

/// Create a copy of Introduction
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? parentMatchId = null,Object? status = null,Object? wardA = null,Object? wardB = null,}) {
  return _then(Introduction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,parentMatchId: null == parentMatchId ? _self.parentMatchId : parentMatchId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IntroductionStatus,wardA: null == wardA ? _self.wardA : wardA // ignore: cast_nullable_to_non_nullable
as WardSummary,wardB: null == wardB ? _self.wardB : wardB // ignore: cast_nullable_to_non_nullable
as WardSummary,
  ));
}
/// Create a copy of Introduction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WardSummaryCopyWith<$Res> get wardA {
  
  return $WardSummaryCopyWith<$Res>(_self.wardA, (value) {
    return _then(_self.copyWith(wardA: value));
  });
}/// Create a copy of Introduction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WardSummaryCopyWith<$Res> get wardB {
  
  return $WardSummaryCopyWith<$Res>(_self.wardB, (value) {
    return _then(_self.copyWith(wardB: value));
  });
}
}


/// Adds pattern-matching-related methods to [Introduction].
extension IntroductionPatterns on Introduction {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Introduction value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Introduction() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Introduction value)  $default,){
final _that = this;
switch (_that) {
case _Introduction():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Introduction value)?  $default,){
final _that = this;
switch (_that) {
case _Introduction() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'parent_match_id')  int parentMatchId, @JsonKey(fromJson: IntroductionStatus.fromJson)  IntroductionStatus status, @JsonKey(name: 'ward_a')  WardSummary wardA, @JsonKey(name: 'ward_b')  WardSummary wardB)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Introduction() when $default != null:
return $default(_that.id,_that.parentMatchId,_that.status,_that.wardA,_that.wardB);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'parent_match_id')  int parentMatchId, @JsonKey(fromJson: IntroductionStatus.fromJson)  IntroductionStatus status, @JsonKey(name: 'ward_a')  WardSummary wardA, @JsonKey(name: 'ward_b')  WardSummary wardB)  $default,) {final _that = this;
switch (_that) {
case _Introduction():
return $default(_that.id,_that.parentMatchId,_that.status,_that.wardA,_that.wardB);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'parent_match_id')  int parentMatchId, @JsonKey(fromJson: IntroductionStatus.fromJson)  IntroductionStatus status, @JsonKey(name: 'ward_a')  WardSummary wardA, @JsonKey(name: 'ward_b')  WardSummary wardB)?  $default,) {final _that = this;
switch (_that) {
case _Introduction() when $default != null:
return $default(_that.id,_that.parentMatchId,_that.status,_that.wardA,_that.wardB);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Introduction implements Introduction {
  const _Introduction({required this.id, @JsonKey(name: 'parent_match_id') required this.parentMatchId, @JsonKey(fromJson: IntroductionStatus.fromJson) required this.status, @JsonKey(name: 'ward_a') required this.wardA, @JsonKey(name: 'ward_b') required this.wardB});
  factory _Introduction.fromJson(Map<String, dynamic> json) => _$IntroductionFromJson(json);

@override final  int id;
@override@JsonKey(name: 'parent_match_id') final  int parentMatchId;
@override@JsonKey(fromJson: IntroductionStatus.fromJson) final  IntroductionStatus status;
@override@JsonKey(name: 'ward_a') final  WardSummary wardA;
@override@JsonKey(name: 'ward_b') final  WardSummary wardB;

/// Create a copy of Introduction
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$IntroductionCopyWith<_Introduction> get copyWith => __$IntroductionCopyWithImpl<_Introduction>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$IntroductionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Introduction&&(identical(other.id, id) || other.id == id)&&(identical(other.parentMatchId, parentMatchId) || other.parentMatchId == parentMatchId)&&(identical(other.status, status) || other.status == status)&&(identical(other.wardA, wardA) || other.wardA == wardA)&&(identical(other.wardB, wardB) || other.wardB == wardB));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,parentMatchId,status,wardA,wardB);
}

@override
String toString() {
    return 'Introduction(id: $id, parentMatchId: $parentMatchId, status: $status, wardA: $wardA, wardB: $wardB)';
}


}

/// @nodoc
abstract mixin class _$IntroductionCopyWith<$Res> implements $IntroductionCopyWith<$Res> {
  factory _$IntroductionCopyWith(_Introduction value, $Res Function(_Introduction) _then) = __$IntroductionCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'parent_match_id') int parentMatchId,@JsonKey(fromJson: IntroductionStatus.fromJson) IntroductionStatus status,@JsonKey(name: 'ward_a') WardSummary wardA,@JsonKey(name: 'ward_b') WardSummary wardB
});


@override $WardSummaryCopyWith<$Res> get wardA;@override $WardSummaryCopyWith<$Res> get wardB;

}
/// @nodoc
class __$IntroductionCopyWithImpl<$Res>
    implements _$IntroductionCopyWith<$Res> {
  __$IntroductionCopyWithImpl(this._self, this._then);

  final _Introduction _self;
  final $Res Function(_Introduction) _then;

/// Create a copy of Introduction
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? parentMatchId = null,Object? status = null,Object? wardA = null,Object? wardB = null,}) {
  return _then(_Introduction(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,parentMatchId: null == parentMatchId ? _self.parentMatchId : parentMatchId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as IntroductionStatus,wardA: null == wardA ? _self.wardA : wardA // ignore: cast_nullable_to_non_nullable
as WardSummary,wardB: null == wardB ? _self.wardB : wardB // ignore: cast_nullable_to_non_nullable
as WardSummary,
  ));
}

/// Create a copy of Introduction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WardSummaryCopyWith<$Res> get wardA {
  
  return $WardSummaryCopyWith<$Res>(_self.wardA, (value) {
    return _then(_self.copyWith(wardA: value));
  });
}/// Create a copy of Introduction
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$WardSummaryCopyWith<$Res> get wardB {
  
  return $WardSummaryCopyWith<$Res>(_self.wardB, (value) {
    return _then(_self.copyWith(wardB: value));
  });
}
}

// dart format on
