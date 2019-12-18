import 'package:xlive/session/session.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/const/const_shared.dart';

import 'login_manager.dart';

import 'dart:async';
import 'dart:convert';

//提示有没有人请求关联之类的
class AssociationRequestManager {
  static AssociationRequestManager _manager =
      AssociationRequestManager._internal();

  AssociationRequestManager._internal();

  factory AssociationRequestManager() {
    return _manager;
  }

  Log log = LogFactory().getLogger(Log.DEBUG, 'AssociationRequestManager');

  final List<HomeCenterNotification> _notifications = List();

  List<HomeCenterNotification> get associations {
    final List<HomeCenterNotification> temp = List();
    for (var notification in _notifications) {
      if (notification.type == HomeCenterNotification.REQUEST ||
          notification.type == HomeCenterNotification.INVITATION) {
        temp.add(notification);
      }
    }
    return temp;
  }

  HomeCenterNotification get notificationToShown {
    for (var notification in _notifications) {
      if (notification.type == HomeCenterNotification.REQUEST ||
          notification.type == HomeCenterNotification.INVITATION) {
        if (notification.showInMain) {
          return notification;
        }
      }
    }
    return null;
  }

  StreamSubscription _subscription;

  void start() {
    final String methodName = 'start';
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is AssociationMessage)
        .listen((message) {
      final AssociationMessage msg = message as AssociationMessage;
      final int type = msg.eventType;
      final String homeCenterUuid = msg.deviceUuid;

      log.d('association message type: $type', methodName);

      HomeCenterNotification notification;

      switch (type) {
        case REQUEST_APPROVE_REJECT:
          notification =
              _findRequestToHomeCenterNotification2(homeCenterUuid, msg.user);
          if (notification == null) {
            notification = HomeCenterNotification.initWithAssociationMessage(
                HomeCenterNotification.REQUEST, true, message);
            add(notification);
          } else {
            _notifications.remove(notification);
            add(notification);
          }
          RxBus().post(notification);
          break;
        case REQUEST_APPROVE_OTHERS:
        case REQUEST_REJECT_OTHERS:
        case CANCEL_OTHERS:
        case REQUEST_SHARE_AUTO:
        case REQUEST_SHARE_AUTO_OTHERS:
        case APPROVE_REQUEST:
        case REJECT_REQUEST:
          notification =
              _findRequestToHomeCenterNotification2(homeCenterUuid, msg.user);
          if (notification != null) {
            _notifications.remove(notification);
            RxBus().post(notification);
          }
          break;
        // case AssociationMessage.REQUEST_CANCEL:
        // case AssociationMessage.CANCEL:
        // case AssociationMessage.CANCEL_OTHERS:
        // case AssociationMessage.REQUEST_REJECT:
        // case AssociationMessage.APPROVE_REQUEST:
        // case AssociationMessage.REJECT_REQUEST:
        // case AssociationMessage.REQUEST_SHARE_AUTO:
        // case AssociationMessage.REQUEST_SHARE_AUTO_OTHERS:
        //   notification = _findNewHomeCenterNotification(homeCenterUuid);
        //   if (notification != null) {
        //     _notifications.remove(notification);
        //     RxBus().post(notification);
        //   }
        //   notification = _findRequestToHomeCenterNotification2(homeCenterUuid, msg.user);
        //   if (notification != null) {
        //     _notifications.remove(notification);
        //     RxBus().post(notification);
        //   }
        //   break;
        // case AssociationMessage.REQUEST_APPROVE:
        //   notification = _findNewHomeCenterNotification(homeCenterUuid);
        //   if (notification != null) {
        //     _notifications.remove(notification);
        //     RxBus().post(notification);
        //   }
        //   notification = _findInvitationToNewHomeCenterNotification1(homeCenterUuid);
        //   if (notification != null) {
        //     _notifications.remove(notification);
        //     RxBus().post(notification);
        //   }
        //   break;
        case SHARE_ACCEPT_DECLINE:
          notification = _findNewHomeCenterNotification(homeCenterUuid);
          if (notification != null) {
            _notifications.remove(notification);
          }
          notification = _findInvitationToNewHomeCenterNotification2(
              homeCenterUuid, message.by);
          if (notification != null) {
            _notifications.remove(notification);
            add(notification);
          } else {
            notification =
                _findInvitationToNewHomeCenterNotification1(homeCenterUuid);
            if (notification != null) {
              _notifications.remove(notification);
            }
            notification = HomeCenterNotification.initWithAssociationMessage(
                HomeCenterNotification.INVITATION, true, message);
          }
          RxBus().post(notification);
          break;
        case SHARE_ACCEPT:
        case SHARE_DECLINE:
          notification =
              _findInvitationToNewHomeCenterNotification1(homeCenterUuid);
          if (notification != null) {
            _notifications.remove(notification);
            RxBus().post(notification);
          }
          break;
      }
    });
  }

  void stop() {
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void add(HomeCenterNotification notification) {
    final HomeCenterNotification exist =
        _findHomeCenterNotification(notification);
    if (exist != null) return;
    _notifications.insert(0, notification);
  }

  void initHomeCenterAssociationMessage(
      String homeCenterUuid, String homeCenterName) {
    final String methodName = 'initHomeCenterAssociationMessage';
    final String token = LoginManager().token;
    if (token == '') return;
    HttpProxy.getRosterOfOtherUser(token, homeCenterUuid).then((response) {
      //var body = json.decode(response.body);
      var body = json.decode(DECODER.convert(response.bodyBytes));
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        var rosters = body[API_ROSTER];
        if (rosters == null || rosters.length == 0) return;
        for (var roster in rosters) {
          var groups = roster[API_ROSTER_GROUPS];
          if (groups.contains(ROSTER_GROUP_USER)) {
            final int type = roster[API_ROSTER_TYPE];
            if (type == ASSOCIATION_TYPE_FROM) {
              String nickname = roster[API_ROSTER_NICKNAME];
              final String username = roster[API_ROSTER_USERNAME];
              if (nickname == null || nickname == '') {
                nickname = username;
              }
              final AssociationMessage message = AssociationMessage(
                  username,
                  username,
                  nickname,
                  nickname,
                  homeCenterUuid,
                  homeCenterName,
                  ASSOCIATION_ACTION_REQUEST,
                  REQUEST_APPROVE_REJECT);
              final HomeCenterNotification notification =
                  HomeCenterNotification.initWithAssociationMessage(
                      HomeCenterNotification.REQUEST, false, message);
              add(notification);
            }
          }
        }
      }
    }).catchError((e) {
      log.e('GET ROSTER ERROR: ${e.toString()}', methodName);
    });
  }

  HomeCenterNotification _findHomeCenterNotification(
      HomeCenterNotification notification) {
    if (notification.type == HomeCenterNotification.NEW_HOME_CENTER) {
      for (var exist in _notifications) {
        if (exist.type != HomeCenterNotification.NEW_HOME_CENTER) continue;
        if (exist.homeCenterUuid == notification.homeCenterUuid) {
          return exist;
        }
      }
    } else if (notification.type == HomeCenterNotification.REQUEST) {
      for (var exist in _notifications) {
        if (exist.type != HomeCenterNotification.REQUEST) continue;
        if (exist.message.by == notification.message.by &&
            exist.message.deviceUuid == notification.message.deviceUuid) {
          return exist;
        }
      }
    } else if (notification.type == HomeCenterNotification.INVITATION) {
      for (var exist in _notifications) {
        if (exist.type != HomeCenterNotification.INVITATION) continue;
        if (exist.message.deviceUuid == notification.message.deviceUuid &&
            exist.message.by == notification.message.by &&
            exist.message.user == notification.message.user) {
          return exist;
        }
      }
    } else {
      return null;
    }
    return null;
  }

  HomeCenterNotification _findNewHomeCenterNotification(String homeCenterUuid) {
    for (var notification in _notifications) {
      if (notification.type == HomeCenterNotification.NEW_HOME_CENTER &&
          notification.homeCenterUuid == homeCenterUuid) {
        return notification;
      }
    }
    return null;
  }

  // HomeCenterNotification _findRequestToHomeCenterNotification1(String homeCenterUuid) {
  //   for (var notification in _notifications) {
  //     if (notification.type == HomeCenterNotification.REQUEST &&
  //         notification.homeCenterUuid == homeCenterUuid) {
  //       return notification;
  //     }
  //   }
  //   return null;
  // }

  HomeCenterNotification _findRequestToHomeCenterNotification2(
      String homeCenterUuid, String username) {
    final String methodName = 'findRequestToHomeCenterNotification2';
    for (var notification in _notifications) {
      if (notification.type == HomeCenterNotification.REQUEST &&
          notification.message.deviceUuid == homeCenterUuid &&
          notification.message.user == username) {
        return notification;
      }
    }
    return null;
  }

  HomeCenterNotification _findInvitationToNewHomeCenterNotification1(
      String homeCenterUuid) {
    for (var notification in _notifications) {
      if (notification.type == HomeCenterNotification.INVITATION &&
          notification.homeCenterUuid == homeCenterUuid) {
        return notification;
      }
    }
    return null;
  }

  HomeCenterNotification _findInvitationToNewHomeCenterNotification2(
      String homeCenterUuid, String username) {
    for (var notification in _notifications) {
      if (notification.type == HomeCenterNotification.INVITATION &&
          notification.homeCenterUuid == homeCenterUuid &&
          notification.message.user == username) {
        return notification;
      }
    }
    return null;
  }
}

class HomeCenterNotification {
  static const int NEW_HOME_CENTER = 0;
  static const int REQUEST = 1;
  static const int INVITATION = 2;

  AssociationMessage _message;
  AssociationMessage get message => _message;

  String _homeCenterUuid;
  String get homeCenterUuid => _homeCenterUuid;

  String _homeCenterName;
  String get homeCenterName => _homeCenterName;

  final int _type;
  int get type => _type;

  bool _isNew;
  bool get isNew => _isNew;
  set isNew(bool isNew) => _isNew = isNew;

  //是否要在场景和设备页面显示
  bool _showInMain;
  bool get showInMain => _showInMain;
  set showInMain(bool showInMain) => _showInMain = showInMain;

  HomeCenterNotification.initWithAssociationMessage(
      this._type, this._showInMain, this._message);

  HomeCenterNotification.initWithHomeCenter(
      this._type, this._showInMain, this._homeCenterUuid, this._homeCenterName);
}
