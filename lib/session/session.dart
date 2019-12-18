import 'dart:convert';
import 'dart:async';
import 'dart:io' as io;

import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/mqtt/client.dart';
import 'package:xlive/protocol/message.pb.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';

import 'associate_account_manager.dart';
import 'association_request_manager.dart';

//管理账号
const int SESSION_STATE_NONE = 0;
const int SESSION_STATE_CONNECTED = 1;
const int SESSION_STATE_DISCONNECTED = 2;

class Session {
  static const String className = 'Session';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  String _username;
  String get username => _username;

  String _token;
  String get token => _token;

  String _loginPolicy;
  String get loginPolicy => _loginPolicy;

  String _server;
  String get server => _server;

  String _resource;
  String get resource => _resource;
  set resource(String resource) => _resource = resource;

  String _nickname;
  String get nickname => _nickname;
  set nickname(String nickname) => _nickname = nickname;

  Session(this._username, this._token, this._server, this._loginPolicy);

  String get sessionKey => _username + '@' + _server + ':' + _loginPolicy;

  static String makeSessionKey(
      String username, String server, String loginPolicy) {
    return username + '@' + server + ':' + loginPolicy;
  }

  int _state = SESSION_STATE_NONE;
  int get state => _state;

  Client _client;

  StreamSubscription _subscription;

  void start() {
    final String methodName = 'start';
    if (_state == SESSION_STATE_CONNECTED) return;
    if (_client == null) {
      _client = Client();
    }
    //如果支持本地登录，此处需要修改
    _client
        .connected(server, username, token, _onConnectionLost)
        .then((c) {
          log.d('session connect done, subscribe session message', methodName);
          log.d('connect response: ${c.toString()}', methodName);
          //
          //LoginManager().isLoginComplete = true;
          LoginManager().stage = LoginManager.STAGE_LOGIN_SUCCEED;
          RxBus().post(LoginEvent(LoginEvent.LOGIN_COMPLETE));

          _state = SESSION_STATE_CONNECTED;

          final SessionStateChangedEvent event = SessionStateChangedEvent(
            state: SESSION_STATE_CONNECTED,
          );
          RxBus().post(event);

          _client.subscribeSessionMessage(username);
          getSessionHomeCenters();
        })
        .catchError((e) => log.e('ERROR: ${e.toString()}', methodName),
            test: (e) => e is io.SocketException)
        .catchError((mqttErr) {
          LoginManager().stage = LoginManager.STAGE_LOGIN_FAILED;
          log.e('ERROR: ${mqttErr.toString()}', methodName);
        });

    _subscription = RxBus()
        .toObservable()
        .where((message) =>
            (message is DeviceAssociationNotificationMessage &&
                message.username == _username) ||
            message is DeviceAssociationNotificationEvent)
        .listen((message) {
      if (message is DeviceAssociationNotificationMessage) {
        _processDeviceAssocationNotificationMessage(message);
      } else if (message is DeviceAssociationNotificationEvent) {
        _processDeviceAssociationNotificationEvent(message);
      }
    });
  }

  void _reconnect() {
    final String methodName = 'reconnect';
    log.d('reconnect', methodName);
    if (_client == null) {
      log.w('client is null, return', methodName);
      return;
    }
    _client
        .connected(server, username, token, _onConnectionLost)
        .then((response) {
      log.d('reconnect response: ${response.toString()}', methodName);
      _state = SESSION_STATE_CONNECTED;

      final SessionStateChangedEvent event = SessionStateChangedEvent(
        state: SESSION_STATE_CONNECTED,
      );
      RxBus().post(event);

      _client.subscribeSessionMessage(username);

      for (HomeCenter homeCenter in HomeCenterManager().homeCenters.values) {
        if (homeCenter.state == ASSOCIATION_TYPE_BOTH) {
          _client.subscribePeerMessage(homeCenter.uuid);
        }
      }
    }).catchError((e) {
      log.e('CONNECT ERROR: ${e.toString()}', methodName);
      Timer(const Duration(seconds: 10), () {
        _reconnect();
      });
    });
  }

  void stop() {
    if (_client != null) {
      _client.disconnected();
      _client = null;
    }
    if (_subscription != null) {
      _subscription.cancel();
    }
    for (HomeCenter homeCenter in HomeCenterManager().homeCenters.values) {
      var cache = HomeCenterManager().getHomeCenterCache(homeCenter.uuid);
      cache.goOffline();
    }
  }

