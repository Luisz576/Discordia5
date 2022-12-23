import 'package:discordia5/models/db_model.dart';
import 'package:firebase_database/firebase_database.dart';

class DUser extends DBModel{
  late String id,
    username,
    nickname = "",
    imageUrl = "";

  DUser(this.id, this.username, this.imageUrl, this.nickname);
  DUser.fromDBModel(DataSnapshot model) : super.fromDBModel(model){
    id = model.child('id').value!.toString();
    username = model.child('username').value!.toString();
    nickname = model.child('nickname').value!.toString();
    imageUrl = model.child('imageUrl').value == null ? "" : model.child('imageUrl').value!.toString();
  }
  factory DUser.empty(){
    return DUser("", "", "", "");
  }
}