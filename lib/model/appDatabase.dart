import 'dart:async';

import 'package:floor/floor.dart';
import 'package:lb_connect_sample_project/model/personal_details.dart';
import 'package:lb_connect_sample_project/model/personal_details_dao.dart';
import 'package:sqflite/sqflite.dart' as sqflite;


part 'appDatabase.g.dart';

@Database(
 version: 2,
 entities: [PersonalDetails],
)
abstract class AppDatabase extends FloorDatabase{
 PersonalDetailsDao get personalDetailsDao;


}
