import 'package:discordia5/types/simple_function.dart';

class ListCallbacks{
  final List<SimpleFunction> _callbacks = [];

  int get length => _callbacks.length;

  void call(){
    for(SimpleFunction callback in _callbacks){
      callback();
    }
  }

  operator [](int index){
    return _callbacks[index];
  }
  operator <<(SimpleFunction callback){
    _callbacks.add(callback);
  }
  operator >>(SimpleFunction callback){
    _callbacks.remove(callback);
  }
}