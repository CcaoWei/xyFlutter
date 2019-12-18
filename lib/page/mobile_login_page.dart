import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';

import 'dart:convert';
import 'dart:async';

import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/data/data_shared.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/session/account_manager.dart';

import 'package:fluttertoast/fluttertoast.dart';

import 'home_page.dart';
import 'email_login_page.dart';
import 'add_home_center_page.dart';
import 'common_page.dart';

class MobileLoginPage extends StatefulWidget {
  State<StatefulWidget> createState() => _MobileLoginState();
}

class _MobileLoginState extends State<MobileLoginPage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'MobileLoginPage');

  final TextEditingController _mobileController = TextEditingController();
  final TextEditingController _verificationCodeController =
      TextEditingController();

  bool get _isGetCodeButtonEnabled {
    if (_timer != null && _timer.isActive) return false;
    final String mobile = _mobileController.text;
    if (mobile == null || mobile == '') return false;
    if (mobile.length != 11) return false;
    if (!mobile.startsWith('1')) return false;
    return true;
  }

  bool get _isLoginButtonEnabled {
    final String mobile = _mobileController.text;
    if (mobile == null || mobile == '') return false;
    if (mobile.length != 11) return false;
    if (!mobile.startsWith('1')) return false;
    final String verificationCode = _verificationCodeController.text;
    if (verificationCode == null || verificationCode == '') return false;
    return true;
  }

  Timer _timer;
  int _seconds = 0;

  StreamSubscription _subscription;

  void initState() {
    super.initState();
    _start();
  }

  void _start() {
    _subscription = RxBus()
        .toObservable()
        .where((event) => event is LoginEvent)
        .listen((event) {
      final LoginEvent evt = event as LoginEvent;
      print(evt.type);
      if (evt.type == LoginEvent.GET_DATA_COMPLETE ||
          evt.type == LoginEvent.NO_HOME_CENTER ||
          evt.type == LoginEvent.LOGIN_COMPLETE) {
        if (HomeCenterManager().homeCenters.length == 0) {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => AddHomeCenterPage(showBackIcon: false),
              settings: RouteSettings(
                name: '/AddHomeCenter',
              ),
            ),
            (route) => false,
          );
        } else {
          Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
            CupertinoPageRoute(
              builder: (context) => HomePage(),
              settings: RouteSettings(
                name: '/Home',
              ),
            ),
            (route) => false,
          );
        }
      }
    });
  }

  void dispose() {
    super.dispose();
    if (_timer != null && _timer.isActive) {
      _timer.cancel();
    }
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (_seconds == 0) {
        _timer.cancel();
        //_isGetCodeButtonEnabled = (_mobileController.text.length > 0);
        setState(() {});
        return;
      }
      //_isGetCodeButtonEnabled = false;
      _seconds--;
      setState(() {});
    });
  }

  void _mobileLogin(BuildContext context) {
    final String methodName = 'mobileLogin';
    final String mobile = _mobileController.text;
    final String verificationCode = _verificationCodeController.text;
    final String verificationCodeId = LoginManager().verificationCodeId;
    log.d('try to authenticate', methodName);
    HttpProxy.authenticate(ID_TYPE_MOBILE, mobile, verificationCode, null, null,
            verificationCodeId)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      final String message = body[API_MESSAGE];
      log.d('Authenticate message: $message', methodName);
      if (statusCode == HTTP_STATUS_CODE_OK) {
        final String username = body[API_USERNAME];
        final String token = body[API_ACCESS_TOKEN];
        log.d('authenticate ok , start session', methodName);
        LoginManager().storeUsernameAndToken(username, token);
        SessionManager()
            .startSession(username, token, CLOUD_SERVER, LOGIN_POLICY_CLOUD);
        AccountManager().getAccountInformation(token, username);
      } else if (statusCode == HTTP_STATUS_CODE_NOT_FOUND) {
        log.d('not found, try to register ${mobile}', methodName);
        log.d('verification code: ${verificationCode}', methodName);
        final String verificationCodeId = LoginManager().verificationCodeId;
        HttpProxy.register(
                ID_TYPE_MOBILE, mobile, verificationCode, verificationCodeId)
            .then((response) {
          var body = json.decode(response.body);
          final int statusCode = body[API_STATUS_CODE];
          final String message = body[API_MESSAGE];
          log.d('Register message: ${message}', methodName);
          if (statusCode == HTTP_STATUS_CODE_OK) {
            final String username = body[API_USERNAME];
            final String token = body[API_ACCESS_TOKEN];
            log.d('register ok, authenticate to server again', methodName);
            HttpProxy.authenticate(ID_TYPE_MOBILE, mobile, verificationCode,
                    null, null, verificationCodeId)
                .then((response) {
              var body = json.decode(response.body);
              final int statusCode = body[API_STATUS_CODE];
              final String message = body[API_MESSAGE];
              log.d('Authenticate message: ${message}', methodName);
              if (statusCode == HTTP_STATUS_CODE_OK) {
                final String username = body[API_USERNAME];
                final String token = body[API_ACCESS_TOKEN];

                log.d('authenticate ok, start session', methodName);
                LoginManager().storeUsernameAndToken(username, token);
                SessionManager().startSession(
                    username, token, CLOUD_SERVER, LOGIN_POLICY_CLOUD);
                AccountManager().setNickname(token, username, mobile);
              } else {
                Navigator.of(context, rootNavigator: true).pop();
                Fluttertoast.showToast(
                  msg:
                      DefinedLocalizations.of(context).failed + ': $statusCode',
                );
                log.e('authenticate 2 failed: $statusCode', methodName);
              }
            }).catchError((e) {
              Navigator.of(context, rootNavigator: true).pop();
              print('ERROR: ${e.toString()}');
            });
          } else {
            Navigator.of(context, rootNavigator: true).pop();
            Fluttertoast.showToast(
              msg: DefinedLocalizations.of(context).failed + ': $statusCode',
            );
            log.e('register failed: $statusCode', methodName);
          }
        }).catchError((e) {
          Navigator.of(context, rootNavigator: true).pop();
          log.e('REGISTER ERROR: ${e.toString()}', methodName);
        });
      } else {
        Navigator.of(context, rootNavigator: true).pop();
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': $statusCode',
        );
        log.e('authenticate 1 failed: $statusCode', methodName);
      }
    }).catchError((e) {
      Navigator.of(context, rootNavigator: true).pop();
      log.e('AUTHENTICATE ERROR: ${e.toString()}', methodName);
    });
  }

  Widget build(BuildContext context) {
    print("------------------------------mobile_login_page.dart");
    return CommonPage(
      title: DefinedLocalizations.of(context).mobileLogin,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0),
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  controller: _mobileController,
                  keyboardType: TextInputType.phone,
                  autofocus: true,
                  inputFormatters: [
                    WhitelistingTextInputFormatter.digitsOnly,
                  ],
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputMobile,
                    hintStyle: TextStyle(
                      color: Color(0xFFD9D9D9),
                      inherit: false,
                      fontSize: 14.0,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                  onChanged: (s) {
                    //_isGetCodeButtonEnabled = (s.length > 0) && (_seconds == 0);
                    //_isLoginButtonEnabled = (s.length > 0) && (_verificationCodeController.text.length > 0);
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      offstage: _mobileController.text.length == 0,
                      child: GestureDetector(
                        child: Image(
                          width: 15.0,
                          height: 15.0,
                          image: AssetImage('images/delete.png'),
                        ),
                        onTap: () {
                          _mobileController.text = '';
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                    ),
                    Container(
                      width: 90.0,
                      height: 24.0,
                      decoration: BoxDecoration(
                        border: Border.all(color: Color(0x3397BAC6)),
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: CupertinoButton(
                        minSize: 24.0,
                        padding: EdgeInsets.only(),
                        child: Text(
                          _seconds == 0
                              ? DefinedLocalizations.of(context).getCode
                              : DefinedLocalizations.of(context).sendAgain +
                                  '(${_seconds.toString()})',
                          style: TextStyle(
                            inherit: false,
                            fontSize: 11.0,
                            color: _isGetCodeButtonEnabled
                                ? Color(0xFF606972)
                                : Color(0xFFDDDDDD),
                          ),
                        ),
                        borderRadius: BorderRadius.circular(12.0),
                        color: Colors.white,
                        disabledColor: Colors.white,
                        onPressed: !_isGetCodeButtonEnabled
                            ? null
                            : () {
                                _startTimer();
                                final String mobile = _mobileController.text;
                                HttpProxy.getVerificationCode(
                                        VERIFICATION_CODE_TYPE_NUMBER,
                                        NOTIFICATION_TYPE_SMS,
                                        mobile,
                                        LENGTH_VERIFICATION_CODE,
                                        EXPIRE_VRIFICATION_CODE,
                                        VERIFICATION_CODE_PURPOSE_LOGIN)
                                    .then((response) {
                                  var body = json.decode(response.body);
                                  final int statusCode = body[API_STATUS_CODE];
                                  if (statusCode == HTTP_STATUS_CODE_OK) {
                                    LoginManager().verificationCodeId =
                                        body[API_VERIFICATION_CODE_ID];
                                  }
                                }).catchError((e) {
                                  print("ERROR -> ${e.toString()}");
                                });
                              },
                      ),
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _verificationCodeController,
                  maxLength: 6,
                  onChanged: (s) {
                    //_isLoginButtonEnabled = (s.length > 0) && (_mobileController.text.length > 0);
                    setState(() {});
                  },
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputCode,
                    hintStyle: TextStyle(
                      color: Color(0xFFD9D9D9),
                      fontSize: 14.0,
                      inherit: false,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                ),
                Offstage(
                  offstage: _verificationCodeController.text.length == 0,
                  child: GestureDetector(
                      child: Image(
                        width: 15.0,
                        height: 15.0,
                        image: AssetImage('images/delete.png'),
                      ),
                      onTap: () {
                        _verificationCodeController.text = '';
                        setState(() {});
                      }),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.only(top: 20.0),
            ),
            Align(
              alignment: Alignment.centerRight,
              child: CupertinoButton(
                minSize: 14.0,
                padding: EdgeInsets.only(),
                disabledColor: Colors.white,
                color: Colors.white,
                pressedOpacity: 1.0,
                child: Text(DefinedLocalizations.of(context).accountLogin,
                    style: TextStyle(
                      fontSize: 12.0,
                      color: Colors.blue,
                    )),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => EmailLoginPage(),
                      settings: RouteSettings(
                        name: '/EmailLogin',
                      ),
                    ),
                  );
                },
              ),
            ),
            Padding(
              padding: EdgeInsets.only(top: 50.0),
            ),
            Container(
              width: 200.0,
              height: 44.0,
              decoration: BoxDecoration(
                border: Border.all(color: Color(0x3397BAC6)),
                borderRadius: BorderRadius.circular(22.0),
              ),
              child: CupertinoButton(
                minSize: 44.0,
                padding: EdgeInsets.only(),
                child: Text(
                  DefinedLocalizations.of(context).login,
                  style: TextStyle(
                    fontSize: 16.0,
                    inherit: false,
                    color: _isLoginButtonEnabled
                        ? Color(0xFF606972)
                        : Color(0xFFDDDDDD),
                  ),
                ),
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: !_isLoginButtonEnabled
                    ? null
                    : () {
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
                                          fontSize: 16.0),
                                    ),
                                  ],
                                ),
                              ),
                            );
                          },
                        );

                        _mobileLogin(context);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