  void _onConnectionLost() {
    final String methodName = 'onConnectLost';
    log.d('connection to websocket is lost!', methodName);
    _state = SESSION_STATE_DISCONNECTED;

    final SessionStateChangedEvent event = SessionStateChangedEvent(
      state: SESSION_STATE_DISCONNECTED,
    );
    RxBus().post(event);

    log.d('try to reconnect', methodName);
    _reconnect();
  }

  //获取当前帐号关联的家庭中心
  void getSessionHomeCenters() {
    if (_loginPolicy == LOGIN_POLICY_LOCAL) {
      print(
          "the session is local mode, subscribe all peers (${HomeCenterManager().homeCenters.length}) now");
      for (var hc in HomeCenterManager().homeCenters.values) {
        if (hc.state == ASSOCIATION_TYPE_BOTH) {
          print("subscribe peer ${hc.uuid} now");
          _client.subscribePeerMessage(hc.uuid);
        } else {
          print("skip peer ${hc.uuid} now, state ${hc.state}");
        }
      }
      return;
    }
    final String methodName = 'getSessionHomeCenters';
    HttpProxy.getRosterOfCurrentUser(token).then((response) {
      //var body = json.decode(response.body);
      var body = json.decode(DECODER.convert(response.bodyBytes));
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode != HTTP_STATUS_CODE_OK) return;
      //_nickname = body[API_NICKNAME];
      var rosters = body[API_ROSTER];
      if (rosters == null || rosters.length == 0) {
        //LoginManager().isGetDataComplete = true;
        LoginManager().stage = LoginManager.STAGE_NO_ASSOCIATED_HOME_CENTER;
        RxBus().post(LoginEvent(LoginEvent.NO_HOME_CENTER));
        return;
      }
      for (var roster in rosters) {
        var groups = roster[API_ROSTER_GROUPS];
        if (groups.contains(ROSTER_GROUP_GATEWAY)) {
          final String nickname = roster[API_ROSTER_NICKNAME];
          String name = roster[API_ROSTER_USERNAME]; //家庭中心的名称，先给默认值uuid
          final int type = roster[API_ROSTER_TYPE];
          final String username = roster[API_ROSTER_USERNAME];

          if (type == ASSOCIATION_TYPE_BOTH || type == ASSOCIATION_TYPE_TO) {
            name = nickname;
          } else if (type == ASSOCIATION_TYPE_FROM) {
            //当网关作为用户的好友时，并且关联状态为From时, 获取到的列表中Nickname格式为(他人分享)
            //Nickname = request.By + "|" + request.ByDisplayName + "|" + request.DeviceName
            if (nickname.isNotEmpty) {
              final List<String> names = nickname.split('|');
              name = names.elementAt(2);
              final String by = names.elementAt(0);
              final String byDisplayName = names.elementAt(1);
              final AssociationMessage message = AssociationMessage(
                  by,
                  '',
                  byDisplayName,
                  '',
                  username,
                  name,
                  ASSOCIATION_ACTION_SHARE,
                  SHARE_ACCEPT_DECLINE);
              final HomeCenterNotification notification =
                  HomeCenterNotification.initWithAssociationMessage(
                      HomeCenterNotification.INVITATION, false, message);
              AssociationRequestManager().add(notification);
            }
          }
          final HomeCenter homeCenter = HomeCenter(uuid: username, name: name);
          homeCenter.state = type;
          log.d('add home center: ${homeCenter.uuid}', methodName);
          HomeCenterManager().addHomeCenter(homeCenter);

          if (type == ASSOCIATION_TYPE_BOTH) {
            log.d('subscribe peer messages: ${homeCenter.uuid}', methodName);
            _client.subscribePeerMessage(homeCenter.uuid);

            AssociateAccountManager()
                .getAssociateAccoutOfHomeCenter(homeCenter.uuid);
            AssociationRequestManager().initHomeCenterAssociationMessage(
                homeCenter.uuid, homeCenter.getName());
          }
        }
      }
      LoginManager().stage = LoginManager.STAGE_GET_ROSTER_SUCCEED;
      RxBus().post(LoginEvent(LoginEvent.GET_ROSTER_COMPLETE));
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  Future publishMessage(String homeCenterUuid, Message message) {
    assert(_client != null);
    if (_state != SESSION_STATE_CONNECTED) {
      return Future.error(null);
    }
    message.sender = username;
    return _client.publish(homeCenterUuid, message);
  }

  void _processDeviceAssocationNotificationMessage(
      DeviceAssociationNotificationMessage notification) {
    final String methodName = 'processDeviceAssocationNotificationMessage';
    final Message msg = notification.message;
    final DeviceAssociationNotification association = msg.deviceAssociation;
    final String user = association.user;
    final String by = association.by;
    final String deviceName = association.deviceName;
    final String deviceUuid = association.deviceUUID;
    final int action = association.action.value;
    final int type = association.status.value;
    final String byDisplayName = association.byDisplayName;
    final String userDisplayName = association.userDisplayName;

    log.d(
        'MESSAGE: \r\n user: $user \r\n userDisplayName: $userDisplayName \r\n by: $by \r\n byDisplayName: $byDisplayName \r\n deviceName: $deviceName \r\n deviceUuid: $deviceUuid \r\n action: $action \r\n type: $type',
        methodName);

    final AssociationMessage message = AssociationMessage(by, user,
        byDisplayName, userDisplayName, deviceUuid, deviceName, action, type);

    HomeCenter homeCenter = HomeCenterManager().getHomeCenter(deviceUuid);

    if (user == _username &&
        by == _username &&
        action == ASSOCIATION_ACTION_REQUEST &&
        type == ASSOCIATION_TYPE_TO) {
      message.eventType = REQUEST_CANCEL;
      //TODO: ???
      if (homeCenter == null) {
        homeCenter = HomeCenter(uuid: deviceUuid, name: deviceName);
      }

      HomeCenterManager().addHomeCenter(homeCenter);

      homeCenter.state = ASSOCIATION_TYPE_TO;
    } else if (user == _username &&
        by == _username &&
        action == ASSOCIATION_ACTION_CANCEL_REQUEST &&
        type == ASSOCIATION_TYPE_NONE) {
      message.eventType = CANCEL;

      if (homeCenter != null) {
        homeCenter.state = ASSOCIATION_TYPE_NONE;
      }
    } else if (user == _username &&
        by != _username &&
        action == ASSOCIATION_ACTION_SHARE &&
        type == ASSOCIATION_TYPE_FROM) {
      message.eventType = SHARE_ACCEPT_DECLINE;
    } else if (user == _username &&
        by != _username &&
        action == ASSOCIATION_ACTION_REJECT &&
        type == ASSOCIATION_TYPE_NONE) {
      message.eventType = REQUEST_REJECT;

      homeCenter.state = ASSOCIATION_TYPE_NONE;
    } else if (user == _username &&
        action == ASSOCIATION_ACRION_REMOVE &&
        type == ASSOCIATION_TYPE_NONE) {
      message.eventType = REMOVE;
      //TODO: 家庭中心被删除  需要相应处理
      if (deviceUuid == HomeCenterManager().defaultHomeCenterUuid) {
        message.isDefaultHomeCenterRemoved = true;
      }

      homeCenter.state = ASSOCIATION_TYPE_NONE;

      HomeCenterManager().removeHomeCenter(homeCenter.uuid);

      if (HomeCenterManager().defaultHomeCenterUuid == homeCenter.uuid) {
        HomeCenterManager().resetDefaultHomeCenterUuid();
      }
    } else if (user == _username &&
        by != _username &&
        action == ASSOCIATION_ACTION_APPROVE &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = REQUEST_APPROVE;

      if (homeCenter == null) {
        homeCenter = HomeCenter(uuid: deviceUuid, name: deviceName);
      }

      homeCenter.state = ASSOCIATION_TYPE_BOTH;

      HomeCenterManager().addHomeCenter(homeCenter);

      if (HomeCenterManager().defaultHomeCenterUuid == null) {
        HomeCenterManager().defaultHomeCenterUuid = homeCenter.uuid;
      }
      _client.subscribePeerMessage(homeCenter.uuid);
      AssociateAccountManager().getAssociateAccoutOfHomeCenter(homeCenter.uuid);
      AssociationRequestManager().initHomeCenterAssociationMessage(
          homeCenter.uuid, homeCenter.getName());
    } else if (user == _username &&
        by == _username &&
        action == ASSOCIATION_ACTION_ACCEPT &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = SHARE_ACCEPT;
    } else if (user == _username &&
        by == _username &&
        action == ASSOCIATION_ACTION_REQUEST &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = REQUEST_APPROVE;

      if (homeCenter == null) {
        homeCenter = HomeCenter(uuid: deviceUuid, name: deviceName);
      }

      homeCenter.state = ASSOCIATION_TYPE_BOTH;

      if (HomeCenterManager().defaultHomeCenterUuid == null) {
        HomeCenterManager().defaultHomeCenterUuid = homeCenter.uuid;
      }
      _client.subscribePeerMessage(homeCenter.uuid);
      AssociateAccountManager().getAssociateAccoutOfHomeCenter(homeCenter.uuid);
      AssociationRequestManager().initHomeCenterAssociationMessage(
          homeCenter.uuid, homeCenter.getName());
    } else if (user == _username &&
        by == _username &&
        action == ASSOCIATION_ACTION_DECLINE &&
        type == ASSOCIATION_TYPE_NONE) {
      message.eventType = SHARE_DECLINE;
    } else if (user == _username &&
        by == _username &&
        action == ASSOCIATION_ACTION_REQUEST &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = REQUEST_APPROVE;

      if (homeCenter == null) {
        homeCenter = HomeCenter(uuid: deviceUuid, name: deviceName);
      }

      homeCenter.state = ASSOCIATION_TYPE_BOTH;

      if (HomeCenterManager().defaultHomeCenterUuid == null) {
        HomeCenterManager().defaultHomeCenterUuid = homeCenter.uuid;
      }
      _client.subscribePeerMessage(homeCenter.uuid);
      AssociateAccountManager().getAssociateAccoutOfHomeCenter(homeCenter.uuid);
      AssociationRequestManager().initHomeCenterAssociationMessage(
          homeCenter.uuid, homeCenter.getName());
    } else if (user == _username &&
        by != _username &&
        action == ASSOCIATION_ACTION_SHARE &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = SHARE_ACCEPT;
    } else if (user != _username &&
        action == ASSOCIATION_ACRION_REMOVE &&
        type == ASSOCIATION_TYPE_NONE) {
      log.d('OTHERS_REMOVED', methodName);
      message.eventType = OTHERS_REMOVED;
    }

    RxBus().post(message);
  }

  void _processDeviceAssociationNotificationEvent(
      DeviceAssociationNotificationEvent event) {
    final String methodName = 'processDeviceAssociationNotificationEvent';
    final String by = event.event.by;
    final String user = event.event.user;
    final String deviceUuid = event.event.deviceUUID;
    final String deviceName = event.event.deviceName;
    final int action = event.event.action.value;
    final int type = event.event.status.value;
    final String userDisplayName = event.event.userDisplayName;
    final String byDisplayName = event.event.byDisplayName;

    log.d(
        'EVENT: \r\n user: $user \r\n userDisplayName: $userDisplayName \r\n by: $by \r\n byDisplayName: $byDisplayName \r\n deviceName: $deviceName \r\n deviceUuid: $deviceUuid \r\n action: $action \r\n type: $type',
        methodName);

    final AssociationMessage message = AssociationMessage(by, user,
        byDisplayName, userDisplayName, deviceUuid, deviceName, action, type);

    final HomeCenter homeCenter = HomeCenterManager().getHomeCenter(deviceUuid);

    if (user == _username &&
        action == ASSOCIATION_ACTION_REQUEST &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = REQUEST_APPROVE;
      homeCenter.state = ASSOCIATION_TYPE_BOTH;

      if (HomeCenterManager().defaultHomeCenterUuid == null) {
        HomeCenterManager().defaultHomeCenterUuid = homeCenter.uuid;
      }
      _client.subscribePeerMessage(homeCenter.uuid);
      AssociateAccountManager().getAssociateAccoutOfHomeCenter(homeCenter.uuid);
      AssociationRequestManager().initHomeCenterAssociationMessage(
          homeCenter.uuid, homeCenter.getName());
    } else if (user != _username &&
        by != _username &&
        action == ASSOCIATION_ACTION_CANCEL_REQUEST &&
        type == ASSOCIATION_TYPE_NONE) {
      log.d('CANCEL OTHERS', methodName);
      message.eventType = CANCEL_OTHERS;
    } else if (user != _username &&
        action == ASSOCIATION_ACTION_REQUEST &&
        type == ASSOCIATION_TYPE_TO) {
      message.eventType = REQUEST_APPROVE_REJECT;
    } else if (user != _username &&
        by != _username &&
        action == ASSOCIATION_ACTION_APPROVE &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = REQUEST_APPROVE_OTHERS;
    } else if (user != _username &&
        by != _username &&
        action == ASSOCIATION_ACTION_REJECT &&
        type == ASSOCIATION_TYPE_NONE) {
      message.eventType = REQUEST_REJECT_OTHERS;
    } else if (by == _username &&
        action == ASSOCIATION_ACTION_APPROVE &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = APPROVE_REQUEST;
    } else if (by == _username &&
        action == ASSOCIATION_ACTION_REJECT &&
        type == ASSOCIATION_TYPE_NONE) {
      message.eventType = REJECT_REQUEST;
    } else if (user != _username &&
        by == _username &&
        action == ASSOCIATION_ACTION_SHARE &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = REQUEST_SHARE_AUTO;
    } else if (user != _username &&
        by != _username &&
        action == ASSOCIATION_ACTION_SHARE &&
        type == ASSOCIATION_TYPE_BOTH) {
      message.eventType = REQUEST_SHARE_AUTO_OTHERS;
    } else if (user != _username &&
        action == ASSOCIATION_ACRION_REMOVE &&
        type == ASSOCIATION_TYPE_NONE) {
      log.d('OTHERS_REMOVED', methodName);
      message.eventType = OTHERS_REMOVED;
    }
    RxBus().post(message);
  }
}

const REQUEST_CANCEL = 1; //当前用户请求添加其他家庭中心
const REQUEST_APPROVE_REJECT = 2; //其他用户请求添加当前用户已添加的家庭中心
const SHARE_ACCEPT_DECLINE = 3; //其他用户分享家庭中心给当前用户
const CANCEL = 4; //当前用户取消已发送的添加家庭中心请求
const REQUEST_REJECT = 5; //当前用户请求添加家庭中心被其他用户拒绝
const REMOVE = 6; //a.家庭中心重置  b.当前用户自己删除家庭中心  c.其他用户解除当前用户与家庭中心的关联关系
const REQUEST_APPROVE = 7; //当前用户请求添加家庭中心，被其他用户同意或自动完成关联
const SHARE_ACCEPT = 8; //当前用户接受其他用户分享，或其他用户分享给当前用户自动同意
const SHARE_DECLINE = 9; //其他用户分享家庭中心给当前用户，被当前用户拒绝
const REQUEST_APPROVE_OTHERS = 10; //其他用户请求添加家庭中心被其他用户同意
const REQUEST_REJECT_OTHERS = 11; //其他用户请求添加家庭中心被其他用户拒绝
const CANCEL_OTHERS = 12; //其他用户请求添加家庭中心后取消
const APPROVE_REQUEST = 13; //当前用户同意其他用户请求
const REJECT_REQUEST = 14; //当前用户拒绝其他用户请求
const REQUEST_SHARE_AUTO = 15; //其他用户请求，当前用户邀请后自动同意
const REQUEST_SHARE_AUTO_OTHERS = 16; //其他用户请求，其他用户邀请后自动同意
const OTHERS_REMOVED = 17; //其他用户被其他用户删除

class AssociationMessage {
  final String _by;
  String get by => _by;

  final String _user;
  String get user => _user;

  final String _deviceUuid;
  String get deviceUuid => _deviceUuid;

  final String _deviceName;
  String get deviceName => _deviceName;

  final String _userDisplayName;
  String get userDisplayName => _userDisplayName;

  final String _byDisplayName;
  String get byDisplayName => _byDisplayName;

  final int _action;
  int get action => _action;

  final int _type;
  int get type => _type;

  int _eventType;
  int get eventType => _eventType;
  set eventType(int eventType) => _eventType = eventType;

  bool _isDefaultHomeCenterRemoved = false;
  bool get isDefaultHomeCenterRemoved => _isDefaultHomeCenterRemoved;
  set isDefaultHomeCenterRemoved(bool isDefaultHomeCenterRemoved) =>
      _isDefaultHomeCenterRemoved = isDefaultHomeCenterRemoved;

  AssociationMessage(
      this._by,
      this._user,
      this._byDisplayName,
      this._userDisplayName,
      this._deviceUuid,
      this._deviceName,
      this._action,
      this._type);
}

class SessionStateChangedEvent {
  final int state;

  SessionStateChangedEvent({
    this.state,
  });
}
