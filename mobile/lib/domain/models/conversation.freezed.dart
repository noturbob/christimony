// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'conversation.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$LastMessagePreview {

 String get body;@JsonKey(name: 'sent_at') String get sentAt;
/// Create a copy of LastMessagePreview
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$LastMessagePreviewCopyWith<LastMessagePreview> get copyWith => _$LastMessagePreviewCopyWithImpl<LastMessagePreview>(this as LastMessagePreview, _$identity);

  /// Serializes this LastMessagePreview to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as LastMessagePreview;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is LastMessagePreview&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.sentAt, _this.sentAt) || other.sentAt == _this.sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as LastMessagePreview;
  return Object.hash(runtimeType,_this.body,_this.sentAt);
}

@override
String toString() {
  final _this = this as LastMessagePreview;
  return 'LastMessagePreview(body: ${_this.body}, sentAt: ${_this.sentAt})';
}


}

/// @nodoc
abstract mixin class $LastMessagePreviewCopyWith<$Res>  {
  factory $LastMessagePreviewCopyWith(LastMessagePreview value, $Res Function(LastMessagePreview) _then) = _$LastMessagePreviewCopyWithImpl;
@useResult
$Res call({
 String body,@JsonKey(name: 'sent_at') String sentAt
});




}
/// @nodoc
class _$LastMessagePreviewCopyWithImpl<$Res>
    implements $LastMessagePreviewCopyWith<$Res> {
  _$LastMessagePreviewCopyWithImpl(this._self, this._then);

  final LastMessagePreview _self;
  final $Res Function(LastMessagePreview) _then;

/// Create a copy of LastMessagePreview
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? body = null,Object? sentAt = null,}) {
  return _then(LastMessagePreview(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}

}


/// Adds pattern-matching-related methods to [LastMessagePreview].
extension LastMessagePreviewPatterns on LastMessagePreview {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _LastMessagePreview value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _LastMessagePreview() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _LastMessagePreview value)  $default,){
final _that = this;
switch (_that) {
case _LastMessagePreview():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _LastMessagePreview value)?  $default,){
final _that = this;
switch (_that) {
case _LastMessagePreview() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( String body, @JsonKey(name: 'sent_at')  String sentAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _LastMessagePreview() when $default != null:
return $default(_that.body,_that.sentAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( String body, @JsonKey(name: 'sent_at')  String sentAt)  $default,) {final _that = this;
switch (_that) {
case _LastMessagePreview():
return $default(_that.body,_that.sentAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( String body, @JsonKey(name: 'sent_at')  String sentAt)?  $default,) {final _that = this;
switch (_that) {
case _LastMessagePreview() when $default != null:
return $default(_that.body,_that.sentAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _LastMessagePreview implements LastMessagePreview {
  const _LastMessagePreview({required this.body, @JsonKey(name: 'sent_at') required this.sentAt});
  factory _LastMessagePreview.fromJson(Map<String, dynamic> json) => _$LastMessagePreviewFromJson(json);

@override final  String body;
@override@JsonKey(name: 'sent_at') final  String sentAt;

/// Create a copy of LastMessagePreview
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$LastMessagePreviewCopyWith<_LastMessagePreview> get copyWith => __$LastMessagePreviewCopyWithImpl<_LastMessagePreview>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$LastMessagePreviewToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _LastMessagePreview&&(identical(other.body, body) || other.body == body)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,body,sentAt);
}

@override
String toString() {
    return 'LastMessagePreview(body: $body, sentAt: $sentAt)';
}


}

/// @nodoc
abstract mixin class _$LastMessagePreviewCopyWith<$Res> implements $LastMessagePreviewCopyWith<$Res> {
  factory _$LastMessagePreviewCopyWith(_LastMessagePreview value, $Res Function(_LastMessagePreview) _then) = __$LastMessagePreviewCopyWithImpl;
@override @useResult
$Res call({
 String body,@JsonKey(name: 'sent_at') String sentAt
});




}
/// @nodoc
class __$LastMessagePreviewCopyWithImpl<$Res>
    implements _$LastMessagePreviewCopyWith<$Res> {
  __$LastMessagePreviewCopyWithImpl(this._self, this._then);

  final _LastMessagePreview _self;
  final $Res Function(_LastMessagePreview) _then;

/// Create a copy of LastMessagePreview
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? body = null,Object? sentAt = null,}) {
  return _then(_LastMessagePreview(
body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String,
  ));
}


}


/// @nodoc
mixin _$ConversationSummary {

 int get id;@JsonKey(name: 'match_id') int get matchId;@JsonKey(name: 'other_profile') ProfileSummary get otherProfile;@JsonKey(name: 'last_message') LastMessagePreview? get lastMessage;@JsonKey(name: 'unread_count') int get unreadCount;
/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ConversationSummaryCopyWith<ConversationSummary> get copyWith => _$ConversationSummaryCopyWithImpl<ConversationSummary>(this as ConversationSummary, _$identity);

  /// Serializes this ConversationSummary to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as ConversationSummary;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ConversationSummary&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.matchId, _this.matchId) || other.matchId == _this.matchId)&&(identical(other.otherProfile, _this.otherProfile) || other.otherProfile == _this.otherProfile)&&(identical(other.lastMessage, _this.lastMessage) || other.lastMessage == _this.lastMessage)&&(identical(other.unreadCount, _this.unreadCount) || other.unreadCount == _this.unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as ConversationSummary;
  return Object.hash(runtimeType,_this.id,_this.matchId,_this.otherProfile,_this.lastMessage,_this.unreadCount);
}

@override
String toString() {
  final _this = this as ConversationSummary;
  return 'ConversationSummary(id: ${_this.id}, matchId: ${_this.matchId}, otherProfile: ${_this.otherProfile}, lastMessage: ${_this.lastMessage}, unreadCount: ${_this.unreadCount})';
}


}

/// @nodoc
abstract mixin class $ConversationSummaryCopyWith<$Res>  {
  factory $ConversationSummaryCopyWith(ConversationSummary value, $Res Function(ConversationSummary) _then) = _$ConversationSummaryCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'match_id') int matchId,@JsonKey(name: 'other_profile') ProfileSummary otherProfile,@JsonKey(name: 'last_message') LastMessagePreview? lastMessage,@JsonKey(name: 'unread_count') int unreadCount
});


$ProfileSummaryCopyWith<$Res> get otherProfile;$LastMessagePreviewCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class _$ConversationSummaryCopyWithImpl<$Res>
    implements $ConversationSummaryCopyWith<$Res> {
  _$ConversationSummaryCopyWithImpl(this._self, this._then);

  final ConversationSummary _self;
  final $Res Function(ConversationSummary) _then;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? matchId = null,Object? otherProfile = null,Object? lastMessage = freezed,Object? unreadCount = null,}) {
  return _then(ConversationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as int,otherProfile: null == otherProfile ? _self.otherProfile : otherProfile // ignore: cast_nullable_to_non_nullable
as ProfileSummary,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as LastMessagePreview?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}
/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSummaryCopyWith<$Res> get otherProfile {
  
  return $ProfileSummaryCopyWith<$Res>(_self.otherProfile, (value) {
    return _then(_self.copyWith(otherProfile: value));
  });
}/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastMessagePreviewCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $LastMessagePreviewCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}


