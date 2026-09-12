// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'feed_page.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$FeedPage {

 List<Profile> get profiles;@JsonKey(name: 'next_page') int? get nextPage;
/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedPageCopyWith<FeedPage> get copyWith => _$FeedPageCopyWithImpl<FeedPage>(this as FeedPage, _$identity);

  /// Serializes this FeedPage to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedPage;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedPage&&const DeepCollectionEquality().equals(other.profiles, _this.profiles)&&(identical(other.nextPage, _this.nextPage) || other.nextPage == _this.nextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedPage;
  return Object.hash(runtimeType,const DeepCollectionEquality().hash(_this.profiles),_this.nextPage);
}

@override
String toString() {
  final _this = this as FeedPage;
  return 'FeedPage(profiles: ${_this.profiles}, nextPage: ${_this.nextPage})';
}


}

/// @nodoc
abstract mixin class $FeedPageCopyWith<$Res>  {
  factory $FeedPageCopyWith(FeedPage value, $Res Function(FeedPage) _then) = _$FeedPageCopyWithImpl;
@useResult
$Res call({
 List<Profile> profiles,@JsonKey(name: 'next_page') int? nextPage
});




}
/// @nodoc
class _$FeedPageCopyWithImpl<$Res>
    implements $FeedPageCopyWith<$Res> {
  _$FeedPageCopyWithImpl(this._self, this._then);

  final FeedPage _self;
  final $Res Function(FeedPage) _then;

/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? profiles = null,Object? nextPage = freezed,}) {
  return _then(FeedPage(
profiles: null == profiles ? _self.profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<Profile>,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedPage].
extension FeedPagePatterns on FeedPage {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedPage value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedPage() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedPage value)  $default,){
final _that = this;
switch (_that) {
case _FeedPage():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedPage value)?  $default,){
final _that = this;
switch (_that) {
case _FeedPage() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( List<Profile> profiles, @JsonKey(name: 'next_page')  int? nextPage)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedPage() when $default != null:
return $default(_that.profiles,_that.nextPage);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( List<Profile> profiles, @JsonKey(name: 'next_page')  int? nextPage)  $default,) {final _that = this;
switch (_that) {
case _FeedPage():
return $default(_that.profiles,_that.nextPage);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( List<Profile> profiles, @JsonKey(name: 'next_page')  int? nextPage)?  $default,) {final _that = this;
switch (_that) {
case _FeedPage() when $default != null:
return $default(_that.profiles,_that.nextPage);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedPage implements FeedPage {
  const _FeedPage({required  List<Profile> profiles, @JsonKey(name: 'next_page') this.nextPage}): _profiles = profiles;
  factory _FeedPage.fromJson(Map<String, dynamic> json) => _$FeedPageFromJson(json);

 final  List<Profile> _profiles;
@override List<Profile> get profiles {
  if (_profiles is EqualUnmodifiableListView) return _profiles;
  // ignore: implicit_dynamic_type
  return EqualUnmodifiableListView(_profiles);
}

@override@JsonKey(name: 'next_page') final  int? nextPage;

/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedPageCopyWith<_FeedPage> get copyWith => __$FeedPageCopyWithImpl<_FeedPage>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedPageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedPage&&const DeepCollectionEquality().equals(other.profiles, _profiles)&&(identical(other.nextPage, nextPage) || other.nextPage == nextPage));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,const DeepCollectionEquality().hash(_profiles),nextPage);
}

@override
String toString() {
    return 'FeedPage(profiles: $profiles, nextPage: $nextPage)';
}


}

/// @nodoc
abstract mixin class _$FeedPageCopyWith<$Res> implements $FeedPageCopyWith<$Res> {
  factory _$FeedPageCopyWith(_FeedPage value, $Res Function(_FeedPage) _then) = __$FeedPageCopyWithImpl;
@override @useResult
$Res call({
 List<Profile> profiles,@JsonKey(name: 'next_page') int? nextPage
});




}
/// @nodoc
class __$FeedPageCopyWithImpl<$Res>
    implements _$FeedPageCopyWith<$Res> {
  __$FeedPageCopyWithImpl(this._self, this._then);

  final _FeedPage _self;
  final $Res Function(_FeedPage) _then;

/// Create a copy of FeedPage
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? profiles = null,Object? nextPage = freezed,}) {
  return _then(_FeedPage(
profiles: null == profiles ? _self._profiles : profiles // ignore: cast_nullable_to_non_nullable
as List<Profile>,nextPage: freezed == nextPage ? _self.nextPage : nextPage // ignore: cast_nullable_to_non_nullable
as int?,
  ));
}


}


