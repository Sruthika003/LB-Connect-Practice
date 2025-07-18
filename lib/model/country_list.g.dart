// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'country_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CountryListItems _$CountryListItemsFromJson(Map<String, dynamic> json) =>
    CountryListItems(
      countryId: (json['country_id'] as num?)?.toInt(),
      countryName: json['country_name'] as String?,
    );

Map<String, dynamic> _$CountryListItemsToJson(CountryListItems instance) =>
    <String, dynamic>{
      'country_id': instance.countryId,
      'country_name': instance.countryName,
    };

CountryEntity _$CountryEntityFromJson(Map<String, dynamic> json) =>
    CountryEntity(
      responseCode: json['response_code'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map(
            (e) => e == null
                ? null
                : CountryListItems.fromJson(e as Map<String, dynamic>),
          )
          .toList(),
    );

Map<String, dynamic> _$CountryEntityToJson(CountryEntity instance) =>
    <String, dynamic>{
      'response_code': instance.responseCode,
      'data': instance.data,
    };

CountryResponse _$CountryResponseFromJson(Map<String, dynamic> json) =>
    CountryResponse(
      countryEntity: json['response'] == null
          ? null
          : CountryEntity.fromJson(json['response'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CountryResponseToJson(CountryResponse instance) =>
    <String, dynamic>{'response': instance.countryEntity};
