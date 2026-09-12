// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'profile.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Profile {

 int get id; String get name;@JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) ProfileType get profileType; String? get dob; int? get age;@JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson) Gender? get gender; String? get city; String? get education; String? get profession; String? get bio;@JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson) ProfileStatus get status;@JsonKey(name: 'denomination_id') int? get denominationId; String? get denomination; List<PhotoRef> get photos; List<Prompt> get prompts;
/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileCopyWith<Profile> get copyWith => _$ProfileCopyWithImpl<Profile>(this as Profile, _$identity);

  /// Serializes this Profile to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Profile;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Profile&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.profileType, _this.profileType) || other.profileType == _this.profileType)&&(identical(other.dob, _this.dob) || other.dob == _this.dob)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.education, _this.education) || other.education == _this.education)&&(identical(other.profession, _this.profession) || other.profession == _this.profession)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.status, _this.status) || other.status == _this.status)&&(identical(other.denominationId, _this.denominationId) || other.denominationId == _this.denominationId)&&(identical(other.denomination, _this.denomination) || other.denomination == _this.denomination)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&const DeepCollectionEquality().equals(other.prompts, _this.prompts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Profile;
  return Object.hash(runtimeType,_this.id,_this.name,_this.profileType,_this.dob,_this.age,_this.gender,_this.city,_this.education,_this.profession,_this.bio,_this.status,_this.denominationId,_this.denomination,const DeepCollectionEquality().hash(_this.photos),const DeepCollectionEquality().hash(_this.prompts));
}

@override
String toString() {
  final _this = this as Profile;
  return 'Profile(id: ${_this.id}, name: ${_this.name}, profileType: ${_this.profileType}, dob: ${_this.dob}, age: ${_this.age}, gender: ${_this.gender}, city: ${_this.city}, education: ${_this.education}, profession: ${_this.profession}, bio: ${_this.bio}, status: ${_this.status}, denominationId: ${_this.denominationId}, denomination: ${_this.denomination}, photos: ${_this.photos}, prompts: ${_this.prompts})';
}


}

/// @nodoc
abstract mixin class $ProfileCopyWith<$Res>  {
  factory $ProfileCopyWith(Profile value, $Res Function(Profile) _then) = _$ProfileCopyWithImpl;
@useResult
$Res call({
 int id, String name,@JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) ProfileType profileType, String? dob, int? age,@JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson) Gender? gender, String? city, String? education, String? profession, String? bio,@JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson) ProfileStatus status,@JsonKey(name: 'denomination_id') int? denominationId, String? denomination, List<PhotoRef> photos, List<Prompt> prompts
});




}
/// @nodoc
class _$ProfileCopyWithImpl<$Res>
    implements $ProfileCopyWith<$Res> {
  _$ProfileCopyWithImpl(this._self, this._then);

  final Profile _self;
  final $Res Function(Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? profileType = null,Object? dob = freezed,Object? age = freezed,Object? gender = freezed,Object? city = freezed,Object? education = freezed,Object? profession = freezed,Object? bio = freezed,Object? status = null,Object? denominationId = freezed,Object? denomination = freezed,Object? photos = null,Object? prompts = null,}) {
  return _then(Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileType: null == profileType ? _self.profileType : profileType // ignore: cast_nullable_to_non_nullable
as ProfileType,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileStatus,denominationId: freezed == denominationId ? _self.denominationId : denominationId // ignore: cast_nullable_to_non_nullable
as int?,denomination: freezed == denomination ? _self.denomination : denomination // ignore: cast_nullable_to_non_nullable
as String?,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoRef>,prompts: null == prompts ? _self.prompts : prompts // ignore: cast_nullable_to_non_nullable
as List<Prompt>,
  ));
}

}