/// Adds pattern-matching-related methods to [ConversationSummary].
extension ConversationSummaryPatterns on ConversationSummary {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _ConversationSummary value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _ConversationSummary value)  $default,){
final _that = this;
switch (_that) {
case _ConversationSummary():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _ConversationSummary value)?  $default,){
final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'match_id')  int matchId, @JsonKey(name: 'other_profile')  ProfileSummary otherProfile, @JsonKey(name: 'last_message')  LastMessagePreview? lastMessage, @JsonKey(name: 'unread_count')  int unreadCount)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
return $default(_that.id,_that.matchId,_that.otherProfile,_that.lastMessage,_that.unreadCount);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'match_id')  int matchId, @JsonKey(name: 'other_profile')  ProfileSummary otherProfile, @JsonKey(name: 'last_message')  LastMessagePreview? lastMessage, @JsonKey(name: 'unread_count')  int unreadCount)  $default,) {final _that = this;
switch (_that) {
case _ConversationSummary():
return $default(_that.id,_that.matchId,_that.otherProfile,_that.lastMessage,_that.unreadCount);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'match_id')  int matchId, @JsonKey(name: 'other_profile')  ProfileSummary otherProfile, @JsonKey(name: 'last_message')  LastMessagePreview? lastMessage, @JsonKey(name: 'unread_count')  int unreadCount)?  $default,) {final _that = this;
switch (_that) {
case _ConversationSummary() when $default != null:
return $default(_that.id,_that.matchId,_that.otherProfile,_that.lastMessage,_that.unreadCount);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _ConversationSummary implements ConversationSummary {
  const _ConversationSummary({required this.id, @JsonKey(name: 'match_id') required this.matchId, @JsonKey(name: 'other_profile') required this.otherProfile, @JsonKey(name: 'last_message') this.lastMessage, @JsonKey(name: 'unread_count') required this.unreadCount});
  factory _ConversationSummary.fromJson(Map<String, dynamic> json) => _$ConversationSummaryFromJson(json);

@override final  int id;
@override@JsonKey(name: 'match_id') final  int matchId;
@override@JsonKey(name: 'other_profile') final  ProfileSummary otherProfile;
@override@JsonKey(name: 'last_message') final  LastMessagePreview? lastMessage;
@override@JsonKey(name: 'unread_count') final  int unreadCount;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ConversationSummaryCopyWith<_ConversationSummary> get copyWith => __$ConversationSummaryCopyWithImpl<_ConversationSummary>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$ConversationSummaryToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _ConversationSummary&&(identical(other.id, id) || other.id == id)&&(identical(other.matchId, matchId) || other.matchId == matchId)&&(identical(other.otherProfile, otherProfile) || other.otherProfile == otherProfile)&&(identical(other.lastMessage, lastMessage) || other.lastMessage == lastMessage)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,matchId,otherProfile,lastMessage,unreadCount);
}

@override
String toString() {
    return 'ConversationSummary(id: $id, matchId: $matchId, otherProfile: $otherProfile, lastMessage: $lastMessage, unreadCount: $unreadCount)';
}


}

