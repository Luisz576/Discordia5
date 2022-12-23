import 'dart:async';

import 'package:discordia5/models/list_callbacks.dart';
import 'package:discordia5/types/listenable_list_stream_function.dart';
import 'package:discordia5/types/simple_function.dart';

class ListenableListStream<T>{
  StreamSubscription? _stream;
  final List<T> _lastGet = [];
  final ListCallbacks _callbacks = ListCallbacks();

  set init(StreamSubscription stream) => _stream ??= stream;
  set initByFunc(ListenableListStreamFunction<T> streamFunc) {
    _stream ??= streamFunc(_update);
  }

  void _update(List<T> values){
    _lastGet.clear();
    _lastGet.addAll(values);
    _callbacks();
  }

  List<T> get lastGet => List.unmodifiable(_lastGet);

  void registerListener(SimpleFunction listener){
    _callbacks << listener;
  }
  void unregisterListener(SimpleFunction listener){
    _callbacks >> listener;
  }
}