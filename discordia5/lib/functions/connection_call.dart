class ConnectionCall<T>{
  Function(T)? _observer;

  void setObserver(Function(T) observer){
    _observer = observer;
  }

  void notify(T value){
    if(_observer != null){
      _observer!.call(value);
    }
  }
}