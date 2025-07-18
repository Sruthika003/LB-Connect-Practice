// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'email_verify_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

EmailVerifyModel _$EmailVerifyModelFromJson(Map<String, dynamic> json) =>
    EmailVerifyModel(
      type: json['type'] as String,
      response_code: json['response_code'] as String,
      message: json['message'] as String,
    );

Map<String, dynamic> _$EmailVerifyModelToJson(EmailVerifyModel instance) =>
    <String, dynamic>{
      'type': instance.type,
      'response_code': instance.response_code,
      'message': instance.message,
    };
