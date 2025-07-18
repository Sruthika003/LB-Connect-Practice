import 'package:json_annotation/json_annotation.dart';

part 'country_list.g.dart';

@JsonSerializable()
class CountryListItems {
  @JsonKey(name: "country_id")
  int? countryId;
  @JsonKey(name: "country_name")
  String? countryName;

  CountryListItems({
    this.countryId,
    this.countryName,
  });

  factory CountryListItems.fromJson(Map<String, dynamic> json) => _$CountryListItemsFromJson(json);
  Map<String, dynamic> toJson() => _$CountryListItemsToJson(this);
}

@JsonSerializable()
class CountryEntity {
  @JsonKey(name: "response_code")
  String? responseCode;
  @JsonKey(name: "data")
  List<CountryListItems?>? data;

  CountryEntity({
    this.responseCode,
    this.data,
  });

  factory CountryEntity.fromJson(Map<String, dynamic> json) => _$CountryEntityFromJson(json);
  Map<String, dynamic> toJson() => _$CountryEntityToJson(this);
}

@JsonSerializable()
class CountryResponse {
  @JsonKey(name: "response")
  CountryEntity? countryEntity;

  CountryResponse({
    this.countryEntity,
  });

  factory CountryResponse.fromJson(Map<String, dynamic> json) => _$CountryResponseFromJson(json);
  Map<String, dynamic> toJson() => _$CountryResponseToJson(this);
}