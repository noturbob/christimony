// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'verification.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Verification {

 int get id;@JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson) VerificationType get verificationType;@JsonKey(fromJson: VerificationStatus.fromJson) VerificationStatus get status;@JsonKey(name: 'verified_at') String? get verifiedAt;
/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VerificationCopyWith<Verification> get copyWith => _$VerificationCopyWithImpl<Verification>(this as Verification, _$identity);

  /// Serializes this Verification to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Verification;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Verification&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.verificationType, _this.verificationType) || other.verificationType == _this.verificationType)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.verifiedAt, _this.verifiedAt) || other.verifiedAt == _this.verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Verification;
  return Object.hash(runtimeType,_this.id,_this.verificationType,_this.status,_this.verifiedAt);
}

@override
String toString() {
  final _this = this as Verification;
  return 'Verification(id: ${_this.id}, verificationType: ${_this.verificationType}, status: ${_this.status}, verifiedAt: ${_this.verifiedAt})';
}


}

/// @nodoc
abstract mixin class $VerificationCopyWith<$Res>  {
  factory $VerificationCopyWith(Verification value, $Res Function(Verification) _then) = _$VerificationCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson) VerificationType verificationType,@JsonKey(fromJson: VerificationStatus.fromJson) VerificationStatus status,@JsonKey(name: 'verified_at') String? verifiedAt
});




}
/// @nodoc
class _$VerificationCopyWithImpl<$Res>
    implements $VerificationCopyWith<$Res> {
  _$VerificationCopyWithImpl(this._self, this._then);

  final Verification _self;
  final $Res Function(Verification) _then;

/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? verificationType = null,Object? status = null,Object? verifiedAt = freezed,}) {
  return _then(Verification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,verificationType: null == verificationType ? _self.verificationType : verificationType // ignore: cast_nullable_to_non_nullable
as VerificationType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Verification].
extension VerificationPatterns on Verification {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Verification value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Verification() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Verification value)  $default,){
final _that = this;
switch (_that) {
case _Verification():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Verification value)?  $default,){
final _that = this;
switch (_that) {
case _Verification() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson)  VerificationType verificationType, @JsonKey(fromJson: VerificationStatus.fromJson)  VerificationStatus status, @JsonKey(name: 'verified_at')  String? verifiedAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Verification() when $default != null:
return $default(_that.id,_that.verificationType,_that.status,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson)  VerificationType verificationType, @JsonKey(fromJson: VerificationStatus.fromJson)  VerificationStatus status, @JsonKey(name: 'verified_at')  String? verifiedAt)  $default,) {final _that = this;
switch (_that) {
case _Verification():
return $default(_that.id,_that.verificationType,_that.status,_that.verifiedAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson)  VerificationType verificationType, @JsonKey(fromJson: VerificationStatus.fromJson)  VerificationStatus status, @JsonKey(name: 'verified_at')  String? verifiedAt)?  $default,) {final _that = this;
switch (_that) {
case _Verification() when $default != null:
return $default(_that.id,_that.verificationType,_that.status,_that.verifiedAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Verification implements Verification {
  const _Verification({required this.id, @JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson) required this.verificationType, @JsonKey(fromJson: VerificationStatus.fromJson) required this.status, @JsonKey(name: 'verified_at') this.verifiedAt});
  factory _Verification.fromJson(Map<String, dynamic> json) => _$VerificationFromJson(json);

@override final  int id;
@override@JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson) final  VerificationType verificationType;
@override@JsonKey(fromJson: VerificationStatus.fromJson) final  VerificationStatus status;
@override@JsonKey(name: 'verified_at') final  String? verifiedAt;

/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VerificationCopyWith<_Verification> get copyWith => __$VerificationCopyWithImpl<_Verification>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VerificationToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Verification&&(identical(other.id, id) || other.id == id)&&(identical(other.verificationType, verificationType) || other.verificationType == verificationType)&&(identical(other.status, status) || other.status == status)&&(identical(other.verifiedAt, verifiedAt) || other.verifiedAt == verifiedAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,verificationType,status,verifiedAt);
}

@override
String toString() {
    return 'Verification(id: $id, verificationType: $verificationType, status: $status, verifiedAt: $verifiedAt)';
}


}

/// @nodoc
abstract mixin class _$VerificationCopyWith<$Res> implements $VerificationCopyWith<$Res> {
  factory _$VerificationCopyWith(_Verification value, $Res Function(_Verification) _then) = __$VerificationCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'verification_type', fromJson: VerificationType.fromJson) VerificationType verificationType,@JsonKey(fromJson: VerificationStatus.fromJson) VerificationStatus status,@JsonKey(name: 'verified_at') String? verifiedAt
});




}
/// @nodoc
class __$VerificationCopyWithImpl<$Res>
    implements _$VerificationCopyWith<$Res> {
  __$VerificationCopyWithImpl(this._self, this._then);

  final _Verification _self;
  final $Res Function(_Verification) _then;

/// Create a copy of Verification
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? verificationType = null,Object? status = null,Object? verifiedAt = freezed,}) {
  return _then(_Verification(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,verificationType: null == verificationType ? _self.verificationType : verificationType // ignore: cast_nullable_to_non_nullable
as VerificationType,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VerificationStatus,verifiedAt: freezed == verifiedAt ? _self.verifiedAt : verifiedAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
