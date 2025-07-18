
import 'package:json_annotation/json_annotation.dart';

part 'email_verify_model.g.dart';

@JsonSerializable()
class EmailVerifyModel{
  String type;
  String response_code;
  String message;

  EmailVerifyModel({required this.type, required this.response_code, required this.message});

  factory EmailVerifyModel.fromJson(Map<String, dynamic> json) => _$EmailVerifyModelFromJson(json);
  Map<String, dynamic> toJson() => _$EmailVerifyModelToJson(this);
}