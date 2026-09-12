// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'account.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingStatus {

 bool get complete;@JsonKey(name: 'profile_id') int? get profileId;
/// Create a copy of OnboardingStatus
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingStatusCopyWith<OnboardingStatus> get copyWith => _$OnboardingStatusCopyWithImpl<OnboardingStatus>(this as OnboardingStatus, _$identity);

  /// Serializes this OnboardingStatus to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnboardingStatus;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingStatus&&(identical(other.complete, _this.complete) || other.complete == _this.complete)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnboardingStatus;
  return Object.hash(runtimeType,_this.complete,_this.profileId);
}

@override
String toString() {
  final _this = this as OnboardingStatus;
  return 'OnboardingStatus(complete: ${_this.complete}, profileId: ${_this.profileId})';
}


}

/// @nodoc
abstract mixin class $OnboardingStatusCopyWith<$Res>  {
  factory $OnboardingStatusCopyWith(OnboardingStatus value, $Res Function(OnboardingStatus) _then) = _$OnboardingStatusCopyWithImpl;
@useResult
$Res call({
 bool complete,@JsonKey(name: 'profile_id') int? profileId
});




}
/// @nodoc
class _$OnboardingStatusCopyWithImpl<$Res>
    implements $OnboardingStatusCopyWith<$Res> {
  _$OnboardingStatusCopyWithImpl(this._self, this._then);

  final OnboardingStatus _self;
  final $Res Function(OnboardingStatus) _then;

/// Create a copy of OnboardingStatus
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? complete = null,Object? profileId = freezed,}) {
  return _then(OnboardingStatus(
complete: null == complete ? _self.complete : complete // ignore: cast_nullable_to_non_nullable
as bool,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingStatus].
extension OnboardingStatusPatterns on OnboardingStatus {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingStatus value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingStatus() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingStatus value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatus():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingStatus value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingStatus() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( bool complete, @JsonKey(name: 'profile_id')  int? profileId)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingStatus() when $default != null:
return $default(_that.complete,_that.profileId);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( bool complete, @JsonKey(name: 'profile_id')  int? profileId)  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatus():
return $default(_that.complete,_that.profileId);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( bool complete, @JsonKey(name: 'profile_id')  int? profileId)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingStatus() when $default != null:
return $default(_that.complete,_that.profileId);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingStatus implements OnboardingStatus {
  const _OnboardingStatus({required this.complete, @JsonKey(name: 'profile_id') this.profileId});
  factory _OnboardingStatus.fromJson(Map<String, dynamic> json) => _$OnboardingStatusFromJson(json);

@override final  bool complete;
@override@JsonKey(name: 'profile_id') final  int? profileId;

/// Create a copy of OnboardingStatus
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingStatusCopyWith<_OnboardingStatus> get copyWith => __$OnboardingStatusCopyWithImpl<_OnboardingStatus>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingStatusToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingStatus&&(identical(other.complete, complete) || other.complete == complete)&&(identical(other.profileId, profileId) || other.profileId == profileId));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,complete,profileId);
}

@override
String toString() {
    return 'OnboardingStatus(complete: $complete, profileId: $profileId)';
}


}

