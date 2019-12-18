import 'package:shared_preferences/shared_preferences.dart';

import 'package:xlive/session/session_manager.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/data/data_shared.dart';

import 'dart:convert';

import 'account_manager.dart';

//用户名和token
class LoginManager {
  //家庭中心不在线  或者 是否要不要登入进去
  LoginManager.internal();
  static final LoginManager _manager = LoginManager.internal();
  factory LoginManager() => _manager;

  static const int STAGE_ORIGIN = 0;
  static const int STAGE_NOT_AUTO_LOGIN = 1;
  static const int STAGE_AUTO_LOGIN_START = 2;
  static const int STAGE_TOKEN_VALIDATE_SUCCEED = 3;
  static const int STAGE_TOKEN_VALIDATE_FAILED = 4;
  static const int STAGE_LOGIN_SUCCEED = 5;
  static const int STAGE_LOGIN_FAILED = 6;
  static const int STAGE_NO_ASSOCIATED_HOME_CENTER = 7;
  static const int STAGE_GET_DATA_SUCCEED = 8;
  static const int STAGE_GET_DATA_FAILED = 9;
  static const int STAGE_GET_ROSTER_SUCCEED = 10;

  int stage = STAGE_ORIGIN;

  // bool _isLoginStart = false;
  // bool get isLoginStatrt => _isLoginStart;

  // bool _isLoginComplete = false;
  // bool get isLoginComplete => _isLoginComplete;
  // set isLoginComplete(bool isLoginComplete) => _isLoginComplete = isLoginComplete;

  //TODO:一般情况下只有一个家庭中心，则根据当前家庭中心是否获取完数据来判断进入主页面时间
  //当多于一个家庭中心时会有一个默认的家庭中心(自动设置或根据上一次退出app时的设置判断)，据此家庭中心判断进入主页面时间
  // bool _isGetDataComplete = false;
  // bool get isGetDataComplete => _isGetDataComplete;
  // set isGetDataComplete(bool isGetDataComplete) => _isGetDataComplete = isGetDataComplete;

  void start() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    final Set<String> keys = prefs.getKeys();
    for (var s in keys) {
      print('prefs -> $s');
    }

    if (keys.contains('defaultHomeCenterUuid')) {
      _defaultHomeCenterUuid = prefs.getString('defaultHomeCenterUuid');
      HomeCenterManager().defaultHomeCenterUuid = _defaultHomeCenterUuid;
    }

    if (keys.contains('username') && keys.contains('token')) {
      stage = STAGE_AUTO_LOGIN_START;

      final String username = prefs.getString('username');
      final String token = prefs.getString('token');
      HttpProxy.validateAccessToken(username, token).then((response) {
        var body = json.decode(response.body);
        final int statusCode = body[API_STATUS_CODE];
        if (statusCode == HTTP_STATUS_CODE_OK) {
          stage = STAGE_TOKEN_VALIDATE_SUCCEED;

          _token = token;
          _username = username;
          SessionManager()
              .startSession(username, token, CLOUD_SERVER, LOGIN_POLICY_CLOUD);
          //_isLoginStart = true;

          AccountManager().getAccountInformation(token, username);
        } else {
          stage = STAGE_TOKEN_VALIDATE_FAILED;
        }
      }).catchError((e) {
        print('ERROR: ${e.toString()}');
      });
    }
  }

  void reset() {
    //_isLoginStart = true;
    stage = STAGE_ORIGIN;
    //_isLoginComplete = false;
    //_isGetDataComplete = false;
    _verificationCodeId = null;
  }

  void removeStorage() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('username');
    await prefs.remove('token');
  }

  String _username;
  String get username => _username ?? '';

  String _token;
  String get token => _token ?? '';

  void storeUsernameAndToken(String username, String token) async {
    _username = username;
    _token = token;

    AccountManager().username = username;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', username);
    await prefs.setString('token', token);
  }

  void logout() {
    reset();
    removeStorage();
  }

  String _verificationCodeId;
  String get verificationCodeId => _verificationCodeId;
  set verificationCodeId(String verificationCodeId) =>
      _verificationCodeId = verificationCodeId;

  String _platform; //平台
  String get platform => _platform;
  set platform(String platform) => _platform = platform;

  double _systemVersion; //版本
  double get systemVersion => _systemVersion;
  set systemVersion(double systemVersion) => _systemVersion = systemVersion;

  int _channel;
  int get channel => _channel;
  set channel(int channel) => _channel = channel;

  bool get homekitEnabled =>
      _platform == PLATFORM_IOS && _channel == CHANNEL_HOMEKIT;

  String _defaultHomeCenterUuid;
  String get defaultHomeCenterUuid => _defaultHomeCenterUuid ?? '';

  void storeDefaultHomeCenterUuid(String homeCenterUuid) async {
    _defaultHomeCenterUuid = homeCenterUuid;

    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString('defaultHomeCenterUuid', homeCenterUuid);
  }
}

class LoginEvent {
  static const int LOGIN_COMPLETE = 0;
  static const int GET_DATA_COMPLETE = 1;
  static const int NO_HOME_CENTER = 2; //没有关联的家庭中心
  static const int GET_ROSTER_COMPLETE = 3; //没有关联的家庭中心

  final int _type;
  int get type => _type;

  LoginEvent(this._type);
}
