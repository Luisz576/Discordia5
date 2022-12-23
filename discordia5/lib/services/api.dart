import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:crypto/crypto.dart';
import 'package:discordia5/enums/agora_connection_event.dart';
import 'package:discordia5/models/channel.dart';
import 'package:discordia5/models/message.dart';
import 'package:discordia5/models/d_user.dart';
import 'package:discordia5/models/notifiers/simple_notifier.dart';
import 'package:discordia5/models/stream/listenable_list_stream.dart';
import 'package:discordia5/services/agora_connection.dart';
import 'package:discordia5/types/simple_function.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class Api{
  static DUser? _user;
  static SimpleFunction? logoutCallback;
  static bool _logged = false;
  // Login
  static void logout(){
    if(_connection.initialized){
      _connection.disconnect();
    }
    _user = null;
    _logged = false;
    if(logoutCallback != null){
      logoutCallback!();
    }
  }
  // this code is unsecure, is recommeded you change it!
  static Future<DUser?> login(String username, String password) async{
    username = username.toLowerCase().trim();
    if(_user != null){
      logout();
    }
    final users = (await FirebaseDatabase.instance.ref("dusers").get()).children;
    for(DataSnapshot snapshot in users){
      final data = await FirebaseDatabase.instance.ref("dusers/${snapshot.key}").get();
      if(data.child("username").value.toString() == username){
        if(data.child("password").value.toString() == md5.convert(utf8.encode(password)).toString()){
          _user = DUser.fromDBModel(data);
          _logged = true;
        }
      }
    }
    return _user;
  }
  static Future<bool> register(String username, String password, String imageUrl) async{
    username = username.toLowerCase().trim();
    if(_user != null){
      logout();
    }
    // this code is unsecure, is recommeded you change it
    if(await getUserModel(username) == null){
      final ref = FirebaseDatabase.instance.ref('dusers').push();
      ref.child("username").set(username);
      ref.child("nickname").set(username);
      ref.child("password").set(md5.convert(utf8.encode(password)).toString());
      ref.child("imageUrl").set(imageUrl);
      ref.child("id").set(ref.key);
      _user = DUser(ref.key!, username, imageUrl, username);
      _logged = true;
      return true;
    }
    return false;
  }
  static String getUserImage(){
    if(_user != null){
      return _user!.imageUrl;
    }
    return "";
  }
  static Future<DUser?> getUserModelById(String userId) async{
    final user = await FirebaseDatabase.instance.ref("dusers/$userId").get();
    if(user.exists){
      return DUser.fromDBModel(user);
    }
    return null;
  }
  static Future<DUser?> getUserModel(String username) async{
    username = username.toLowerCase().trim();
    final users = (await FirebaseDatabase.instance.ref("dusers").get()).children;
    for(DataSnapshot snapshot in users){
      final data = await FirebaseDatabase.instance.ref("dusers/${snapshot.key}").get();
      if(data.child('username').value.toString().toLowerCase() == username){
        return DUser.fromDBModel(data);
      }
    }
    return null;
  }
  // Message
  static void _sendMessage(Message message){
    FirebaseFirestore.instance.collection('dmessages').add(message.toMap());
  }
  static void sendMessage(String message){
    if(_user != null){
      _sendMessage(Message.message(_user!.id, message));
    }
  }
  static Stream<QuerySnapshot<Map<String, dynamic>>> getMessages(){
    return FirebaseFirestore.instance.collection('dmessages').snapshots();
  }
  static void sendMessageImage(XFile image, Function() error){
    if(_user != null){
      _uploadImage(image, (imageUrl) {
        _sendMessage(Message.image(_user!.id, imageUrl));
      }, error);
    }
  }
  static final ListenableListStream<Channel> _channels = ListenableListStream();
  static set channelsListenerRegister(SimpleFunction listener) => _channels.registerListener(listener);
  static set channelsListenerUnregister(SimpleFunction listener) => _channels.unregisterListener(listener);
  // this code is unsecure, is recommeded you change it!
  static List<Channel> getChannels(){
    _channels.initByFunc = (update) => FirebaseDatabase.instance.ref("dchannels").onValue.listen((event) {
      if(event.snapshot.value == null){
        update([]);
        return;
      }
      update(event.snapshot.children.map((c) => Channel.fromDBModel(c)).toList());
    });
    return _channels.lastGet;
  }
  // User utils
  static final ListenableListStream<DUser> _users = ListenableListStream();
  static set usersListenerRegister(SimpleFunction listener) => _users.registerListener(listener);
  static set usersListenerUnregister(SimpleFunction listener) => _users.unregisterListener(listener);
  // this code is unsecure, is recommeded you change it!
  static void initUsersListenerIfNot(){
    _users.initByFunc = (update) => FirebaseDatabase.instance.ref("dusers").onValue.listen((event) {
      List<DUser> listToUpdate = [];
      if(event.snapshot.value == null){
        update(listToUpdate);
        if(_user != null || _logged){
          logout();
        }
        return;
      }
      if(_user != null){
        bool deleted = true;
        for (var d in event.snapshot.children) {
          listToUpdate.add(DUser.fromDBModel(d));
          if(d.child("id").value.toString() == _user!.id){
            deleted = false;
          }
        }
        if(deleted){
          logout();
        }
      }else{
        listToUpdate.addAll(event.snapshot.children.map((d) => DUser.fromDBModel(d)).toList());
        if(_logged){
          logout();
        }
      }
      update(listToUpdate);
    });
  }
  static List<DUser> getUsers(){
    initUsersListenerIfNot();
    return _users.lastGet;
  }
  // this code is unsecure, is recommeded you change it!
  static void deleteUser(String id) async{
    FirebaseDatabase.instance.ref("dusers/$id").remove();
  }
  static void renameUser(String id, String nickname){
    if(nickname.isEmpty){
      return;
    }
    FirebaseDatabase.instance.ref("dusers/$id").update({
      "nickname": nickname.trim()
    });
  }
  static void changeUserImage(String id, XFile xfile){
    _uploadImage(xfile, (imageUrl) {
      FirebaseDatabase.instance.ref("dusers/$id").update({
        "imageUrl": imageUrl
      });
    }, (){});
  }
  // Image
  static void _uploadImage(XFile xfile, void Function(String imageUrl) onSuccess, void Function() onError){
    try{
      String ref = 'discordia5/${xfile.name}-${DateTime.now().toString()}.jpg';
      FirebaseStorage.instance.ref(ref).putFile(File(xfile.path)).whenComplete(() async{
        onSuccess(await FirebaseStorage.instance.ref(ref).getDownloadURL());
      });
    } on FirebaseException catch(_){
      onError();
    }
  }
  // Voice Call
  static final AgoraConnection _connection = AgoraConnection();
  static final SimpleNotifier<bool> isConnectedNotifier = SimpleNotifier(false);
  static final List<Function(List<DUser>)> _channelListeners = [];
  static Future initializeAgoraIfNot() async{
    if(_connection.initialized == false){
      await _connection.initialize();
      _connection.listener = (AgoraConnectionEvent event){
        if(event == AgoraConnectionEvent.join){
          isConnectedNotifier.notifier.value = true;
        }else if(event == AgoraConnectionEvent.leave){
          isConnectedNotifier.notifier.value = false;
        }
        for(Function(List<DUser>) func in _channelListeners){
          func(_connection.dusers);
        }
      };
    }
  }
  static Future connectChannel(String channelId, String token) async{
    if(_connection.connected){ return; }
    await _connection.connect(channelId, token);
  }
  static Future leaveChannel() async{
    if(_connection.initialized){
      await _connection.disconnect();
    }
  }
  static void addChannelListener(Function(List<DUser>) listener){
    _channelListeners.add(listener);
  }
  static void removeChannelListener(Function(List<DUser>) listener){
    _channelListeners.remove(listener);
  }
}