// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'prompt.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Prompt {

 int get id;@JsonKey(name: 'profile_id') int get profileId; String get question; String get answer;
/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$PromptCopyWith<Prompt> get copyWith => _$PromptCopyWithImpl<Prompt>(this as Prompt, _$identity);

  /// Serializes this Prompt to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Prompt;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Prompt&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.profileId, _this.profileId) || other.profileId == _this.profileId)&&(identical(other.question, _this.question) || other.question == _this.question)&&(identical(other.answer, _this.answer) || other.answer == _this.answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Prompt;
  return Object.hash(runtimeType,_this.id,_this.profileId,_this.question,_this.answer);
}

@override
String toString() {
  final _this = this as Prompt;
  return 'Prompt(id: ${_this.id}, profileId: ${_this.profileId}, question: ${_this.question}, answer: ${_this.answer})';
}


}

/// @nodoc
abstract mixin class $PromptCopyWith<$Res>  {
  factory $PromptCopyWith(Prompt value, $Res Function(Prompt) _then) = _$PromptCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'profile_id') int profileId, String question, String answer
});




}
/// @nodoc
class _$PromptCopyWithImpl<$Res>
    implements $PromptCopyWith<$Res> {
  _$PromptCopyWithImpl(this._self, this._then);

  final Prompt _self;
  final $Res Function(Prompt) _then;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? profileId = null,Object? question = null,Object? answer = null,}) {
  return _then(Prompt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [Prompt].
extension PromptPatterns on Prompt {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Prompt value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Prompt() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Prompt value)  $default,){
final _that = this;
switch (_that) {
case _Prompt():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Prompt value)?  $default,){
final _that = this;
switch (_that) {
case _Prompt() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'profile_id')  int profileId,  String question,  String answer)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Prompt() when $default != null:
return $default(_that.id,_that.profileId,_that.question,_that.answer);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'profile_id')  int profileId,  String question,  String answer)  $default,) {final _that = this;
switch (_that) {
case _Prompt():
return $default(_that.id,_that.profileId,_that.question,_that.answer);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'profile_id')  int profileId,  String question,  String answer)?  $default,) {final _that = this;
switch (_that) {
case _Prompt() when $default != null:
return $default(_that.id,_that.profileId,_that.question,_that.answer);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Prompt implements Prompt {
  const _Prompt({required this.id, @JsonKey(name: 'profile_id') required this.profileId, required this.question, required this.answer});
  factory _Prompt.fromJson(Map<String, dynamic> json) => _$PromptFromJson(json);

@override final  int id;
@override@JsonKey(name: 'profile_id') final  int profileId;
@override final  String question;
@override final  String answer;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$PromptCopyWith<_Prompt> get copyWith => __$PromptCopyWithImpl<_Prompt>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$PromptToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Prompt&&(identical(other.id, id) || other.id == id)&&(identical(other.profileId, profileId) || other.profileId == profileId)&&(identical(other.question, question) || other.question == question)&&(identical(other.answer, answer) || other.answer == answer));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,profileId,question,answer);
}

@override
String toString() {
    return 'Prompt(id: $id, profileId: $profileId, question: $question, answer: $answer)';
}


}

/// @nodoc
abstract mixin class _$PromptCopyWith<$Res> implements $PromptCopyWith<$Res> {
  factory _$PromptCopyWith(_Prompt value, $Res Function(_Prompt) _then) = __$PromptCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'profile_id') int profileId, String question, String answer
});




}
/// @nodoc
class __$PromptCopyWithImpl<$Res>
    implements _$PromptCopyWith<$Res> {
  __$PromptCopyWithImpl(this._self, this._then);

  final _Prompt _self;
  final $Res Function(_Prompt) _then;

/// Create a copy of Prompt
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? profileId = null,Object? question = null,Object? answer = null,}) {
  return _then(_Prompt(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,profileId: null == profileId ? _self.profileId : profileId // ignore: cast_nullable_to_non_nullable
as int,question: null == question ? _self.question : question // ignore: cast_nullable_to_non_nullable
as String,answer: null == answer ? _self.answer : answer // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}

// dart format on