/// Adds pattern-matching-related methods to [Profile].
extension ProfilePatterns on Profile {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Profile value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Profile value)  $default,){
final _that = this;
switch (_that) {
case _Profile():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Profile value)?  $default,){
final _that = this;
switch (_that) {
case _Profile() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson)  ProfileType profileType,  String? dob,  int? age, @JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson)  Gender? gender,  String? city,  String? education,  String? profession,  String? bio, @JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson)  ProfileStatus status, @JsonKey(name: 'denomination_id')  int? denominationId,  String? denomination,  List<PhotoRef> photos,  List<Prompt> prompts)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.name,_that.profileType,_that.dob,_that.age,_that.gender,_that.city,_that.education,_that.profession,_that.bio,_that.status,_that.denominationId,_that.denomination,_that.photos,_that.prompts);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name, @JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson)  ProfileType profileType,  String? dob,  int? age, @JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson)  Gender? gender,  String? city,  String? education,  String? profession,  String? bio, @JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson)  ProfileStatus status, @JsonKey(name: 'denomination_id')  int? denominationId,  String? denomination,  List<PhotoRef> photos,  List<Prompt> prompts)  $default,) {final _that = this;
switch (_that) {
case _Profile():
return $default(_that.id,_that.name,_that.profileType,_that.dob,_that.age,_that.gender,_that.city,_that.education,_that.profession,_that.bio,_that.status,_that.denominationId,_that.denomination,_that.photos,_that.prompts);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name, @JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson)  ProfileType profileType,  String? dob,  int? age, @JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson)  Gender? gender,  String? city,  String? education,  String? profession,  String? bio, @JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson)  ProfileStatus status, @JsonKey(name: 'denomination_id')  int? denominationId,  String? denomination,  List<PhotoRef> photos,  List<Prompt> prompts)?  $default,) {final _that = this;
switch (_that) {
case _Profile() when $default != null:
return $default(_that.id,_that.name,_that.profileType,_that.dob,_that.age,_that.gender,_that.city,_that.education,_that.profession,_that.bio,_that.status,_that.denominationId,_that.denomination,_that.photos,_that.prompts);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Profile implements Profile {
  const _Profile({required this.id, required this.name, @JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) required this.profileType, this.dob, this.age, @JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson) this.gender, this.city, this.education, this.profession, this.bio, @JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson) required this.status, @JsonKey(name: 'denomination_id') this.denominationId, this.denomination,  List<PhotoRef> photos = const [],  List<Prompt> prompts = const []}): _photos = photos,_prompts = prompts;
  factory _Profile.fromJson(Map<String, dynamic> json) => _$ProfileFromJson(json);

@override final  int id;
@override final  String name;
@override@JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) final  ProfileType profileType;
@override final  String? dob;
@override final  int? age;
@override@JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson) final  Gender? gender;
@override final  String? city;
@override final  String? education;
@override final  String? profession;
@override final  String? bio;
@override@JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson) final  ProfileStatus status;
@override@JsonKey(name: 'denomination_id') final  int? denominationId;
@override final  String? denomination;
 final  List<PhotoRef> _photos;
@override@JsonKey() List<PhotoRef> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

 final  List<Prompt> _prompts;
@override@JsonKey() List<Prompt> get prompts {
  if (_prompts is EqualUnmodifiableListView) return _prompts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_prompts);
}


/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileCopyWith<_Profile> get copyWith => __$ProfileCopyWithImpl<_Profile>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Profile&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.profileType, profileType) || other.profileType == profileType)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.age, age) || other.age == age)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.city, city) || other.city == city)&&(identical(other.education, education) || other.education == education)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.status, status) || other.status == status)&&(identical(other.denominationId, denominationId) || other.denominationId == denominationId)&&(identical(other.denomination, denomination) || other.denomination == denomination)&&const DeepCollectionEquality().equals(other.photos, _photos)&&const DeepCollectionEquality().equals(other.prompts, _prompts));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,profileType,dob,age,gender,city,education,profession,bio,status,denominationId,denomination,const DeepCollectionEquality().hash(_photos),const DeepCollectionEquality().hash(_prompts));
}

@override
String toString() {
    return 'Profile(id: $id, name: $name, profileType: $profileType, dob: $dob, age: $age, gender: $gender, city: $city, education: $education, profession: $profession, bio: $bio, status: $status, denominationId: $denominationId, denomination: $denomination, photos: $photos, prompts: $prompts)';
}


}

