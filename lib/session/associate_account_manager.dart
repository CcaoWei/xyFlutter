import 'package:xlive/log/log_shared.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/session/session.dart';

import 'login_manager.dart';

import 'dart:convert';

//app 我的家人  主人账号之类的
class AssociateAccountManager {
  static const String className = 'HomeCenterAssociateAccountManager';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  static final AssociateAccountManager _manager =
      AssociateAccountManager._internal();

  AssociateAccountManager._internal();

  factory AssociateAccountManager() {
    return _manager;
  }

  final Map<String, Map<String, Account>> _cacheMap = Map();

  Map<String, Map<String, Account>> get cacheMap => _cacheMap;

  void getAssociateAccoutOfHomeCenter(String homeCenterUuid) {
    final String methodName = 'getAssociateAccountOfHomeCenter';
    final String token = LoginManager().token;
    if (token == '') return;
    HttpProxy.getRosterOfOtherUser(token, homeCenterUuid).then((response) {
      //var body = json.decode(response.body);
      var body = json.decode(DECODER.convert(response.bodyBytes));
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        var rosters = body[API_ROSTER];
        if (rosters == null || rosters.length == 0) return;
        Map<String, Account> temp = Map();
        if (_cacheMap.containsKey(homeCenterUuid)) {
          temp = _cacheMap[homeCenterUuid];
        }
        for (var roster in rosters) {
          var groups = roster[API_ROSTER_GROUPS];
          if (groups.contains(ROSTER_GROUP_USER)) {
            final int type = roster[API_ROSTER_TYPE];
            if (type != ASSOCIATION_TYPE_BOTH) continue;
            final String username = roster[API_ROSTER_USERNAME];
            final String nickname = roster[API_ROSTER_NICKNAME];
            final Account account =
                Account(username: username, nickname: nickname);
            temp[username] = account;
          }
        }
        if (temp.length > 0) {
          _cacheMap[homeCenterUuid] = temp;
        }
      } else {
        log.e(
            'Get associate account of home center $homeCenterUuid failed: $statusCode',
            methodName);
      }
    }).catchError((e) {
      log.d('ERROR: ${e.toString()}', methodName);
    });
  }

  void start() {
    RxBus()
        .toObservable()
        .where((event) =>
            event is AssociationMessage &&
            (event.eventType == OTHERS_REMOVED ||
                event.eventType == REQUEST_APPROVE_OTHERS ||
                event.eventType == APPROVE_REQUEST))
        .listen((event) {
      final AssociationMessage msg = event as AssociationMessage;
      if (msg.eventType == OTHERS_REMOVED) {
        final String username = msg.user;
        final String homeCenterUuid = msg.deviceUuid;
        removeAccount(homeCenterUuid, username);
      } else if (msg.eventType == REQUEST_APPROVE_OTHERS ||
          msg.eventType == APPROVE_REQUEST) {
        final String username = msg.user;
        final String nickname = msg.userDisplayName;
        final String homeCenterUuid = msg.deviceUuid;
        addAccount(homeCenterUuid, username, nickname);
      }
    });
  }

  void removeAccount(String homeCenterUuid, String username) {
    if (_cacheMap.containsKey(homeCenterUuid)) {
      final Map<String, Account> tempMap = _cacheMap[homeCenterUuid];
      if (tempMap.containsKey(username)) {
        tempMap.remove(username);

        RxBus().post(UserAssociationEvent());
      }
    }
  }

  void addAccount(String homeCenterUuid, String username, String nickname) {
    if (_cacheMap.containsKey(homeCenterUuid)) {
      final Map<String, Account> tempMap = _cacheMap[homeCenterUuid];
      if (tempMap.containsKey(username)) {
        final Account exist = tempMap[username];
        if (exist.nickname != nickname) {
          exist.nickname = nickname;
          RxBus().post(UserAssociationEvent());
        }
      } else {
        final Account account = Account(username: username, nickname: nickname);
        tempMap[username] = account;
        RxBus().post(UserAssociationEvent());
      }
    } else {
      final Account account = Account(username: username, nickname: nickname);
      final Map<String, Account> map = Map();
      map[username] = account;
      _cacheMap[homeCenterUuid] = map;
      RxBus().post(UserAssociationEvent());
    }
  }

  int numberOfAssociateAccount(String homeCenterUuid) {
    if (_cacheMap.containsKey(homeCenterUuid)) {
      return _cacheMap[homeCenterUuid].length;
    }
    return 0;
  }

  List<Account> associateAccountOfHomeCenter(String homeCenterUuid) {
    final List<Account> temp = List();
    if (_cacheMap.containsKey(homeCenterUuid)) {
      for (var account in _cacheMap[homeCenterUuid].values) {
        temp.add(account);
      }
    }
    return temp;
  }

  String nickname(String username) {
    for (var accountMap in _cacheMap.values) {
      if (accountMap.containsKey(username)) {
        return accountMap[username].nickname;
      }
    }
    return '';
  }
}

class Account {
  final String username;
  String nickname;
  bool online;

  Account({
    this.username,
    this.nickname,
    this.online = true,
  });
}

class UserAssociationEvent {}
