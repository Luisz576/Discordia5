import 'package:firebase_database/firebase_database.dart';

abstract class DBModel{
  DBModel();
  DBModel.fromDBModel(DataSnapshot model);
}