/// @nodoc
abstract mixin class _$ProfileCopyWith<$Res> implements $ProfileCopyWith<$Res> {
  factory _$ProfileCopyWith(_Profile value, $Res Function(_Profile) _then) = __$ProfileCopyWithImpl;
@override @useResult
$Res call({
 int id, String name,@JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) ProfileType profileType, String? dob, int? age,@JsonKey(fromJson: Gender.fromJson, toJson: _genderToJson) Gender? gender, String? city, String? education, String? profession, String? bio,@JsonKey(fromJson: ProfileStatus.fromJson, toJson: _profileStatusToJson) ProfileStatus status,@JsonKey(name: 'denomination_id') int? denominationId, String? denomination, List<PhotoRef> photos, List<Prompt> prompts
});




}
/// @nodoc
class __$ProfileCopyWithImpl<$Res>
    implements _$ProfileCopyWith<$Res> {
  __$ProfileCopyWithImpl(this._self, this._then);

  final _Profile _self;
  final $Res Function(_Profile) _then;

/// Create a copy of Profile
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? profileType = null,Object? dob = freezed,Object? age = freezed,Object? gender = freezed,Object? city = freezed,Object? education = freezed,Object? profession = freezed,Object? bio = freezed,Object? status = null,Object? denominationId = freezed,Object? denomination = freezed,Object? photos = null,Object? prompts = null,}) {
  return _then(_Profile(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,profileType: null == profileType ? _self.profileType : profileType // ignore: cast_nullable_to_non_nullable
as ProfileType,dob: freezed == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String?,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as Gender?,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,education: freezed == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String?,profession: freezed == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String?,bio: freezed == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String?,status: null == status ? _self.status : status // ignore: cast_nullable_to_non_nullable
as ProfileStatus,denominationId: freezed == denominationId ? _self.denominationId : denominationId // ignore: cast_nullable_to_non_nullable
as int?,denomination: freezed == denomination ? _self.denomination : denomination // ignore: cast_nullable_to_non_nullable
as String?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoRef>,prompts: null == prompts ? _self._prompts : prompts // ignore: cast_nullable_to_non_nullable
as List<Prompt>,
  ));
}


}


/// @nodoc
mixin _$ProfileSummary {

 int get id; String get name; String? get city;@JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) ProfileType get profileType; int? get age;@JsonKey(name: 'cover_photo_url') String? get coverPhotoUrl;
/// Create a copy of ProfileSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ProfileSummaryCopyWith<ProfileSummary> get copyWith => _$ProfileSummaryCopyWithImpl<ProfileSummary>(this as ProfileSummary, _$identity);

  /// Serializes this ProfileSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ProfileSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ProfileSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.profileType, _this.profileType) || other.profileType == _this.profileType)&&(identical(other.age, _this.age) || other.age == _this.age)&&(identical(other.coverPhotoUrl, _this.coverPhotoUrl) || other.coverPhotoUrl == _this.coverPhotoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ProfileSummary;
  return Object.hash(runtimeType,_this.id,_this.name,_this.city,_this.profileType,_this.age,_this.coverPhotoUrl);
}

@override
String toString() {
  final _this = this as ProfileSummary;
  return 'ProfileSummary(id: ${_this.id}, name: ${_this.name}, city: ${_this.city}, profileType: ${_this.profileType}, age: ${_this.age}, coverPhotoUrl: ${_this.coverPhotoUrl})';
}


}