/// @nodoc
mixin _$FeedFilters {

 String? get city;@JsonKey(name: 'denomination_id') int? get denominationId; String? get gender;@JsonKey(name: 'min_age') int? get minAge;@JsonKey(name: 'max_age') int? get maxAge; int get page;
/// Create a copy of FeedFilters
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$FeedFiltersCopyWith<FeedFilters> get copyWith => _$FeedFiltersCopyWithImpl<FeedFilters>(this as FeedFilters, _$identity);

  /// Serializes this FeedFilters to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as FeedFilters;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is FeedFilters&&(identical(other.city, _this.city) || other.city == _this.city)&&(identical(other.denominationId, _this.denominationId) || other.denominationId == _this.denominationId)&&(identical(other.gender, _this.gender) || other.gender == _this.gender)&&(identical(other.minAge, _this.minAge) || other.minAge == _this.minAge)&&(identical(other.maxAge, _this.maxAge) || other.maxAge == _this.maxAge)&&(identical(other.page, _this.page) || other.page == _this.page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as FeedFilters;
  return Object.hash(runtimeType,_this.city,_this.denominationId,_this.gender,_this.minAge,_this.maxAge,_this.page);
}

@override
String toString() {
  final _this = this as FeedFilters;
  return 'FeedFilters(city: ${_this.city}, denominationId: ${_this.denominationId}, gender: ${_this.gender}, minAge: ${_this.minAge}, maxAge: ${_this.maxAge}, page: ${_this.page})';
}


}

