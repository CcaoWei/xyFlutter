import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:xlive/const/adapt.dart';

import 'dart:convert';
import 'dart:async';
import 'dart:ui';
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
import 'register_page.dart';
import 'add_home_center_page.dart';
import 'common_page.dart';

class EmailLoginPage extends StatefulWidget {
  State<StatefulWidget> createState() => _EmailLoginState();
}

class _EmailLoginState extends State<EmailLoginPage> {
  static const String className = 'EmailLoginPage';
  Log log = LogFactory().getLogger(Log.DEBUG, className);

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isLoginButtonEnabled {
    final String email = _emailController.text;
    if (email == null || email == '') return false;
    if (!email.contains('@')) return false;
    final String password = _passwordController.text;
    if (password == null || password == '') return false;
    return true;
  }

  bool _showPassword = false;

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
      if (evt.type == LoginEvent.GET_DATA_COMPLETE ||
          evt.type == LoginEvent.NO_HOME_CENTER) {
        //Navigator.of(context, rootNavigator: true).maybePop();
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
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  void _emailLogin(BuildContext context) {
    final String methodName = 'emailLogin';
    final String email = _emailController.text;
    final String password = _passwordController.text;
    HttpProxy.authenticate(ID_TYPE_EMAIL, email, password, null, null, null)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        final String username = body[API_USERNAME];
        final String token = body[API_ACCESS_TOKEN];

        log.d('email login username: $username', methodName);
        log.d('emial login access token: $token', methodName);
        LoginManager().storeUsernameAndToken(username, token);
        SessionManager()
            .startSession(username, token, CLOUD_SERVER, LOGIN_POLICY_CLOUD);
        AccountManager().getAccountInformation(token, username);
      } else {
        Navigator.of(context, rootNavigator: true).maybePop();
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).failed + ': $statusCode',
        );
        log.w('email login failed: $statusCode', methodName);
      }
    }).catchError((e) {
      Navigator.of(context, rootNavigator: true).maybePop();
      log.e('AUTHENTICATE ERROR: ${e.toString()}', methodName);
    });
  }

  Widget build(BuildContext context) {
    print("------------------------------email_login_page.dart");
    final String methodName = 'build';
    return CommonPage(
      title: DefinedLocalizations.of(context).accountLogin,
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
                  controller: _emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputEmail,
                    hintStyle: TEXT_STYLE_INPUT_HINT,
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(
                        color: Color(0xFFD9D9D9),
                      ),
                    ),
                  ),
                  onChanged: (s) {
                    //_isLoginButtonEnabled = (s.length > 0) && (_passwordController.text.length > 0);
                    setState(() {});
                  },
                ),
                Offstage(
                  offstage: _emailController.text.length == 0,
                  child: GestureDetector(
                    child: Image(
                      width: 15.0,
                      height: 15.0,
                      image: AssetImage('images/delete.png'),
                    ),
                    onTap: () {
                      _emailController.text = '';
                      setState(() {});
                    },
                  ),
                ),
              ],
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputPassword,
                    hintStyle: TextStyle(
                      color: Color(0xFFD9D9D9),
                      inherit: false,
                      fontSize: 13.0,
                    ),
                    enabledBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                    focusedBorder: UnderlineInputBorder(
                      borderSide: BorderSide(color: Color(0xFFD9D9D9)),
                    ),
                  ),
                  onChanged: (s) {
                    //_isLoginButtonEnabled = (s.length > 0) && (_emailController.text.length > 0);
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      offstage: _passwordController.text.length == 0,
                      child: GestureDetector(
                        child: Image(
                          width: 15.0,
                          height: 15.0,
                          image: AssetImage('images/delete.png'),
                        ),
                        onTap: () {
                          _passwordController.text = '';
                          setState(() {});
                        },
                      ),
                    ),
                    GestureDetector(
                      child: Container(
                        height: 43.0,
                        width: Adapt.px(80),
                        alignment: Alignment.centerRight,
                        child: Image(
                          width: Adapt.px(47),
                          height: Adapt.px(43),
                          image: AssetImage(_showPassword
                              ? 'images/eye_shown.png'
                              : 'images/eye_hidden.png'),
                        ),
                      ),
                      onTap: () {
                        _showPassword = !_showPassword;
                        setState(() {});
                      },
                    ),
                  ],
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
                child: Text(
                  DefinedLocalizations.of(context).resisterAccount,
                  style: TextStyle(
                    inherit: false,
                    fontSize: 12.0,
                    color: Colors.blue,
                  ),
                ),
                onPressed: () {
                  Navigator.push(
                    context,
                    CupertinoPageRoute(
                      builder: (context) => RegisterPage(),
                      settings: RouteSettings(
                        name: '/Register',
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
                          builder: (context) => CupertinoDialog(
                                child: Container(
                                  width: 200.0,
                                  height: 50.0,
                                  color: Colors.white,
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
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
                              ),
                        );
                        _emailLogin(context);
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
