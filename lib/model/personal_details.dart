import 'package:floor/floor.dart';

@entity
class PersonalDetails{
  @PrimaryKey(autoGenerate: true)
  final int? id;
  final String? firstName;
  final String? middleName;
  final String? lastName;
  final String? emailAddress;
  final String? district;
  final int? pinCode;
  //final String? country;

  PersonalDetails({this.id,this.firstName,  this.middleName,  this.lastName,  this.emailAddress, this.district, this.pinCode});

}