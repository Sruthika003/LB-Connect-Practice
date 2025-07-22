import 'package:floor/floor.dart';
import 'package:lb_connect_sample_project/model/personal_details.dart';

@dao
abstract class PersonalDetailsDao{

  @insert
  Future<void> insertPersonalDetails(PersonalDetails personalDetails);

  @Query("SELECT * FROM PersonalDetails")
  Future<List<PersonalDetails>> fetchDataFromPersonalDetails();

  @Query("update PersonalDetails SET firstName= :firstName, middleName= :middleName, lastName= :lastName, emailAddress= :emailAddress where id= :id")
  Future<void> updateDataUsedById(int id, String firstName, String middleName, String lastName, String emailAddress);
  
  @Query("delete from PersonalDetails where id= :id")
  Future<void> deletePersonById(int id);
}