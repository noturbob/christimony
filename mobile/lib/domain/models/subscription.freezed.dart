// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'subscription.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Subscription {

 int get id;@JsonKey(fromJson: SubscriptionPlan.fromJson) SubscriptionPlan get plan;@JsonKey(fromJson: SubscriptionStatus.fromJson) SubscriptionStatus get status;@JsonKey(name: 'started_at') String get startedAt;@JsonKey(name: 'expires_at') String? get expiresAt;
/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$SubscriptionCopyWith<Subscription> get copyWith => _$SubscriptionCopyWithImpl<Subscription>(this as Subscription, _$identity);

  /// Serializes this Subscription to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Subscription;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Subscription&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.plan, _this.plan) || other.plan == _this.plan)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.startedAt, _this.startedAt) || other.startedAt == _this.startedAt)&&(identical(other.expiresAt, _this.expiresAt) || other.expiresAt == _this.expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Subscription;
  return Object.hash(runtimeType,_this.id,_this.plan,_this.status,_this.startedAt,_this.expiresAt);
}

@override
String toString() {
  final _this = this as Subscription;
  return 'Subscription(id: ${_this.id}, plan: ${_this.plan}, status: ${_this.status}, startedAt: ${_this.startedAt}, expiresAt: ${_this.expiresAt})';
}


}

/// @nodoc
abstract mixin class $SubscriptionCopyWith<$Res>  {
  factory $SubscriptionCopyWith(Subscription value, $Res Function(Subscription) _then) = _$SubscriptionCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(fromJson: SubscriptionPlan.fromJson) SubscriptionPlan plan,@JsonKey(fromJson: SubscriptionStatus.fromJson) SubscriptionStatus status,@JsonKey(name: 'started_at') String startedAt,@JsonKey(name: 'expires_at') String? expiresAt
});




}
/// @nodoc
class _$SubscriptionCopyWithImpl<$Res>
    implements $SubscriptionCopyWith<$Res> {
  _$SubscriptionCopyWithImpl(this._self, this._then);

  final Subscription _self;
  final $Res Function(Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? plan = null,Object? status = null,Object? startedAt = null,Object? expiresAt = freezed,}) {
  return _then(Subscription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as SubscriptionPlan,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Subscription].
extension SubscriptionPatterns on Subscription {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Subscription value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Subscription value)  $default,){
final _that = this;
switch (_that) {
case _Subscription():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Subscription value)?  $default,){
final _that = this;
switch (_that) {
case _Subscription() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(fromJson: SubscriptionPlan.fromJson)  SubscriptionPlan plan, @JsonKey(fromJson: SubscriptionStatus.fromJson)  SubscriptionStatus status, @JsonKey(name: 'started_at')  String startedAt, @JsonKey(name: 'expires_at')  String? expiresAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.plan,_that.status,_that.startedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(fromJson: SubscriptionPlan.fromJson)  SubscriptionPlan plan, @JsonKey(fromJson: SubscriptionStatus.fromJson)  SubscriptionStatus status, @JsonKey(name: 'started_at')  String startedAt, @JsonKey(name: 'expires_at')  String? expiresAt)  $default,) {final _that = this;
switch (_that) {
case _Subscription():
return $default(_that.id,_that.plan,_that.status,_that.startedAt,_that.expiresAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(fromJson: SubscriptionPlan.fromJson)  SubscriptionPlan plan, @JsonKey(fromJson: SubscriptionStatus.fromJson)  SubscriptionStatus status, @JsonKey(name: 'started_at')  String startedAt, @JsonKey(name: 'expires_at')  String? expiresAt)?  $default,) {final _that = this;
switch (_that) {
case _Subscription() when $default != null:
return $default(_that.id,_that.plan,_that.status,_that.startedAt,_that.expiresAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Subscription implements Subscription {
  const _Subscription({required this.id, @JsonKey(fromJson: SubscriptionPlan.fromJson) required this.plan, @JsonKey(fromJson: SubscriptionStatus.fromJson) required this.status, @JsonKey(name: 'started_at') required this.startedAt, @JsonKey(name: 'expires_at') this.expiresAt});
  factory _Subscription.fromJson(Map<String, dynamic> json) => _$SubscriptionFromJson(json);

@override final  int id;
@override@JsonKey(fromJson: SubscriptionPlan.fromJson) final  SubscriptionPlan plan;
@override@JsonKey(fromJson: SubscriptionStatus.fromJson) final  SubscriptionStatus status;
@override@JsonKey(name: 'started_at') final  String startedAt;
@override@JsonKey(name: 'expires_at') final  String? expiresAt;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$SubscriptionCopyWith<_Subscription> get copyWith => __$SubscriptionCopyWithImpl<_Subscription>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$SubscriptionToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Subscription&&(identical(other.id, id) || other.id == id)&&(identical(other.plan, plan) || other.plan == plan)&&(identical(other.status, status) || other.status == status)&&(identical(other.startedAt, startedAt) || other.startedAt == startedAt)&&(identical(other.expiresAt, expiresAt) || other.expiresAt == expiresAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,plan,status,startedAt,expiresAt);
}

@override
String toString() {
    return 'Subscription(id: $id, plan: $plan, status: $status, startedAt: $startedAt, expiresAt: $expiresAt)';
}


}

/// @nodoc
abstract mixin class _$SubscriptionCopyWith<$Res> implements $SubscriptionCopyWith<$Res> {
  factory _$SubscriptionCopyWith(_Subscription value, $Res Function(_Subscription) _then) = __$SubscriptionCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(fromJson: SubscriptionPlan.fromJson) SubscriptionPlan plan,@JsonKey(fromJson: SubscriptionStatus.fromJson) SubscriptionStatus status,@JsonKey(name: 'started_at') String startedAt,@JsonKey(name: 'expires_at') String? expiresAt
});




}
/// @nodoc
class __$SubscriptionCopyWithImpl<$Res>
    implements _$SubscriptionCopyWith<$Res> {
  __$SubscriptionCopyWithImpl(this._self, this._then);

  final _Subscription _self;
  final $Res Function(_Subscription) _then;

/// Create a copy of Subscription
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? plan = null,Object? status = null,Object? startedAt = null,Object? expiresAt = freezed,}) {
  return _then(_Subscription(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,plan: null == plan ? _self.plan : plan // ignore: cast_nullable_to_non_nullable
as SubscriptionPlan,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as SubscriptionStatus,startedAt: null == startedAt ? _self.startedAt : startedAt // ignore: cast_nullable_to_non_nullable
as String,expiresAt: freezed == expiresAt ? _self.expiresAt : expiresAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