/// @nodoc
abstract mixin class $ProfileSummaryCopyWith<$Res>  {
  factory $ProfileSummaryCopyWith(ProfileSummary value, $Res Function(ProfileSummary) _then) = _$ProfileSummaryCopyWithImpl;
@useResult
$Res call({
 int id, String name, String? city,@JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) ProfileType profileType, int? age,@JsonKey(name: 'cover_photo_url') String? coverPhotoUrl
});




}
/// @nodoc
class _$ProfileSummaryCopyWithImpl<$Res>
    implements $ProfileSummaryCopyWith<$Res> {
  _$ProfileSummaryCopyWithImpl(this._self, this._then);

  final ProfileSummary _self;
  final $Res Function(ProfileSummary) _then;

/// Create a copy of ProfileSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? name = null,Object? city = freezed,Object? profileType = null,Object? age = freezed,Object? coverPhotoUrl = freezed,}) {
  return _then(ProfileSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,profileType: null == profileType ? _self.profileType : profileType // ignore: cast_nullable_to_non_nullable
as ProfileType,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,coverPhotoUrl: freezed == coverPhotoUrl ? _self.coverPhotoUrl : coverPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [ProfileSummary].
extension ProfileSummaryPatterns on ProfileSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ProfileSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ProfileSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ProfileSummary value)  $default,){
final _that = this;
switch (_that) {
case _ProfileSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ProfileSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ProfileSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String name,  String? city, @JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson)  ProfileType profileType,  int? age, @JsonKey(name: 'cover_photo_url')  String? coverPhotoUrl)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ProfileSummary() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.profileType,_that.age,_that.coverPhotoUrl);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String name,  String? city, @JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson)  ProfileType profileType,  int? age, @JsonKey(name: 'cover_photo_url')  String? coverPhotoUrl)  $default,) {final _that = this;
switch (_that) {
case _ProfileSummary():
return $default(_that.id,_that.name,_that.city,_that.profileType,_that.age,_that.coverPhotoUrl);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String name,  String? city, @JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson)  ProfileType profileType,  int? age, @JsonKey(name: 'cover_photo_url')  String? coverPhotoUrl)?  $default,) {final _that = this;
switch (_that) {
case _ProfileSummary() when $default != null:
return $default(_that.id,_that.name,_that.city,_that.profileType,_that.age,_that.coverPhotoUrl);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ProfileSummary implements ProfileSummary {
  const _ProfileSummary({required this.id, required this.name, this.city, @JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) required this.profileType, this.age, @JsonKey(name: 'cover_photo_url') this.coverPhotoUrl});
  factory _ProfileSummary.fromJson(Map<String, dynamic> json) => _$ProfileSummaryFromJson(json);

@override final  int id;
@override final  String name;
@override final  String? city;
@override@JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) final  ProfileType profileType;
@override final  int? age;
@override@JsonKey(name: 'cover_photo_url') final  String? coverPhotoUrl;

/// Create a copy of ProfileSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ProfileSummaryCopyWith<_ProfileSummary> get copyWith => __$ProfileSummaryCopyWithImpl<_ProfileSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ProfileSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ProfileSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.city, city) || other.city == city)&&(identical(other.profileType, profileType) || other.profileType == profileType)&&(identical(other.age, age) || other.age == age)&&(identical(other.coverPhotoUrl, coverPhotoUrl) || other.coverPhotoUrl == coverPhotoUrl));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,name,city,profileType,age,coverPhotoUrl);
}

@override
String toString() {
    return 'ProfileSummary(id: $id, name: $name, city: $city, profileType: $profileType, age: $age, coverPhotoUrl: $coverPhotoUrl)';
}


}

/// @nodoc
abstract mixin class _$ProfileSummaryCopyWith<$Res> implements $ProfileSummaryCopyWith<$Res> {
  factory _$ProfileSummaryCopyWith(_ProfileSummary value, $Res Function(_ProfileSummary) _then) = __$ProfileSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id, String name, String? city,@JsonKey(name: 'profile_type', fromJson: ProfileType.fromJson, toJson: _profileTypeToJson) ProfileType profileType, int? age,@JsonKey(name: 'cover_photo_url') String? coverPhotoUrl
});




}
/// @nodoc
class __$ProfileSummaryCopyWithImpl<$Res>
    implements _$ProfileSummaryCopyWith<$Res> {
  __$ProfileSummaryCopyWithImpl(this._self, this._then);

  final _ProfileSummary _self;
  final $Res Function(_ProfileSummary) _then;

/// Create a copy of ProfileSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? name = null,Object? city = freezed,Object? profileType = null,Object? age = freezed,Object? coverPhotoUrl = freezed,}) {
  return _then(_ProfileSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,profileType: null == profileType ? _self.profileType : profileType // ignore: cast_nullable_to_non_nullable
as ProfileType,age: freezed == age ? _self.age : age // ignore: cast_nullable_to_non_nullable
as int?,coverPhotoUrl: freezed == coverPhotoUrl ? _self.coverPhotoUrl : coverPhotoUrl // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
