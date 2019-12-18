import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:xlive/channel/event_channel.dart';

import 'dart:convert';
import 'dart:io';
import 'dart:async';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/session/account_manager.dart';
import 'package:xlive/channel/method_channel.dart' as methodChannel;

import 'package:fluttertoast/fluttertoast.dart';

import 'mobile_login_page.dart';
import 'register_page.dart';
import 'home_page.dart';
import 'add_home_center_page.dart';
import 'package:xlive/homekit_page/homekit_main_page.dart';

class LoginPage extends StatefulWidget {
  State<StatefulWidget> createState() => LoginState();
}

class LoginState extends State<LoginPage> {
  static const String className = "LoginPage";
  final Log log = LogFactory().getLogger(Log.DEBUG, className);

  StreamSubscription _subscription;

  bool _wechatLoginStarted = false;
  bool _qqLoginStarted = false;

  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is LoginEvent || event is LocalServiceEvent)
        .listen((event) {
      if (event is LoginEvent) {
        final LoginEvent evt = event;
        if (evt.type == LoginEvent.GET_DATA_COMPLETE ||
            evt.type == LoginEvent.GET_ROSTER_COMPLETE ||
            evt.type == LoginEvent.NO_HOME_CENTER) {
          if (HomeCenterManager().homeCenters.length == 0) {
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => AddHomeCenterPage(showBackIcon: false),
                  settings: RouteSettings(
                    name: '/AddHomeCenter',
                  ),
                ),
                (route) => false);
          } else {
            _subscription.cancel();
            sleep(const Duration(milliseconds: 600));
            Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                CupertinoPageRoute(
                  builder: (context) => HomePage(),
                  settings: RouteSettings(
                    name: '/Home',
                  ),
                ),
                (route) => false);
          }
        }
      } else if (event is LocalServiceFoundEvent) {
        // Fluttertoast.showToast(
        //     msg: "found home center " + event.homeCenter.name);
        setState(() {});
      } else if (event is LocalServiceLostEvent) {
        // Fluttertoast.showToast(msg: "lost home center " + event.uuid);
        setState(() {});
      }
    });
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  Future<Null> _handleWechatLogin(BuildContext context) async {
    final String methodName = 'handleWechatLogin';

    try {
      methodChannel.registerWechat(appId: APP_ID_WECHAT);

      //var isWechatInstalled = await PLATFORM.invokeMethod('isWechatInstalled');
      var isWechatInstalled = await methodChannel.isWechatInstalled();
      if (!isWechatInstalled) {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).wechatNotInstalled,
        );
        return;
      }

      methodChannel.wechatLogin(
          scope: 'snsapi_userinfo', state: 'xiaoyan_wechat');
      _wechatLoginStarted = true;
      methodChannel.responseFromAuth.listen((response) {
        final int errCode = response.errCode;
        if (errCode == 0) {
          final String code = response.code;
          HttpProxy.getWechatAccessToken(
                  APP_ID_WECHAT,
                  '6fa36536b98d48e24cd7bc6c9eb3758e',
                  code,
                  'authorization_code')
              .then((response) {
            var body = json.decode(response.body);
            if (body['errcode'] == null) {
              final String openid = body['openid'];
              final String accessToken = body['access_token'];
              log.i('OpenId: $openid', methodName);
              log.i('AccessToken: $accessToken', methodName);
              _loginToAuthServer(ID_TYPE_WECHAT, openid, accessToken);
            }
          }).catchError((e) {
            log.e('ERROR: ${e.toString()}', methodName);
            if (_wechatLoginStarted) {
              Navigator.of(context, rootNavigator: true).pop();
              _wechatLoginStarted = false;
            }
          });
        } else if (errCode == -2) {
          print('wechat cancel login');
          if (_wechatLoginStarted) {
            _wechatLoginStarted = false;
            Navigator.of(context, rootNavigator: true).pop();
          }
        } else {
          log.d('wechat login error code: $errCode', methodName);
        }
      });
    } catch (e) {
      log.e('ERROR: ${e.toString()}', methodName);
      if (_wechatLoginStarted) {
        _wechatLoginStarted = false;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
  }

  Future<Null> _handleQQLogin(BuildContext context) async {
    final String methodName = 'handleQQLogin';

    try {
      //FlutterQq.registerQQ(APP_ID_QQ);
      final Map<String, String> args = Map();
      args['appId'] = APP_ID_QQ;
      //PLATFORM.invokeMethod('registerQQ', args);
      methodChannel.registerQQ();
      //var isQQInstalled = await PLATFORM.invokeMethod('isQQInstalled', Map());
      var isQQInstalled = await methodChannel.isQQInstalled();
      if (!isQQInstalled) {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).qqNotInstalled,
        );
        return;
      }

      _qqLoginStarted = true;
      //var qqResult = await FlutterQq.login();
      //var qqResult = await PLATFORM.invokeMethod('qqLogin', Map());
      var qqResult = await methodChannel.qqLogin();
      final int code = qqResult['Code'];
      if (code == 0) {
        var response = qqResult['Response'];
        String accessToken = response['accessToken'];
        String openId = response['openid'];
        log.d('AccessToken: $accessToken', methodName);
        log.d('OpenId: $openId', methodName);
        _loginToAuthServer(ID_TYPE_QQ, openId, accessToken);
      } else if (code == 1) {
        if (_qqLoginStarted) {
          _qqLoginStarted = false;
          Navigator.of(context, rootNavigator: true).pop();
        }
      } else if (code == 2) {}
      {
        if (_qqLoginStarted) {
          _qqLoginStarted = false;
          Navigator.of(context, rootNavigator: true).pop();
        }
      }
    } catch (e) {
      log.e('ERROR: ${e.toString()}', methodName);
      if (_qqLoginStarted) {
        _qqLoginStarted = false;
        Navigator.of(context, rootNavigator: true).pop();
      }
    }
    return;
  }

  Future<Null> _loginToAuthServer(String idType, String id, String credential) {
    final String methodName = "_loginToAuthServer";
    HttpProxy.authenticate(idType, id, credential, null, null, null)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        final String username = body[API_USERNAME];
        final String token = body[API_ACCESS_TOKEN];
        LoginManager().storeUsernameAndToken(username, token);
        SessionManager()
            .startSession(username, token, CLOUD_SERVER, LOGIN_POLICY_CLOUD);
        AccountManager().getAccountInformation(token, username);
      } else if (statusCode == HTTP_STATUS_CODE_NOT_FOUND) {
        HttpProxy.register(idType, id, credential, null).then((response) {
          var body = json.decode(response.body);
          final int statusCode = body[API_STATUS_CODE];
          if (statusCode == HTTP_STATUS_CODE_OK) {
            final String username = body[API_USERNAME];
            final String token = body[API_ACCESS_TOKEN];
            HttpProxy.authenticate(
                    ID_TYPE_BASIC, username, token, null, null, null)
                .then((response) {
              var body = json.decode(response.body);
              final int statusCode = body[API_STATUS_CODE];
              if (statusCode == HTTP_STATUS_CODE_OK) {
                final String username = body[API_USERNAME];
                final String token = body[API_ACCESS_TOKEN];
                LoginManager().storeUsernameAndToken(username, token);
                SessionManager().startSession(
                    username, token, CLOUD_SERVER, LOGIN_POLICY_CLOUD);

                _setNickname(token, username, idType, id, credential);
              }
            }).catchError((e) {
              log.e('ERROR: ${e.toString()}', methodName);
            });
          }
        }).catchError((e) {
          log.e('ERROR: ${e.toString()}', methodName);
        });
      }
    }).catchError((e) {
      log.e('ERROR: ${e.toString()}', methodName);
    });
    return null;
  }

  void _setNickname(String token, String username, String idType, String openid,
      String accessToken) {
    if (idType == ID_TYPE_QQ) {
      AccountManager().setQQNickname(token, username, openid, accessToken);
    } else if (idType == ID_TYPE_WECHAT) {
      AccountManager().setWechatNickname(token, username, openid, accessToken);
    }
  }

  Widget buildHomeCenter(BuildContext context, final HomeCenter hc) {
    // final HomeCenter hc = HomeCenterManager().localFoundHomeCenters[index];
    return GestureDetector(
        child: Column(children: <Widget>[
          Image(
            image: AssetImage('images/home_center.png'),
            width: 105.0,
            height: 100.0,
          ),
          Text(hc.name.length < 7
              ? hc.name
              : hc.name.substring(hc.name.length - 7))
        ]),
        onTap: () {
          showCupertinoDialog(
            context: context,
            builder: (BuildContext context) {
              return CupertinoDialog(
                child: Container(
                  width: 200.0,
                  height: 50.0,
                  color: Colors.white,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      CupertinoActivityIndicator(),
                      Padding(
                        padding: EdgeInsets.only(left: 5.0),
                      ),
                      Text(
                        DefinedLocalizations.of(context).loginUncomplete,
                        style: TextStyle(
                          inherit: false,
                          color: Color(0xFF2D3B46),
                          fontSize: 16.0,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            },
          );
          hc.state = ASSOCIATION_TYPE_BOTH;
          HomeCenterManager().addHomeCenter(hc);
          SessionManager().startSession(
              "localuser", "password", hc.host, LOGIN_POLICY_LOCAL);
        });
  }

  Widget build(BuildContext context) {
    print("------------------------------login_page.dart");
    var hcInLocal = List();
    for (var hc in HomeCenterManager().localFoundHomeCenters) {
      if (hc.getVersion() >= 20609) {
        print(
            "add homecenter that supports local mode ${hc.versionString} ${hc.getVersion()}");
        hcInLocal.add(hc);
      }
    }
    bool showLocalHomeCenter = hcInLocal.length > 0;
    print("$hcInLocal");
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(top: 80.0),
      child: Column(
        children: <Widget>[
          Offstage(
            offstage: !showLocalHomeCenter,
            child: Container(
                height: 150,
                width: 105,
                margin: EdgeInsets.only(top: 36, bottom: 16),
                // width: AlignmentGeometry.,
                alignment: Alignment.center,
                child: ListView.builder(
                    physics: PageScrollPhysics(),
                    scrollDirection: Axis.horizontal,
                    itemCount: hcInLocal.length,
                    // padding: EdgeInsets.only(top: 5.0, bottom: 5.0),
                    itemBuilder: (BuildContext context, int index) {
                      return buildHomeCenter(context, hcInLocal[index]);
                    })),
          ),
          Offstage(
              offstage: showLocalHomeCenter,
              child: Image(
                image: AssetImage('images/first.png'),
                width: 100.0,
                height: 200.0,
              )),
          Text(
            showLocalHomeCenter
                ? DefinedLocalizations.of(context).useLanAccess
                : DefinedLocalizations.of(context).firstDescription,
            style: TextStyle(
              color: Color(0x765B666F),
              fontSize: 11.0,
              inherit: false,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 30.0),
          ),
          CupertinoButton(
            child: Container(
              width: 200.0,
              height: 44.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x3397BAC6)),
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: Text(
                DefinedLocalizations.of(context).login,
                style: TextStyle(
                  color: Color(0xFF2D3B46),
                  fontSize: 16.0,
                  inherit: false,
                ),
              ),
            ),
            padding: EdgeInsets.only(left: 0.0, right: 0.0),
            borderRadius: BorderRadius.all(Radius.circular(22.0)),
            color: Colors.white,
            disabledColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(CupertinoPageRoute(
                builder: (context) => MobileLoginPage(),
                settings: RouteSettings(
                  name: '/MobileLogin',
                ),
              ));
            },
          ),
          Padding(
            padding: EdgeInsets.only(top: 10.0),
          ),
          CupertinoButton(
            child: Container(
              width: 200.0,
              height: 44.0,
              alignment: Alignment.center,
              decoration: BoxDecoration(
                border: Border.all(color: const Color(0x3397BAC6)),
                borderRadius: BorderRadius.circular(22.0),
                //TODO: shadow
              ),
              child: Text(
                DefinedLocalizations.of(context).register,
                style: TextStyle(
                  color: Color(0xFF2D3B46),
                  fontSize: 16.0,
                  inherit: false,
                ),
              ),
            ),
            padding: EdgeInsets.only(),
            borderRadius: BorderRadius.all(Radius.circular(22.0)),
            color: Colors.white,
            disabledColor: Colors.white,
            onPressed: () {
              Navigator.of(context).push(
                CupertinoPageRoute(
                  builder: (context) => RegisterPage(),
                  settings: RouteSettings(
                    name: '/Register',
                  ),
                ),
              );
            },
          ),
          Offstage(
            offstage: LoginManager().platform != PLATFORM_IOS,
            child: Padding(padding: EdgeInsets.only(top: 10.0)),
          ),
          Offstage(
            offstage: LoginManager().platform != PLATFORM_IOS,
            child: CupertinoButton(
              child: Container(
                width: 200.0,
                height: 44.0,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  border: Border.all(color: const Color(0x3397BAC6)),
                  borderRadius: BorderRadius.circular(22.0),
                ),
                child: Text(
                  'HomeKit',
                  style: TextStyle(
                    color: Color(0xFF2D3B46),
                    fontSize: 16.0,
                    inherit: false,
                  ),
                ),
              ),
              padding: EdgeInsets.only(),
              borderRadius: BorderRadius.circular(22.0),
              color: Colors.white,
              disabledColor: Colors.white,
              onPressed: () {
                Navigator.of(context).pushAndRemoveUntil(
                    CupertinoPageRoute(
                      builder: (BuildContext context) => HomekitMainPage(),
                      settings: RouteSettings(
                        name: '/HomekitMain',
                      ),
                    ),
                    (route) => false);
              },
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top: 20.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Image(
                width: 25.0,
                height: 1.0,
                image: AssetImage('images/line.png'),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
              ),
              Text(
                DefinedLocalizations.of(context).loginOtherWays,
                style: TextStyle(
                    inherit: false,
                    color: const Color(0x802D3B46),
                    fontSize: 12.0),
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
              ),
              Image(
                width: 25.0,
                height: 1.0,
                image: AssetImage('images/line.png'),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 2.0),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Image(
                      width: 24.0,
                      height: 22.0,
                      image: AssetImage('images/third_party_wechat.png')),
                ),
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoDialog(
                        child: Container(
                          width: 200.0,
                          height: 50.0,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoActivityIndicator(),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                              ),
                              Text(
                                DefinedLocalizations.of(context)
                                    .loginUncomplete,
                                style: TextStyle(
                                  inherit: false,
                                  color: Color(0xFF2D3B46),
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  _handleWechatLogin(context);
                },
              ),
              Padding(
                padding: EdgeInsets.only(left: 5.0),
              ),
              GestureDetector(
                behavior: HitTestBehavior.opaque,
                child: Container(
                  width: 50.0,
                  height: 50.0,
                  alignment: Alignment.center,
                  child: Image(
                    width: 20.0,
                    height: 23.0,
                    image: AssetImage('images/third_party_qq.png'),
                  ),
                ),
                onTap: () {
                  showCupertinoDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return CupertinoDialog(
                        child: Container(
                          width: 200.0,
                          height: 50.0,
                          color: Colors.white,
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              CupertinoActivityIndicator(),
                              Padding(
                                padding: EdgeInsets.only(left: 5.0),
                              ),
                              Text(
                                DefinedLocalizations.of(context)
                                    .loginUncomplete,
                                style: TextStyle(
                                  inherit: false,
                                  color: Color(0xFF2D3B46),
                                  fontSize: 16.0,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );

                  _handleQQLogin(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}
