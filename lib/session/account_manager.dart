import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/const/const_shared.dart';

import 'dart:convert';

const int ACCOUNT_BIND_TYPE_MOBILE = 0;
const int ACCOUNT_BIND_TYPE_EMAIL = 1;
const int ACCOUNT_BIND_TYPE_WECHAT = 2;
const int ACCOUNT_BIND_TYPE_QQ = 3;

//登入  绑定手机  邮箱之类的 用户名 昵称 微信
class AccountManager {
  Log log = LogFactory().getLogger(Log.DEBUG, 'AccountManager');

  static AccountManager _manager = AccountManager._internal();

  AccountManager._internal();

  factory AccountManager() {
    return _manager;
  }

  void clear() {
    _username = '';
    _nickname = '';
    _mobile = '';
    _email = '';
    _emailConfirmed = false;
    _qqOpenId = '';
    _wechatOpenId = '';
  }

  String _username = '';
  String _token = '';
  String get username => _username;
  set username(String username) => _username = username;

  String _nickname = '';
  String get nickname => _nickname;
  set nickname(String nickname) => _nickname = nickname;

  String _mobile = '';
  String get mobile => _mobile;
  set mobile(String mobile) => _mobile = mobile;

  bool get mobileBinded => _mobile != '';

  bool _receiveMessageViaMobile = false;
  bool get receiveMessageViaMobile => _receiveMessageViaMobile;
  set receiveMessageViaMobile(bool receiveMessageViaMobile) =>
      _receiveMessageViaMobile = receiveMessageViaMobile;

  String _email = '';
  String get email => _email;
  set email(String email) => _email = email;

  bool get emailBinded => _email != '';

  bool _emailConfirmed = false;
  bool get emailConfirmed => _emailConfirmed;
  set emailConfirmed(bool emailConfirmed) => _emailConfirmed = emailConfirmed;

  bool _receiveMessageViaEmail = false;
  bool get receiveMessageViaEmail => _receiveMessageViaEmail;
  set receiveMessageViaEmail(bool receiveMessageViaEmail) =>
      _receiveMessageViaEmail = receiveMessageViaEmail;

  String _qqOpenId = '';
  String get qqOpenId => _qqOpenId;
  set qqOpenId(String qqOpenId) => _qqOpenId = qqOpenId;

  bool get qqBinded => _qqOpenId != '';

  String _wechatOpenId = '';
  String get wechatOpenId => _wechatOpenId;
  set wechatOpenId(String wechatOpenId) => _wechatOpenId = wechatOpenId;

  bool get wechatBinded => _wechatOpenId != '';

  bool _receiveMessageViaWechat = false;
  bool get receiveMessageViaWechat => _receiveMessageViaWechat;
  set receiveMessageViaWechat(bool receiveMessageViaWechat) =>
      _receiveMessageViaWechat = receiveMessageViaWechat;

  void refreshAccountInformation() {
    final String methodName = 'refreshAccountInformation';
    HttpProxy.getUserInformation(_token, _username, null).then((response) {
      var body = json.decode(DECODER.convert(response.bodyBytes));
      print(body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        if (body[API_NAME] != null) {
          _nickname = body[API_NAME];
        }
        if (body[API_MOBILE] != null && body[API_MOBILE] != '') {
          _mobile = body[API_MOBILE];
        }
        if (body[API_EMAIL] != null && body[API_EMAIL] != '') {
          _email = body[API_EMAIL];
          _emailConfirmed = body[API_EMAIL_CONFIRMED];
        }
        if (body[API_OPEN_IDS] != null) {
          var openIds = body[API_OPEN_IDS];
          for (var openId in openIds) {
            final String idType = openId[API_ID_TYPE];
            if (idType == ID_TYPE_QQ) {
              _qqOpenId = openId[API_OPEN_ID];
            }
            if (idType == ID_TYPE_WECHAT) {
              _wechatOpenId = openId[API_OPEN_ID];
            }
          }
        }
      } else {
        log.w('get account information failed: $statusCode', methodName);
      }
    }).catchError((e) {
      log.e("GET USER INFORMATION ERROR: ${e.toString()}", methodName);
    });

    HttpProxy.getNotificationConfiguration(_token, _username).then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        var notifications = body[API_NOTIFICATIONS];
        if (notifications != null) {
          for (var noti in notifications) {
            final String type = noti[API_TYPE];
            final bool enabled = noti[API_ENABLED];
            if (type == NOTIFICATION_TYPE_SMS) {
              _receiveMessageViaMobile = enabled;
            } else if (type == NOTIFICATION_TYPE_EMAIL) {
              _receiveMessageViaEmail = enabled;
            } else if (type == NOTIFICATION_TYPE_WECHAT) {
              _receiveMessageViaWechat = enabled;
            }
          }
        }
      } else {
        log.e('Get notification error: $statusCode', methodName);
      }
    }).catchError((e) {
      log.e(
          'GET NOTIFICATION CONFIGURATION ERROR: ${e.toString()}', methodName);
    });
  }

  void getAccountInformation(String token, String username) {
    _username = username;
    _token = token;
    refreshAccountInformation();
  }

  //set user nick name
  void setNickname(String token, String username, String nickname) {
    final String methodName = 'setNickname';
    if (username == '' || token == '') return;
    HttpProxy.setNickname(token, username, nickname).then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        this.nickname = nickname;
        getAccountInformation(token, username);
      } else {
        log.w('set nick name failed: $statusCode', methodName);
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  void setWechatNickname(
      String token, String username, String openId, String wechatToken) {
    final String methodName = 'setWechatNickname';
    HttpProxy.getWechatUserInformation(openId, wechatToken).then((response) {
      var body = json.decode(DECODER.convert(response.bodyBytes));
      if (body['errcode'] == null) {
        this._nickname = body['nickname'];
        setNickname(token, username, this._nickname);
        //TODO: 获取微信头像
      } else {
        log.e('Get wechat info failed: ${body['errorCode']}', methodName);
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  void setQQNickname(
      String token, String username, String openId, String qqToken) {
    final String methodName = 'setQQNickname';
    HttpProxy.getQQUserInformation(openId, qqToken).then((response) {
      var body = json.decode(DECODER.convert(response.bodyBytes));
      final int code = body['ret'];
      final String msg = body['msg'];
      if (code == 0) {
        this._nickname = body['nickname'];
        setNickname(token, username, this._nickname);
        //TODO: 获取QQ头像
      } else {
        log.e('Get qq info failed: $code *** $msg', methodName);
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }
}

class AccountBindEvent {
  final int type;

  AccountBindEvent({
    this.type,
  });
}
