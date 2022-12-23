import 'package:discordia5/models/d_user.dart';
import 'package:discordia5/models/db_model.dart';
import 'package:discordia5/enums/channel_type.dart';
import 'package:firebase_database/firebase_database.dart';

class Channel extends DBModel{
  late final String id, name, token, channel;
  late final ChannelType type;
  final List<DUser> usersConnected = [];
  Channel(this.id, this.name, this.type);
  Channel.fromDBModel(DataSnapshot model) : super.fromDBModel(model){
    id = model.child('id').value!.toString();
    name = model.child('name').value!.toString();
    type = model.child('type').value!.toString() == "voice" ? ChannelType.voice : ChannelType.chat;
    token = model.child('token').exists ? model.child('token').value!.toString() : "";
    channel = model.child('channel').exists ? model.child('channel').value!.toString() : "";
  }
}