// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'chat_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ChatDataImpl _$$ChatDataImplFromJson(Map<String, dynamic> json) =>
    _$ChatDataImpl(
      id: json['id'] as String,
      username: json['username'] as String,
      latestMessage: json['latestMessage'] as String?,
      phone: json['phone'] as String,
      msId: json['msId'] as String,
      deviceToken: json['deviceToken'] as String,
    );

Map<String, dynamic> _$$ChatDataImplToJson(_$ChatDataImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'username': instance.username,
      'latestMessage': instance.latestMessage,
      'phone': instance.phone,
      'msId': instance.msId,
      'deviceToken': instance.deviceToken,
    };
