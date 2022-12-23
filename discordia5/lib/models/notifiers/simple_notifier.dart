import 'package:flutter/cupertino.dart';

class SimpleNotifier<T>{
  late final ValueNotifier<T> notifier;

  SimpleNotifier(T initialValue){
    notifier = ValueNotifier(initialValue);
  }
}