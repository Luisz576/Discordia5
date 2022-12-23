import 'dart:async';

typedef ListenableListStreamFunction<T> = StreamSubscription Function(Function(List<T>));