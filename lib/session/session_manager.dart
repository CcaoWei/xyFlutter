import 'session.dart';
import 'network_status_manager.dart';

import 'package:xlive/rxbus/rxbus.dart';

import 'dart:async';

//账号list
class SessionManager {
  static final SessionManager _manager = SessionManager._internal();

  SessionManager._internal();

  factory SessionManager() {
    return _manager;
  }

  Map<String, Session> _sessions = Map();
  Map<String, Session> get sessions => _sessions;

  String _defaultSessionKey;

  StreamSubscription subscription;

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => event is NetworkStatusChangedEvent)
        .listen((event) {
      final NetworkStatusChangedEvent evt = event as NetworkStatusChangedEvent;
      if (evt.networkType == NETWORK_TYPE_NONE) {
        stopAllSessions();
      } else {
        startAllSessions();
      }
    });
  }

  void startSession(
      String username, String token, String server, String loginPolicy) {
    final String sessionKey =
        Session.makeSessionKey(username, server, loginPolicy);
    print('session key -> $sessionKey');
    _defaultSessionKey = sessionKey;
    if (_sessions.containsKey(sessionKey)) {
      final Session session = _sessions[sessionKey];
      print('session exist, restart');
      session.start();
    } else {
      final Session session = Session(username, token, server, loginPolicy);
      _sessions[sessionKey] = session;
      print('session not exist, start a new session ${username}');
      session.start();
    }
  }

  Session get defaultSession {
    if (_defaultSessionKey == null || _defaultSessionKey.isEmpty) return null;
    if (!sessions.containsKey(_defaultSessionKey)) return null;
    return sessions[_defaultSessionKey];
  }

  void startAllSessions() {
    for (Session session in _sessions.values) {
      session.start();
    }
  }

  void stopAllSessions() {
    for (var session in _sessions.values) {
      session.stop();
    }
  }

  void clearSessions() {
    stopAllSessions();
    _sessions.clear();
  }

  //是否登录过帐号 包扩本地帐号
  bool get hasSessions {
    for (Session session in _sessions.values) {
      if (session.state == SESSION_STATE_CONNECTED) return true;
    }
    return false;
  }
}
