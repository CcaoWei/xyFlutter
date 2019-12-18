import 'dart:async';
import 'dart:convert';

import 'http_service.dart';

import 'package:xlive/channel/method_channel.dart' as methodChannel;

const Utf8Decoder DECODER = Utf8Decoder();
const Utf8Encoder ENCODER = Utf8Encoder();

//http接口  和云端通讯    新接口接在这里面
class HttpProxy {
  static Future authenticate(String idType, String id, String credential,
      String deviceType, String deviceId, String verificationCodeId) async {
    final String path = '/users/authenticate';
    //final String clientId = await PLATFORM.invokeMethod('clientId', Map());
    final String clientId = await methodChannel.getClientId();
    var body = {
      'id_type': idType,
      'id': id,
      'credential': credential,
      'client_id': clientId,
      'device_type': deviceType,
      'device_id': deviceId,
      'verification_code_id': verificationCodeId
    };
    final String bodyString = json.encode(body);
    return HttpService.post(path, null, bodyString);
  }

  static Future register(
      String idType, String id, String credential, String verificationCodeId) {
    final String path = '/users';
    var body;
    if (verificationCodeId == null || verificationCodeId == '') {
      body = {'id_type': idType, 'id': id, 'credential': credential};
    } else {
      body = {
        'id_type': idType,
        'id': id,
        'credential': credential,
        'verification_code_id': verificationCodeId
      };
    }

    final String bodyString = json.encode(body);
    return HttpService.post(path, null, bodyString);
  }

  static Future setNickname(String token, String username, String nickname) {
    final String path = '/users/$username/name';
    var body = {
      //带body 新接口类似这种
      'name': nickname
    };
    final String bodyString = json.encode(body);
    return HttpService.patch(path, token, bodyString);
  }

  static Future getVerificationCode(String type, String pushType,
      String pushTarget, int length, int expireInSecond, String purpose) {
    final String path = '/verificationcodes';
    var body = {
      'type': type,
      'push_type': pushType,
      'push_target': pushTarget,
      'length': length,
      'expire_in_second': expireInSecond,
      'purpose': purpose
    };
    final String bodyString = json.encode(body);
    return HttpService.post(path, null, bodyString); // 新接口类似这种  模板是这个
  }

  static Future validateAccessToken(String username, String token) {
    final String path = '/users/$username/token';
    var body = {
      'username': username,
      'access_token': token,
    };
    final String bodyString = json.encode(body);
    return HttpService.post(path, token, bodyString);
  }

  static Future revokeAccessToken(String username, String token) {
    final String path = '/users/$username/token';
    var body = {
      'username': username,
      'access_token': token,
    };
    final String bodyString = json.encode(body);
    return HttpService.delete(path, token, bodyString);
  }

  static Future getRosterOfCurrentUser(String token) {
    final String path = '/users/~/roster';
    return HttpService.get(path, token, null);
  }

  static Future getRosterOfOtherUser(String token, String username) {
    final String path = '/users/$username/roster';
    return HttpService.get(path, token, null);
  }

  static Future changePassword(String token, String username,
      String currentPassword, String newPassword) {
    final String path = '/users/$username/password';
    var body = {
      'username': username,
      'current_password': currentPassword,
      'new_password': newPassword
    };
    final String bodyString = json.encode(body);
    return HttpService.patch(path, token, bodyString);
  }

  static Future resetPassword(String idType, String id, String verificationCode,
      String verificationCodeId, String password) {
    final String path = '/users/~/password';
    var body = {
      'id_type': idType,
      'id': id,
      'verification_code': verificationCode,
      'verification_code_id': verificationCodeId,
      'password': password
    };
    final String bodyString = json.encode(body);
    return HttpService.post(path, null, bodyString);
  }

  static Future getUserInformation(
      String token, String username, String idType) {
    final String path = '/users/$username';
    final String queryString = idType == null ? null : '?id_type=$idType';
    return HttpService.get(path, token, queryString);
  }

  static Future setUserLocalePreference(
      String token, String username, String locale) {
    final String path = '/users/$username/locale';
    var body = {
      'locale': locale,
    };
    final String bodyString = json.encode(body);
    return HttpService.post(path, token, bodyString);
  }

