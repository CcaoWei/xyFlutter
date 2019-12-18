import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:fluttertoast/fluttertoast.dart';

import 'package:xlive/localization/defined_localization.dart';
import 'package:xlive/http/http_proxy.dart';
import 'package:xlive/session/account_manager.dart';
import 'package:xlive/session/login_manager.dart';
import 'package:xlive/session/session_manager.dart';
import 'package:xlive/const/const_shared.dart';
import 'package:xlive/data/data_shared.dart';

import 'dart:convert';

import 'login_page.dart';
import 'forget_password_page.dart';
import 'common_page.dart';

class ChangePasswordPage extends StatefulWidget {
  State<StatefulWidget> createState() => _ChangePasswordState();
}

class _ChangePasswordState extends State<StatefulWidget> {
  final TextEditingController _originPasswordController =
      TextEditingController();
  final TextEditingController _newPasswordController = TextEditingController();

  bool _showOriginPassword = false;
  bool _showNewPassword = false;

  bool _isSubmitButtonEnabled = false;

  void initState() {
    super.initState();
  }

  void dispose() {
    super.dispose();
  }

  Widget build(BuildContext context) {
    print("------------------------------change_password_page.dart");
    return CommonPage(
      title: DefinedLocalizations.of(context).changePassword,
      child: buildChild(context),
    );
  }

  Widget buildChild(BuildContext context) {
    return Scaffold(
      body: Container(
        color: Colors.white,
        padding: EdgeInsets.only(left: 13.0, right: 13.0, top: 20.0),
        child: Column(
          children: [
            Stack(
              alignment: Alignment.centerRight,
              children: <Widget>[
                TextField(
                  controller: _originPasswordController,
                  obscureText: !_showOriginPassword,
                  decoration: InputDecoration(
                    hintText:
                        DefinedLocalizations.of(context).inputOriginPassword,
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
                    _isSubmitButtonEnabled =
                        (s.length >= MIN_PASSWORD_LENGTH) &&
                            (_newPasswordController.text.length >=
                                MIN_PASSWORD_LENGTH);
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      offstage: _originPasswordController.text.length == 0,
                      child: GestureDetector(
                        child: Image(
                          width: 15.0,
                          height: 15.0,
                          image: AssetImage('images/delete.png'),
                        ),
                        onTap: () {
                          _originPasswordController.text = '';
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
                        image: AssetImage(_showOriginPassword
                            ? 'images/eye_shown.png'
                            : 'images/eye_hidden.png'),
                      ),
                      onTap: () {
                        _showOriginPassword = !_showOriginPassword;
                        setState(() {});
                      },
                    ),
                  ],
                ),
              ],
            ),
            Stack(
              alignment: Alignment.centerRight,
              children: [
                TextField(
                  controller: _newPasswordController,
                  obscureText: !_showNewPassword,
                  decoration: InputDecoration(
                    hintText: DefinedLocalizations.of(context).inputNewPassword,
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
                    _isSubmitButtonEnabled =
                        (s.length >= MIN_PASSWORD_LENGTH) &&
                            (_originPasswordController.text.length >=
                                MIN_PASSWORD_LENGTH);
                    setState(() {});
                  },
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: <Widget>[
                    Offstage(
                      offstage: _newPasswordController.text.length == 0,
                      child: GestureDetector(
                        child: Image(
                          width: 15.0,
                          height: 15.0,
                          image: AssetImage('images/delete.png'),
                        ),
                        onTap: () {
                          _newPasswordController.text = '';
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
                        image: AssetImage(_showNewPassword
                            ? 'images/eye_shown.png'
                            : 'images/eye_hidden.png'),
                      ),
                      onTap: () {
                        _showNewPassword = !_showNewPassword;
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
                  DefinedLocalizations.of(context).forgetPassword,
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
                      builder: (context) => ForgetPasswordPage(),
                      settings: RouteSettings(
                        name: '/ChangePassword',
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
                color: Colors.white,
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
                disabledColor: Colors.white,
                onPressed: !_isSubmitButtonEnabled
                    ? null
                    : () {
                        final String currentPassword =
                            _originPasswordController.text;
                        final String newPassword = _newPasswordController.text;
                        final String username = LoginManager().username;
                        final String token = LoginManager().token;
                        HttpProxy.changePassword(
                                token, username, currentPassword, newPassword)
                            .then((response) {
                          var body = json.decode(response.body);
                          final int statusCode = body[API_STATUS_CODE];
                          if (statusCode == HTTP_STATUS_CODE_OK) {
                            SessionManager().clearSessions();
                            HomeCenterManager().logout();
                            LoginManager().logout();
                            AccountManager().clear();
                            Navigator.of(context).pushAndRemoveUntil(
                              CupertinoPageRoute(
                                builder: (context) => LoginPage(),
                                settings: RouteSettings(
                                  name: '/Login',
                                ),
                              ),
                              (route) => false,
                            );
                          } else {
                            Fluttertoast.showToast(
                                msg: DefinedLocalizations.of(context)
                                    .changePasswordFailed,
                                timeInSecForIos: 5,
                                toastLength: Toast.LENGTH_LONG,
                                backgroundColor: Colors.pinkAccent,
                                gravity: ToastGravity.CENTER);
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
