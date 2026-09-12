// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'interest.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Interest {

 int get id;@JsonKey(name: 'sender_profile_id') int get senderProfileId;@JsonKey(name: 'receiver_profile_id') int get receiverProfileId;@JsonKey(fromJson: InterestStatus.fromJson) InterestStatus get status;
/// Create a copy of Interest
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$InterestCopyWith<Interest> get copyWith => _$InterestCopyWithImpl<Interest>(this as Interest, _$identity);

  /// Serializes this Interest to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Interest;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Interest&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.senderProfileId, _this.senderProfileId) || other.senderProfileId == _this.senderProfileId)&&(identical(other.receiverProfileId, _this.receiverProfileId) || other.receiverProfileId == _this.receiverProfileId)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Interest;
  return Object.hash(runtimeType,_this.id,_this.senderProfileId,_this.receiverProfileId,_this.status);
}

@override
String toString() {
  final _this = this as Interest;
  return 'Interest(id: ${_this.id}, senderProfileId: ${_this.senderProfileId}, receiverProfileId: ${_this.receiverProfileId}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $InterestCopyWith<$Res>  {
  factory $InterestCopyWith(Interest value, $Res Function(Interest) _then) = _$InterestCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'sender_profile_id') int senderProfileId,@JsonKey(name: 'receiver_profile_id') int receiverProfileId,@JsonKey(fromJson: InterestStatus.fromJson) InterestStatus status
});




}
/// @nodoc
class _$InterestCopyWithImpl<$Res>
    implements $InterestCopyWith<$Res> {
  _$InterestCopyWithImpl(this._self, this._then);

  final Interest _self;
  final $Res Function(Interest) _then;

/// Create a copy of Interest
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? senderProfileId = null,Object? receiverProfileId = null,Object? status = null,}) {
  return _then(Interest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,senderProfileId: null == senderProfileId ? _self.senderProfileId : senderProfileId // ignore: cast_nullable_to_non_nullable
as int,receiverProfileId: null == receiverProfileId ? _self.receiverProfileId : receiverProfileId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InterestStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Interest].
extension InterestPatterns on Interest {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Interest value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Interest() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Interest value)  $default,){
final _that = this;
switch (_that) {
case _Interest():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Interest value)?  $default,){
final _that = this;
switch (_that) {
case _Interest() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'sender_profile_id')  int senderProfileId, @JsonKey(name: 'receiver_profile_id')  int receiverProfileId, @JsonKey(fromJson: InterestStatus.fromJson)  InterestStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Interest() when $default != null:
return $default(_that.id,_that.senderProfileId,_that.receiverProfileId,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'sender_profile_id')  int senderProfileId, @JsonKey(name: 'receiver_profile_id')  int receiverProfileId, @JsonKey(fromJson: InterestStatus.fromJson)  InterestStatus status)  $default,) {final _that = this;
switch (_that) {
case _Interest():
return $default(_that.id,_that.senderProfileId,_that.receiverProfileId,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'sender_profile_id')  int senderProfileId, @JsonKey(name: 'receiver_profile_id')  int receiverProfileId, @JsonKey(fromJson: InterestStatus.fromJson)  InterestStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Interest() when $default != null:
return $default(_that.id,_that.senderProfileId,_that.receiverProfileId,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Interest implements Interest {
  const _Interest({required this.id, @JsonKey(name: 'sender_profile_id') required this.senderProfileId, @JsonKey(name: 'receiver_profile_id') required this.receiverProfileId, @JsonKey(fromJson: InterestStatus.fromJson) required this.status});
  factory _Interest.fromJson(Map<String, dynamic> json) => _$InterestFromJson(json);

@override final  int id;
@override@JsonKey(name: 'sender_profile_id') final  int senderProfileId;
@override@JsonKey(name: 'receiver_profile_id') final  int receiverProfileId;
@override@JsonKey(fromJson: InterestStatus.fromJson) final  InterestStatus status;

/// Create a copy of Interest
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$InterestCopyWith<_Interest> get copyWith => __$InterestCopyWithImpl<_Interest>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$InterestToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Interest&&(identical(other.id, id) || other.id == id)&&(identical(other.senderProfileId, senderProfileId) || other.senderProfileId == senderProfileId)&&(identical(other.receiverProfileId, receiverProfileId) || other.receiverProfileId == receiverProfileId)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,senderProfileId,receiverProfileId,status);
}

@override
String toString() {
    return 'Interest(id: $id, senderProfileId: $senderProfileId, receiverProfileId: $receiverProfileId, status: $status)';
}


}

/// @nodoc
abstract mixin class _$InterestCopyWith<$Res> implements $InterestCopyWith<$Res> {
  factory _$InterestCopyWith(_Interest value, $Res Function(_Interest) _then) = __$InterestCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'sender_profile_id') int senderProfileId,@JsonKey(name: 'receiver_profile_id') int receiverProfileId,@JsonKey(fromJson: InterestStatus.fromJson) InterestStatus status
});




}
/// @nodoc
class __$InterestCopyWithImpl<$Res>
    implements _$InterestCopyWith<$Res> {
  __$InterestCopyWithImpl(this._self, this._then);

  final _Interest _self;
  final $Res Function(_Interest) _then;

/// Create a copy of Interest
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? senderProfileId = null,Object? receiverProfileId = null,Object? status = null,}) {
  return _then(_Interest(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,senderProfileId: null == senderProfileId ? _self.senderProfileId : senderProfileId // ignore: cast_nullable_to_non_nullable
as int,receiverProfileId: null == receiverProfileId ? _self.receiverProfileId : receiverProfileId // ignore: cast_nullable_to_non_nullable
as int,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as InterestStatus,
  ));
}


}

// dart format on
