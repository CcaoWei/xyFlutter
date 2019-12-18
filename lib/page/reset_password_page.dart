import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/data/data_shared.dart';

import 'dart:async';
import 'dart:convert';

import 'login_page.dart';
import 'common_page.dart';

import 'package:fluttertoast/fluttertoast.dart';

class ResetPasswordPage extends StatefulWidget {
  final String type;
  final String target;
  final String idType;

  ResetPasswordPage({
    @required this.type,
    @required this.target,
    @required this.idType,
  });

  State<StatefulWidget> createState() => _ResetPasswordState();
}

class _ResetPasswordState extends State<ResetPasswordPage> {
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  bool _isSubmitButtonEnabled = false;
  bool _isGetCodeButtonEnabled = false;
  bool _showPassword = false;

  Timer _timer;
  int _seconds = 0;

  void initState() {
    super.initState();

    _init();
  }

  void _init() {
    HttpProxy.getVerificationCode(
            VERIFICATION_CODE_TYPE_NUMBER,
            widget.type,
            widget.target,
            LENGTH_VERIFICATION_CODE,
            EXPIRE_VRIFICATION_CODE,
            VERIFICATION_CODE_PURPOSE_RESET_PASSWORD)
        .then((response) {
      var body = json.decode(response.body);
      final int statusCode = body[API_STATUS_CODE];
      if (statusCode == HTTP_STATUS_CODE_OK) {
        _startTimer();
        LoginManager().verificationCodeId = body[API_VERIFICATION_CODE_ID];
        Fluttertoast.showToast(
          msg: DefinedLocalizations.of(context).codeSend,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
        );
      }
    }).catchError((e) {
      print('ERROR: ${e.toString()}');
    });
  }

  void dispose() {
    if (_timer != null) {
      _timer.cancel();
    }
    super.dispose();
  }

  void _startTimer() {
    _seconds = 60;
    _timer = Timer.periodic(Duration(seconds: 1), (time) {
      if (_seconds == 0) {
        _timer.cancel();
        _isGetCodeButtonEnabled = true;
        setState(() {});
        return;
      }
      _isGetCodeButtonEnabled = false;
      _seconds--;
      setState(() {});
    });
  }

  Widget build(BuildContext context) {
    return CommonPage(
      title: DefinedLocalizations.of(context).resetPassword,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Scaffold(
      body: Container(
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0),
        color: Colors.white,
        child: Column(
          children: <Widget>[
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _codeController,
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputCode,
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
                    _isGetCodeButtonEnabled = (_seconds == 0);
                    _isSubmitButtonEnabled =
                        (s.length >= MIN_PASSWORD_LENGTH) &&
                            (_passwordController.text.length >=
                                MIN_PASSWORD_LENGTH);
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      offstage: _codeController.text.length == 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
                        child: Image(
                          width: 15.0,
                          height: 15.0,
                          image: AssetImage('images/delete.png'),
                        ),
                        onTap: () {
                          _codeController.text = '';
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
                              : DefinedLocalizations.of(context).getCode +
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
                                HttpProxy.getVerificationCode(
                                        VERIFICATION_CODE_TYPE_NUMBER,
                                        widget.type,
                                        widget.target,
                                        LENGTH_VERIFICATION_CODE,
                                        EXPIRE_VRIFICATION_CODE,
                                        VERIFICATION_CODE_PURPOSE_RESET_PASSWORD)
                                    .then((response) {
                                  var body = json.decode(response.body);
                                  final int statusCode = body[API_STATUS_CODE];
                                  if (statusCode == HTTP_STATUS_CODE_OK) {
                                    LoginManager().verificationCodeId =
                                        body[API_VERIFICATION_CODE_ID];
                                  }
                                }).catchError((e) {
                                  print('ERROR: ${e.toString()}');
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
              children: <Widget>[
                TextField(
                  controller: _passwordController,
                  obscureText: !_showPassword,
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputPassword,
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
                  onChanged: (s) {
                    _isSubmitButtonEnabled = (s.length >=
                            MIN_PASSWORD_LENGTH) &&
                        (_codeController.text.length >= MIN_PASSWORD_LENGTH);
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      offstage: _passwordController.text.length == 0,
                      child: GestureDetector(
                        behavior: HitTestBehavior.opaque,
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
                    Padding(
                      padding: EdgeInsets.only(left: 12.0),
                    ),
                    GestureDetector(
                      behavior: HitTestBehavior.opaque,
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
                  DefinedLocalizations.of(context).submit,
                  style: TextStyle(
                    fontSize: 16.0,
                    inherit: false,
                    color: _isSubmitButtonEnabled
                        ? Color(0xFF606972)
                        : Color(0xFFDDDDDD),
                  ),
                ),
                borderRadius: BorderRadius.circular(22.0),
                color: Colors.white,
                disabledColor: Colors.white,
                onPressed: !_isSubmitButtonEnabled
                    ? null
                    : () {
                        final String verificationCode = _codeController.text;
                        final String verificationCodeId =
                            LoginManager().verificationCodeId;
                        final String password = _passwordController.text;
                        HttpProxy.resetPassword(widget.idType, widget.target,
                                verificationCode, verificationCodeId, password)
                            .then((response) {
                          var body = json.decode(response.body);
                          final int statusCode = body[API_STATUS_CODE];
                          final String message = body[API_MESSAGE];
                          if (statusCode == HTTP_STATUS_CODE_OK) {
                            SessionManager().clearSessions();
                            HomeCenterManager().logout();
                            LoginManager().logout();
                            Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(
                                builder: (context) => LoginPage(),
                                settings: RouteSettings(
                                  name: '/Login',
                                ),
                              ),
                              (route) => false,
                            );
                          }
                        }).catchError((e) {
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
