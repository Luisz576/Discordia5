import 'package:discordia5/models/d_user.dart';
import 'package:flutter/cupertino.dart';

class ConnectionNotifier extends ChangeNotifier{
  final ValueNotifier<List<DUser>> _dusers = ValueNotifier([]);

  List<DUser> get dusers => List.unmodifiable(_dusers.value);
  ValueNotifier<List<DUser>> get listenable => _dusers;

  updateConnections(List<DUser> dusers){
    _dusers.value.clear();
    _dusers.value.addAll(dusers);
  }
  connect(DUser duser){
    _dusers.value.add(duser);
  }
  disconnect(String userId){
    DUser? target;
    for(DUser duser in _dusers.value){
      if(duser.id == userId){
        target = duser;
        break;
      }
    }
    if(target == null){
      return;
    }
    _dusers.value.remove(target);
  }
}