  static Future getWechatAccessToken(
      String appId, String secret, String code, String grantType) {
    final String path = '/sns/oauth2/access_token';
    final String queryString =
        '?appid=$appId&secret=$secret&code=$code&grant_type=$grantType';
    return HttpService.getFromServer(
        HttpService.WECHAT_SERVER, path, '', queryString);
  }

  static Future getWechatUserInformation(String openId, String token) {
    final String path = '/sns/userinfo';
    final String queryString = '?openid=$openId&access_token=$token';
    return HttpService.getFromServer(
        HttpService.WECHAT_SERVER, path, token, queryString);
  }

  static Future getQQUserInformation(String openid, String token) {
    final String path = '/user/get_user_info';
    final String queryString =
        '?openid=$openid&access_token=$token&oauth_consumer_key=1106951967';
    return HttpService.getFromServer(
        HttpService.QQ_SERVER, path, token, queryString);
  }

  static Future confirmMobile(String token, String username, String mobile,
      String verificationCode, String verificationCodeId) {
    final String path = '/users/$username/mobile';
    var body = {
      'mobile': mobile,
      'verification_code': verificationCode,
      'verification_code_id': verificationCodeId
    };
    final String bodyString = json.encode(body);
    return HttpService.post(path, token, bodyString);
  }

  static Future deleteMobile(String token, String username, String mobile) {
    final String path = '/users/$username/mobile';
    var body = {'mobile': mobile};
    final String bodyString = json.encode(body);
    return HttpService.delete(path, token, bodyString);
  }

  static Future addEmail(String token, String username, String email) {
    final String path = '/users/$username/email';
    var body = {'email': email};
    final String bodyString = json.encode(body);
    return HttpService.post(path, token, bodyString);
  }

  static Future confirmEmail(String token, String username, String email,
      String verificationCode, String verificationCodeId) {
    final String path = '/users/$username/email';
    var body = {
      'email': email,
      'verification_code': verificationCode,
      'verification_code_id': verificationCodeId
    };
    final String bodyString = json.encode(body);
    return HttpService.patch(path, token, bodyString);
  }

  static Future deleteEmail(String token, String username, String email) {
    final String path = '/users/$username/email';
    var body = {'email': email};
    final String bodyString = json.encode(body);
    return HttpService.delete(path, token, bodyString);
  }

  static Future associateOpenIdWithUsername(String token, String username,
      String idType, String openId, String accessToken) {
    final String path = '/users/$username/openid';
    var body = {
      'id_type': idType,
      'open_id': openId,
      'access_token': accessToken,
      'username': username
    };
    final String bodyString = json.encode(body);
    return HttpService.post(path, token, bodyString);
  }

  static Future unassociateOpenIdWithUsername(String token, String username,
      String idType, String openId, String accessToken) {
    final String path = '/users/$username/openid';
    var body = {
      'id_type': idType,
      'open_id': openId,
      'access_token': accessToken,
      'username': username
    };
    final String bodyString = json.encode(body);
    return HttpService.delete(path, token, bodyString);
  }

  static Future getNotificationConfiguration(String token, String username) {
    final String path = '/users/$username/notification';
    return HttpService.get(path, token, null);
  }

  static Future setNotificationConfiguration(
      String token, String username, String type, bool enabled) {
    final String path = '/users/$username/notification';
    var body = {'type': type, 'enabled': enabled};
    final String bodyString = json.encode(body);
    return HttpService.post(path, token, bodyString);
  }

  static Future getDeviceInformation(String token, String serial) {
    final String path = '/devices/$serial';
    return HttpService.get(path, token, null);
  }

  static Future associateHomeCenter(
      String token,
      String homeCenterUuid,
      String action,
      String user,
      String userDisplayName,
      String by,
      String byDisplayName,
      String deviceName) {
    final String path = '/devices/$homeCenterUuid/association';
    var body = {
      'action': action,
      'user': user,
      'user_display_name': userDisplayName,
      'by': by,
      'by_display_name': byDisplayName,
      'device_name': deviceName,
    };
    final String bodyString = json.encode(body);
    return HttpService.post(path, token, bodyString);
  }

  static Future getAndroidAppNewVersion(String currentVersion) {
    final String path = '/android';
    final String queryString =
        '?version=$currentVersion&hwversion=1.1&channel=stable';
    return HttpService.get(path, null, queryString);
  }
}
