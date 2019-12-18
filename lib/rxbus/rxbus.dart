import 'package:rxdart/rxdart.dart';

//消息转这里在转出去的dart
class RxBus {
  static final RxBus _instance = RxBus._internal();

  RxBus._internal();

  factory RxBus() => _instance;

  Subject<Object> _subject = PublishSubject();

  Observable toObservable() {
    return _subject.stream;
  }

  void post(Object event) {
    if (_subject.hasListener) {
      _subject.add(event);
    }
  }
}
