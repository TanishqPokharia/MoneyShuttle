// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_history.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$UserHistoryImpl _$$UserHistoryImplFromJson(Map<String, dynamic> json) =>
    _$UserHistoryImpl(
      username: json['username'] as String,
      phone: json['phone'] as String,
      note: json['note'] as String,
      msId: json['msId'] as String,
      amount: json['amount'] as String,
      category: json['category'] as String,
      time: json['time'] as String,
      date: (json['date'] as num).toInt(),
      month: (json['month'] as num).toInt(),
      year: (json['year'] as num).toInt(),
    );

Map<String, dynamic> _$$UserHistoryImplToJson(_$UserHistoryImpl instance) =>
    <String, dynamic>{
      'username': instance.username,
      'phone': instance.phone,
      'note': instance.note,
      'msId': instance.msId,
      'amount': instance.amount,
      'category': instance.category,
      'time': instance.time,
      'date': instance.date,
      'month': instance.month,
      'year': instance.year,
    };
