import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/rxbus/rxbus.dart';
import 'package:xlive/log/log_shared.dart';
import 'package:xlive/session/account_manager.dart';

import 'dart:convert';
import 'dart:async';

import 'package:fluttertoast/fluttertoast.dart';

import 'add_home_center_page.dart';
import 'common_page.dart';

class RegisterPage extends StatefulWidget {
  State<StatefulWidget> createState() => _RegisterState();
}

class _RegisterState extends State<RegisterPage> {
  Log log = LogFactory().getLogger(Log.DEBUG, 'RegisterPage');

  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool get _isRegisterButtonEnabled {
    final String email = _emailController.text;
    if (email == null || email == '') return false;
    if (!email.contains('@')) return false;
    final String password = _passwordController.text;
    if (password == null || password.length < MIN_PASSWORD_LENGTH) return false;
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
        Navigator.pushAndRemoveUntil(
          context,
          CupertinoPageRoute(
            builder: (context) => AddHomeCenterPage(showBackIcon: false),
            settings: RouteSettings(
              name: '/AddHomeCenter',
            ),
          ),
          (route) => false,
        );
      }
    });
  }

  void dispose() {
    super.dispose();
    if (_subscription != null) {
      _subscription.cancel();
    }
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).register,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0),
        color: Colors.white,
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _emailController,
                  autofocus: true,
                  keyboardType: TextInputType.emailAddress,
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputEmail,
                    hintStyle: TextStyle(
                      inherit: false,
                      color: Color(0xFFD9D9D9),
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
                    //_isRegisterButtonEnabled = (s.length > 0) && (_passwordController.text.length > 0);
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
                      inherit: false,
                      color: Color(0xFFD9D9D9),
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
                    //_isRegisterButtonEnabled = (s.length > 0) && (_emailController.text.length > 0);
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
                            image: AssetImage('images/delete.png')),
                        onTap: () {
                          _passwordController.text = '';
                          setState(() {});
                        },
                      ),
                    ),
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                    ),
                    GestureDetector(
                      child: Image(
                        width: 16.0,
                        height: 11.0,
                        image: AssetImage(_showPassword
                            ? 'images/eye_shown.png'
                            : 'images/eye_hidden.png'),
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
                  DefinedLocalizations.of(context).register,
                  style: TextStyle(
                    inherit: false,
                    color: _isRegisterButtonEnabled
                        ? Color(0xFF606972)
                        : Color(0xFFDDDDDD),
                    fontSize: 16.0,
                  ),
                ),
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: !_isRegisterButtonEnabled
                    ? null
                    : () {
                        final String password = _passwordController.text;
                        if (password.trim().length < 6 ||
                            password.trim().length > 32) {
                          Fluttertoast.showToast(
                            msg: DefinedLocalizations.of(context)
                                .illegalPasswordLength,
                          );
                          return;
                        }

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

                        final String email = _emailController.text;
                        HttpProxy.register(ID_TYPE_EMAIL, email, password, null)
                            .then((response) {
                          var body = json.decode(response.body);
                          final int statusCode = body[API_STATUS_CODE];
                          if (statusCode == HTTP_STATUS_CODE_OK) {
                            //final String username = body[API_USERNAME];
                            HttpProxy.authenticate(ID_TYPE_EMAIL, email,
                                    password, null, null, null)
                                .then((response) {
                              var body = json.decode(response.body);
                              final int statusCode = body[API_STATUS_CODE];
                              if (statusCode == HTTP_STATUS_CODE_OK) {
                                final String username = body[API_USERNAME];
                                final String token = body[API_ACCESS_TOKEN];
                                LoginManager()
                                    .storeUsernameAndToken(username, token);
                                SessionManager().startSession(username, token,
                                    CLOUD_SERVER, LOGIN_POLICY_CLOUD);

                                AccountManager()
                                    .setNickname(token, username, email);
                              } else {
                                Navigator.of(context, rootNavigator: true)
                                    .pop();
                                Fluttertoast.showToast(
                                  msg: DefinedLocalizations.of(context).failed +
                                      ': ${statusCode.toString()}',
                                );
                              }
                            }).catchError((e) {
                              Navigator.of(context, rootNavigator: true).pop();
                              print('ERROR: ${e.toString()}');
                            });
                          } else if (statusCode == HTTP_STATUS_CODE_CONFLICT) {
                            Fluttertoast.showToast(
                              msg: DefinedLocalizations.of(context)
                                  .emailRegisted,
                            );
                            Navigator.of(context, rootNavigator: true).pop();
                          } else {
                            Fluttertoast.showToast(
                              msg: DefinedLocalizations.of(context).failed +
                                  ': ${statusCode.toString()}',
                            );
                            Navigator.of(context, rootNavigator: true).pop();
                          }
                        }).catchError((e) {
                          Navigator.of(context, rootNavigator: true).pop();
                          print('ERROR: ${e.toString()}');
                        });
                      },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