/// @nodoc
abstract mixin class _$OnboardingStatusCopyWith<$Res> implements $OnboardingStatusCopyWith<$Res> {
  factory _$OnboardingStatusCopyWith(_OnboardingStatus value, $Res Function(_OnboardingStatus) _then) = __$OnboardingStatusCopyWithImpl;
@override @useResult
$Res call({
 bool complete,@JsonKey(name: 'profile_id') int? profileId
});




}
/// @nodoc
class __$OnboardingStatusCopyWithImpl<$Res>
    implements _$OnboardingStatusCopyWith<$Res> {
  __$OnboardingStatusCopyWithImpl(this._self, this._then);

  final _OnboardingStatus _self;
  final $Res Function(_OnboardingStatus) _then;

/// Create a copy of OnboardingStatus
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? complete = null,Object? profileId = freezed,}) {
  return _then(_OnboardingStatus(
complete: null == complete ? _self.complete : complete // ignore: cast_nullable_to_non_nullable
as bool,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$Account {

 int get id; String? get email; String? get phone;@JsonKey(name: 'phone_verified_at') String? get phoneVerifiedAt;@JsonKey(name: 'account_type', fromJson: AccountType.fromJson, toJson: _accountTypeToJson) AccountType get accountType; OnboardingStatus? get onboarding;
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$AccountCopyWith<Account> get copyWith => _$AccountCopyWithImpl<Account>(this as Account, _$identity);

  /// Serializes this Account to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Account;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Account&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.email, _this.email) || other.email == _this.email)&&(identical(other.phone, _this.phone) || other.phone == _this.phone)&&(identical(other.phoneVerifiedAt, _this.phoneVerifiedAt) || other.phoneVerifiedAt == _this.phoneVerifiedAt)&&(identical(other.accountType, _this.accountType) || other.accountType == _this.accountType)&&(identical(other.onboarding, _this.onboarding) || other.onboarding == _this.onboarding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Account;
  return Object.hash(runtimeType,_this.id,_this.email,_this.phone,_this.phoneVerifiedAt,_this.accountType,_this.onboarding);
}

@override
String toString() {
  final _this = this as Account;
  return 'Account(id: ${_this.id}, email: ${_this.email}, phone: ${_this.phone}, phoneVerifiedAt: ${_this.phoneVerifiedAt}, accountType: ${_this.accountType}, onboarding: ${_this.onboarding})';
}


}

/// @nodoc
abstract mixin class $AccountCopyWith<$Res>  {
  factory $AccountCopyWith(Account value, $Res Function(Account) _then) = _$AccountCopyWithImpl;
@useResult
$Res call({
 int id, String? email, String? phone,@JsonKey(name: 'phone_verified_at') String? phoneVerifiedAt,@JsonKey(name: 'account_type', fromJson: AccountType.fromJson, toJson: _accountTypeToJson) AccountType accountType, OnboardingStatus? onboarding
});


$OnboardingStatusCopyWith<$Res>? get onboarding;

}
/// @nodoc
class _$AccountCopyWithImpl<$Res>
    implements $AccountCopyWith<$Res> {
  _$AccountCopyWithImpl(this._self, this._then);

  final Account _self;
  final $Res Function(Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? email = freezed,Object? phone = freezed,Object? phoneVerifiedAt = freezed,Object? accountType = null,Object? onboarding = freezed,}) {
  return _then(Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,phoneVerifiedAt: freezed == phoneVerifiedAt ? _self.phoneVerifiedAt : phoneVerifiedAt // ignore: cast_nullable_to_non_nullable
as String?,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as AccountType,onboarding: freezed == onboarding ? _self.onboarding : onboarding // ignore: cast_nullable_to_non_nullable
as OnboardingStatus?,
  ));
}
/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStatusCopyWith<$Res>? get onboarding {
    if (_self.onboarding == null) {
    return null;
  }

  return $OnboardingStatusCopyWith<$Res>(_self.onboarding!, (value) {
    return _then(_self.copyWith(onboarding: value));
  });
}
}


