// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'vouch.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Vouch {

 int get id;@JsonKey(name: 'profile_id') int get profileId;@JsonKey(name: 'voucher_name') String get voucherName;@JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson) VoucherRole get voucherRole;@JsonKey(fromJson: _vouchStatusFromJson) VouchStatus get status;
/// Create a copy of Vouch
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$VouchCopyWith<Vouch> get copyWith => _$VouchCopyWithImpl<Vouch>(this as Vouch, _$identity);

  /// Serializes this Vouch to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Vouch;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Vouch&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.voucherName, _this.voucherName) || other.voucherName == _this.voucherName)&&(identical(other.voucherRole, _this.voucherRole) || other.voucherRole == _this.voucherRole)&&(identical(other.status, _this.status) || other.status == _this.status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Vouch;
  return Object.hash(runtimeType,_this.id,_this.profileId,_this.voucherName,_this.voucherRole,_this.status);
}

@override
String toString() {
  final _this = this as Vouch;
  return 'Vouch(id: ${_this.id}, profileId: ${_this.profileId}, voucherName: ${_this.voucherName}, voucherRole: ${_this.voucherRole}, status: ${_this.status})';
}


}

/// @nodoc
abstract mixin class $VouchCopyWith<$Res>  {
  factory $VouchCopyWith(Vouch value, $Res Function(Vouch) _then) = _$VouchCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'profile_id') int profileId,@JsonKey(name: 'voucher_name') String voucherName,@JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson) VoucherRole voucherRole,@JsonKey(fromJson: _vouchStatusFromJson) VouchStatus status
});




}
/// @nodoc
class _$VouchCopyWithImpl<$Res>
    implements $VouchCopyWith<$Res> {
  _$VouchCopyWithImpl(this._self, this._then);

  final Vouch _self;
  final $Res Function(Vouch) _then;

/// Create a copy of Vouch
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? voucherName = null,Object? voucherRole = null,Object? status = null,}) {
  return _then(Vouch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int,voucherName: null == voucherName ? _self.voucherName : voucherName // ignore: cast_nullable_to_non_nullable
as String,voucherRole: null == voucherRole ? _self.voucherRole : voucherRole // ignore: cast_nullable_to_non_nullable
as VoucherRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VouchStatus,
  ));
}

}


/// Adds pattern-matching-related methods to [Vouch].
extension VouchPatterns on Vouch {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Vouch value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Vouch() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Vouch value)  $default,){
final _that = this;
switch (_that) {
case _Vouch():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Vouch value)?  $default,){
final _that = this;
switch (_that) {
case _Vouch() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'profile_id')  int profileId, @JsonKey(name: 'voucher_name')  String voucherName, @JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson)  VoucherRole voucherRole, @JsonKey(fromJson: _vouchStatusFromJson)  VouchStatus status)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Vouch() when $default != null:
return $default(_that.id,_that.profileId,_that.voucherName,_that.voucherRole,_that.status);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'profile_id')  int profileId, @JsonKey(name: 'voucher_name')  String voucherName, @JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson)  VoucherRole voucherRole, @JsonKey(fromJson: _vouchStatusFromJson)  VouchStatus status)  $default,) {final _that = this;
switch (_that) {
case _Vouch():
return $default(_that.id,_that.profileId,_that.voucherName,_that.voucherRole,_that.status);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'profile_id')  int profileId, @JsonKey(name: 'voucher_name')  String voucherName, @JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson)  VoucherRole voucherRole, @JsonKey(fromJson: _vouchStatusFromJson)  VouchStatus status)?  $default,) {final _that = this;
switch (_that) {
case _Vouch() when $default != null:
return $default(_that.id,_that.profileId,_that.voucherName,_that.voucherRole,_that.status);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Vouch implements Vouch {
  const _Vouch({required this.id, @JsonKey(name: 'profile_id') required this.profileId, @JsonKey(name: 'voucher_name') required this.voucherName, @JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson) required this.voucherRole, @JsonKey(fromJson: _vouchStatusFromJson) required this.status});
  factory _Vouch.fromJson(Map<String, dynamic> json) => _$VouchFromJson(json);

@override final  int id;
@override@JsonKey(name: 'profile_id') final  int profileId;
@override@JsonKey(name: 'voucher_name') final  String voucherName;
@override@JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson) final  VoucherRole voucherRole;
@override@JsonKey(fromJson: _vouchStatusFromJson) final  VouchStatus status;

/// Create a copy of Vouch
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$VouchCopyWith<_Vouch> get copyWith => __$VouchCopyWithImpl<_Vouch>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$VouchToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Vouch&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.voucherName, voucherName) || other.voucherName == voucherName)&&(identical(other.voucherRole, voucherRole) || other.voucherRole == voucherRole)&&(identical(other.status, status) || other.status == status));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,profileId,voucherName,voucherRole,status);
}

@override
String toString() {
    return 'Vouch(id: $id, profileId: $profileId, voucherName: $voucherName, voucherRole: $voucherRole, status: $status)';
}


}

/// @nodoc
abstract mixin class _$VouchCopyWith<$Res> implements $VouchCopyWith<$Res> {
  factory _$VouchCopyWith(_Vouch value, $Res Function(_Vouch) _then) = __$VouchCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'profile_id') int profileId,@JsonKey(name: 'voucher_name') String voucherName,@JsonKey(name: 'voucher_role', fromJson: VoucherRole.fromJson) VoucherRole voucherRole,@JsonKey(fromJson: _vouchStatusFromJson) VouchStatus status
});




}
/// @nodoc
class __$VouchCopyWithImpl<$Res>
    implements _$VouchCopyWith<$Res> {
  __$VouchCopyWithImpl(this._self, this._then);

  final _Vouch _self;
  final $Res Function(_Vouch) _then;

/// Create a copy of Vouch
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? voucherName = null,Object? voucherRole = null,Object? status = null,}) {
  return _then(_Vouch(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int,voucherName: null == voucherName ? _self.voucherName : voucherName // ignore: cast_nullable_to_non_nullable
as String,voucherRole: null == voucherRole ? _self.voucherRole : voucherRole // ignore: cast_nullable_to_non_nullable
as VoucherRole,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as VouchStatus,
  ));
}


}

// dart format on
