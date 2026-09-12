// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'photo.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$PhotoRef {

 int get id; String get url;@JsonKey(name: 'thumb_url') String get thumbUrl; int get position;
/// Create a copy of PhotoRef
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PhotoRefCopyWith<PhotoRef> get copyWith => _$PhotoRefCopyWithImpl<PhotoRef>(this as PhotoRef, _$identity);

  /// Serializes this PhotoRef to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as PhotoRef;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is PhotoRef&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.url, _this.url) || other.url == _this.url)&&(identical(other.thumbUrl, _this.thumbUrl) || other.thumbUrl == _this.thumbUrl)&&(identical(other.position, _this.position) || other.position == _this.position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as PhotoRef;
  return Object.hash(runtimeType,_this.id,_this.url,_this.thumbUrl,_this.position);
}

@override
String toString() {
  final _this = this as PhotoRef;
  return 'PhotoRef(id: ${_this.id}, url: ${_this.url}, thumbUrl: ${_this.thumbUrl}, position: ${_this.position})';
}


}

/// @nodoc
abstract mixin class $PhotoRefCopyWith<$Res>  {
  factory $PhotoRefCopyWith(PhotoRef value, $Res Function(PhotoRef) _then) = _$PhotoRefCopyWithImpl;
@useResult
$Res call({
 int id, String url,@JsonKey(name: 'thumb_url') String thumbUrl, int position
});




}
/// @nodoc
class _$PhotoRefCopyWithImpl<$Res>
    implements $PhotoRefCopyWith<$Res> {
  _$PhotoRefCopyWithImpl(this._self, this._then);

  final PhotoRef _self;
  final $Res Function(PhotoRef) _then;

/// Create a copy of PhotoRef
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? url = null,Object? thumbUrl = null,Object? position = null,}) {
  return _then(PhotoRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: null == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

}


/// Adds pattern-matching-related methods to [PhotoRef].
extension PhotoRefPatterns on PhotoRef {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _PhotoRef value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _PhotoRef() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _PhotoRef value)  $default,){
final _that = this;
switch (_that) {
case _PhotoRef():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _PhotoRef value)?  $default,){
final _that = this;
switch (_that) {
case _PhotoRef() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id,  String url, @JsonKey(name: 'thumb_url')  String thumbUrl,  int position)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _PhotoRef() when $default != null:
return $default(_that.id,_that.url,_that.thumbUrl,_that.position);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id,  String url, @JsonKey(name: 'thumb_url')  String thumbUrl,  int position)  $default,) {final _that = this;
switch (_that) {
case _PhotoRef():
return $default(_that.id,_that.url,_that.thumbUrl,_that.position);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id,  String url, @JsonKey(name: 'thumb_url')  String thumbUrl,  int position)?  $default,) {final _that = this;
switch (_that) {
case _PhotoRef() when $default != null:
return $default(_that.id,_that.url,_that.thumbUrl,_that.position);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _PhotoRef implements PhotoRef {
  const _PhotoRef({required this.id, required this.url, @JsonKey(name: 'thumb_url') required this.thumbUrl, required this.position});
  factory _PhotoRef.fromJson(Map<String, dynamic> json) => _$PhotoRefFromJson(json);

@override final  int id;
@override final  String url;
@override@JsonKey(name: 'thumb_url') final  String thumbUrl;
@override final  int position;

/// Create a copy of PhotoRef
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PhotoRefCopyWith<_PhotoRef> get copyWith => __$PhotoRefCopyWithImpl<_PhotoRef>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PhotoRefToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _PhotoRef&&(identical(other.id, id) || other.id == id)&&(identical(other.url, url) || other.url == url)&&(identical(other.thumbUrl, thumbUrl) || other.thumbUrl == thumbUrl)&&(identical(other.position, position) || other.position == position));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,url,thumbUrl,position);
}

@override
String toString() {
    return 'PhotoRef(id: $id, url: $url, thumbUrl: $thumbUrl, position: $position)';
}


}

/// @nodoc
abstract mixin class _$PhotoRefCopyWith<$Res> implements $PhotoRefCopyWith<$Res> {
  factory _$PhotoRefCopyWith(_PhotoRef value, $Res Function(_PhotoRef) _then) = __$PhotoRefCopyWithImpl;
@override @useResult
$Res call({
 int id, String url,@JsonKey(name: 'thumb_url') String thumbUrl, int position
});




}
/// @nodoc
class __$PhotoRefCopyWithImpl<$Res>
    implements _$PhotoRefCopyWith<$Res> {
  __$PhotoRefCopyWithImpl(this._self, this._then);

  final _PhotoRef _self;
  final $Res Function(_PhotoRef) _then;

/// Create a copy of PhotoRef
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? url = null,Object? thumbUrl = null,Object? position = null,}) {
  return _then(_PhotoRef(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,url: null == url ? _self.url : url // ignore: cast_nullable_to_non_nullable
as String,thumbUrl: null == thumbUrl ? _self.thumbUrl : thumbUrl // ignore: cast_nullable_to_non_nullable
as String,position: null == position ? _self.position : position // ignore: cast_nullable_to_non_nullable
as int,
  ));
}


}

// dart format on
