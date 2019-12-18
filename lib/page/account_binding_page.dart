import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/session/account_manager.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;
import 'package:xlive/rxbus/rxbus.dart';

import 'bind_mobile_page.dart';
import 'bind_email_page.dart';
import 'common_page.dart';

import 'dart:convert';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

class AccountBindingPage extends StatefulWidget {
  State<StatefulWidget> createState() => AccountBindingState();
}

class AccountBindingState extends State<AccountBindingPage> {
  static const String className = 'AccountBindingPage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  StreamSubscription subscription;

  void initState() {
    print("------------------------------account_binding_page.dart");
    super.initState();
    //start();
  }

  void didChangeDependencies() {
    super.didChangeDependencies();
    setState(() {});
  }

  void dispose() {
    super.dispose();
    if (subscription != null) {
      subscription.cancel();
    }
  }

  void start() {
    subscription = RxBus()
        .toObservable()
        .where((event) => event is AccountBindEvent)
        .listen((event) {
      setState(() {});
    });
  }

  void _deleteMobile() {
    final String methodName = 'deleteMobile';
    final String token = LoginManager().token;
    final String username = LoginManager().username;
    if (token.isEmpty || username.isEmpty) return;
    if (AccountManager().mobile.isEmpty) return;
    HttpProxy.deleteMobile(token, username, AccountManager().mobile)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        //_mobileBinded = false;
        AccountManager().mobile = '';
        setState(() {});
      } else {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': $statusCode',
        );
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  void _deleteEmail() {
    final String methodName = 'deleteEmail';
    final String token = LoginManager().token;
    final String username = LoginManager().username;
    if (token.isEmpty || username.isEmpty) return;
    if (AccountManager().email.isEmpty) return;
    HttpProxy.deleteEmail(token, username, AccountManager().email)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        var body = json.decode(response.body);
        final int statusCode = body[API_STATUS_CODE];
        if (statusCode == HTTP_STATUS_CODE_OK) {
          //_emailBinded = false;
          AccountManager().emailConfirmed = false;
          AccountManager().email = '';
          setState(() {});
        }
      } else {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': $statusCode',
        );
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  void _setNotificationConfiguration(String type, bool enabled) {
    final String methodName = 'setNotificationConfiguration';
    final String token = LoginManager().token;
    final String username = LoginManager().username;
    if (token.isEmpty || username.isEmpty) return;
    HttpProxy.setNotificationConfiguration(token, username, type, enabled)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
      } else {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': $statusCode',
        );
        if (type == NOTIFICATION_TYPE_SMS) {
          AccountManager().receiveMessageViaMobile = !enabled;
          setState(() {});
        } else if (type == NOTIFICATION_TYPE_EMAIL) {
          AccountManager().receiveMessageViaEmail = !enabled;
          setState(() {});
        } else if (type == NOTIFICATION_TYPE_WECHAT) {
          AccountManager().receiveMessageViaWechat = !enabled;
          setState(() {});
        }
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  void _unassociateOpenIdWithUsername(String idType, String openId) {
    final String methodName = 'unassociateOpenIdWithUsername';
    final String token = LoginManager().token;
    final String username = LoginManager().username;
    if (token.isEmpty || username.isEmpty) return;
    if (AccountManager().qqOpenId.isEmpty && idType == ID_TYPE_QQ) return;
    if (AccountManager().wechatOpenId.isEmpty && idType == ID_TYPE_WECHAT)
      return;
    HttpProxy.unassociateOpenIdWithUsername(
            token, username, idType, openId, null)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      final String message = body[API_MESSAGE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        if (idType == ID_TYPE_WECHAT) {
          //_wechatBinded = false;
          AccountManager().wechatOpenId = '';
          setState(() {});
        } else if (idType == ID_TYPE_QQ) {
          //_qqBinded = false;
          AccountManager().qqOpenId = '';
          setState(() {});
        }
      } else {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': $statusCode',
        );
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  void _associateOpenIdWithUsername(
      String idType, String openId, String accessToken) {
    final String methodName = 'asscociateOpenIdWithUsername';
    final String token = LoginManager().token;
    final String username = LoginManager().username;
    if (token.isEmpty || username.isEmpty) return;
    HttpProxy.associateOpenIdWithUsername(
            token, username, idType, openId, accessToken)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        if (idType == ID_TYPE_QQ) {
          //_qqBinded = true;
          AccountManager().qqOpenId = openId;
          setState(() {});
        } else if (idType == ID_TYPE_WECHAT) {
          //_wechatBinded = true;
          AccountManager().wechatOpenId = openId;
          setState(() {});
        }
      } else if (statusCode == HTTP_STATUS_CODE_CONFLICT) {
        if (idType == ID_TYPE_WECHAT) {
          Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).wechatBinded);
        } else if (idType == ID_TYPE_QQ) {
          Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).qqBinded);
        }
      } else {
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': $statusCode',
        );
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
  }

  void _bindWechat() async {
    final String methodName = 'bindWechat';
    try {
      //await channel.register(appId: APP_ID_WECHAT);
      await methodChannel.registerWechat(appId: APP_ID_WECHAT);
      methodChannel.wechatLogin(
          scope: 'snsapi_userinfo', state: 'xiaoyan_wechat');
      methodChannel.responseFromAuth.listen((response) {
        if (response.errCode == 0) {
          HttpProxy.getWechatAccessToken(
                  APP_ID_WECHAT,
                  '6fa36536b98d48e24cd7bc6c9eb3758e',
                  response.code,
                  'authorization_code')
              .then((response) {
            var body = json.decode(response.body);
            if (body['errcode'] == null) {
              final String openId = body['openid'];
              final String token = body['access_token'];
              log.d('wechat open id: $openId', methodName);
              log.d('wechat access token: $token', methodName);
              _associateOpenIdWithUsername(ID_TYPE_WECHAT, openId, token);
            }
          }).catchError((e) {
            log.e('ERROR: ${e.toString()}', methodName);
          });
        } else if (response.errCode == -2) {
          log.d('wechat login result: ${response.code}', methodName);
        } else {
          log.d('wechat login result: ${response.code}', methodName);
        }
      });
    } catch (e) {
      log.e('ERROR: ${e.toString()}', methodName);
    }
  }

  void _bindQQ() async {
    final String methodName = 'bindQQ';
    try {
      //FlutterQq.registerQQ(APP_ID_QQ);
      // final Map<String, String> args = Map();
      // args['appId'] = APP_ID_QQ;
      // PLATFORM.invokeMethod('registerQQ', args);
      methodChannel.registerQQ();
      //var qqResult = await PLATFORM.invokeMethod('qqLogin', Map());
      var qqResult = await methodChannel.qqLogin();
      final int code = qqResult['Code'];
      if (code == 0) {
        var response = qqResult['Response'];
        String accessToken = response['accessToken'];
        String openId = response['openid'];
        log.d('qq access token : $accessToken', methodName);
        log.d('qq open id: $openId', methodName);
        _associateOpenIdWithUsername(ID_TYPE_QQ, openId, accessToken);
      } else if (code == 1) {
        log.e('qq login failed', methodName);
      } else {
        log.e('qq login canceled', methodName);
      }
    } catch (e) {
      log.e('ERROR: ${e.toString()}', methodName);
    }
  }

  Widget build(BuildContext context) {
    final String methodName = 'build';
    return CommonPage(
      title: DefinedLocalizations.of(context).accountBinding,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    final String methodName = 'buildChild';
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 20.0, right: 20.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            Container(
              height: 90.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Image(
                        width: 33.0,
                        height: 33.0,
                        image: AssetImage('images/binding_mobile.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13.0),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text(
                            AccountManager().mobileBinded
                                ? DefinedLocalizations.of(context).binded
                                : DefinedLocalizations.of(context).notBind,
                            style: TEXT_STYLE_BINDING_STATE,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3.0),
                          ),
                          Offstage(
                            offstage: !AccountManager().mobileBinded,
                            child: Text(
                              AccountManager().mobile,
                              style: TEXT_STYLE_BINDING_ACCOUNT,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3.0),
                          ),
                          Offstage(
                            offstage: !AccountManager().mobileBinded,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: <Widget>[
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  padding: EdgeInsets.only(left: 0.0),
                                  child: Checkbox(
                                    value: AccountManager()
                                        .receiveMessageViaMobile,
                                    onChanged: (value) {
                                      AccountManager().receiveMessageViaMobile =
                                          value;
                                      setState(() {});
                                      _setNotificationConfiguration(
                                          NOTIFICATION_TYPE_SMS, value);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                ),
                                Text(
                                  DefinedLocalizations.of(context)
                                      .receiveMessageByMobile,
                                  style: TEXT_STYLE_BINDING_MESSAGE_TIP,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 84.0,
                    height: 26.0,
                    decoration: BOX_DECORATION_13,
                    child: CupertinoButton(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      color: Colors.white,
                      pressedOpacity: 0.7,
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      child: Text(
                        AccountManager().mobileBinded
                            ? DefinedLocalizations.of(context).clickToUnbind
                            : DefinedLocalizations.of(context).clickToBind,
                        style: TEXT_STYLE_BINDING_BUTTON,
                      ),
                      onPressed: () {
                        if (AccountManager().mobileBinded) {
                          showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  title: Text(
                                    DefinedLocalizations.of(context)
                                        .sureToDeleteMobile,
                                    style: TEXT_STYLE_ALERT_DIALOG_TITLE,
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text(
                                        DefinedLocalizations.of(context).cancel,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .maybePop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text(
                                        DefinedLocalizations.of(context).delete,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .maybePop();
                                        _deleteMobile();
                                      },
                                    ),
                                  ],
                                ),
                          );
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => BindMobilePage(),
                              settings: RouteSettings(
                                name: '/BindMobile',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1.0,
              color: const Color(0x33000000),
            ),
            Container(
              height: 90.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image(
                        width: 33.0,
                        height: 33.0,
                        image: AssetImage('images/binding_email.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13.0),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              Text(
                                AccountManager().emailBinded
                                    ? AccountManager().emailConfirmed
                                        ? DefinedLocalizations.of(context)
                                            .binded
                                        : DefinedLocalizations.of(context)
                                            .toBeConfirmed
                                    : DefinedLocalizations.of(context).notBind,
                                style: TEXT_STYLE_BINDING_STATE,
                              ),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                              ),
                              Offstage(
                                offstage: !AccountManager().emailBinded ||
                                    (AccountManager().emailBinded &&
                                        AccountManager().emailConfirmed),
                                child: CupertinoButton(
                                    minSize: 14.0,
                                    padding: EdgeInsets.only(),
                                    disabledColor: Colors.white,
                                    color: Colors.white,
                                    pressedOpacity: 1.0,
                                    child: Text(
                                      '(' +
                                          DefinedLocalizations.of(context)
                                              .getCode +
                                          ')',
                                      style: TEXT_STYLE_BINDING_GET_CODE,
                                    ),
                                    onPressed: () {
                                      HttpProxy.getVerificationCode(
                                              VERIFICATION_CODE_TYPE_NUMBER,
                                              NOTIFICATION_TYPE_EMAIL,
                                              AccountManager().email,
                                              LENGTH_VERIFICATION_CODE,
                                              EXPIRE_VRIFICATION_CODE,
                                              VERIFICATION_CODE_PURPOSE_CONFIRM)
                                          .then((response) {
                                        var body = json.decode(response.body);
                                        final int statusCode =
                                            body[API_STATUS_CODE];
                                        if (statusCode == HTTP_STATUS_CODE_OK) {
                                          Fluttertoast.showToast(
                                            msg:
                                                DefinedLocalizations.of(context)
                                                    .emailSend,
                                          );
                                        } else {
                                          Fluttertoast.showToast(
                                            msg:
                                                DefinedLocalizations.of(context)
                                                        .failed +
                                                    ': $statusCode',
                                          );
                                        }
                                      }).catchError((e) {
                                        log.e('ERROR: ${e.toString()}',
                                            methodName);
                                      });
                                    }),
                              ),
                            ],
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3.0),
                          ),
                          Offstage(
                            offstage: !AccountManager().emailBinded,
                            child: Text(
                              AccountManager().email,
                              style: TEXT_STYLE_BINDING_ACCOUNT,
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3.0),
                          ),
                          Offstage(
                            offstage: !(AccountManager().emailBinded &&
                                AccountManager().emailConfirmed),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  padding: EdgeInsets.only(left: 0.0),
                                  child: Checkbox(
                                    value:
                                        AccountManager().receiveMessageViaEmail,
                                    onChanged: (value) {
                                      AccountManager().receiveMessageViaEmail =
                                          value;
                                      setState(() {});
                                      _setNotificationConfiguration(
                                          NOTIFICATION_TYPE_EMAIL, value);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                ),
                                Text(
                                  DefinedLocalizations.of(context)
                                      .receiveMessageByEmail,
                                  style: TEXT_STYLE_BINDING_MESSAGE_TIP,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 84.0,
                    height: 26.0,
                    decoration: BOX_DECORATION_13,
                    child: CupertinoButton(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      color: Colors.white,
                      pressedOpacity: 0.7,
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      child: Text(
                        AccountManager().emailBinded
                            ? DefinedLocalizations.of(context).clickToUnbind
                            : DefinedLocalizations.of(context).clickToBind,
                        style: TEXT_STYLE_BINDING_BUTTON,
                      ),
                      onPressed: () {
                        if (AccountManager().emailBinded) {
                          showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  title: Text(
                                    DefinedLocalizations.of(context)
                                        .sureToDeleteEmail,
                                    style: TEXT_STYLE_ALERT_DIALOG_TITLE,
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text(
                                        DefinedLocalizations.of(context).cancel,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .maybePop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text(
                                        DefinedLocalizations.of(context).delete,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .maybePop();
                                        _deleteEmail();
                                      },
                                    ),
                                  ],
                                ),
                          );
                        } else {
                          Navigator.of(context).push(
                            CupertinoPageRoute(
                              builder: (context) => BindEmailPage(),
                              settings: RouteSettings(
                                name: '/BindEmail',
                              ),
                            ),
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1.0,
              color: const Color(0x33000000),
            ),
            Container(
              height: 90.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image(
                        width: 33.0,
                        height: 33.0,
                        image: AssetImage('images/binding_wechat.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13.0),
                      ),
                      Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            AccountManager().wechatBinded
                                ? DefinedLocalizations.of(context).binded
                                : DefinedLocalizations.of(context).notBind,
                            style: TEXT_STYLE_BINDING_STATE,
                          ),
                          Padding(
                            padding: EdgeInsets.only(top: 3.0),
                          ),
                          Offstage(
                            offstage: !AccountManager().wechatBinded,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.start,
                              children: [
                                Container(
                                  width: 20.0,
                                  height: 20.0,
                                  padding: EdgeInsets.only(left: 0.0),
                                  child: Checkbox(
                                    value: AccountManager()
                                        .receiveMessageViaWechat,
                                    onChanged: (value) {
                                      AccountManager().receiveMessageViaWechat =
                                          value;
                                      setState(() {});
                                      _setNotificationConfiguration(
                                          NOTIFICATION_TYPE_WECHAT, value);
                                    },
                                  ),
                                ),
                                Padding(
                                  padding: EdgeInsets.only(left: 5.0),
                                ),
                                Text(
                                  DefinedLocalizations.of(context)
                                      .receiveMessageByWechat,
                                  style: TEXT_STYLE_BINDING_MESSAGE_TIP,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  Container(
                    width: 84.0,
                    height: 26.0,
                    decoration: BOX_DECORATION_13,
                    child: CupertinoButton(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      color: Colors.white,
                      pressedOpacity: 0.7,
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      child: Text(
                        AccountManager().wechatBinded
                            ? DefinedLocalizations.of(context).clickToUnbind
                            : DefinedLocalizations.of(context).clickToBind,
                        style: TEXT_STYLE_BINDING_BUTTON,
                      ),
                      onPressed: () {
                        if (AccountManager().wechatBinded) {
                          showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  title: Text(
                                    DefinedLocalizations.of(context)
                                        .sureToDeleteWechat,
                                    style: TEXT_STYLE_ALERT_DIALOG_TITLE,
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text(
                                        DefinedLocalizations.of(context).cancel,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .maybePop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text(
                                        DefinedLocalizations.of(context).delete,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .maybePop();
                                        _unassociateOpenIdWithUsername(
                                            ID_TYPE_WECHAT,
                                            AccountManager().wechatOpenId);
                                      },
                                    ),
                                  ],
                                ),
                          );
                        } else {
                          _bindWechat();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
            Divider(
              height: 1.0,
              color: const Color(0x33000000),
            ),
            Container(
              height: 90.0,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Image(
                        width: 33.0,
                        height: 33.0,
                        image: AssetImage('images/binding_qq.png'),
                      ),
                      Padding(
                        padding: EdgeInsets.only(left: 13.0),
                      ),
                      Text(
                        AccountManager().qqBinded
                            ? DefinedLocalizations.of(context).binded
                            : DefinedLocalizations.of(context).notBind,
                        style: TEXT_STYLE_BINDING_STATE,
                      ),
                    ],
                  ),
                  Container(
                    width: 84.0,
                    height: 26.0,
                    decoration: BOX_DECORATION_13,
                    child: CupertinoButton(
                      padding: EdgeInsets.only(left: 0.0, right: 0.0),
                      color: Colors.white,
                      pressedOpacity: 0.7,
                      borderRadius: BorderRadius.all(Radius.circular(13.0)),
                      child: Text(
                        AccountManager().qqBinded
                            ? DefinedLocalizations.of(context).clickToUnbind
                            : DefinedLocalizations.of(context).clickToBind,
                        style: TEXT_STYLE_BINDING_BUTTON,
                      ),
                      onPressed: () {
                        if (AccountManager().qqBinded) {
                          showDialog(
                            context: context,
                            builder: (context) => CupertinoAlertDialog(
                                  title: Text(
                                    DefinedLocalizations.of(context)
                                        .sureToDeleteQQ,
                                    style: TEXT_STYLE_ALERT_DIALOG_TITLE,
                                  ),
                                  actions: <Widget>[
                                    CupertinoDialogAction(
                                      child: Text(
                                        DefinedLocalizations.of(context).cancel,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .maybePop();
                                      },
                                    ),
                                    CupertinoDialogAction(
                                      child: Text(
                                        DefinedLocalizations.of(context).delete,
                                      ),
                                      onPressed: () {
                                        Navigator.of(context,
                                                rootNavigator: true)
                                            .maybePop();
                                        _unassociateOpenIdWithUsername(
                                            ID_TYPE_QQ,
                                            AccountManager().qqOpenId);
                                      },
                                    ),
                                  ],
                                ),
                          );
                        } else {
                          _bindQQ();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