/// @nodoc
abstract mixin class $FeedFiltersCopyWith<$Res>  {
  factory $FeedFiltersCopyWith(FeedFilters value, $Res Function(FeedFilters) _then) = _$FeedFiltersCopyWithImpl;
@useResult
$Res call({
 String? city,@JsonKey(name: 'denomination_id') int? denominationId, String? gender,@JsonKey(name: 'min_age') int? minAge,@JsonKey(name: 'max_age') int? maxAge, int page
});




}
/// @nodoc
class _$FeedFiltersCopyWithImpl<$Res>
    implements $FeedFiltersCopyWith<$Res> {
  _$FeedFiltersCopyWithImpl(this._self, this._then);

  final FeedFilters _self;
  final $Res Function(FeedFilters) _then;

/// Create a copy of FeedFilters
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? city = freezed,Object? denominationId = freezed,Object? gender = freezed,Object? minAge = freezed,Object? maxAge = freezed,Object? page = null,}) {
  return _then(FeedFilters(
city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,denominationId: freezed == denominationId ? _self.denominationId : denominationId // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,minAge: freezed == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int?,maxAge: freezed == maxAge ? _self.maxAge : maxAge // ignore: cast_nullable_to_non_nullable
as int?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [FeedFilters].
extension FeedFiltersPatterns on FeedFilters {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _FeedFilters value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _FeedFilters() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _FeedFilters value)  $default,){
final _that = this;
switch (_that) {
case _FeedFilters():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _FeedFilters value)?  $default,){
final _that = this;
switch (_that) {
case _FeedFilters() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String? city, @JsonKey(name: 'denomination_id')  int? denominationId,  String? gender, @JsonKey(name: 'min_age')  int? minAge, @JsonKey(name: 'max_age')  int? maxAge,  int page)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _FeedFilters() when $default != null:
return $default(_that.city,_that.denominationId,_that.gender,_that.minAge,_that.maxAge,_that.page);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String? city, @JsonKey(name: 'denomination_id')  int? denominationId,  String? gender, @JsonKey(name: 'min_age')  int? minAge, @JsonKey(name: 'max_age')  int? maxAge,  int page)  $default,) {final _that = this;
switch (_that) {
case _FeedFilters():
return $default(_that.city,_that.denominationId,_that.gender,_that.minAge,_that.maxAge,_that.page);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String? city, @JsonKey(name: 'denomination_id')  int? denominationId,  String? gender, @JsonKey(name: 'min_age')  int? minAge, @JsonKey(name: 'max_age')  int? maxAge,  int page)?  $default,) {final _that = this;
switch (_that) {
case _FeedFilters() when $default != null:
return $default(_that.city,_that.denominationId,_that.gender,_that.minAge,_that.maxAge,_that.page);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _FeedFilters implements FeedFilters {
  const _FeedFilters({this.city, @JsonKey(name: 'denomination_id') this.denominationId, this.gender, @JsonKey(name: 'min_age') this.minAge, @JsonKey(name: 'max_age') this.maxAge, this.page = 1});
  factory _FeedFilters.fromJson(Map<String, dynamic> json) => _$FeedFiltersFromJson(json);

@override final  String? city;
@override@JsonKey(name: 'denomination_id') final  int? denominationId;
@override final  String? gender;
@override@JsonKey(name: 'min_age') final  int? minAge;
@override@JsonKey(name: 'max_age') final  int? maxAge;
@override@JsonKey() final  int page;

/// Create a copy of FeedFilters
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$FeedFiltersCopyWith<_FeedFilters> get copyWith => __$FeedFiltersCopyWithImpl<_FeedFilters>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$FeedFiltersToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _FeedFilters&&(identical(other.city, city) || other.city == city)&&(identical(other.denominationId, denominationId) || other.denominationId == denominationId)&&(identical(other.gender, gender) || other.gender == gender)&&(identical(other.minAge, minAge) || other.minAge == minAge)&&(identical(other.maxAge, maxAge) || other.maxAge == maxAge)&&(identical(other.page, page) || other.page == page));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,city,denominationId,gender,minAge,maxAge,page);
}

@override
String toString() {
    return 'FeedFilters(city: $city, denominationId: $denominationId, gender: $gender, minAge: $minAge, maxAge: $maxAge, page: $page)';
}


}

/// @nodoc
abstract mixin class _$FeedFiltersCopyWith<$Res> implements $FeedFiltersCopyWith<$Res> {
  factory _$FeedFiltersCopyWith(_FeedFilters value, $Res Function(_FeedFilters) _then) = __$FeedFiltersCopyWithImpl;
@override @useResult
$Res call({
 String? city,@JsonKey(name: 'denomination_id') int? denominationId, String? gender,@JsonKey(name: 'min_age') int? minAge,@JsonKey(name: 'max_age') int? maxAge, int page
});




}
/// @nodoc
class __$FeedFiltersCopyWithImpl<$Res>
    implements _$FeedFiltersCopyWith<$Res> {
  __$FeedFiltersCopyWithImpl(this._self, this._then);

  final _FeedFilters _self;
  final $Res Function(_FeedFilters) _then;

/// Create a copy of FeedFilters
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? city = freezed,Object? denominationId = freezed,Object? gender = freezed,Object? minAge = freezed,Object? maxAge = freezed,Object? page = null,}) {
  return _then(_FeedFilters(
city: freezed == city ? _self.city : city // ignore: cast_nullable_to_non_nullable
as String?,denominationId: freezed == denominationId ? _self.denominationId : denominationId // ignore: cast_nullable_to_non_nullable
as int?,gender: freezed == gender ? _self.gender : gender // ignore: cast_nullable_to_non_nullable
as String?,minAge: freezed == minAge ? _self.minAge : minAge // ignore: cast_nullable_to_non_nullable
as int?,maxAge: freezed == maxAge ? _self.maxAge : maxAge // ignore: cast_nullable_to_non_nullable
as int?,page: null == page ? _self.page : page // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
