// GENERATED CODE - DO NOT MODIFY BY HAND
// coverage:ignore-file
// ignore_for_file: type=lint, type=warning, deprecated_member_use, deprecated_member_use_from_same_package
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'message.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// dart format off
T _$identity<T>(T value) => value;

/// @nodoc
mixin _$Message {

 int get id;@JsonKey(name: 'conversation_id') int get conversationId;@JsonKey(name: 'sender_account_id') int get senderAccountId; String get body;@JsonKey(name: 'sent_at') String get sentAt;@JsonKey(name: 'read_at') String? get readAt;
/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$MessageCopyWith<Message> get copyWith => _$MessageCopyWithImpl<Message>(this as Message, _$identity);

  /// Serializes this Message to a JSON map.
  Map<String, dynamic> toJson();


@override
bool operator ==(Object other) {
  final _this = this as Message;
  return identical(this, other) || (other.runtimeType == runtimeType&&other is Message&&(identical(other.id, _this.id) || other.id == _this.id)&&(identical(other.conversationId, _this.conversationId) || other.conversationId == _this.conversationId)&&(identical(other.senderAccountId, _this.senderAccountId) || other.senderAccountId == _this.senderAccountId)&&(identical(other.body, _this.body) || other.body == _this.body)&&(identical(other.sentAt, _this.sentAt) || other.sentAt == _this.sentAt)&&(identical(other.readAt, _this.readAt) || other.readAt == _this.readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
  final _this = this as Message;
  return Object.hash(runtimeType,_this.id,_this.conversationId,_this.senderAccountId,_this.body,_this.sentAt,_this.readAt);
}

@override
String toString() {
  final _this = this as Message;
  return 'Message(id: ${_this.id}, conversationId: ${_this.conversationId}, senderAccountId: ${_this.senderAccountId}, body: ${_this.body}, sentAt: ${_this.sentAt}, readAt: ${_this.readAt})';
}


}

/// @nodoc
abstract mixin class $MessageCopyWith<$Res>  {
  factory $MessageCopyWith(Message value, $Res Function(Message) _then) = _$MessageCopyWithImpl;
@useResult
$Res call({
 int id,@JsonKey(name: 'conversation_id') int conversationId,@JsonKey(name: 'sender_account_id') int senderAccountId, String body,@JsonKey(name: 'sent_at') String sentAt,@JsonKey(name: 'read_at') String? readAt
});




}
/// @nodoc
class _$MessageCopyWithImpl<$Res>
    implements $MessageCopyWith<$Res> {
  _$MessageCopyWithImpl(this._self, this._then);

  final Message _self;
  final $Res Function(Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = null,Object? conversationId = null,Object? senderAccountId = null,Object? body = null,Object? sentAt = null,Object? readAt = freezed,}) {
  return _then(Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as int,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}

}


/// Adds pattern-matching-related methods to [Message].
extension MessagePatterns on Message {
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

@optionalTypeArgs TResult maybeMap<TResult extends Object?>(TResult Function( _Message value)?  $default,{required TResult orElse(),}){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult map<TResult extends Object?>(TResult Function( _Message value)  $default,){
final _that = this;
switch (_that) {
case _Message():
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

@optionalTypeArgs TResult? mapOrNull<TResult extends Object?>(TResult? Function( _Message value)?  $default,){
final _that = this;
switch (_that) {
case _Message() when $default != null:
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

@optionalTypeArgs TResult maybeWhen<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'conversation_id')  int conversationId, @JsonKey(name: 'sender_account_id')  int senderAccountId,  String body, @JsonKey(name: 'sent_at')  String sentAt, @JsonKey(name: 'read_at')  String? readAt)?  $default,{required TResult orElse(),}) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderAccountId,_that.body,_that.sentAt,_that.readAt);case _:
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

@optionalTypeArgs TResult when<TResult extends Object?>(TResult Function( int id, @JsonKey(name: 'conversation_id')  int conversationId, @JsonKey(name: 'sender_account_id')  int senderAccountId,  String body, @JsonKey(name: 'sent_at')  String sentAt, @JsonKey(name: 'read_at')  String? readAt)  $default,) {final _that = this;
switch (_that) {
case _Message():
return $default(_that.id,_that.conversationId,_that.senderAccountId,_that.body,_that.sentAt,_that.readAt);case _:
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

@optionalTypeArgs TResult? whenOrNull<TResult extends Object?>(TResult? Function( int id, @JsonKey(name: 'conversation_id')  int conversationId, @JsonKey(name: 'sender_account_id')  int senderAccountId,  String body, @JsonKey(name: 'sent_at')  String sentAt, @JsonKey(name: 'read_at')  String? readAt)?  $default,) {final _that = this;
switch (_that) {
case _Message() when $default != null:
return $default(_that.id,_that.conversationId,_that.senderAccountId,_that.body,_that.sentAt,_that.readAt);case _:
  return null;

}
}

}

/// @nodoc
@JsonSerializable()

class _Message implements Message {
  const _Message({required this.id, @JsonKey(name: 'conversation_id') required this.conversationId, @JsonKey(name: 'sender_account_id') required this.senderAccountId, required this.body, @JsonKey(name: 'sent_at') required this.sentAt, @JsonKey(name: 'read_at') this.readAt});
  factory _Message.fromJson(Map<String, dynamic> json) => _$MessageFromJson(json);

@override final  int id;
@override@JsonKey(name: 'conversation_id') final  int conversationId;
@override@JsonKey(name: 'sender_account_id') final  int senderAccountId;
@override final  String body;
@override@JsonKey(name: 'sent_at') final  String sentAt;
@override@JsonKey(name: 'read_at') final  String? readAt;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$MessageCopyWith<_Message> get copyWith => __$MessageCopyWithImpl<_Message>(this, _$identity);

@override
Map<String, dynamic> toJson() {
  return _$MessageToJson(this, );
}

@override
bool operator ==(Object other) {
    return identical(this, other) || (other.runtimeType == runtimeType&&other is _Message&&(identical(other.id, id) || other.id == id)&&(identical(other.conversationId, conversationId) || other.conversationId == conversationId)&&(identical(other.senderAccountId, senderAccountId) || other.senderAccountId == senderAccountId)&&(identical(other.body, body) || other.body == body)&&(identical(other.sentAt, sentAt) || other.sentAt == sentAt)&&(identical(other.readAt, readAt) || other.readAt == readAt));
}

@JsonKey(includeFromJson: false, includeToJson: false)
@override
int get hashCode {
    return Object.hash(runtimeType,id,conversationId,senderAccountId,body,sentAt,readAt);
}

@override
String toString() {
    return 'Message(id: $id, conversationId: $conversationId, senderAccountId: $senderAccountId, body: $body, sentAt: $sentAt, readAt: $readAt)';
}


}

/// @nodoc
abstract mixin class _$MessageCopyWith<$Res> implements $MessageCopyWith<$Res> {
  factory _$MessageCopyWith(_Message value, $Res Function(_Message) _then) = __$MessageCopyWithImpl;
@override @useResult
$Res call({
 int id,@JsonKey(name: 'conversation_id') int conversationId,@JsonKey(name: 'sender_account_id') int senderAccountId, String body,@JsonKey(name: 'sent_at') String sentAt,@JsonKey(name: 'read_at') String? readAt
});




}
/// @nodoc
class __$MessageCopyWithImpl<$Res>
    implements _$MessageCopyWith<$Res> {
  __$MessageCopyWithImpl(this._self, this._then);

  final _Message _self;
  final $Res Function(_Message) _then;

/// Create a copy of Message
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = null,Object? conversationId = null,Object? senderAccountId = null,Object? body = null,Object? sentAt = null,Object? readAt = freezed,}) {
  return _then(_Message(
id: null == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as int,conversationId: null == conversationId ? _self.conversationId : conversationId // ignore: cast_nullable_to_non_nullable
as int,senderAccountId: null == senderAccountId ? _self.senderAccountId : senderAccountId // ignore: cast_nullable_to_non_nullable
as int,body: null == body ? _self.body : body // ignore: cast_nullable_to_non_nullable
as String,sentAt: null == sentAt ? _self.sentAt : sentAt // ignore: cast_nullable_to_non_nullable
as String,readAt: freezed == readAt ? _self.readAt : readAt // ignore: cast_nullable_to_non_nullable
as String?,
  ));
}


}

// dart format on
