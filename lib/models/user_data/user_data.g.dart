// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_data.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserDataImpl _$$UserDataImplFromJson(Map<String, dynamic> json) =>
    _$UserDataImpl(
      username: json['username'] as String,
      email: json['email'] as String,
      phone: json['phone'] as String,
      pin: json['pin'] as String,
      msId: json['msId'] as String,
      balance: (json['balance'] as num).toDouble(),
      expenditure: (json['expenditure'] as num).toDouble(),
      paymentCategory: (json['paymentCategory'] as Map<String, dynamic>).map(
        (k, e) => MapEntry(k, (e as num).toDouble()),
      ),
      history: json['history'] as List<dynamic>,
      deviceToken: json['deviceToken'] as String,
    );

Map<String, dynamic> _$$UserDataImplToJson(_$UserDataImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'email': instance.email,
      'phone': instance.phone,
      'pin': instance.pin,
      'msId': instance.msId,
      'balance': instance.balance,
      'expenditure': instance.expenditure,
      'paymentCategory': instance.paymentCategory,
      'history': instance.history,
      'deviceToken': instance.deviceToken,
    };
