// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'onboarding_draft.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$OnboardingDraft {

 String get accountType; String get name;/// Civil date, `YYYY-MM-DD`.
 String get dob; String get gender; int? get denominationId; String get denominationName; String get city; String get education; String get profession; String get bio; int? get profileId; List<PhotoRef> get photos;/// Selected prompt questions, in the order picked, to their answers.
 Map<String, String> get answers;/// Prompt ids already on the server, by question -- so leaving the
/// prompts step twice updates instead of duplicating.
 Map<String, int> get savedPrompts;/// The last step the user moved to.
 String get step;
/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$OnboardingDraftCopyWith<OnboardingDraft> get copyWith => _$OnboardingDraftCopyWithImpl<OnboardingDraft>(this as OnboardingDraft, _$identity);

  /// Serializes this OnboardingDraft to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as OnboardingDraft;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is OnboardingDraft&&(identical(other.accountType, _this.accountType) || other.accountType == _this.accountType)&&(identical(other.name, _this.name) || other.name == _this.name)&&(identical(other.dob, _this.dob) || other.dob == _this.dob)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.denominationId, _this.denominationId) || other.denominationId == _this.denominationId)&&(identical(other.denominationName, _this.denominationName) || other.denominationName == _this.denominationName)&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.education, _this.education) || other.education == _this.education)&&(identical(other.profession, _this.profession) || other.profession == _this.profession)&&(identical(other.bio, _this.bio) || other.bio == _this.bio)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&const DeepCollectionEquality().equals(other.photos, _this.photos)&&const DeepCollectionEquality().equals(other.answers, _this.answers)&&const DeepCollectionEquality().equals(other.savedPrompts, _this.savedPrompts)&&(identical(other.step, _this.step) || other.step == _this.step));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as OnboardingDraft;
  return Object.hash(runtimeType,_this.accountType,_this.name,_this.dob,_this.gender,_this.denominationId,_this.denominationName,_this.city,_this.education,_this.profession,_this.bio,_this.profileId,const DeepCollectionEquality().hash(_this.photos),const DeepCollectionEquality().hash(_this.answers),const DeepCollectionEquality().hash(_this.savedPrompts),_this.step);
}

@override
String toString() {
  final _this = this as OnboardingDraft;
  return 'OnboardingDraft(accountType: ${_this.accountType}, name: ${_this.name}, dob: ${_this.dob}, gender: ${_this.gender}, denominationId: ${_this.denominationId}, denominationName: ${_this.denominationName}, city: ${_this.city}, education: ${_this.education}, profession: ${_this.profession}, bio: ${_this.bio}, profileId: ${_this.profileId}, photos: ${_this.photos}, answers: ${_this.answers}, savedPrompts: ${_this.savedPrompts}, step: ${_this.step})';
}


}