/// @nodoc
abstract mixin class _$ConversationSummaryCopyWith<$Res> implements $ConversationSummaryCopyWith<$Res> {
  factory _$ConversationSummaryCopyWith(_ConversationSummary value, $Res Function(_ConversationSummary) _then) = __$ConversationSummaryCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'match_id') int matchId,@JsonKey(name: 'other_profile') ProfileSummary otherProfile,@JsonKey(name: 'last_message') LastMessagePreview? lastMessage,@JsonKey(name: 'unread_count') int unreadCount
});


@override $ProfileSummaryCopyWith<$Res> get otherProfile;@override $LastMessagePreviewCopyWith<$Res>? get lastMessage;

}
/// @nodoc
class __$ConversationSummaryCopyWithImpl<$Res>
    implements _$ConversationSummaryCopyWith<$Res> {
  __$ConversationSummaryCopyWithImpl(this._self, this._then);

  final _ConversationSummary _self;
  final $Res Function(_ConversationSummary) _then;

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? matchId = null,Object? otherProfile = null,Object? lastMessage = freezed,Object? unreadCount = null,}) {
  return _then(_ConversationSummary(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,matchId: null == matchId ? _self.matchId : matchId // ignore: cast_nullable_to_non_nullable
as int,otherProfile: null == otherProfile ? _self.otherProfile : otherProfile // ignore: cast_nullable_to_non_nullable
as ProfileSummary,lastMessage: freezed == lastMessage ? _self.lastMessage : lastMessage // ignore: cast_nullable_to_non_nullable
as LastMessagePreview?,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,
  ));
}

/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$ProfileSummaryCopyWith<$Res> get otherProfile {
  
  return $ProfileSummaryCopyWith<$Res>(_self.otherProfile, (value) {
    return _then(_self.copyWith(otherProfile: value));
  });
}/// Create a copy of ConversationSummary
/// with the given fields replaced by the non-null parameter values.
@override
@pragma('vm:prefer-inline')
$LastMessagePreviewCopyWith<$Res>? get lastMessage {
    if (_self.lastMessage == null) {
    return null;
  }

  return $LastMessagePreviewCopyWith<$Res>(_self.lastMessage!, (value) {
    return _then(_self.copyWith(lastMessage: value));
  });
}
}

// dart format on