/// Adds pattern-matching-related methods to [Account].
extension AccountPatterns on Account {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Account value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Account() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Account value)  $default,){
final _that = this;
switch (_that) {
case _Account():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Account value)?  $default,){
final _that = this;
switch (_that) {
case _Account() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String? email,  String? phone, @JsonKey(name: 'phone_verified_at')  String? phoneVerifiedAt, @JsonKey(name: 'account_type', fromJson: AccountType.fromJson, toJson: _accountTypeToJson)  AccountType accountType,  OnboardingStatus? onboarding)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.email,_that.phone,_that.phoneVerifiedAt,_that.accountType,_that.onboarding);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String? email,  String? phone, @JsonKey(name: 'phone_verified_at')  String? phoneVerifiedAt, @JsonKey(name: 'account_type', fromJson: AccountType.fromJson, toJson: _accountTypeToJson)  AccountType accountType,  OnboardingStatus? onboarding)  $default,) {final _that = this;
switch (_that) {
case _Account():
return $default(_that.id,_that.email,_that.phone,_that.phoneVerifiedAt,_that.accountType,_that.onboarding);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String? email,  String? phone, @JsonKey(name: 'phone_verified_at')  String? phoneVerifiedAt, @JsonKey(name: 'account_type', fromJson: AccountType.fromJson, toJson: _accountTypeToJson)  AccountType accountType,  OnboardingStatus? onboarding)?  $default,) {final _that = this;
switch (_that) {
case _Account() when $default != null:
return $default(_that.id,_that.email,_that.phone,_that.phoneVerifiedAt,_that.accountType,_that.onboarding);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Account implements Account {
  const _Account({required this.id, this.email, this.phone, @JsonKey(name: 'phone_verified_at') this.phoneVerifiedAt, @JsonKey(name: 'account_type', fromJson: AccountType.fromJson, toJson: _accountTypeToJson) required this.accountType, this.onboarding});
  factory _Account.fromJson(Map<String, dynamic> json) => _$AccountFromJson(json);

@override final  int id;
@override final  String? email;
@override final  String? phone;
@override@JsonKey(name: 'phone_verified_at') final  String? phoneVerifiedAt;
@override@JsonKey(name: 'account_type', fromJson: AccountType.fromJson, toJson: _accountTypeToJson) final  AccountType accountType;
@override final  OnboardingStatus? onboarding;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$AccountCopyWith<_Account> get copyWith => __$AccountCopyWithImpl<_Account>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$AccountToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Account&&(identical(other.id, id) || other.id == id)&&(identical(other.email, email) || other.email == email)&&(identical(other.phone, phone) || other.phone == phone)&&(identical(other.phoneVerifiedAt, phoneVerifiedAt) || other.phoneVerifiedAt == phoneVerifiedAt)&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.onboarding, onboarding) || other.onboarding == onboarding));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,email,phone,phoneVerifiedAt,accountType,onboarding);
}

@override
String toString() {
    return 'Account(id: $id, email: $email, phone: $phone, phoneVerifiedAt: $phoneVerifiedAt, accountType: $accountType, onboarding: $onboarding)';
}


}

/// @nodoc
abstract mixin class _$AccountCopyWith<$Res> implements $AccountCopyWith<$Res> {
  factory _$AccountCopyWith(_Account value, $Res Function(_Account) _then) = __$AccountCopyWithImpl;
@override @useResult
$Res call({
 int id, String? email, String? phone,@JsonKey(name: 'phone_verified_at') String? phoneVerifiedAt,@JsonKey(name: 'account_type', fromJson: AccountType.fromJson, toJson: _accountTypeToJson) AccountType accountType, OnboardingStatus? onboarding
});


@override $OnboardingStatusCopyWith<$Res>? get onboarding;

}
/// @nodoc
class __$AccountCopyWithImpl<$Res>
    implements _$AccountCopyWith<$Res> {
  __$AccountCopyWithImpl(this._self, this._then);

  final _Account _self;
  final $Res Function(_Account) _then;

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? email = freezed,Object? phone = freezed,Object? phoneVerifiedAt = freezed,Object? accountType = null,Object? onboarding = freezed,}) {
  return _then(_Account(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,email: freezed == email ? _self.email : email // ignore: cast_nullable_to_non_nullable
as String?,phone: freezed == phone ? _self.phone : phone // ignore: cast_nullable_to_non_nullable
as String?,phoneVerifiedAt: freezed == phoneVerifiedAt ? _self.phoneVerifiedAt : phoneVerifiedAt // ignore: cast_nullable_to_non_nullable
as String?,accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as AccountType,onboarding: freezed == onboarding ? _self.onboarding : onboarding // ignore: cast_nullable_to_non_nullable
as OnboardingStatus?,
  ));
}

/// Create a copy of Account
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$OnboardingStatusCopyWith<$Res>? get onboarding {
    if (_self.onboarding == null) {
    return null;
  }

  return $OnboardingStatusCopyWith<$Res>(_self.onboarding!, (value) {
    return _then(_self.copyWith(onboarding: value));
  });
}
}

// dart format on
