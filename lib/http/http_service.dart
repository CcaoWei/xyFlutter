import 'dart:async';
import 'http.dart' as http;
import 'package:xlive/session/app_info_manager.dart';
import 'dart:convert';
import 'dart:ui';

import 'package:uuid/uuid.dart';

//http设置   如header  post put patch path之类的
class HttpService {
  static final String SERVER = 'https://api.xiaoyan.io';
  static final String WECHAT_SERVER = 'https://api.weixin.qq.com';
  static final String QQ_SERVER = 'https://graph.qq.com';

  static Map<String, String> _getHeader(String token) {
    final Map<String, String> map = Map();

    map['Authorization'] = 'Bearer $token';

    final String language =
        window.locale.languageCode + '-' + window.locale.countryCode;
    if (language != 'zh-CN') {
      language == 'en-US';
    }
    map['Accept-Language'] = language;

    if (AppInfoManager().httpAgent != '') {
      final String userAgent =
          '${AppInfoManager().httpAgent}; App/${AppInfoManager().version}';
      map['User-Agent'] = userAgent;
    }

    final String requestId = Uuid().v1();
    map['X-Request-Id'] = requestId;

    return map;
  }

  static Future get(String path, String token, String queryString) {
    String url;
    if (queryString == null) {
      url = SERVER + path;
    } else {
      url = SERVER + path + queryString;
    }
    return http.get(url, headers: _getHeader(token));
  }

  static Future getFromServer(
      String server, String path, String token, String queryString) {
    String url;
    if (queryString == null) {
      url = server + path;
    } else {
      url = server + path + queryString;
    }
    return http.get(url);
  }

  static Future post(String path, String token, String body) {
    final String url = SERVER + path;
    return http.post(url,
        headers: _getHeader(token), body: body, encoding: utf8);
  }

  static Future patch(String path, String token, String body) {
    final String url = SERVER + path;
    return http.patch(url,
        headers: _getHeader(token), body: body, encoding: utf8);
  }

  static Future put(String path, String token, String body) {
    final String url = SERVER + path;
    return http.put(url,
        headers: _getHeader(token), body: body, encoding: utf8);
  }

  static Future delete(String path, String token, String body) {
    final String url = SERVER + path;
    return http.delete(url,
        headers: _getHeader(token), body: body, encoding: utf8);
  }
}