/// @nodoc
abstract mixin class $OnboardingDraftCopyWith<$Res>  {
  factory $OnboardingDraftCopyWith(OnboardingDraft value, $Res Function(OnboardingDraft) _then) = _$OnboardingDraftCopyWithImpl;
@useResult
$Res call({
 String accountType, String name, String dob, String gender, int? denominationId, String denominationName, String city, String education, String profession, String bio, int? profileId, List<PhotoRef> photos, Map<String, String> answers, Map<String, int> savedPrompts, String step
});




}
/// @nodoc
class _$OnboardingDraftCopyWithImpl<$Res>
    implements $OnboardingDraftCopyWith<$Res> {
  _$OnboardingDraftCopyWithImpl(this._self, this._then);

  final OnboardingDraft _self;
  final $Res Function(OnboardingDraft) _then;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? accountType = null,Object? name = null,Object? dob = null,Object? gender = null,Object? denominationId = freezed,Object? denominationName = null,Object? city = null,Object? education = null,Object? profession = null,Object? bio = null,Object? profileId = freezed,Object? photos = null,Object? answers = null,Object? savedPrompts = null,Object? step = null,}) {
  return _then(OnboardingDraft(
accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,denominationId: freezed == denominationId ? _self.denominationId : denominationId // ignore: cast_nullable_to_non_nullable
as int?,denominationName: null == denominationName ? _self.denominationName : denominationName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String,profession: null == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int?,photos: null == photos ? _self.photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoRef>,answers: null == answers ? _self.answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,savedPrompts: null == savedPrompts ? _self.savedPrompts : savedPrompts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [OnboardingDraft].
extension OnboardingDraftPatterns on OnboardingDraft {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _OnboardingDraft value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _OnboardingDraft value)  $default,){
final _that = this;
switch (_that) {
case _OnboardingDraft():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _OnboardingDraft value)?  $default,){
final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String accountType,  String name,  String dob,  String gender,  int? denominationId,  String denominationName,  String city,  String education,  String profession,  String bio,  int? profileId,  List<PhotoRef> photos,  Map<String, String> answers,  Map<String, int> savedPrompts,  String step)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that.accountType,_that.name,_that.dob,_that.gender,_that.denominationId,_that.denominationName,_that.city,_that.education,_that.profession,_that.bio,_that.profileId,_that.photos,_that.answers,_that.savedPrompts,_that.step);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String accountType,  String name,  String dob,  String gender,  int? denominationId,  String denominationName,  String city,  String education,  String profession,  String bio,  int? profileId,  List<PhotoRef> photos,  Map<String, String> answers,  Map<String, int> savedPrompts,  String step)  $default,) {final _that = this;
switch (_that) {
case _OnboardingDraft():
return $default(_that.accountType,_that.name,_that.dob,_that.gender,_that.denominationId,_that.denominationName,_that.city,_that.education,_that.profession,_that.bio,_that.profileId,_that.photos,_that.answers,_that.savedPrompts,_that.step);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String accountType,  String name,  String dob,  String gender,  int? denominationId,  String denominationName,  String city,  String education,  String profession,  String bio,  int? profileId,  List<PhotoRef> photos,  Map<String, String> answers,  Map<String, int> savedPrompts,  String step)?  $default,) {final _that = this;
switch (_that) {
case _OnboardingDraft() when $default != null:
return $default(_that.accountType,_that.name,_that.dob,_that.gender,_that.denominationId,_that.denominationName,_that.city,_that.education,_that.profession,_that.bio,_that.profileId,_that.photos,_that.answers,_that.savedPrompts,_that.step);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _OnboardingDraft extends OnboardingDraft {
  const _OnboardingDraft({this.accountType = 'individual', this.name = '', this.dob = '', this.gender = '', this.denominationId, this.denominationName = '', this.city = '', this.education = '', this.profession = '', this.bio = '', this.profileId,  List<PhotoRef> photos = const [],  Map<String, String> answers = const {},  Map<String, int> savedPrompts = const {}, this.step = 'account-type'}): _photos = photos,_answers = answers,_savedPrompts = savedPrompts,super._();
  factory _OnboardingDraft.fromJson(Map<String, dynamic> json) => _$OnboardingDraftFromJson(json);

@override@JsonKey() final  String accountType;
@override@JsonKey() final  String name;
/// Civil date, `YYYY-MM-DD`.
@override@JsonKey() final  String dob;
@override@JsonKey() final  String gender;
@override final  int? denominationId;
@override@JsonKey() final  String denominationName;
@override@JsonKey() final  String city;
@override@JsonKey() final  String education;
@override@JsonKey() final  String profession;
@override@JsonKey() final  String bio;
@override final  int? profileId;
 final  List<PhotoRef> _photos;
@override@JsonKey() List<PhotoRef> get photos {
  if (_photos is EqualUnmodifiableListView) return _photos;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_photos);
}

/// Selected prompt questions, in the order picked, to their answers.
 final  Map<String, String> _answers;
/// Selected prompt questions, in the order picked, to their answers.
@override@JsonKey() Map<String, String> get answers {
  if (_answers is EqualUnmodifiableMapView) return _answers;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_answers);
}

/// Prompt ids already on the server, by question -- so leaving the
/// prompts step twice updates instead of duplicating.
 final  Map<String, int> _savedPrompts;
/// Prompt ids already on the server, by question -- so leaving the
/// prompts step twice updates instead of duplicating.
@override@JsonKey() Map<String, int> get savedPrompts {
  if (_savedPrompts is EqualUnmodifiableMapView) return _savedPrompts;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableMapView(_savedPrompts);
}

/// The last step the user moved to.
@override@JsonKey() final  String step;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$OnboardingDraftCopyWith<_OnboardingDraft> get copyWith => __$OnboardingDraftCopyWithImpl<_OnboardingDraft>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$OnboardingDraftToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _OnboardingDraft&&(identical(other.accountType, accountType) || other.accountType == accountType)&&(identical(other.name, name) || other.name == name)&&(identical(other.dob, dob) || other.dob == dob)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.denominationId, denominationId) || other.denominationId == denominationId)&&(identical(other.denominationName, denominationName) || other.denominationName == denominationName)&&(identical(other.city, city) || other.city == city)&&(identical(other.education, education) || other.education == education)&&(identical(other.profession, profession) || other.profession == profession)&&(identical(other.bio, bio) || other.bio == bio)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&const DeepCollectionEquality().equals(other.photos, _photos)&&const DeepCollectionEquality().equals(other.answers, _answers)&&const DeepCollectionEquality().equals(other.savedPrompts, _savedPrompts)&&(identical(other.step, step) || other.step == step));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,accountType,name,dob,gender,denominationId,denominationName,city,education,profession,bio,profileId,const DeepCollectionEquality().hash(_photos),const DeepCollectionEquality().hash(_answers),const DeepCollectionEquality().hash(_savedPrompts),step);
}

@override
String toString() {
    return 'OnboardingDraft(accountType: $accountType, name: $name, dob: $dob, gender: $gender, denominationId: $denominationId, denominationName: $denominationName, city: $city, education: $education, profession: $profession, bio: $bio, profileId: $profileId, photos: $photos, answers: $answers, savedPrompts: $savedPrompts, step: $step)';
}


}

/// @nodoc
abstract mixin class _$OnboardingDraftCopyWith<$Res> implements $OnboardingDraftCopyWith<$Res> {
  factory _$OnboardingDraftCopyWith(_OnboardingDraft value, $Res Function(_OnboardingDraft) _then) = __$OnboardingDraftCopyWithImpl;
@override @useResult
$Res call({
 String accountType, String name, String dob, String gender, int? denominationId, String denominationName, String city, String education, String profession, String bio, int? profileId, List<PhotoRef> photos, Map<String, String> answers, Map<String, int> savedPrompts, String step
});




}
/// @nodoc
class __$OnboardingDraftCopyWithImpl<$Res>
    implements _$OnboardingDraftCopyWith<$Res> {
  __$OnboardingDraftCopyWithImpl(this._self, this._then);

  final _OnboardingDraft _self;
  final $Res Function(_OnboardingDraft) _then;

/// Create a copy of OnboardingDraft
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? accountType = null,Object? name = null,Object? dob = null,Object? gender = null,Object? denominationId = freezed,Object? denominationName = null,Object? city = null,Object? education = null,Object? profession = null,Object? bio = null,Object? profileId = freezed,Object? photos = null,Object? answers = null,Object? savedPrompts = null,Object? step = null,}) {
  return _then(_OnboardingDraft(
accountType: null == accountType ? _self.accountType : accountType // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,dob: null == dob ? _self.dob : dob // ignore: cast_nullable_to_non_nullable
as String,gender: null == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String,denominationId: freezed == denominationId ? _self.denominationId : denominationId // ignore: cast_nullable_to_non_nullable
as int?,denominationName: null == denominationName ? _self.denominationName : denominationName // ignore: cast_nullable_to_non_nullable
as String,city: null == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String,education: null == education ? _self.education : education // ignore: cast_nullable_to_non_nullable
as String,profession: null == profession ? _self.profession : profession // ignore: cast_nullable_to_non_nullable
as String,bio: null == bio ? _self.bio : bio // ignore: cast_nullable_to_non_nullable
as String,profileId: freezed == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int?,photos: null == photos ? _self._photos : photos // ignore: cast_nullable_to_non_nullable
as List<PhotoRef>,answers: null == answers ? _self._answers : answers // ignore: cast_nullable_to_non_nullable
as Map<String, String>,savedPrompts: null == savedPrompts ? _self._savedPrompts : savedPrompts // ignore: cast_nullable_to_non_nullable
as Map<String, int>,step: null == step ? _self.step : step // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
